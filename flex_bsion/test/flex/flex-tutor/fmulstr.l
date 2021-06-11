%{
//
// Illustrate scanning multiple strings
// Scanner will scan a string and replace <@#> occurances with another string
//
#include <memory.h>
#include <stack>

std::stack< YY_BUFFER_STATE > buff_states_stack;

const char* inserts[] = { "World", "Flex" };
const char  start_text[] = "Hello <@1> <@0>!";


%}

%option noyywrap

%%
^.           printf("^%c", *yytext); // beginning of the input
\<@[01]\>    { 
                // replace <@#> with new buffer and continue scanning 
                // yy_scan_string() calls yy_switch_to_buffer()
                buff_states_stack.push( yy_scan_string(inserts[yytext[2] - '0']) );
             }
.            ECHO; 
<<EOF>>      { 
                printf("$"); // the end of the current buffer
                // release current buffer memory
                if (!buff_states_stack.empty())
                {
                   yy_delete_buffer(buff_states_stack.top());
                   buff_states_stack.pop();
                }
                if (buff_states_stack.empty())
                {
                   yyterminate(); // all input scanned. return 0
                }
                else
                {
                   // switch back to the previous buffer 
                   yy_switch_to_buffer(buff_states_stack.top());
                }
             } 
%%

int main (int argc, char* argv[])
{
  buff_states_stack.push(yy_scan_string (start_text));

  printf("calling yylex to scan string: %s\n", start_text);

  yylex();

  printf("\nstates stack size=%lu\n", buff_states_stack.size());

  // clean up of state buffers if something left

  while (!buff_states_stack.empty())
  {
     yy_delete_buffer(buff_states_stack.top());
     buff_states_stack.pop();
  }
}
