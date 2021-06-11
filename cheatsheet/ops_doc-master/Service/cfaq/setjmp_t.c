#include <setjmp.h>
#include <stdio.h>
void some_function(jmp_buf env_buf)
{
    longjmp(env_buf,5);
}
int main(void)
{
    int value;
    jmp_buf environment_buffer;
    value=setjmp(environment_buffer);
    if(value!=0)
    {
        printf("Reached this point from a longjmp with value=%d\n",value);
        exit(0);
    }
    printf("Calling function.\n");
    some_function(environment_buffer);
    return 0;
}