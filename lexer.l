%{
#include "header.h"
#include "parser.tab.h"
%}

%%
[ \t\n]         ; /* Skip whitespace */
"if"            { return IF; }
"else"          { return ELSE; }
"for"           { return FOR; }
"Printf"        { return PRINTF; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULT; }
"/"             { return DIV; }
"="             { return ASSIGN; }
"=="            { return EQ; }
"<"             { return LT; }
">"             { return GT; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
";"             { return SEMICOLON; }
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { yylval.id = strdup(yytext); return ID; }
.               { printf("Unexpected character: %s\n", yytext); }

%%


int yywrap() {
    return 1;
}