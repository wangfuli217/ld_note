/* 
*  gcc backtrace1.c -o backtrace1  -rdynamic  -ldl
*  ./backtrace1
*  http://www.acsu.buffalo.edu/~charngda/backtrace.html （强烈推荐）
*/

#include <execinfo.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <ucontext.h>

#define STACKCALL __attribute__((regparm(1),noinline))  
void ** STACKCALL getEBP(void){  
        void **ebp=NULL;  
        __asm__ __volatile__("mov %%rbp, %0;\n\t"  
                    :"=m"(ebp)      /* 输出 */  
                    :      /* 输入 */  
                    :"memory");     /* 不受影响的寄存器 */  
        return (void **)(*ebp);  
}  

void print_walk_backtrace( void )
{
    int frame = 0;
    Dl_info dlip;
    void **ebp = getEBP();
    void **ret = NULL;
    printf( "Stack backtrace:\n" );
    while( ebp )
    {
        ret = ebp + 1;
        dladdr( *ret, &dlip );
        printf("Frame %d: [ebp=0x%08x] [ret=0x%08x] %s\n",
                frame++, *ebp, *ret, dlip.dli_sname );
        ebp = (void**)(*ebp);
        /* get the next frame pointer */
    }
    printf("---------------------------------------------------------\n");
}

int foo()
{
    print_walk_backtrace();
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