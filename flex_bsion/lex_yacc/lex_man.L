%{
#include <stdlib.h>
#include <stdio.h>

int numbers = 0;
%}

BEN             [Bb][Ee][Nn]

%%

{BEN}           printf("Saw Ben!\n");

integer         printf("Found keyword integer!\n");
\n              ECHO;

[0-9]+          {
                    ++numbers;
                    printf("Saw the number %s; seen %d numbers so far\n", yytext, numbers);
                    int k = atoi(yytext);
                    if(k % 7 == 0) {
                        printf("The number is divisible by 7!\n");
                    }
                }

[A-Za-z]+       printf("Saw a string of length %u\n", yyleng);

%%
