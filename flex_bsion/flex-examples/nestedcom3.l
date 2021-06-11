%option stack
%x comment
%%
"/*"   { yy_push_state(comment); }
"*/"   { fprintf(stderr,"Error. Com cerrar no casado\n"); exit(2); }
(.|\n) ECHO;
<comment>{
"/*"     { yy_push_state(comment); } 
"*/"     { yy_pop_state(); } 
(.|\n)   ;
<<EOF>>  { fprintf(stderr,"Error. Inesperado fin de fichero\n"); exit(1); }
}
%%
