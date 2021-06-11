%%
hello {
        strcat(yytext, " world"); 
	printf("\n%d: %s\n",strlen(yytext),yytext);
      }
