%array
number [0-9]+
integer [+-]?{number}
float ({integer}\.{number}?|\.{number})(E{integer})?
label [A-Z0-9]+
%%
DO/{label}={number}\, { printf("do loop\n"); }
DO{label} { printf("Identifier %s\n",yytext); }
(.|\n) 


