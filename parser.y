%{
#include "header.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#define MAX_SYMBOLS 100
#define MAX_TAC 1000

Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;
ThreeAddressCode tacTable[MAX_TAC];
int tacCount = 0;
int tempCount = 0;
extern ErrorInfo error_info;  // Changed to extern declaration

char* newTemp() {
    static char temp[10];
    sprintf(temp, "t%d", tempCount++);
    return strdup(temp);
}

void report_error(const char* format, ...) {
    va_list args;
    va_start(args, format);
    vsnprintf(error_info.last_error, sizeof(error_info.last_error), format, args);
    va_end(args);
    error_info.error_count++;
    fprintf(stderr, "Error at line %d: %s\n", yylineno, error_info.last_error);
}

Symbol* lookup(char* name) {
    for(int i = 0; i < symbolCount; i++) {
        if(strcmp(symbolTable[i].name, name) == 0) {
            return &symbolTable[i];
        }
    }
    return NULL;
}

void insert(char* name, int value) {
    Symbol* s = lookup(name);
    if(s == NULL) {
        if(symbolCount >= MAX_SYMBOLS) {
            report_error("Symbol table overflow");
            return;
        }
        strcpy(symbolTable[symbolCount].name, name);
        symbolTable[symbolCount].value = value;
        symbolTable[symbolCount].initialized = 1;
        symbolCount++;
    } else {
        s->value = value;
        s->initialized = 1;
    }
}

int is_initialized(char* name) {
    Symbol* s = lookup(name);
    return (s != NULL && s->initialized);
}

void emit(char* op, char* arg1, char* arg2, char* result) {
    strcpy(tacTable[tacCount].op, op);
    strcpy(tacTable[tacCount].arg1, arg1);
    strcpy(tacTable[tacCount].arg2, arg2);
    strcpy(tacTable[tacCount].result, result);
    tacCount++;
}

void printThreeAddressCode() {
    printf("\nThree Address Code:\n");
    printf("------------------\n");
    for(int i = 0; i < tacCount; i++) {
        if(strcmp(tacTable[i].op, "label") == 0) {
            printf("\n%s:\n", tacTable[i].result);
        }
        else if(strcmp(tacTable[i].op, "goto") == 0) {
            printf("goto %s\n", tacTable[i].result);
        }
        else if(strcmp(tacTable[i].op, "if_true") == 0) {
            printf("if %s goto %s\n", tacTable[i].arg1, tacTable[i].result);
        }
        else if(strcmp(tacTable[i].op, "if_false") == 0) {
            printf("ifFalse %s goto %s\n", tacTable[i].arg1, tacTable[i].result);
        }
        else if(strcmp(tacTable[i].op, "print") == 0) {
            printf("print %s\n", tacTable[i].arg1);
        }
        else if(strcmp(tacTable[i].arg2, "") == 0) {
            if(strcmp(tacTable[i].op, "=") == 0) {
                printf("%s := %s\n", tacTable[i].result, tacTable[i].arg1);
            } else {
                printf("%s := %s %s\n", tacTable[i].result, tacTable[i].op, tacTable[i].arg1);
            }
        }
        else {
            printf("%s := %s %s %s\n", tacTable[i].result, tacTable[i].arg1, tacTable[i].op, tacTable[i].arg2);
        }
    }
    printf("\n");
}
%}

%union {
    int num;
    char id[50];
}

%token <num> NUMBER
%token <id> IDENTIFIER
%token IF ELSE FOR PRINTF
%token PLUS MINUS MULTIPLY DIVIDE
%token GT LT GE LE EQ NE ASSIGN

%type <num> expr condition
%type <id> lvalue

%%

program: statement_list
       ;

statement_list: statement
             | statement_list statement
             ;

statement: assignment_stmt
        | if_stmt
        | for_stmt
        | printf_stmt
        ;

assignment_stmt: lvalue ASSIGN expr ';' {
    insert($1, $3);
    char val[10];
    sprintf(val, "%d", $3);
    emit("=", val, "", $1);
}
;

if_stmt: IF '(' condition ')' '{' statement_list '}' ELSE '{' statement_list '}'
       ;

for_stmt: FOR '(' assignment_stmt
    {
        emit("label", "", "", "loop_start");
    }
    condition ';' IDENTIFIER ASSIGN expr ')' '{' 
    statement_list 
    {
        Symbol* s = lookup($7);  // Using $7 to reference the IDENTIFIER token
        if(s != NULL) {
            // Increment counter
            int new_val = s->value + 1;
            char val[10];
            sprintf(val, "%d", new_val);
            insert($7, new_val);
            emit("=", val, "", $7);
            
            // Check condition for next iteration
            char* t = newTemp();
            emit("<", val, "5", t);
            emit("if_true", t, "", "loop_start");
        }
        emit("label", "", "", "loop_end");
    }
    '}'
;

printf_stmt: PRINTF '(' expr ')' ';' {
    printf("Output: %d\n", $3);
    char val[10];
    sprintf(val, "%d", $3);
    emit("print", val, "", "");
}
;

condition: expr GT expr { 
        char* t = newTemp();
        char arg1[10], arg2[10];
        sprintf(arg1, "%d", $1);
        sprintf(arg2, "%d", $3);
        emit(">", arg1, arg2, t);
        emit("if_false", t, "", "end");
    }
    | expr LT expr { 
        char* t = newTemp();
        char arg1[10], arg2[10];
        sprintf(arg1, "%d", $1);
        sprintf(arg2, "%d", $3);
        emit("<", arg1, arg2, t);
        emit("if_false", t, "", "end");
    }
    | expr GE expr { 
        char* t = newTemp();
        char arg1[10], arg2[10];
        sprintf(arg1, "%d", $1);
        sprintf(arg2, "%d", $3);
        emit(">=", arg1, arg2, t);
        emit("if_false", t, "", "end");
    }
    | expr LE expr { 
        char* t = newTemp();
        char arg1[10], arg2[10];
        sprintf(arg1, "%d", $1);
        sprintf(arg2, "%d", $3);
        emit("<=", arg1, arg2, t);
        emit("if_false", t, "", "end");
    }
    | expr EQ expr { 
        char* t = newTemp();
        char arg1[10], arg2[10];
        sprintf(arg1, "%d", $1);
        sprintf(arg2, "%d", $3);
        emit("==", arg1, arg2, t);
        emit("if_false", t, "", "end");
    }
    | expr NE expr { 
        char* t = newTemp();
        char arg1[10], arg2[10];
        sprintf(arg1, "%d", $1);
        sprintf(arg2, "%d", $3);
        emit("!=", arg1, arg2, t);
        emit("if_false", t, "", "end");
    }
    ;

expr: NUMBER { $$ = $1; }
    | IDENTIFIER {
        Symbol* s = lookup($1);
        if(s == NULL) {
            report_error("Undefined variable '%s'", $1);
            $$ = 0;
        } else if(!s->initialized) {
            report_error("Variable '%s' used before initialization", $1);
            $$ = 0;
        } else {
            $$ = s->value;
        }
    }
    | expr PLUS expr {
        $$ = $1 + $3;
        char temp[10], arg1[10], arg2[10];
        sprintf(temp, "%d", $$);
        sprintf(arg1, "%d", $1);
        sprintf(arg2, "%d", $3);
        char* t = newTemp();
        emit("+", arg1, arg2, t);
    }
    | expr MINUS expr {
        $$ = $1 - $3;
        char temp[10], arg1[10], arg2[10];
        sprintf(temp, "%d", $$);
        sprintf(arg1, "%d", $1);
        sprintf(arg2, "%d", $3);
        char* t = newTemp();
        emit("-", arg1, arg2, t);
    }
    | expr MULTIPLY expr {
        $$ = $1 * $3;
        char temp[10], arg1[10], arg2[10];
        sprintf(temp, "%d", $$);
        sprintf(arg1, "%d", $1);
        sprintf(arg2, "%d", $3);
        char* t = newTemp();
        emit("*", arg1, arg2, t);
    }
    | expr DIVIDE expr {
        if($3 == 0) {
            report_error("Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
            char temp[10], arg1[10], arg2[10];
            sprintf(temp, "%d", $$);
            sprintf(arg1, "%d", $1);
            sprintf(arg2, "%d", $3);
            char* t = newTemp();
            emit("/", arg1, arg2, t);
        }
    }
    ;

lvalue: IDENTIFIER { strcpy($$, $1); }
      ;

%%

void yyerror(const char* s) {
    report_error("Syntax error: %s", s);
}