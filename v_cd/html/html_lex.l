%{
/* HTML Lexical Analyzer using Lex/Flex
 * This lexer recognizes HTML tags, attributes, text content, comments,
 * doctype declarations, character entities, and CDATA sections.
 */

#include <stdio.h>
#include <string.h>

/* Token types */
#define T_DOCTYPE        1
#define T_OPEN_TAG       2
#define T_CLOSE_TAG      3
#define T_SELF_CLOSE     4
#define T_ATTRIBUTE      5
#define T_ATT_VALUE      6
#define T_COMMENT        7
#define T_TEXT           8
#define T_CHAR_ENTITY    9
#define T_SCRIPT_CONTENT 10
#define T_STYLE_CONTENT  11
#define T_CDATA          12

/* For tracking script and style tags */
int in_script = 0;
int in_style = 0;
char current_tag[256] = "";  /* To store the current tag name */

/* Function to print tokens with their types */
void print_token(int type, char *token) {
    char *token_name;
    
    switch(type) {
        case T_DOCTYPE:        token_name = "DOCTYPE"; break;
        case T_OPEN_TAG:       token_name = "OPEN_TAG"; break;
        case T_CLOSE_TAG:      token_name = "CLOSE_TAG"; break;
        case T_SELF_CLOSE:     token_name = "SELF_CLOSE"; break;
        case T_ATTRIBUTE:      token_name = "ATTRIBUTE"; break;
        case T_ATT_VALUE:      token_name = "ATT_VALUE"; break;
        case T_COMMENT:        token_name = "COMMENT"; break;
        case T_TEXT:           token_name = "TEXT"; break;
        case T_CHAR_ENTITY:    token_name = "CHAR_ENTITY"; break;
        case T_SCRIPT_CONTENT: token_name = "SCRIPT_CONTENT"; break;
        case T_STYLE_CONTENT:  token_name = "STYLE_CONTENT"; break;
        case T_CDATA:          token_name = "CDATA"; break;
        default:               token_name = "UNKNOWN"; break;
    }
    
    printf("%-15s : %s\n", token_name, token);
}
%}

%option noyywrap
%option case-insensitive
%option yylineno

%x TAG SCRIPT STYLE COMMENT_STATE ATTR ATTR_VALUE SCRIPT_TAG STYLE_TAG CDATA_SECTION

/* Regular expressions for HTML elements */
DOCTYPE         <!DOCTYPE[^>]*>
WHITESPACE      [ \t\n\r]+
TAG_NAME        [a-zA-Z][a-zA-Z0-9_:-]*
ATTR_NAME       [a-zA-Z_][a-zA-Z0-9_:-]*
STRING          \"[^\"]*\"|'[^']*'
TEXT_CONTENT    [^<&]+
CHAR_ENTITY     &[a-zA-Z]+;|&#[0-9]+;|&#x[0-9a-fA-F]+;

%%

{DOCTYPE}                   { print_token(T_DOCTYPE, yytext); }

"<!--"                      { BEGIN(COMMENT_STATE); }
<COMMENT_STATE>"-->"        { BEGIN(INITIAL); print_token(T_COMMENT, "HTML_COMMENT"); }
<COMMENT_STATE>[^-]+|"-"    { /* Accumulate comment content */ }
<COMMENT_STATE>"--"[^>]     { /* Accumulate comment content */ }

"<![CDATA["                 { BEGIN(CDATA_SECTION); printf("%-15s : %s\n", "CDATA_BEGIN", "CDATA Section Start"); }
<CDATA_SECTION>"]]>"        { BEGIN(INITIAL); printf("%-15s : %s\n", "CDATA_END", "CDATA Section End"); }
<CDATA_SECTION>[^]]*|"]"[^]]|"]]"[^>]  { print_token(T_CDATA, yytext); }

"<script"                   { BEGIN(SCRIPT_TAG); strcpy(current_tag, "script"); print_token(T_OPEN_TAG, "script"); }
<SCRIPT_TAG>{ATTR_NAME}     { print_token(T_ATTRIBUTE, yytext); }
<SCRIPT_TAG>"="             { /* equals sign in attributes */ }
<SCRIPT_TAG>{STRING}        { print_token(T_ATT_VALUE, yytext); }
<SCRIPT_TAG>{WHITESPACE}    { /* ignore whitespace */ }
<SCRIPT_TAG>"/>"            { BEGIN(INITIAL); print_token(T_SELF_CLOSE, current_tag); }
<SCRIPT_TAG>">"             { BEGIN(SCRIPT); in_script = 1; }

<SCRIPT>"</script>"         { BEGIN(INITIAL); in_script = 0; print_token(T_CLOSE_TAG, "script"); }
<SCRIPT>[^<]+|"<"[^/]       { if (in_script) print_token(T_SCRIPT_CONTENT, yytext); }

"<style"                    { BEGIN(STYLE_TAG); strcpy(current_tag, "style"); print_token(T_OPEN_TAG, "style"); }
<STYLE_TAG>{ATTR_NAME}      { print_token(T_ATTRIBUTE, yytext); }
<STYLE_TAG>"="              { /* equals sign in attributes */ }
<STYLE_TAG>{STRING}         { print_token(T_ATT_VALUE, yytext); }
<STYLE_TAG>{WHITESPACE}     { /* ignore whitespace */ }
<STYLE_TAG>"/>"             { BEGIN(INITIAL); print_token(T_SELF_CLOSE, current_tag); }
<STYLE_TAG>">"              { BEGIN(STYLE); in_style = 1; }

<STYLE>"</style>"           { BEGIN(INITIAL); in_style = 0; print_token(T_CLOSE_TAG, "style"); }
<STYLE>[^<]+|"<"[^/]        { if (in_style) print_token(T_STYLE_CONTENT, yytext); }

"</"                        { BEGIN(TAG); }
<TAG>{TAG_NAME}             { print_token(T_CLOSE_TAG, yytext); }
<TAG>">"                    { BEGIN(INITIAL); }

"<"                         { BEGIN(TAG); }
<TAG>{TAG_NAME}             { strcpy(current_tag, yytext); print_token(T_OPEN_TAG, yytext); }
<TAG>{WHITESPACE}           { BEGIN(ATTR); }
<TAG>"/>"                   { BEGIN(INITIAL); print_token(T_SELF_CLOSE, current_tag); }
<TAG>">"                    { BEGIN(INITIAL); }

<ATTR>{ATTR_NAME}           { print_token(T_ATTRIBUTE, yytext); }
<ATTR>"="                   { BEGIN(ATTR_VALUE); }
<ATTR>{WHITESPACE}          { /* ignore whitespace */ }
<ATTR>"/>"                  { BEGIN(INITIAL); print_token(T_SELF_CLOSE, current_tag); }
<ATTR>">"                   { BEGIN(INITIAL); }

<ATTR_VALUE>{STRING}        { BEGIN(ATTR); print_token(T_ATT_VALUE, yytext); }
<ATTR_VALUE>{WHITESPACE}    { /* ignore whitespace */ }

{CHAR_ENTITY}               { print_token(T_CHAR_ENTITY, yytext); }
{TEXT_CONTENT}              { print_token(T_TEXT, yytext); }
{WHITESPACE}                { /* Ignore whitespace outside of tags */ }

.                           { printf("UNRECOGNIZED: %s\n", yytext); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    printf("HTML LEXICAL ANALYZER\n");
    printf("=====================\n");
    
    yylex();
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}