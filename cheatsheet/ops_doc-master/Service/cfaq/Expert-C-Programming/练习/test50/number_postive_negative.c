// 输入10个数，分别统计其中正数、负数、零的个数。
#include <stdio.h>

typedef struct{
    int zero;
    int positive;
    int negative;
} STATUS;

#define REDUCE_ELEM int
#define REDUCE_CACHE STATUS*

// reduce
REDUCE_CACHE reduce(REDUCE_CACHE(*callback)(REDUCE_CACHE, REDUCE_ELEM, int),
                    REDUCE_ELEM *arr, int size, REDUCE_CACHE init){
    int i;
    REDUCE_CACHE acc = init;
    for(i = 0; i < size; i++){
        acc = callback(acc, arr[i], i);
    }
    return acc;
}

STATUS* callback(STATUS *acc, int num, int idx){
    if(num == 0) acc->zero++;
    else if(num > 0) acc->positive++;
    else acc->negative++;
    return acc;
}
int main(){
    int arr[] = {1,2,3,4,0,0,-5,-6,0,-7,-9};
    STATUS status = {0,0,0};
    reduce(callback, arr, sizeof(arr) / sizeof(int), &status);
    printf("zero: %d; positive: %d; negative: %d\n",
        status.zero, status.positive, status.negative);
    return 0;
}