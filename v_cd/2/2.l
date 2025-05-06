%{
#include <stdio.h>
#include <string.h>

#define MAX_TOKENS 100

typedef struct {
char keyword[20];
char identifier[20];
char integer[20];
char float_num[20];
char operator[5];
char special_char[5];
} Token;

Token tokens[MAX_TOKENS];
int token_count = 0;

char stored_identifiers[MAX_TOKENS][20]; // To store unique identifiers
int identifier_count = 0;

void print_table();
int is_identifier_stored(const char *id);
%}

%%

"int"|"return"|"if"|"else"|"float" { strcpy(tokens[token_count].keyword, yytext); token_count++; }
[a-zA-Z_][a-zA-Z0-9_]* { 
if (!is_identifier_stored(yytext)) { 
strcpy(tokens[token_count].identifier, yytext); 
strcpy(stored_identifiers[identifier_count], yytext);
identifier_count++;
token_count++; 
}
}
[0-9]+ { strcpy(tokens[token_count].integer, yytext); token_count++; }
[0-9]*\.[0-9]+ { strcpy(tokens[token_count].float_num, yytext); token_count++; }
[\+\-\*/=><!]=? { strcpy(tokens[token_count].operator, yytext); token_count++; }
[\{\}\(\);] { strcpy(tokens[token_count].special_char, yytext); token_count++; }
[ \t\n] { /* Ignore whitespace */ }
. { /* Ignore unknown tokens */ }

%%

int is_identifier_stored(const char *id) {
for (int i = 0; i < identifier_count; i++) {
if (strcmp(stored_identifiers[i], id) == 0) {
return 1; // Identifier already stored
}
}
return 0; // New identifier
}

int main() {
printf("Enter C code (Press Ctrl+D to finish input on terminal):\n");
yylex(); // Process input fully before printing
printf("\nLexical Analysis Table:\n");
printf("-----------------------------------------------------------------------------\n");
printf("| %-10s | %-12s | %-8s | %-8s | %-8s | %-15s |\n",
"Keyword", "Identifier", "Integer", "Float", "Operator", "Special Character");
printf("-----------------------------------------------------------------------------\n");

for (int i = 0; i < token_count; i++) {
printf("| %-10s | %-12s | %-8s | %-8s | %-8s | %-15s |\n",
tokens[i].keyword[0] ? tokens[i].keyword : "",
tokens[i].identifier[0] ? tokens[i].identifier : "",
tokens[i].integer[0] ? tokens[i].integer : "",
tokens[i].float_num[0] ? tokens[i].float_num : "",
tokens[i].operator[0] ? tokens[i].operator : "",
tokens[i].special_char[0] ? tokens[i].special_char : "");
}
printf("-----------------------------------------------------------------------------\n");
return 0;
}

int yywrap() {
return 1;
}