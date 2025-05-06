%{
#include "if.tab.h"
#include <stdio.h>
%}

%%

"if"        { return IF; }
"else"      { return ELSE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }

">"         { return GT; }
"<"         { return LT; }
"=="        { return EQ; }
"!="        { return NE; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }

[0-9]+      { return NUMBER; }
[a-zA-Z][a-zA-Z0-9_]*  { return ID; }

[ \t\n]     { /* skip whitespace */ }

.           { printf("Unexpected character: %c\n", yytext[0]); }

%%

int yywrap() {
    return 1;
}
