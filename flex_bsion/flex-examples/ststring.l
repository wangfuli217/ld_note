%option main
%x str
%{
#define MAX_STR_CONST 256

  char string_buffer[MAX_STR_CONST];
  char *string_buf_ptr;
%}

%%
\"  string_buf_ptr  = string_buffer; BEGIN(str); 
<str>{
\"             {BEGIN (INITIAL); *string_buf_ptr = '\0'; printf("%s",string_buffer); }
\n             { printf("Error: non terminated string\n"); exit(1); }
\\[0-7]{1,3}   { int result; /* octal escape sequence */
                        (void) sscanf(yytext+1,"%o",&result);
                         if (result > 0xff) {printf("Error: constant out of bounds\n"); exit(2); }
                         *string_buf_ptr++ = result;
                    }
\\[0-9]+       { printf("Error: bad escape sequence\n"); exit(2); }
\\n            {*string_buf_ptr++ = '\n';}
\\t            {*string_buf_ptr++ = '\t';}
\\b            {*string_buf_ptr++ = '\b';}
\\r            {*string_buf_ptr++ = '\r';}
\\f            {*string_buf_ptr++ = '\f';}
\\(.|\n)       {*string_buf_ptr++ = yytext[1];}
[^\\\n\"]+     {char *yptr = yytext; while(*yptr) *string_buf_ptr++ = *yptr++; }
}
(.|\n)
%%
