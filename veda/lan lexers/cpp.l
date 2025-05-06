%{
#include <iostream>
#include <fstream>
using namespace std;
int lineno = 1;
extern "C" int yylex();
extern FILE *yyin;
%}

%option noyywrap

ID        [a-zA-Z_][a-zA-Z0-9_]*
NUM       [0-9]+|[0-9]+[.0-9]+
OPERATOR  "="|"+"|"-"|"*"|"/"
CONDI_OP  "=="|"<="|">="|">"|"<"
DELIMITER [;]
KEYWORDS  "int"|"float"|"char"|"if"|"while"

%%

\n              { lineno++; }
{KEYWORDS}      { cout << lineno << "\tKEY\t" << yytext << endl; }
{ID}            { cout << lineno << "\tID\t" << yytext << endl; }
{NUM}           { cout << lineno << "\tNUM\t" << yytext << endl; }
{OPERATOR}      { cout << lineno << "\tOP\t" << yytext << endl; }
{CONDI_OP}      { cout << lineno << "\tCOP\t" << yytext << endl; }
{DELIMITER}     { cout << lineno << "\tDIL\t" << yytext << endl; }
"("             { cout << lineno << "\tLeft paren:\t" << yytext << endl; }
")"             { cout << lineno << "\tRight paren:\t" << yytext << endl; }
"{"             { cout << lineno << "\tLeft Curly:\t" << yytext << endl; }
"}"             { cout << lineno << "\tRight Curly:\t" << yytext << endl; }

[ \t\r]+        { /* ignore whitespace */ }
.               { cout << lineno << "\tUnknown:\t" << yytext << endl; }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    }
    cout << "Line\tToken\tLexeme" << endl;
    yylex();
    return 0;
}
