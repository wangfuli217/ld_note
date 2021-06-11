#include <stdio.h>

// 从终端（键盘）读入20个数据到数组中，统计其中正数的个数，并计算这些正数之和。
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

// filter
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

int add(int acc, int num, int idx){return acc + num;}
int is_positive(int num, int idx){return num > 0;}
int main(){
    int arr[] = {1,2,3,4,5,6,-3,-4,-5,-6,11,12,13,14,15,16,-13,-14,-15,-16};
    int size = sizeof(arr) / sizeof(int);
    size = filter(is_positive, arr, size);
    printf("size: %d; sum: %d \n", size, reduce(add, arr, size, 0));
    return 0;
}