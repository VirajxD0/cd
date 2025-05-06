%{
#include "5yaac.tab.h"
#include <ctype.h>
#include <stdlib.h>

extern int yylval;
extern void yyerror(const char *s);
%}

%%

[0-9]       { yylval = atoi(yytext); return NUMBER; }
[1-9][0-9]  { yyerror("Error: Only single-digit numbers are allowed for variables"); }
[a-z]       { yylval = yytext[0] - 'a'; return VARIABLE; }
[+\-*/=]    { return yytext[0]; }
[\t ]       { /* Ignore whitespace */ }
\n          { return '\n'; }
.           { return yytext[0]; }

%%

int yywrap() { return 1; }