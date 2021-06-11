
#include <stdio.h>

int main(void)
{
    int array[5];
    int *p;
    int i;

    /*给数组array 的各元素设定值*/
     for (i = 0; i < 5; i++) {
         array[i] = i;
     }

     /*输出数组各元素的值（指针版）*/ 
     /* p = array; array指向数组初始元素的指针 -- 错误说法 */
     for (p = &array[0]; p != &array[5]; p++) {
         printf("%d\n", *p);
     }
     
#if 0
     /*利用指针输出数组各元素的值——改写版*/
    p = &array[0];
    for (i = 0; i < 5; i++) {
        printf("%d\n", *(p + i));
    }
#endif

#if 0
    p = array;    // 只是改写了这里，可是……
    for (i = 0; i < 5; i++) {
        printf("%d\n", *(p + i));
    }
#endif

#if 0
    p = array;
    for (i = 0; i < 5; i++) {
        printf("%d\n", p[i]);
    }
#endif
     return 0;
 }
 
 /*
 表达式中，数组可以解读成“指向它的初始元素的指针”。尽管有三个小例外，但是这和在后面加不加[]没有关系。
 p[i]是*(p + i)的简便写法。
 下标运算符[]原本只有这种用法，它和数组无关。
 */