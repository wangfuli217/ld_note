// 用for编程找出100~200中的完全平方数。
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include "utils.h"

#define MAP_SRC_ELEM int
#define MAP_DEST_ELEM int

//= require range
//= require map
//= require print_arr

int square(int num, int idx){return num * num;}
int main(){
    int arr[10];
    int size = range(sqrt(100), sqrt(200)+1, 1, arr);
    int *ret = map(square, arr, size);
    print_arr(stdout, ret, size);
    return 0;
}