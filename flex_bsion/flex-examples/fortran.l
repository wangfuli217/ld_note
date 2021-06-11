%array
number [0-9]+
integer [+-]?{number}
float ({integer}\.{number}?|\.{number})(E{integer})?
label [A-Z0-9]+
%%
DO/{label}={number}\. { printf("Identifier\n"); }
DO/{label}={number}\, { printf("do loop\n"); }
(.|\n) 


