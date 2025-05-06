%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
int syntax_valid = 1;  // Flag to track if syntax is valid
%}

%token WHILE DO LPAREN RPAREN LBRACE RBRACE SEMICOLON ID NUMBER
%token GT LT EQ NE ASSIGN PLUS MINUS

/* Precedence rules to resolve conflicts */
%left GT LT EQ NE
%left PLUS MINUS
%right ASSIGN

%%
program: statement;

statement: while_stmt | do_while_stmt | while_do_stmt;

while_stmt: WHILE LPAREN condition RPAREN compound_statement
          | WHILE error { yyerror("Syntax error in while statement"); syntax_valid = 0; };

do_while_stmt: DO compound_statement WHILE LPAREN condition RPAREN SEMICOLON
             | DO error { yyerror("Syntax error in do-while statement"); syntax_valid = 0; };

while_do_stmt: WHILE LPAREN condition RPAREN DO compound_statement
             | WHILE LPAREN condition RPAREN DO error { yyerror("Syntax error in while-do statement"); syntax_valid = 0; };

compound_statement: block | simple_statement;

block: LBRACE statement_list RBRACE | LBRACE RBRACE  /* Empty block */;

statement_list: simple_statement | statement_list simple_statement;

simple_statement: SEMICOLON  /* Empty statement */| expression SEMICOLON;

condition: expression;

expression: ID
          | NUMBER
          | LPAREN expression RPAREN
          | expression PLUS expression
          | expression MINUS expression
          | expression GT expression
          | expression LT expression
          | expression EQ expression
          | expression NE expression
          | ID ASSIGN expression;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
    printf("Enter a while/do-while/while-do statement:\n");
    yyparse();
    if (syntax_valid) {
        printf("Syntax is correct.\n");
    } else {
        printf("Syntax contains errors.\n");
    }
    return 0;
}
