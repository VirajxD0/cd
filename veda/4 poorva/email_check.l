%{
#include <stdio.h>
#include <string.h>
%}

%%
^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$   { printf("%s\t-> Valid Email Address\n", yytext); }
^[^\n]+$                                              { printf("%s\t-> Invalid Email Address\n", yytext); }
%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter email addresses (Ctrl+D to stop on Linux/Mac, Ctrl+Z then Enter on Windows):\n");
    yylex();
    return 0;
}
