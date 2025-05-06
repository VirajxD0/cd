%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
int yylex();
%}
%token NUMBER
/* Define precedence and associativity of operators */
%left '+' '-'
%%
/* Grammar rules */
input:
 /* empty */
 | input line
 ;
line:
 '\n'
 | exp '\n' { printf("Result: %d\n", $1); }
 ;
exp:
 NUMBER { $$ = $1; }
 | exp '+' exp { $$ = $1 + $3; }
 | exp '-' exp { $$ = $1 - $3; }
 ;
%%
/* Error handling */
void yyerror(const char *s) {
 fprintf(stderr, "Error: %s\n", s);
}
int main() {
 printf("Enter single-digit expressions to evaluate (Ctrl+D to exit):\n");
 yyparse();
 return 0;
}