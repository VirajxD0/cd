%{
#include "switch.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // <-- Required for strdup
%}

%%
"switch"        { return SWITCH; }
"case"          { return CASE; }
"default"       { return DEFAULT; }
"break"         { return BREAK; }
"="             { return ASSIGN; }
";"             { return SEMICOLON; }
":"             { return COLON; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*   { yylval.id = strdup(yytext); return ID; }
[ \t\n]         ; // Ignore whitespace
.               { printf("Unknown character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}
