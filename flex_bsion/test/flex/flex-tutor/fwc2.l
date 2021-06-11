%{
#include <stdio.h>
#include <errno.h>
#include <queue>

enum { LN, WD, CH, SIZE };

static int cf[SIZE]; // current file count
static int ct[SIZE]; // total count
static std::queue<const char*> fnames; 

%}

%%
   /*** Scanner rules ***/
[^ \t\n\r\f\v]+   { cf[WD]++; cf[CH] += yyleng; }
\n                { cf[LN]++; cf[CH]++; }
.                 { cf[CH]++; }
%%

/* 
 * User code 
 */

void clear_counters()
{
   cf[LN] = cf[WD] = cf[CH] = 0;
}

void update_total()
{
   ct[LN] += cf[LN]; 
   ct[WD] += cf[WD]; 
   ct[CH] += cf[CH];
}

void print_clear_counters(const char* fname, int c[])
{
   printf("%8d %8d %8d %s\n", c[LN], c[WD], c[CH], fname);
   clear_counters();
}

bool HaveMoreFiles() 
{
   while (!fnames.empty())
   {
      if ((yyin = fopen(fnames.front(), "r")))  
         return true;
  
      printf("fwc2: %s: %s: open:\n", fnames.front(), strerror(errno));
      fnames.pop();
   }
   return false;
}

// Usage: fwc2 [file ...]

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

int yywrap (void)
{
   update_total();

   if (yyin == stdin)
   {
      print_clear_counters("", cf);
   }
   else 
   {
      print_clear_counters(fnames.front(), cf);
      fclose(yyin);
      fnames.pop();
   }

   return HaveMoreFiles() ? 0 : 1; 
}
