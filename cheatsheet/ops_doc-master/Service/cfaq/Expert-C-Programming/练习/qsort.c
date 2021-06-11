/*
4）函数指针和qsort库函数

    C语言快速排序库函数：   
    void qsort(void *base,int nelem,unsigned int width,int(*pfCompare)(const void*,const void*));
    可以对任意类型的数组进行排序
    对数组排序，需要知道：
    1）数组的起始地址；
    2）数组元素的个数；
    3）每个元素的大小；(由此可以算出每个元素的地址)
    4）元素谁在前谁在后的规则
       base:待排序数组的起始地址
       nelem：待排序数组的元素个数
       width：待排序数组的每个元素的大小（以字节为单位）
       pfCompare：函数指针，指向一个比较函数的地址，该比较函数应为以下形式：
       int 函数名（const void *elem1,const void *elem2);
       比较函数是程序员自己编写的

    排序就是一个不断比较并交换位置的过程。
    qsort函数在执行期间，会通过pfCompare指针调用 “比较函数”，调用时将要比较的两个元素的地址传给“比较函数”，然后根据“比较函数”返回值判断两个元素哪个更应该排在前面。

    pfCompare(e1,e2)
    int 比较函数名(const void *elem1,const void *elem2);
    比较函数编写规则：
    1）如果*elem1应该排在*elem2前面，则函数返回值是负整数；
    2）如果*elem1和*elem2哪个排在前面都行，那么函数返回0；
    3）如果*elem1应该排在*elem2后面，则函数返回值是正整数。

实例：

程序的功能是调用qsort库函数，将一个unsigned int数组按照个位数从小到大进行排序。比如8,23,15三个数，按个位数从小到大排序，就应该是23,15,8
*/
#include <stdio.h>
#include <stdlib.h>
int MyCompare( const void * elem1, const void * elem2 ){
    unsigned int * p1, * p2;
    p1 = (unsigned int *) elem1;//*elem1非法
    p2 = (unsigned int *) elem2;//*elem2非法
    return  (* p1 % 10)-(* p2 % 10 );
}
    #define NUM 5
int main(void){
    unsigned int an[NUM] = { 8,123,11,10,4 };
    qsort( an,NUM,sizeof(unsigned int),MyCompare);
    for( int i = 0;i < NUM; i ++ )
      printf("%d ",an[i]);
    return 0;
}