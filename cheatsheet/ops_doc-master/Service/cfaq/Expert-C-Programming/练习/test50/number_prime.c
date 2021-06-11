// 找出三位自然数中的所有素数，要求判断x素数用自定义函数data(x)实现。
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "utils.h"

#define FILTER_ELEM int

//= require range
//= require filter
//= require print_arr

int data(int num, int idx){
    if(num == 1 || num == 2 || num == 3) return 1;
    int i = 2, max = sqrt(num);
    while(i < max){
        if(num % i == 0) return 0;
        i++;
    }
    return 1;
}

int main(void){
    int nums[1000];
    int size = range(100, 1000, 1, nums);
    size = filter(data, nums, size);
    printf("count: %d\n", size);
    print_arr(stdout, nums, size);

    return 0;
}