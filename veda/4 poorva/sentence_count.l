%{
#include <stdio.h>
int sentence_count = 0;
%}

%%

[.?!]          { sentence_count++; }
\n             { /* Ignore newlines */ }
[ \t\r]+       { /* Ignore spaces and tabs */ }
.              { /* Ignore other characters */ }

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter text (Ctrl+Z to stop on Windows):\n");
    yylex(); // Start the lexical analysis

    printf("Number of Sentences: %d\n", sentence_count);
    return 0;
}
