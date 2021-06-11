%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
"#include "     { return(INCLUDE); }
"char"			{ return(CHAR); }
"double"		{ return(DOUBLE); }
"else"			{ return(ELSE); }
"float"			{ return(FLOAT); }
"if"			{ return(IF); }
"int"			{ return(INT); }
"void"			{ return(VOID); }
"while"			{ return(WHILE); }

[0-9]+		                { strcpy(yylval.source, yytext); return(CONSTANT); }
[a-zA-Z]([a-zA-Z]|[0-9])*	{ strcpy(yylval.source, yytext); return(IDENTIFIER); }
\"(\\.|[^\\"])*\"	        { strcpy(yylval.source, yytext); return(STRING_LITERAL); }

"&&"			{ return(AND_OP); }
"||"			{ return(OR_OP); }
"<="			{ return(LE_OP); }
">="			{ return(GE_OP); }
"=="			{ return(EQ_OP); }
"!="			{ return(NE_OP); }
";"			    { return(';'); }
("{"|"<%")		{ return('{'); }
("}"|"%>")		{ return('}'); }
","			    { return(','); }
":"			    { return(':'); }
"="			    { return('='); }
"("			    { return('('); }
")"			    { return(')'); }
("["|"<:")		{ return('['); }
("]"|":>")		{ return(']'); }
"."			    { return('.'); }
"&"			    { return('&'); }
"!"			    { return('!'); }
"~"			    { return('~'); }
"-"			    { return('-'); }
"+"			    { return('+'); }
"*"			    { return('*'); }
"/"			    { return('/'); }
"%"			    { return('%'); }
"<"			    { return('<'); }
">"			    { return('>'); }
"^"			    { return('^'); }
"|"			    { return('|'); }
"?"			    { return('?'); }

[ \t\v\n\f]		{ }
.			{ /* ignore bad characters */ }

%%

int yywrap (void) {return 1;}