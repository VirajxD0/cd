%{
#include <stdio.h>

int digit_count = 0;
int letter_count = 0;
int special_count = 0;
%}

%%

[0-9]              { digit_count++; }
[a-zA-Z]           { letter_count++; }
[^a-zA-Z0-9 \t\n]  { special_count++; }
[ \t\n]            { /* Ignore whitespace */ }

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter input (Ctrl+D to stop on Linux/Mac, Ctrl+Z then Enter on Windows):\n");
    yylex();
    printf("\n===== Summary =====\n");
    printf("Digits: %d\n", digit_count);
    printf("Letters: %d\n", letter_count);
    printf("Special Characters: %d\n", special_count);
    return 0;
}
