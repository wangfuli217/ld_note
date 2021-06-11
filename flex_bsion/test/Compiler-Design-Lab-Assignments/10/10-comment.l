%{
//10-identify whether a given line is comment or not
%}
%%
(\/\/.*)|(\/\*.*\*\/)|(\/\/\/) printf("This is a comment line");
.* printf("This is not a comment line");
%%
