// 从键盘输入10个战士的身高，输出最高、最低的身高。
#include <stdio.h>
#include "utils.h"

typedef struct{
    int min;
    int max;
} STAT;

#define REDUCE_CACHE STAT*
#define REDUCE_ELEM int

//= require reduce

STAT* pipe(STAT* acc, int num, int idx){
    if(num < acc->min) acc -> min = num;
    else if(num > acc->max) acc -> max = num;
    return acc;
}

int main(){
    int soldiers[] = {171, 172, 173, 174, 181, 183, 190, 190, 176, 168};
    int count = sizeof(soldiers) / sizeof(int);
    STAT stat = {soldiers[0], soldiers[0]};
    reduce(pipe, soldiers, count, &stat);
    printf("min: %d; max: %d\n", stat.min, stat.max);

    return 0;
}