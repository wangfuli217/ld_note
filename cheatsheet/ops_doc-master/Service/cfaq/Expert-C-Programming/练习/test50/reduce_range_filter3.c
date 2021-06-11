// 从键盘输入10个战士的身高，输出平均身高，并找出哪些身高高于平均身高。
#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

#define REDUCE_CACHE int
#define REDUCE_ELEM int
#define FILTER_ELEM int

//= require reduce
//= require filter
//= require print_arr

int avg = 0;
int add(int acc, int num, int idx){return acc + num;}
int check(int num, int idx){return num > avg;}

int main(){
    int soldiers[] = {171, 172, 173, 174, 181, 183, 190, 190, 176, 168};
    int count = sizeof(soldiers) / sizeof(int);
    avg = reduce(add, soldiers, count, 0) / count;
    count = filter(check, soldiers, count);
    printf("average: %d", avg);
    print_arr(stdout, soldiers, count);

    return 0;
}