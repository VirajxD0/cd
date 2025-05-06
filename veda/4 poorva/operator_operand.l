%{
#include <stdio.h>

%}

%%

[0-9]+                 { printf("%s\t-> Operand (Integer)\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]* { printf("%s\t-> Operand (Identifier)\n", yytext); }
"=="|"!="|"<="|">="    { printf("%s\t-> Relational Operator\n", yytext); }
"&&"|"||"              { printf("%s\t-> Logical Operator\n", yytext); }
"+"|"-"|"*"|"/"        { printf("%s\t-> Arithmetic Operator\n", yytext); }
"<"|">"|"="            { printf("%s\t-> Assignment or Relational Operator\n", yytext); }
";"|"("|")"|"{"|"}"    { /* Ignore punctuation */ }
[ \t\n]+               { /* Ignore whitespace */ }
.                      { printf("%s\t-> Unknown Token\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter code (Ctrl+D to stop on Linux/Mac, Ctrl+Z then Enter on Windows):\n");
    yylex();
    return 0;
}
