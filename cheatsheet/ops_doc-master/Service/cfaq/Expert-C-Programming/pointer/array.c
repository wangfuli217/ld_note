#include <stdio.h>

int main(void)
{
    int array[5];
    int i;

    /*为数组array 的各元素设值*/
    for (i = 0; i < 5; i++) {
         array[i] = i;
     }

     /*输出数组各元素的值*/
     for (i = 0; i < 5; i++) {
         printf("%d\n", array[i]);
     }

     /*输出数组各元素的地址*/
     for (i = 0; i < 5; i++) {
         printf("&array[%d]... %p\n", i, &array[i]);
     }

     return 0;
}