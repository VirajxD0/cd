%{
#include <stdio.h>
#include <stdlib.h>
#include "bison_code.tab.h"

int line_num = 1;
void print_token(const char* type, const char* value);
%}

%option noyywrap

%%

"while"                { print_token("KEYWORD", yytext); return KEYWORD; }
"("                    { print_token("LPAREN", yytext); return LPAREN; }
")"                    { print_token("RPAREN", yytext); return RPAREN; }
"{"                    { print_token("LBRACE", yytext); return LBRACE; }
"}"                    { print_token("RBRACE", yytext); return RBRACE; }
";"                    { print_token("SEMICOLON", yytext); return SEMICOLON; }

"="                    { print_token("ASSIGN", yytext); return ASSIGN; }
"+"                    { print_token("PLUS", yytext); return PLUS; }
"-"                    { print_token("MINUS", yytext); return MINUS; }
"*"                    { print_token("MULT", yytext); return MULT; }
"/"                    { print_token("DIV", yytext); return DIV; }
">"                    { print_token("GT", yytext); return GT; }
"<"                    { print_token("LT", yytext); return LT; }

[0-9]+                 { print_token("NUMBER", yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { print_token("IDENTIFIER", yytext); return IDENTIFIER; }

[ \t\r]+               ;   // skip whitespace
\n                     { line_num++; }
.                      { print_token("UNKNOWN", yytext); return 0; }

%%

void print_token(const char* type, const char* value) {
    printf("| %-14s | %-14s | %-10d |\n", type, value, line_num);
}
