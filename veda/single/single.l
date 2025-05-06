%{
#include "bbb.tab.h"
void yyerror(const char *s);
%}

%%
[0-9] { yylval = atoi(yytext); return NUMBER; }
[0-9][0-9]+ { yyerror("Only single-digit numbers are allowed."); return 0; }
[ \t] { /* Ignore whitespace */ }
\n { return '\n'; }
. { return yytext[0]; }
%%
int yywrap() {
 return 1;
}