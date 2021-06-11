%{
   /* 
    * Code enclosed between '%{' and '%}' in the defintions section gets 
    * included somewhere in the middle of the generated scanner file,
    * before yylex() definition.
    */

   #include <stdio.h>

   const uint32_t user_code_lineno = __LINE__;
%}

%top {
    /* 
     * The %top block will be put at the top of the generated scanner file.
     * Include stdint.h here so uint32_t type is defined.
     */
   #include <stdint.h>

   const uint32_t top_block_lineno = __LINE__;
}

%option noyywrap 

%%
     /* 
      * Indented lines of code at the beginning of rules section get 
      * included at the beginning of yylex() func. 
      */
     int yylex_code_lineno = __LINE__;
%{
     // Another way of including code in yylex() function, beside indentation,
     // is to use '%{' and %}' block in the rules section.

     int yylex_code_lineno2 = __LINE__;
   
     printf("Function %s: yylex_code_lineno==%u, yylex_code_lineno2==%u\n", 
             __FUNCTION__, yylex_code_lineno, yylex_code_lineno2);

%}
%%

// Another user code section goes here, included at the end of flex generated file

int main ()
{
   const uint32_t main_lineno = __LINE__;

   printf("top_block_lineno=%u, user_code_block_lineno=%u, main_lineno=%u\n", 
           top_block_lineno, 
           user_code_lineno, 
           main_lineno);

   // Create a string input buffer and use this string as the input instead of stdin
   YY_BUFFER_STATE buff_state = yy_scan_string ("The End\r\nThe End\n\r");
 
   int ret = yylex();
 
   yy_delete_buffer(buff_state); // free state buffer memory allocated by yy_scan_string()

   return ret;
}
