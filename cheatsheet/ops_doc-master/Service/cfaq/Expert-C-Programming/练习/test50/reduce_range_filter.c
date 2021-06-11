// 求n以内（不包括n）同时能被3和7整除的所有自然数之和的平方根s，n从键盘输入。
// 例如若n为1000时，函数值应为：s=153.909064。
#include <stdio.h>
#include <math.h>

#define REDUCE_ELEM int
#define REDUCE_CACHE int
#define FILTER_ELEM int

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

int filter(int(*predicate)(FILTER_ELEM, int), FILTER_ELEM *arr, int size){
    int i, new_size = 0;
    FILTER_ELEM temp;
    for(i = 0; i < size; i++){
        if(predicate(arr[i], i)){
            temp = arr[i];
            arr[new_size] = temp;
            new_size++;
        }
    }
    return new_size;
}

// 需要引入math.h，并在gcc时，需要 -lm
int add(int acc, int num, int idx){return acc + num;}
int check_num(int num, int idx){return (num % 3 == 0) && (num % 7 == 0);}
int main(void){
    int n = 1000;
    int arr[n];

    int size = range(1, n, 1, arr);
    size = filter(check_num, arr, size);
    int sum = reduce(add, arr, size, 0);
    double ret = sqrt(sum);

    printf("%f\n", ret);
    return 0;
}