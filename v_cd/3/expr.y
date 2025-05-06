%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);
extern FILE *yyin;
extern int yylineno;
void reset_lexer(); // To reset line number if needed
%}

%token ID NUM
%token PLUS MINUS MULT DIV LPAREN RPAREN

%left PLUS MINUS
%left MULT DIV

%%
expr:
expr PLUS expr
| expr MINUS expr
| expr MULT expr
| expr DIV expr
| LPAREN expr RPAREN
| ID
| NUM
;
%%

void yyerror(const char *s) {
fprintf(stderr, "\n Syntax Analysis: %s (line %d)\n", s, yylineno);
}

void analyze_file(const char* filename) {
FILE *fp = fopen(filename, "r");
if (!fp) {
perror("File open error");
return;
}

yyin = fp;
yylineno = 1;
printf("\n📂 Processing file: %s\n", filename);
printf("+------------+--------+\n");
printf("| Token Type | Value |\n");
printf("+------------+--------+\n");

if (yyparse() == 0)
printf("\n Syntax Analysis: Valid expression in %s\n", filename);
else
printf("\n Syntax Analysis: Invalid expression in %s\n", filename);

fclose(fp);
}
int main(int argc, char *argv[]) {
if (argc != 3) {
fprintf(stderr, "Usage: %s <input1.txt> <input2.txt>\n", argv[0]);
return 1;
}

analyze_file(argv[1]);
analyze_file(argv[2]);

return 0;
}