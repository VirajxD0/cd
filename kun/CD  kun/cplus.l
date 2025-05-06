%option noyywrap c++

%{
#include <iostream>
#include <string>

using namespace std;

// Token declarations
enum TokenType {
    T_INT = 256,
    T_IDENTIFIER,
    T_ASSIGN,
    T_SEMICOLON,
    T_PLUS
};

extern int yylval;
%}

%%

// Patterns and actions
"int"           { return T_INT; }
[a-zA-Z_][a-zA-Z0-9_]*  { return T_IDENTIFIER; }
"="             { return T_ASSIGN; }
";"             { return T_SEMICOLON; }
"+"             { return T_PLUS; }
[ \t\r\n]+      { /* Ignore whitespace */ }

.               { cerr << "Unknown character: " << yytext << endl; }

%%

// Required for Flex
int yywrap() {
    return 1;
}
