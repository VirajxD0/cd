%{
  #include<stdio.h>
  #include<string.h>

  #define MAX 100

  typedef struct {
    char type[20];
    char lexeme[200];
  } Token;

  Token tokens[MAX];
  int token_count = 0;

  int keywords = 0, identifiers = 0, operators = 0, strings = 0, comments = 0;
  int numbers = 0, punctuations = 0, characters = 0, errors = 0;

  void add_tokens(const char* type, const char* lexeme) {
      if (token_count < MAX) {
          strcpy(tokens[token_count].type, type);
          strcpy(tokens[token_count].lexeme, lexeme);
          token_count++;
      }
  }

%}

%option noyywrap

KEYWORD     int|float|char|if|else|while|return|for|void|class|private|public|namespace|new|delete|endl|using|std|iostream              
ID          [a-zA-Z_][a-zA-Z0-9_]*
NUMBER      [0-9]+(\.[0-9]+)?
STRING      \"([^\\\"]|\\.)*\"
CHAR        \'[a-zA-Z0-9]\'
OP          ::|->|<<|>>|\+\+|--|&&|\|\||\+|\-|\*|\/|\%|\=\=|\!|\=|\<|\>|\<=|\>=|\!=
PUNCT       [()\[\]{}.,;]
COMMENT1    \/\/[^\n]*
COMMENT2    \/\*([^*]|\*+[^*/])*\*+\/

%%

{KEYWORD}       { add_tokens("keywords", yytext); keywords++; }
{ID}            { add_tokens("identifiers", yytext); identifiers++; }
{NUMBER}        { add_tokens("numbers", yytext); numbers++; }
{STRING}        { add_tokens("string", yytext); strings++; }
{CHAR}          { add_tokens("characters", yytext); characters++; }
{OP}            { add_tokens("operators", yytext); operators++; }
{PUNCT}         { add_tokens("punctuations", yytext); punctuations++; }
{COMMENT1}      { comments++; }
{COMMENT2}      { comments++; }
[ \t\n]         ;
"#"[a-zA-Z_]+[ \t]*[<\"]?[a-zA-Z0-9_/.]+[>\"]?        { add_tokens("Preprocessor", yytext); }
\"([^\\\"]|\\.)*         { add_tokens("Lexical Error", yytext); errors++; }  // Unclosed string
\'[^']*                  { add_tokens("Lexical Error", yytext); errors++; }  // Unclosed char
[^a-zA-Z0-9_ \t\n{}()\[\];:,.<>+\-*/%=!&|^'"#]  { add_tokens("Lexical Error", yytext); errors++; } // Invalid symbols
.               { add_tokens("Lexical Error", yytext); errors++; }

%%

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror("File open error");
        return 1;
    }

    yyin = fp;
    yylex();
    fclose(fp);

    printf("\n--- Token Table ---\n");
    printf("%-15s | %-15s\n", "Token", "Lexeme");
    printf("---------------+----------------\n");
    for (int i = 0; i < token_count; ++i) {
        printf("%-15s | %-15s\n", tokens[i].type, tokens[i].lexeme);
    }

    printf("\n---------- Token Summary ----------\n");
    printf("keywords       : %d\n", keywords);
    printf("identifiers    : %d\n", identifiers);
    printf("operators      : %d\n", operators);
    printf("punctuations   : %d\n", punctuations);
    printf("strings        : %d\n", strings);
    printf("numbers        : %d\n", numbers);
    printf("characters     : %d\n", characters);
    printf("comments       : %d\n", comments);
    printf("Lexical Errors : %d\n", errors);

    return 0;
}
