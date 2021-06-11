%{
// 6-reecognise strings having 100 as a substring
%}
%%
.*100.* printf(": 100 is in the string.");
.* printf(":100 is not in this string");
%%
