%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
%}

%%

[0-9]+\.[0-9]+ { 
    printf("%s    Floating Point\n", yytext);
}

[0-9]+ { 
    printf("%s    Integer\n", yytext);
}

\'[a-zA-Z]\' { 
    printf("%s    Character\n", yytext);
}

[ \t\n] { 
    // Ignore spaces, tabs, and newlines
}

[^0-9a-zA-Z\s] { 
    printf("%s    Invalid Token\n", yytext);
}

. { 
    // Catch any invalid token or character
    printf("%s    Invalid Token\n", yytext);
}

%%

int yywrap() {
    return 1; // End of input
}

int main() {
    printf("Enter input (Ctrl+D to stop on Linux/Mac, Ctrl+Z then Enter on Windows):\n");
    yylex();
    return 0;
}
