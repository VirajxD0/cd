%{
#include <stdio.h>
%}

%%
"<!DOCTYPE"[^>]*">"       { printf("DOCTYPE: %s\n", yytext); }
"<[^/][^ >]*"             { printf("Start Tag: %s\n", yytext); }
"</[^>]+>"                { printf("End Tag: %s\n", yytext); }
"[a-zA-Z]+="[^\"]*"       { printf("Attribute: %s\n", yytext); }
">"                       { /* Ignore individual '>' */ }
"[^<>\n]+"                { printf("Content: %s\n", yytext); }
[ \t\n]+                  { /* Ignore whitespace */ }
.                         { printf("Unknown: %s\n", yytext); }
%%

int main() {
    printf("Enter HTML code (CTRL+D to stop):\n");
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
