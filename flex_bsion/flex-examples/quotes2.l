%%
\"[^"]+\" { 
            printf("Procesing string. %d: %s\n",yyleng,yytext); 
            if (yytext[yyleng-2] =='\\') {
	     yymore(); /* concatenate  with current yytext */
             yyless(yyleng-1); /* so that it will match next time */
             printf("After yyless. %d: %s\n",yyleng,yytext); 
	    } else {
	      printf("Finished. The string is: %s\n",yytext);
	    }
	  }
