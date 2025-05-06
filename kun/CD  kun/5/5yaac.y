%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();

int symbol_table[26];
int final_result = 0;
%}

%token NUMBER VARIABLE
%left '+' '-'
%left '*' '/'
%right '='

%%
input:
    /* empty */
    | input line
    ;

line:
    '\n'
    | exp '\n' { final_result = $1; }
    ;

exp:
    NUMBER      { $$ = $1; }
    | VARIABLE  { $$ = symbol_table[$1]; }
    | VARIABLE '=' exp {
        if ($3 > 9) {
            yyerror("Error: Only single-digit numbers can be assigned to variables");
            $$ = 0;
        } else {
            symbol_table[$1] = $3;
            $$ = $3;
        }
    }
    | exp '+' exp  { $$ = $1 + $3; }
    | exp '-' exp  { $$ = $1 - $3; }
    | exp '*' exp  { $$ = $1 * $3; }
    | exp '/' exp  {
        if ($3 == 0) {
            yyerror("Error: Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter expressions (Ctrl+D to exit):\n");
    yyparse();
    printf("Result: %d\n", final_result);
    return 0;
}
