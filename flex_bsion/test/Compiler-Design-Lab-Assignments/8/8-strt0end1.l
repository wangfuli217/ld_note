%{
// 8- recognise strings starting with 0 and ending with 1
%}
%%
0.*1\n printf(":This string start with 0 and end with 1\n\n");
.* printf(":This string does not start with 0 and end with 1\n\n");
%%
