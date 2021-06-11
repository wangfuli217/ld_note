%x incl
%{
#define yywrap() 1
#define MAX_INCLUDE_DEPTH 10
YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
int include_stack_ptr = 0;
%}
%%
include          BEGIN(incl);
.                ECHO;
<incl>[ \t]*
<incl>[^ \t\n]+  { /* got the file name */
                   if (include_stack_ptr >= MAX_INCLUDE_DEPTH) {
		     fprintf(stderr,"Includes nested too deeply\n");
		     exit(1);
		   }
		   include_stack[include_stack_ptr++] = YY_CURRENT_BUFFER;
		   yyin = fopen(yytext,"r");
		   if (!yyin) {
		     fprintf(stderr,"File %s not found\n",yytext);
		     exit(1);
		   }
		   yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
		   BEGIN(INITIAL);
		 }
<<EOF>> {
          if ( --include_stack_ptr < 0) { 
	    yyterminate();
	  } else {
	    yy_delete_buffer(YY_CURRENT_BUFFER);
	    yy_switch_to_buffer(include_stack[include_stack_ptr]);
	  }
	}
%%
main(int argc, char ** argv) {

  yyin = fopen(argv[1],"r");
  yylex();
}


