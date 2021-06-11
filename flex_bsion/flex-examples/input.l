%%
"/*" {
        int c;
	for(;;) {
	  while ((c=input()) != '*' && c != EOF)
	    ;
	  if (c == '*')  {
	    while ((c = input()) == '*') 
	      ;
	    if (c == '/') break;
	  }
	  if (c == EOF) {
	    fprintf(stderr,"Error: EOF in comment");
	    yyterminate();
	  }
	}
      }

