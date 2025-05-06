%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line_no = 1;
%}

%%
"the"|"The"                 { printf("%-8d | %-15s | %-12s\n", line_no, yytext, "ARTICLE"); }
"boy"|"Boy"|"girl"|"Girl"|"Viraj"|"Vir"    { printf("%-8d | %-15s | %-12s\n", line_no, yytext, "NOUN"); }
"is"|"are"|"was"|"were"      { printf("%-8d | %-15s | %-12s\n", line_no, yytext, "PRONOUN"); }
"swimming"|"running"|"eating"|"walking" { printf("%-8d | %-15s | %-12s\n", line_no, yytext, "VERB"); }
[.,?!;:"'()\[\]]             { printf("%-8d | %-15s | %-12s\n", line_no, yytext, "PUNCTUATION"); }
[a-zA-Z]+                    { printf("%-8d | %-15s | %-12s\n", line_no, yytext, "UNKNOWN"); }
[\t ]+                       { /* Ignore spaces and tabs */ }
\n                           { line_no++; }
%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Error opening file: %s\n", argv[1]);
        return 1;
    }

    yyin = file;

    // Print table header
    printf("\n%-8s | %-15s | %-12s\n", "Line No", "Lexeme", "Token");
    printf("----------------------------------------------------\n");

    yylex();
    fclose(file);

    return 0;
}

int yywrap() {
    return 1;
}
