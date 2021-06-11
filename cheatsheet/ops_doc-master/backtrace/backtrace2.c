/* 
*  gcc backtrace2.c -o backtrace2 -lunwind -lunwind-x86
*  ./backtrace2
*  http://www.acsu.buffalo.edu/~charngda/backtrace.html （强烈推荐）
*/


#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <libunwind.h>

void do_unwind_backtrace()
{
    unw_cursor_t    cursor;
    unw_context_t   context;

    unw_getcontext(&context);
    unw_init_local(&cursor, &context);

    while (unw_step(&cursor) > 0) {
        unw_word_t  offset, pc;
        char        fname[64];

        unw_get_reg(&cursor, UNW_REG_IP, &pc);

        fname[0] = '\0';
        (void) unw_get_proc_name(&cursor, fname, sizeof(fname), &offset);

        printf ("%p : (%s+0x%x) [%p]\n", pc, fname, offset, pc);
    }
    printf("---------------------------------------------------------\n");
}
int foo()
{
    do_unwind_backtrace();
}
int bar( void )
{
    foo();
    return 0;
}
int boo( void )
{
    bar();
    return 0;
}
int baz( void )
{
    boo();
    return 0;
}
int main( void )
{
    baz();
    return 0;
}