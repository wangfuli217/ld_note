%{
//(.*a.*).(.*a*b+.*) printf("String has substring a,a*b+");
%}
%%
.*abb.* printf("String has abb");
.*a*b+.* printf("String has a*b+");
.*a.* printf("String has a");
%%
