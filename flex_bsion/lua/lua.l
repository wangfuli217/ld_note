/*
* lua.l - flex lexer for Lua 5.1
* Copyright: Same as Lua
*/

%{
int yywrap( ){return 1;}
#include "y.tab.h"
%}

w              [ \t\v\a]+
o              [ \t\v\a]*
name           [_a-zA-Z][_a-zA-Z0-9]*
n              [0-9]+
exp            [Ee][+-]?{n}
number         ({n}|{n}[.]{n}){exp}?


%x XLONGSTRING
%x XSHORTCOMMENT
%x XLONGCOMMENT
%x XSTRINGQ
%x XSTRINGA

%%

^#!.*          fprintf(yyout,"skipping: %s\n", yytext);
and            return TK_AND;
break          return TK_BREAK;
do             return TK_DO;
else           return TK_ELSE;
elseif         return TK_ELSEIF;
end            return TK_END;
false          return TK_FALSE;
for            return TK_FOR;
function       return TK_FUNCTION;
if             return TK_IF;
in             return TK_IN;
local          return TK_LOCAL;
nil            return TK_NIL;
not            return TK_NOT;
or             return TK_OR;
repeat         return TK_REPEAT;
return         return TK_RETURN;
then           return TK_THEN;
true           return TK_TRUE;
until          return TK_UNTIL;
while          return TK_WHILE;

{number}       return TK_NUMBER;
{name}         return TK_NAME;

"--[["         yymore(); BEGIN( XLONGCOMMENT );
"--"           yymore(); BEGIN( XSHORTCOMMENT );

"[["({o}\n)?   yymore();BEGIN( XLONGSTRING );

{w}            return TK_WHITESPACE;
"..."          return TK_DOTS;
".."           return TK_CONCAT;
"=="           return TK_EQ;
">="           return TK_GE;
"<="           return TK_LE;
"~="           return TK_NE;
"-"            return yytext[0];
"+"            return yytext[0];
"*"            return yytext[0];
"/"            return yytext[0];
"="            return yytext[0];
">"            return yytext[0];
"<"            return yytext[0];
"("            return yytext[0];
")"            return yytext[0];
"["            return yytext[0];
"]"            return yytext[0];
"{"            return yytext[0];
"}"            return yytext[0];
\n             return TK_NEWLINE;
\r             return TK_NEWLINE;
\"             yymore(); BEGIN(XSTRINGQ);
'              yymore(); BEGIN(XSTRINGA);
.              return yytext[0];

<XSTRINGQ>
{
  \"\"        yymore();
  \"          BEGIN(0); return TK_STRING;
  \\[abfnrtv] yymore();
  \\\n        yymore();
  \\\"        yymore();
  \\'         yymore();
  \\"["       yymore();
  \\"]"       yymore();
  [\n|\r]     {    fprintf(yyout,"unterminated string.\n");
                      BEGIN(0);
                      return TK_STRING;
                  }
  .           yymore();
}

<XSTRINGA>
{
  ''          yymore();
  '           BEGIN(0); return TK_STRING;
  \\[abfnrtv] yymore();
  \\\n        yymore();
  \\\"        yymore();
  \\'         yymore();
  \\"["       yymore();
  \\"]"       yymore();
  [\n|\r]     {    fprintf(yyout,"unterminated string.\n");
                      BEGIN(0);
                      return TK_STRING;
                  }
  .           yymore();
}

<XLONGSTRING>
{
  "]]"        BEGIN(0); return TK_LONGSTRING;
  \n          yymore();
  \r          yymore();
  .           yymore();
}

<XSHORTCOMMENT>
{
  \n          BEGIN(0); return TK_SHORTCOMMENT;
  \r          BEGIN(0); return TK_SHORTCOMMENT;
  .           yymore();
}

<XLONGCOMMENT>
{
  "]]--"      BEGIN(0); return TK_LONGCOMMENT;
  \n          yymore();
  \r          yymore();
  .           yymore();
}

%%

#ifdef YYMAIN

#include <stdio.h>
extern FILE*yyin,*yyout;

char* TokenName(int t)
{
  static char buffer[80];
  if( t < 0 || t == 256 ) return "<ERROR>";
  if( t == 0 ) return "EOF";
  if( t < 256 )
  {  sprintf( buffer, "CHAR %c", (unsigned char)(unsigned int)t );
     return (char*)buffer;
  }
  switch(t)
  {  case TK_AND:            return "AND";
     case TK_BREAK:          return "BREAK";
     case TK_DO:             return "DO";
     case TK_ELSE:           return "ELSE";
     case TK_ELSEIF:         return "ELSEIF";
     case TK_END:            return "END";
     case TK_FALSE:          return "FALSE";
     case TK_FOR:            return "FOR";
     case TK_FUNCTION:       return "FUNCTION";
     case TK_IF:             return "IF";
     case TK_IN:             return "IN";
     case TK_LOCAL:          return "LOCAL";
     case TK_NIL:            return "NIL";
     case TK_NOT:            return "NOT";
     case TK_OR:             return "OR";
     case TK_REPEAT:         return "REPEAT";
     case TK_RETURN:         return "RETURN";
     case TK_THEN:           return "THEN";
     case TK_TRUE:           return "TRUE";
     case TK_UNTIL:          return "UNTIL";
     case TK_WHILE:          return "WHILE";
     case TK_CONCAT:         return "CONCAT";
     case TK_DOTS:           return "DOTS";
     case TK_EQ:             return "EQ";
     case TK_GE:             return "GE";
     case TK_LE:             return "LE";
     case TK_NE:             return "NE";
     case TK_NUMBER:         return "NUMBER";
     case TK_NAME:           return "NAME";
     case TK_STRING:         return "STRING";
     case TK_LONGSTRING:     return "LONGSTRING";
     case TK_SHORTCOMMENT:   return "SHORTCOMMENT;";
     case TK_LONGCOMMENT:    return "LONGCOMMENT;";
     case TK_WHITESPACE:     return "WHITESPACE";
     case TK_NEWLINE:        return "NEWLINE";
     case TK_BADCHAR:        return "BADCHAR";
     default: break;
  }
  sprintf( buffer, "<? %d>", t );
  return buffer;
}


int main( int argc, char ** argv )
{
  int tok;

  yyin  = (argc>1) ? fopen(argv[1],"rt") : 0;
  yyout = (argc>2) ? fopen(argv[2],"wt") : 0;

  for( tok=yylex() ; tok ; tok=yylex() )
  {
     if( tok == TK_NEWLINE ) continue;
     if( tok == TK_WHITESPACE ) continue;
     fprintf( yyout, "%03d %-13.13s: %s\n", tok, TokenName(tok), yytext );
  }
  if(yyin!=stdin)fclose(yyin);
  if(yyout!=stdout)fclose(stdout);
  return 0;
}

#endif