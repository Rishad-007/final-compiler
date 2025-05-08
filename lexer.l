%{
#include "header.h"
#include "parser.tab.h"
%}

%%
[ \t\n]         ; // Skip whitespace
"if"            { return IF; }
"else"          { return ELSE; }
"for"           { return FOR; }
"Printf"        { return PRINTF; }
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { strcpy(yylval.id, yytext); return IDENTIFIER; }
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
.               { printf("Unknown character\n"); }
%%

int yywrap(void) {
    return 1;
}