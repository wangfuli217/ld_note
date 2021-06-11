%{
//
// Illustrate different ways of scanning string instead of file input.
//
#include <memory.h>
%}

%option noyywrap

%%
\n           { printf("\\n "); *yytext = 'N'; } /* intentionally modify string (replace \n with N) */
.            { printf("%c ", *yytext); }
<<EOF>>      { printf("EOF\n"); yyterminate(); /* yyterminate will cause yylex return 0 */ } 
%%

void print_diff(char in[], char sav[], size_t size)
{
   printf("Input string %s", !memcmp(in, sav, size) ? "has not changed\n" : "modified to: ");
}

int main (int argc, char* argv[])
{
   char buffer[16]     = "foo\nfoe\n\0\0";
   char buffer_sav[16];
   YY_BUFFER_STATE buff_state;
  
   memcpy(buffer_sav, buffer, sizeof buffer);

   // yy_scan*() functions call yy_switch_to_buffer()

   printf("Scanning input string with yy_scan_string(): ");
   // yy_scan_string() will make copy of input string and work with the copy
   buff_state = yy_scan_string (buffer); 
   yylex();
   yy_delete_buffer(buff_state);
   print_diff(buffer, buffer_sav, sizeof buffer);

   printf("Scanning 4 bytes with yy_scan_bytes(): "); 
   // yy_scan_bytes() will make copy of input bytes and work with the copy
   buff_state = yy_scan_bytes (buffer, 4);
   yylex();
   yy_delete_buffer(buff_state);
   print_diff(buffer, buffer_sav, sizeof buffer);

   printf("Scanning bytes with yy_scan_buffer(): "); 
   // yy_scan_buffer() doesn't copy input; requires last 2 chars of input buffer to be '\0' 
   buff_state = yy_scan_buffer(buffer, (yy_size_t)(strlen(buffer)+2)); 
   yylex();
   yy_delete_buffer(buff_state);
   print_diff(buffer, buffer_sav, sizeof buffer);

   // print the buffer modified by scanner when yy_scan_buffer() was used
   buff_state = yy_scan_string (buffer);
   yylex();
   yy_delete_buffer(buff_state);
}
