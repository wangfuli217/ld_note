/*
* lua.l - flex lexer for Lua 5.1
* flex -Bs8 -Cem -oylex.c lua.l
* cl -MD -Ox -DYYMAIN ylex.c -link /opt:ref /opt:icf /opt:nowin98
* Copyright: Same as Lua
*/

%{
#define R return
int yywrap( ){R 1;}
#include "y.tab.h"
int lcmlen = 0;
int firstline=1;
int getlcmlen( int back )
{  char *end;
  // back must be 2 for long string, 4 for long comment.
  int lcmlen=back;
  for( end = yytext+yyleng-back ; end>yytext && *end!=']' ; end-- )
     lcmlen++;
  printf("lcmlen: %d\n", lcmlen );
  if( *end==']' )
     R lcmlen;
  return 0;
}
int checkKw(char*s)
{
  #define CHECK(S,T)if(!strcmp(#S,s))R TK_##T;
  switch(*s)
  {  case 'a':
        CHECK(and,AND);
        break;
     case 'b':
        CHECK(break,BREAK);
        break;
     case 'd':
        CHECK(do,DO);
        break;
     case 'e':
        CHECK(elseif,ELSEIF);
        CHECK(else,ELSE);
        CHECK(end,END);
        break;
     case 'f':
        CHECK(false,FALSE);
        CHECK(for,FOR);
        CHECK(function,FUNCTION);
        break;
     case 'i':
        CHECK(if,IF);
        CHECK(in,IN);
        break;
     case 'l':
        CHECK(local,LOCAL);
        break;
     case 'n':
        CHECK(nil,NIL);
        CHECK(not,NOT);
        break;
     case 'o':
        CHECK(or,OR);
        break;
     case 'r':
        CHECK(repeat,REPEAT);
        CHECK(return,RETURN);
        break;
     case 't':
        CHECK(then,THEN);
        CHECK(true,TRUE);
        break;
     case 'u':
        CHECK(until,UNTIL);
        break;
     case 'w':
        CHECK(while,WHILE);
        break;
  }
  R( TK_NAME );
  #undef CHECK
}

%}

w              [ \t\v\a]+
o              [ \t\v\a]*
name           [_a-zA-Z][_a-zA-Z0-9]*
n              [0-9]+
exp            [Ee][+-]?{n}
number         ({n}|{n}[.]{n}){exp}?
eol            [\n\r]
sep            =*

%x XLONGSTRING
%x XSHORTCOMMENT
%x XLONGCOMMENT
%x XSTRINGQ
%x XSTRINGA

%%

^#!.*          {  if(firstline)  /* ignore it */
                    firstline=0;
                 else
                 {  fprintf(yyout,"skipping misplaced: %s\n", yytext);
                 }
              }
{name}         R checkKw(yytext);
{number}       R TK_NUMBER;

"--["{sep}"[" yymore(); lcmlen=yyleng; printf("%d\n",yyleng); BEGIN( XLONGCOMMENT ); 
"["{sep}"[" yymore(); lcmlen=yyleng; printf("%d\n",yyleng); BEGIN( XLONGSTRING ); 
"--"           yymore(); BEGIN( XSHORTCOMMENT );
{w}            R TK_WHITESPACE;
\"             yymore(); BEGIN(XSTRINGQ);
'              yymore(); BEGIN(XSTRINGA);
"..."          R TK_DOTS;
".."           R TK_CONCAT;
"=="           R TK_EQ;
">="           R TK_GE;
"<="           R TK_LE;
"~="           R TK_NE;
{eol}          R TK_NEWLINE;
.              R yytext[0];

<XSTRINGQ>
{
  \"\"        yymore();
  \"          BEGIN(0); R TK_STRING;
  \\[abfnrtv] yymore();
  \\\n        yymore();
  \\\"        yymore();
  \\'         yymore();
  \\"["       yymore();
  \\"]"       yymore();
  [\n|\r]     {  fprintf(yyout,"unterminated \"string\".\n");
                 BEGIN(0);
                 R TK_STRING;
              }
  .           yymore();
}

<XSTRINGA>
{
  ''          yymore();
  '           BEGIN(0); R TK_STRING;
  \\[abfnrtv] yymore();
  \\\n        yymore();
  \\\"        yymore();
  \\'         yymore();
  \\"["       yymore();
  \\"]"       yymore();
  [\n|\r]     {  fprintf(yyout,"unterminated 'string'.\n");
                 BEGIN(0);
                 R TK_STRING;
              }
  .           yymore();
}

<XSHORTCOMMENT>
{
  {eol}          BEGIN(0); R TK_SHORTCOMMENT;
  .              yymore();
}

<XLONGCOMMENT>
{
  "]"{sep}"]--"  if(lcmlen==getlcmlen(4)){BEGIN(0); R TK_LONGCOMMENT;}
  {eol}          yymore();
  .              yymore();
}

<XLONGSTRING>
{
  "]"{sep}"]"    if(lcmlen==getlcmlen(2)){BEGIN(0); R TK_LONGSTRING;}
  {eol}          yymore();
  .              yymore();
}

%%

#ifdef YYMAIN

#include <stdio.h>
extern FILE*yyin,*yyout;

char* TokenName(int t)
{
  static char buffer[80];
  if( t < 0 || t == 256 ) R "<ERROR>";
  if( t == 0 ) R "EOF";
  if( t < 256 )
  {  sprintf( buffer, "CHAR %c", (unsigned char)(unsigned int)t );
     R (char*)buffer;
  }
  switch(t)
  {  case TK_AND:            R "AND";
     case TK_BREAK:          R "BREAK";
     case TK_DO:             R "DO";
     case TK_ELSE:           R "ELSE";
     case TK_ELSEIF:         R "ELSEIF";
     case TK_END:            R "END";
     case TK_FALSE:          R "FALSE";
     case TK_FOR:            R "FOR";
     case TK_FUNCTION:       R "FUNCTION";
     case TK_IF:             R "IF";
     case TK_IN:             R "IN";
     case TK_LOCAL:          R "LOCAL";
     case TK_NIL:            R "NIL";
     case TK_NOT:            R "NOT";
     case TK_OR:             R "OR";
     case TK_REPEAT:         R "REPEAT";
     case TK_RETURN:         R "RETURN";
     case TK_THEN:           R "THEN";
     case TK_TRUE:           R "TRUE";
     case TK_UNTIL:          R "UNTIL";
     case TK_WHILE:          R "WHILE";
     case TK_CONCAT:         R "CONCAT";
     case TK_DOTS:           R "DOTS";
     case TK_EQ:             R "EQ";
     case TK_GE:             R "GE";
     case TK_LE:             R "LE";
     case TK_NE:             R "NE";
     case TK_NUMBER:         R "NUMBER";
     case TK_NAME:           R "NAME";
     case TK_STRING:         R "STRING";
     case TK_LONGSTRING:     R "LONGSTRING";
     case TK_SHORTCOMMENT:   R "SHORTCOMMENT;";
     case TK_LONGCOMMENT:    R "LONGCOMMENT;";
     case TK_WHITESPACE:     R "WHITESPACE";
     case TK_NEWLINE:        R "NEWLINE";
     case TK_BADCHAR:        R "BADCHAR";
     default: break;
  }
  sprintf( buffer, "<? %d>", t );
  R buffer;
}


int main( int argc, char ** argv )
{
  int tok;

  yyin  = (argc>1) ? fopen(argv[1],"rt") : 0;
  yyout = (argc>2) ? fopen(argv[2],"wt") : 0;

  for( tok=yylex() ; tok ; tok=yylex() )
  {  if( tok == TK_NEWLINE ) continue;
     if( tok == TK_WHITESPACE ) continue;
     fprintf( yyout, "%03d %-13.13s: %s\n", tok, TokenName(tok), yytext );
  }
  // do not close stdin+stdout for the benefit of piped program.
  if(yyin!=stdin)fclose(yyin);
  if(yyout!=stdout)fclose(yyout);
  R 0;
}

#endif

/**/