%{
#include <stdio.h>
#include <string.h>

// Function to convert digit to word
const char* digit_to_word(char digit) {
    switch(digit) {
        case '0': return "zero";
        case '1': return "one";
        case '2': return "two";
        case '3': return "three";
        case '4': return "four";
        case '5': return "five";
        case '6': return "six";
        case '7': return "seven";
        case '8': return "eight";
        case '9': return "nine";
        default: return "";
    }
}

// Function to convert word to digit
char word_to_digit(const char* word) {
    if (strcmp(word, "zero") == 0) return '0';
    if (strcmp(word, "one") == 0) return '1';
    if (strcmp(word, "two") == 0) return '2';
    if (strcmp(word, "three") == 0) return '3';
    if (strcmp(word, "four") == 0) return '4';
    if (strcmp(word, "five") == 0) return '5';
    if (strcmp(word, "six") == 0) return '6';
    if (strcmp(word, "seven") == 0) return '7';
    if (strcmp(word, "eight") == 0) return '8';
    if (strcmp(word, "nine") == 0) return '9';
    return '\0';  // Not a match
}
%}

%%

[0-9] {
    // Convert digit to word
    printf("%s", digit_to_word(yytext[0]));
}

(zero|one|two|three|four|five|six|seven|eight|nine) {
    // Convert word to digit
    char digit = word_to_digit(yytext);
    if (digit != '\0') {
        printf("%c", digit);
    }
}

[ \t\n]     { printf("%s", yytext); }  // Preserve whitespace
.           { printf("%s", yytext); }  // Print all other characters as-is

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter input text (Ctrl+D to end input on Unix or Ctrl+Z on Windows):\n");
    yylex();
    return 0;
}
