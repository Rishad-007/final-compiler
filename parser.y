%{
#include "header.h"

Symbol symbols[100];
int symbol_count = 0;
ThreeAddressCode* code_head = NULL;
int temp_var_counter = 0;
int label_counter = 0;
int in_true_block = 0;  // Track if we're in the true block
int in_else_block = 0;  // Track if we're in the else block

void yyerror(const char* s);
char* new_label();
%}

%union {
    int num;
    char* id;
    struct {
        int value;
        char* addr;
    } expr;
}

%token <num> NUMBER
%token <id> ID
%token PLUS MINUS MULT DIV
%token ASSIGN EQ LT GT
%token IF ELSE FOR PRINTF
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON

%type <expr> expr stmt stmt_list if_stmt for_stmt

%%

program: stmt_list
       ;

stmt_list: stmt
        | stmt_list stmt
        ;

stmt: ID ASSIGN expr SEMICOLON {
        set_symbol_value($1, $3.value);
        add_three_address_code("=", $3.addr, "", $1);
    }
    | if_stmt
    | for_stmt
    | PRINTF LPAREN expr RPAREN SEMICOLON {
        // Only print if we're in the correct block
        if ((in_true_block && !in_else_block) || (!in_true_block && in_else_block)) {
            printf("%d\n", $3.value);
        }
        add_three_address_code("printf", $3.addr, "", "");
    }
    ;

if_stmt: IF LPAREN expr RPAREN {
        char* else_label = new_label();
        char* end_label = new_label();
        $<expr>$.addr = strdup(else_label);  // Store else label
        $<expr>$.value = $3.value;
        add_three_address_code("ifFalse", $3.addr, else_label, "");  // Jump to else if false
    } LBRACE stmt_list RBRACE ELSE {
        char* else_label = $<expr>5.addr;  // Get stored else label
        char* end_label = new_label();
        add_three_address_code("goto", "", "", end_label);  // Skip else block
        add_three_address_code("label", "", "", else_label);  // Mark start of else
        $<expr>$.addr = strdup(end_label);  // Store end label
    } LBRACE stmt_list RBRACE {
        char* end_label = $<expr>9.addr;  // Get stored end label
        add_three_address_code("label", "", "", end_label);  // Mark end of if-else
    }
    | IF LPAREN expr RPAREN {
        char* false_label = new_label();
        $<expr>$.addr = strdup(false_label);
        $<expr>$.value = $3.value;
        add_three_address_code("ifFalse", $3.addr, false_label, "");
    } LBRACE stmt_list RBRACE {
        char* false_label = $<expr>5.addr;
        add_three_address_code("label", "", "", false_label);
    };

for_stmt: FOR LPAREN ID ASSIGN expr SEMICOLON expr SEMICOLON ID ASSIGN expr RPAREN {
        loop_depth++;  // Enter loop
        set_symbol_value($3, $5.value);  // Initialize loop variable
        char* start_label = new_label();
        char* end_label = new_label();
        add_three_address_code("=", $5.addr, "", $3);
        add_three_address_code("label", "", "", start_label);

        // Store loop info for later use
        $<expr>$.addr = start_label;
        $<expr>$.value = get_symbol_value($3);  // Initial value
        
        // Store loop variable and increment info
        char* loop_var = strdup($3);
        char* inc_var = strdup($9);
        int condition_value = $7.value;
    } LBRACE stmt_list RBRACE {
        char* start_label = $<expr>12.addr;
        char* end_label = new_label();
        
        // Update loop variable and check condition
        set_symbol_value($9, get_symbol_value($9) + 1);
        add_three_address_code("=", $11.addr, "", $9);
        
        // Add condition check and loop back
        add_three_address_code("ifFalse", $7.addr, end_label, "");
        add_three_address_code("goto", "", "", start_label);
        add_three_address_code("label", "", "", end_label);
        
        loop_depth--;  // Exit loop
    }
    ;

expr: NUMBER {
        char temp[20];
        sprintf(temp, "%d", $1);
        $$.addr = strdup(temp);
        $$.value = $1;
    }
    | ID {
        $$.addr = $1;
        $$.value = get_symbol_value($1);
    }
    | expr PLUS expr {
        $$.addr = new_temp_var();
        $$.value = $1.value + $3.value;
        add_three_address_code("+", $1.addr, $3.addr, $$.addr);
    }
    | expr MINUS expr {
        $$.addr = new_temp_var();
        $$.value = $1.value - $3.value;
        add_three_address_code("-", $1.addr, $3.addr, $$.addr);
    }
    | expr MULT expr {
        $$.addr = new_temp_var();
        $$.value = $1.value * $3.value;
        add_three_address_code("*", $1.addr, $3.addr, $$.addr);
    }
    | expr DIV expr {
        $$.addr = new_temp_var();
        $$.value = $1.value / $3.value;
        add_three_address_code("/", $1.addr, $3.addr, $$.addr);
    }
    | expr LT expr {
        $$.addr = new_temp_var();
        $$.value = $1.value < $3.value;
        add_three_address_code("<", $1.addr, $3.addr, $$.addr);
    }
    | expr GT expr {
        $$.addr = new_temp_var();
        $$.value = $1.value > $3.value;
        add_three_address_code(">", $1.addr, $3.addr, $$.addr);
    }
    | expr EQ expr {
        $$.addr = new_temp_var();
        $$.value = $1.value == $3.value;
        add_three_address_code("==", $1.addr, $3.addr, $$.addr);
    }
    | LPAREN expr RPAREN {
        $$.addr = $2.addr;
        $$.value = $2.value;
    }
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

char* new_temp_var() {
    char* temp = malloc(10);
    sprintf(temp, "t%d", temp_var_counter++);
    return temp;
}

char* new_label() {
    char* label = malloc(10);
    sprintf(label, "L%d", label_counter++);
    return label;
}

void add_three_address_code(char* op, char* arg1, char* arg2, char* result) {
    ThreeAddressCode* code = malloc(sizeof(ThreeAddressCode));
    code->op = strdup(op);
    code->arg1 = strdup(arg1);
    code->arg2 = strdup(arg2);
    code->result = strdup(result);
    code->next = NULL;

    if (code_head == NULL) {
        code_head = code;
    } else {
        ThreeAddressCode* current = code_head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = code;
    }
}