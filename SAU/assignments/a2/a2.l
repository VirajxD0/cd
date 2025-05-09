%{
#include <stdio.h>
%}

%%

"int"|"float"|"char"|"return"|"if"|"else"|"while"|"for"   { printf("KEYWORD: %s\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("IDENTIFIER: %s\n", yytext); }
[0-9]+(\.[0-9]+)?       { printf("NUMBER: %s\n", yytext); }
"=="|"!="|"<="|">="|"="|"+"|"-"|"*"|"/"  { printf("OPERATOR: %s\n", yytext); }
";"|"{"|"}"|"("|")"      { printf("SYMBOL: %s\n", yytext); }
[ \t\n]+                { /* Ignore whitespace */ }
.                       { printf("UNKNOWN: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}

