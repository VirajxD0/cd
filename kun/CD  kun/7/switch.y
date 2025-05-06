%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int num;
    char* id;
}

%token SWITCH CASE DEFAULT BREAK
%token LPAREN RPAREN LBRACE RBRACE COLON SEMICOLON ASSIGN
%token <num> NUMBER
%token <id> ID

%start program

%%

program:
    switch_stmt
    ;

switch_stmt:
    SWITCH LPAREN ID RPAREN LBRACE case_list default_case RBRACE
    {
        printf("Valid switch-case statement with assignments parsed.\n");
    }
    ;

case_list:
    case_list case_stmt
    |
    case_stmt
    ;

case_stmt:
    CASE NUMBER COLON statement BREAK SEMICOLON
    ;

default_case:
    DEFAULT COLON statement
    |
    /* optional */
    ;

statement:
    ID ASSIGN NUMBER SEMICOLON
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main() {
    printf("Enter switch-case code to parse:\n");
    yyparse();
    return 0;
}
