// 个位数为6且能被3整除但不能被5整除的三位自然数共有多少个，分别是哪些？
#include <stdio.h>
#include <stdlib.h>

#define FILTER_ELEM int

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
void print_arr(FILE *fp, int *arr, int size){
    fprintf(fp, "[ ");
    int i = 0;
    while(i < size){
        fprintf(fp, "%6d ", arr[i++]);
        if(i == size){
            fprintf(fp, " ]\n");
            return;
        }
        if(i%10 == 0) fprintf(fp, "\n");
    }
}

int check_num(int num, int idx){
    return (num%3 == 0) && (num%5 != 0) && (num%10 == 6);
}
int main(){
    int arr[999];
    int size = range(100, 1000, 1, arr);
    size = filter(check_num, arr, size);
    printf("count is %d\n", size);
    print_arr(stdout, arr, size);
    return 0;
}