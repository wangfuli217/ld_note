#include <stdio.h>

int array[] = {23,34,12,17,204,99,16};
#define TOTAL_ELEMENTS (sizeof(array)/sizeof(array[0]))

int main(){
    int d=-1,x=0;
    if(d <= TOTAL_ELEMENTS -2) // if(d <= (int)TOTAL_ELEMENTS -2)
        x = array[d+1];
    printf("%d",x);
    return 0;
}

/*
TOTAL_ELEMENTS所定义的值是unsigned int类型（因为sizeof()的返回类型是无符号数）。
if语句在signed int和unsigned int之间测试相等性，所以d被升级为unsigned int类型，
-1转换成unsigned int的结果是一个非常大的正整数，导致表达式的值为假。
*/