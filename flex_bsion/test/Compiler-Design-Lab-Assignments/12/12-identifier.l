%{
//12-identifier validity
%}
%%
[a-zA-Z_$].* printf("Valid Identifier");
.* printf("Not a valid identifier");
%%
