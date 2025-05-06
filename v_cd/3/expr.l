%{
#include "expr.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_token(const char* type, const char* value);
%}

%%
[ \t]+ ; // Ignore spaces/tabs
\n { /* No need to manually increment yylineno, Flex does it */ }

[a-zA-Z] {
print_token("ID", yytext);
return ID;
}

[0-9]+ {
print_token("NUM", yytext);
yylval = atoi(yytext);
return NUM;
}

"+" { print_token("PLUS", yytext); return PLUS; }
"-" { print_token("MINUS", yytext); return MINUS; }
"*" { print_token("MULT", yytext); return MULT; }
"/" { print_token("DIV", yytext); return DIV; }
"(" { print_token("LPAREN", yytext); return LPAREN; }
")" { print_token("RPAREN", yytext); return RPAREN; }

. {
printf("Invalid character: %s\n", yytext);
}
%%

void print_token(const char* type, const char* value) {
printf("| %-10s | %-6s |\n", type, value);
}

int yywrap() {
return 1;
}