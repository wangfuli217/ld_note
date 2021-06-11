%{
#include <stdio.h>
#include <errno.h>
#include <queue>


enum { LN, WD, CH, SIZE };

static int cf[SIZE]; // current file counters
static int ct[SIZE]; // total counters
static std::queue<const char*> fnames; 

void clear_counters()
{
   cf[LN] = cf[WD] = cf[CH] = 0;
}

void print_clear_counters(const char* fname, int c[])
{
   printf("%8d %8d %8d %s\n", c[LN], c[WD], c[CH], fname);
   clear_counters();
}

void update_total()
{
   ct[LN] += cf[LN]; 
   ct[WD] += cf[WD]; 
   ct[CH] += cf[CH];
}

bool HaveMoreFiles() 
{
   if (yyin && yyin != stdin) 
   {
      fclose(yyin);
      fnames.pop();
   }

   while (!fnames.empty())
   {
      if ((yyin = fopen(fnames.front(), "r")))  
         return true;
  
      printf("fwc2: %s: %s: open:\n", fnames.front(), strerror(errno));
      fnames.pop();
   }
   return false;
}

%}

/* 
 * NOTE: If you use EOF rule, don't use yywrap; terminate yylex in EOF rule
 */
%option noyywrap 


%%
[^ \t\n\r\f\v]+   { cf[WD]++; cf[CH] += yyleng; }
\n                { cf[LN]++; cf[CH]++; }
.                 { cf[CH]++; }
<<EOF>>           { 
                    update_total(); 
                    print_clear_counters(fnames.empty() ? "" : fnames.front(), cf);
                    if (!HaveMoreFiles()) 
                    {
                       yyterminate();  
                    }
                  }
%%


int main (int argc, char* argv[])
{
   // load file names
   for (int i = 1; i < argc; i++) 
      fnames.push(argv[i]);

   // will print total if at least 2 input files were specified
   bool bPrintTotal = fnames.size() >= 2; 

   if (argc < 2 || HaveMoreFiles())
   {
      yylex();
   }

   if (bPrintTotal)
      print_clear_counters("total", ct);
}
