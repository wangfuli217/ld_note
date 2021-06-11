%option stack
%x comment
%%
"/*"   { yy_push_state(comment); }
(.|\n) ECHO;
<comment>"/*"     { yy_push_state(comment); } 
<comment>"*/"     { yy_pop_state(); } 
<comment>(.|\n)   ;
<comment><<EOF>>  { fprintf(stderr,"Error\n"); exit(1); }
%%
