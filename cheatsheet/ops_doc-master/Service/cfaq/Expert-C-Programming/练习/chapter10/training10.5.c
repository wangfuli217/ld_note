#include <stdio.h>
#include <malloc.h>
#include <setjmp.h>

int (*paf())[20];
jmp_buf error;
struct a_tag
{
    int array[20];
}x1,x2,y;
struct a_tag my_function()
{
    y.array[0] = 13;
    return y;
}

int (*paf())[20]
{
    int (*pear)[20];    //声明一个指向包含20个int元素的数组的指针。
    pear = calloc(20, sizeof(int));
    if(!pear) longjmp(error, 1);
    return pear;
}
int main()
{
    int (*result)[20];
    result = paf();
    (*result)[3] = 12;
    printf("%d\n",(*result)[3]);

    x2 = my_function();
    x1 = y;
    printf("x1[0]:%d x2[0]:%d \n",x1.array[0],x2.array[0]);
}
