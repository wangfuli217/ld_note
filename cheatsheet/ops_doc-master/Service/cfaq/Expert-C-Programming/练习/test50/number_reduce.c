#include <stdio.h>

// 计算1+2+3…+n的值，n是从键盘输入的自然数。
#define REDUCE_ELEM int
#define REDUCE_CACHE int

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

// range
int range(int start, int end, int step, int* arr){
    if(step == 0) return 0;
    if(step > 0 && end < start) return 0;
    if(step < 0 && start < end) return 0;
    int new_size = 0;
    while(1){
        if(step > 0 && start >= end) break;
        if(step < 0 && start <= end) break;
        arr[new_size++] = start;
        start += step;
    }
    return new_size;
}

int add(int acc, int b, int idx){return acc + b;}
int main(){
    int n = 50;
    int arr[n];
    int size = range(1, n+1, 1, arr);
    printf("%d\n", reduce(add, arr, size, 0));
    return 0;
}