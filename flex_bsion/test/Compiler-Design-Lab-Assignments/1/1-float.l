%{
//1-recognise a floating point number
%}
%%
[0-9]*\.[0-9]+ printf(":Floating Point number");
[0-9]+ printf(":Not a floating point number");
.* printf("Not a valid number");
%%

