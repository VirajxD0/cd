%{
#include <stdio.h>

int balance = 0;
%}

%%

"("     { balance++; }
")"     {
            balance--;
            if (balance < 0) {
                printf("Unbalanced parentheses: too many closing parentheses.\n");
                exit(1);
            }
        }

.|\n    ;   // Ignore all other characters

%%

int main() {
    printf("Enter an expression:\n");
    yylex();

    if (balance == 0)
        printf("Parentheses are balanced.\n");
    else
        printf("Unbalanced parentheses: too many opening parentheses.\n");

    return 0;
}

int yywrap() {
    return 1;
}
