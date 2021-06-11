%{
	//This belongs to lex
	#include "entry.h"
	#include "awk.tab.h"
	#include "customstring.h"
	
	#undef YY_INPUT
	#define YY_INPUT(b,r,s) readInputForLexer(b,&r,s)
%}


%option yylineno
%option noyywrap

%x STR
%x REG

%%



[#].*	     	/* ignore comment */;
BEGIN			return AWKBEGIN;
END				return AWKEND;
if              return IF;
else            return ELSE;
while           return WHILE;
exit            return EXIT;
[~]				return REGMATCH;
==              return EQ;
[<]=            return LE;
>=              return GE;
!=              return NE;
&&				return BOOLAND;
[|][|]			return BOOLOR;
[[]				return SQBROP;
[]]				return SQBRCL;
[0-9]+([.][0-9]+)?          { yylval = new_entry_0(); yylval->text = concat_string(yytext, NULL); 
                  return NUM;
                }
[$a-zA-Z_][a-zA-Z0-9_]* { yylval = new_entry_0(); yylval->type = id; yylval->text = concat_string(yytext, NULL); 
                  return ID;
                }
["]             {  yylval = new_entry_0(); yylval->type=strvalue; BEGIN(STR); }
<STR>[^\\\n"]+  yylval->text = concat_string(yylval->text, yytext);
<STR>\\n        yylval->text = concat_string(yylval->text, "\n");
<STR>\\t        yylval->text = concat_string(yylval->text, "\t");
<STR>\\["]      yylval->text = concat_string(yylval->text, "\"");
<STR>\\         yyerror("Invalid escape sequence");
<STR>\n         yyerror("Newline in string literal");
<STR>["]        { BEGIN(INITIAL); return STRING; }

[~][ ][/]             {  yylval = new_entry_0(); yylval->type=regex; BEGIN(REG); }
<REG>[^\\\n/]+  yylval->text = concat_string(yylval->text, yytext);
<REG>\\n        yylval->text = concat_string(yylval->text, "\n");
<REG>\\t        yylval->text = concat_string(yylval->text, "\t");
<REG>\\[/]      yylval->text = concat_string(yylval->text, "\"");
<REG>\\         yyerror("Invalid escape sequence");
<REG>\n         yyerror("Newline in regex");
<REG>[/]        { BEGIN(INITIAL); return REGEX; }

[ \t\r\n]       ; // whitespace
[-{};()=<>+*/!,] { return *yytext; }
->               yyerror("Invalid character");

%%
