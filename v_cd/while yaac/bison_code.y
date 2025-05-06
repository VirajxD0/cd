%{
#include <stdio.h>
#include <stdlib.h>


int yylex();
void yyerror(const char* s);
extern int line_num;
extern FILE* yyin;
%}

%token KEYWORD LPAREN RPAREN LBRACE RBRACE SEMICOLON
%token IDENTIFIER NUMBER
%token ASSIGN PLUS MINUS MULT DIV GT LT
%left PLUS MINUS
%left MULT DIV
%left GT LT
%right ASSIGN
%%


program:
    statement_list
;

statement_list:
    /* empty */
    | statement_list statement
;

statement:
    while_stmt
    | assignment_stmt
;

while_stmt:
    KEYWORD LPAREN expression RPAREN LBRACE statement_list RBRACE
;

assignment_stmt:
    IDENTIFIER ASSIGN expression SEMICOLON
;

expression:
    IDENTIFIER
    | NUMBER
    | expression PLUS expression
    | expression MINUS expression
    | expression MULT expression
    | expression DIV expression
    | expression GT expression
    | expression LT expression
;

%%

void yyerror(const char* s) {
    fprintf(stderr, "\nSYNTAX ERROR at line %d: %s\n", line_num, s);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <file1.c> [file2.c ...]\n", argv[0]);
        return 1;
    }
    for (int i = 1; i < argc; i++) {
        FILE* file = fopen(argv[i], "r");
        if (!file) {
            perror(argv[i]);
            continue;
        }
        printf("\n================ Processing file: %s ================\n", argv[i]);
        printf("| %-14s | %-14s | %-10s |\n", "Token Type", "Token Value", "Line No.");
        printf("|----------------|----------------|------------|\n");
        yyin = file;
        line_num = 1;
        if (yyparse() == 0) {
            printf("\nSyntax Analysis Completed Successfully for %s\n", argv[i]);
        }
        fclose(file);
    }
    return 0;
}
