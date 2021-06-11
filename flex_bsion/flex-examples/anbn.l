%option stack
%x A B 
%%
^a      {  ECHO; yy_push_state(A); printf("State: %d\n",YYSTATE); }
[\n ]+  { printf("Acepto\n"); }
.  { printf("En <0>, Error!\n"); exit(1); }
<A>{
"a" { ECHO; yy_push_state(A); printf("State: %d\n",YYSTATE); }
"b" { ECHO; printf("State: %d\n",YYSTATE); BEGIN(B); }
(.|\n)   { printf("En <A>, Error!\n"); exit(1); }
}
<B>{ 
b { ECHO; if (yy_pop_state()) { BEGIN(B); } }
. { printf("En <B>, Error!\n"); exit(1); }
}
%%
