#include <stdio.h>
#include <setjmp.h>
jmp_buf buf;

int banana()
{
    printf("in banana() \n");
    longjmp(buf, 1);
    /* 以下代码不会被执行 */
    printf("you'll never see this, because i longjmp'd");
}

int main()
{
    if(setjmp(buf))
        printf("back in main\n");
    else
    {
        printf("first time through\n");
        banana();
    }
}
