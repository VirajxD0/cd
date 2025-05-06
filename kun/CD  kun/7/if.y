%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
int syntax_valid = 1;
%}

%token IF ELSE LPAREN RPAREN LBRACE RBRACE SEMICOLON
%token ID NUMBER
%token GT LT EQ NE ASSIGN PLUS MINUS

%left GT LT EQ NE
%left PLUS MINUS
%right ASSIGN

%%
program: statement;

statement:
      if_stmt
    | matched_stmt
    ;

if_stmt:
      IF LPAREN condition RPAREN statement %prec IF
    | IF LPAREN condition RPAREN statement ELSE statement
    | IF error { yyerror("Syntax error in if statement"); syntax_valid = 0; }
    ;

matched_stmt:
      block
    | expression SEMICOLON
    | SEMICOLON
    ;

block:
      LBRACE statement_list RBRACE
    | LBRACE RBRACE
    ;

statement_list:
      statement
    | statement_list statement
    ;

condition:
      expression
    ;

expression:
      ID
    | NUMBER
    | LPAREN expression RPAREN
    | expression PLUS expression
    | expression MINUS expression
    | expression GT expression
    | expression LT expression
    | expression EQ expression
    | expression NE expression
    | ID ASSIGN expression
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
    printf("Enter an if or if-else statement:\n");
    yyparse();
    if (syntax_valid) {
        printf("Syntax is correct.\n");
    } else {
        printf("Syntax contains errors.\n");
    }
    return 0;
}

