%option stack
%x A ACCEPT
%%
"a"    {  ECHO;  yy_push_state(A); printf("State: %d\n",YYSTATE); }
(\n)+  { printf("ACCEPT!\n"); } 
.      { printf("Error!\n"); }
<A>{
"a" {  ECHO; yy_push_state(A); printf("State: %d\n",YYSTATE); }
"b" { ECHO; 
         yy_pop_state(); 
         printf("State: %d\n",YYSTATE);
    }
(.|\n)   { printf("Error!\n"); BEGIN(0); }
}
%%
