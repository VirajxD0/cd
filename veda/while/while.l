%{
#include "while.tab.h"
#include <stdio.h>
#include <string.h>
%}

%%
"while"     { return WHILE; }
"do"        { return DO; }
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

[0-9]+      { return NUMBER; }  /* Numbers */
[a-zA-Z][a-zA-Z0-9_]*  { return ID; }  /* Identifiers */

[ \t\n]     { /* Ignore whitespace */ }

.           { printf("Unexpected character: %c\n", yytext[0]); }

%%

int yywrap() {
    return 1;
}
