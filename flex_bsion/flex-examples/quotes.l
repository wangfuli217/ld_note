%%
\"[^"]+\" { 
            printf("Procesing string. %d: %s\n",yyleng,yytext); 
            if (yytext[yyleng-2] =='\\') {
               yyless(yyleng-1); /* so that it will match next time */
               yymore(); /* concatenate  with current yytext */
               printf("After yyless. %d: %s\n",yyleng,yytext); 
            } else {
               printf("Finished. The string is: %s\n",yytext);
            }
	  }
