%{
#include "header.h"
#include "parser.tab.h"
#include <stdlib.h>

extern void report_error(const char* format, ...);
%}

%%
[ \t\n]         ; // Skip whitespace
"if"            { return IF; }
"else"          { return ELSE; }
"for"           { return FOR; }
"Printf"        { return PRINTF; }
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { 
    if (strlen(yytext) >= 50) {
        report_error("Identifier too long (max 49 chars): %s", yytext);
        strcpy(yylval.id, "error");
    } else {
        strcpy(yylval.id, yytext);
    }
    return IDENTIFIER; 
}
"="             { return ASSIGN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULTIPLY; }
"/"             { return DIVIDE; }
">"             { return GT; }
"<"             { return LT; }
">="            { return GE; }
"<="            { return LE; }
"=="            { return EQ; }
"!="            { return NE; }
"{"             { return '{'; }
"}"             { return '}'; }
"("             { return '('; }
")"             { return ')'; }
";"             { return ';'; }
.               { report_error("Invalid character: %s", yytext); }
%%

int yywrap(void) {
    return 1;
}