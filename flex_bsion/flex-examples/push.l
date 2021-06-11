%option stack
%x A ACCEPT
%%
"a"      {  ECHO; yy_push_state(A); printf("State: %d\n",YYSTATE); }
[^a\n]+.*\n  { printf("error\n"); }
[\n ]+ 
(.|\n)   { printf("Error!\n"); }
<A>{
"a" {  ECHO; yy_push_state(A); printf("State: %d\n",YYSTATE); }
"b" { ECHO; 
       if (yy_top_state()) {
         yy_pop_state(); 
         printf("State: %d\n",YYSTATE);
       }
       else {
         printf("State: %d\n",YYSTATE);
         BEGIN(ACCEPT);
       }
    }
(.|\n)   { printf("Error!\n"); BEGIN(0); }
}
<ACCEPT>\n { BEGIN(0); printf("Accept\n"); }
<ACCEPT>. { BEGIN(0); printf("Error\n"); }
%%
