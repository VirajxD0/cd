#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#define MAX_TOKEN_LENGTH 100
#define MAX_TOKENS 1000
#define COLUMN_COUNT 7

const char *keywords[] = {"SELECT", "FROM", "WHERE", "INSERT", "INTO", "VALUES", "UPDATE", "SET", "DELETE", "CREATE", "TABLE", "DROP", "ALTER"};
int keyword_count = sizeof(keywords) / sizeof(keywords[0]);

typedef enum { KEYWORD, IDENTIFIER, OPERATOR, NUMBER, STRING, SYMBOL, COMMENT, ERROR } TokenType;

typedef struct {
TokenType type;
char value[MAX_TOKEN_LENGTH];
} Token;

Token tokens[MAX_TOKENS];
int token_count = 0;

int isKeyword(char *word) {
for (int i = 0; i < keyword_count; i++) {
if (strcasecmp(word, keywords[i]) == 0) {
return 1;
}
}
return 0;
}

void addToken(TokenType type, char *value) {
if (token_count < MAX_TOKENS) {
tokens[token_count].type = type;
strcpy(tokens[token_count].value, value);
token_count++;
}
}

void lexicalAnalysis(char *input) {
int i = 0, j;
char buffer[MAX_TOKEN_LENGTH];
while (input[i] != '\0') {
if (isspace(input[i])) {
i++;
} else if (isalpha(input[i]) || input[i] == '_') {
j = 0;
while (isalnum(input[i]) || input[i] == '_') {
buffer[j++] = input[i++];
}
buffer[j] = '\0';
if (isKeyword(buffer)) {
addToken(KEYWORD, buffer);
} else {
addToken(IDENTIFIER, buffer);
}
} else if (isdigit(input[i])) {
j = 0;
while (isdigit(input[i])) {
buffer[j++] = input[i++];
}
buffer[j] = '\0';
addToken(NUMBER, buffer);
} else if (input[i] == '\'') {
j = 0;
buffer[j++] = input[i++];
while (input[i] != '\'' && input[i] != '\0') {
buffer[j++] = input[i++];
}
if (input[i] == '\'') {
buffer[j++] = input[i++];
buffer[j] = '\0';
addToken(STRING, buffer);
} else {
addToken(ERROR, "Unterminated string");
}
} else if (input[i] == '-' && input[i+1] == '-') {
while (input[i] != '\n' && input[i] != '\0') {
i++;
}
addToken(COMMENT, "-- comment");
} else if (strchr("=<>!", input[i])) {
buffer[0] = input[i];
buffer[1] = '\0';
if ((input[i] == '=' || input[i] == '<' || input[i] == '>' || input[i] == '!') && input[i+1] == '=') {
buffer[1] = '=';
buffer[2] = '\0';
i++;
}
addToken(OPERATOR, buffer);
i++;
} else if (strchr("(),;*", input[i])) {
buffer[0] = input[i];
buffer[1] = '\0';
addToken(SYMBOL, buffer);
i++;
} else {
buffer[0] = input[i];
buffer[1] = '\0';
addToken(ERROR, buffer);
i++;
}
}
}

void writeTokensToFile(const char *filename) {
FILE *file = fopen(filename, "w");
if (!file) {
printf("Error opening output file.\n");
return;
}
fprintf(file, "| %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s |\n", 
"KEYWORD", "IDENTIFIER", "OPERATOR", "NUMBER", "STRING", "SYMBOL", "COMMENT");
fprintf(file, "-----------------------------------------------------------------------------------\n");
for (int i = 0; i < token_count; i++) {
fprintf(file, "| %-10s |", tokens[i].type == KEYWORD ? tokens[i].value : "");
fprintf(file, " %-10s |", tokens[i].type == IDENTIFIER ? tokens[i].value : "");
fprintf(file, " %-10s |", tokens[i].type == OPERATOR ? tokens[i].value : "");
fprintf(file, " %-10s |", tokens[i].type == NUMBER ? tokens[i].value : "");
fprintf(file, " %-10s |", tokens[i].type == STRING ? tokens[i].value : "");
fprintf(file, " %-10s |", tokens[i].type == SYMBOL ? tokens[i].value : "");
fprintf(file, " %-10s |\n", tokens[i].type == COMMENT ? tokens[i].value : "");
}
fprintf(file, "\nTotal Tokens: %d\n", token_count);
fclose(file);
}

int main() {
char input[1000];
FILE *inputFile = fopen("/Users/virajdeshmukh/Downloads/Assignments/Assignments CD 10/Assignment/1/input.sql", "r");
if (!inputFile) {
printf("Error opening input file.\n");
return 1;
}
fread(input, sizeof(char), 999, inputFile);
fclose(inputFile);
lexicalAnalysis(input);
writeTokensToFile("/Users/virajdeshmukh/Downloads/Assignments/Assignments CD 10/Assignment/1/Output.txt");
printf("Lexical analysis complete. Results saved to output.txt.\n");
return 0;
}