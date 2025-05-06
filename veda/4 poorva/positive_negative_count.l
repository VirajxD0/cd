%{
    #include<stdio.h>
    int positive_count = 0;
    int negative_count = 0;
%}

%%
-?[0-9]+ {
    int num = atoi(yytext);
    if(num > 0)positive_count++;
    else if(num < 0)negative_count++;
}

%%
int main(){
    printf("Enter a Number:\n");
    yylex();
    printf("Number of positive number:%d\n",positive_count);
    printf("Number of negative number:%d\n",negative_count);
    return 0;
}

int yywrap(){
    return 1;
}

