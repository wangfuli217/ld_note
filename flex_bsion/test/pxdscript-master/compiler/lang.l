/* pxdscript flex-file
 *
 * History:
 */

%{
#include "lang.tab.h"
#include <string.h>
#include "memory.h"
#include "error.h"

extern int lineno;
extern int interactiveMode;

int commentDepth=0;
%}


  /* exclusive startconditions */
%x commentsc 

%%

  /*  comment start-condition for recognizing multiline comments */
<commentsc>{
  \n                       lineno++;
  "*/"                   { commentDepth--; if (commentDepth == 0) BEGIN(INITIAL);}
  "/*"                     commentDepth++;
  "//"[^\n]*             /* Single line comments take precedence over multilines */;
  <<EOF>>                  yyerror("Unclosed comment.");
  [^*/\n]*               /* ignore anything thats not a '*' or '/' to increase speed */;
  .                      /* ignore (multiline comments)*/;
}



 
  /* INITIAL start-condition for ordinary pxdscript-code */

[ \t]+                /* ignore */;

"/*"                   { commentDepth++; BEGIN(commentsc);}

\n                     { lineno++; if (interactiveMode) return '\n'; }
"//"[^\n]*            /* ignore (singleline comment)*/;

bool                     return tBOOL;
const                    return tCONST;
else                     return tELSE;
for                      return tFOR;
if                       return tIF;
int                      return tINT;
return                   return tRETURN;
program                  return tPROGRAM;
string                   return tSTRING;
void                     return tVOID;
while                    return tWHILE;

trigger_on_init          return tTRIGGERONINIT;
trigger_on_collide       return tTRIGGERONCOLLIDE;
trigger_on_click         return tTRIGGERONCLICK;
trigger_on_pickup        return tTRIGGERONPICKUP;

setint                   return tSETINT;

TYPE_MDL                 return tENTITYMDL;
TYPE_PARTICLE            return tENTITYPARTICLE;
TYPE_PLY                 return tENTITYPLAYER;
TYPE_LIGHT               return tENTITYLIGHT;
TYPE_CAMERA              return tENTITYCAMERA;



sleep                    return tSLEEP;

"&&"                     return tAND;
"=="                     return tEQUALS;
">="                     return tGEQUALS;
"<="                     return tLEQUALS;
"!="                     return tNEQUALS;
"||"                     return tOR;
"="                      return '=';
">"                      return '>';
"<"                      return '<';
"!"                      return '!';
"+"                      return '+';
"-"                      return '-';
"*"                      return '*';
"/"                      return '/';
"%"                      return '%';
"{"                      return '{';
"}"                      return '}';
";"                      return ';';
"("                      return '(';
")"                      return ')';
","                      return ',';

0|([1-9][0-9]*)        { yylval.intconst = atoi(yytext);
                         return tINTCONST; }
true                   { yylval.boolconst = 1;
                         return tBOOLCONST; }
false                  { yylval.boolconst = 0;
                         return tBOOLCONST; }
\"[^\"\n]*\"           { yytext[strlen(yytext)-1]='\0'; /* remove "'s from yytext */
                         yylval.stringconst = strdup(yytext+1);
                          return tSTRINGCONST; }
[A-Za-z_][A-Za-z0-9_]* { yylval.identifier = strdup(yytext);
                         return tIDENTIFIER; }

.                        yyerror("Invalid character '%s'.", yytext);

%%
