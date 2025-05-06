%{
#include <stdio.h>
#include <string.h>

#define MAX 100

typedef struct {
  char type[20];
  char lexeme[200];
} Token;

Token tokens[MAX];
int token_count = 0;

int keywords = 0, identifiers = 0, operators = 0, strings = 0, comments = 0;
int numbers = 0, punctuations = 0, characters = 0, errors = 0;

void add_tokens(const char* type, const char* lexeme) {
    if (token_count < MAX) {
        strcpy(tokens[token_count].type, type);
        strcpy(tokens[token_count].lexeme, lexeme);
        token_count++;
    }
}
%}

%option noyywrap

KEYWORD     def|class|if|elif|else|for|while|return|import|from|as|try|except|finally|with|lambda|pass|break|continue|and|or|not|in|is|None|True|False
ID          [a-zA-Z_][a-zA-Z0-9_]*
NUMBER      [0-9]+(\.[0-9]+)?
STRING      (\"([^\\\"]|\\.)*\"|\'([^\\\']|\\.)*\')
OP          \+|\-|\*|\/|\%|\*\*|\=|\==|\!=|\<|\>|\<=|\>=|\+=|\-=|\*=|\/=|\%=|\/\/|not|in|is|and|or
PUNCT       [()\[\]{}.,:;]
COMMENT     \#.*

%%

{KEYWORD}   { add_tokens("keywords", yytext); keywords++; }
{ID}        { add_tokens("identifiers", yytext); identifiers++; }
{NUMBER}    { add_tokens("numbers", yytext); numbers++; }
{STRING}    { add_tokens("string", yytext); strings++; }
{OP}        { add_tokens("operators", yytext); operators++; }
{PUNCT}     { add_tokens("punctuations", yytext); punct_
