#include <stdio.h>
#include <stdlib.h>

// 从终端（键盘）将5个整数输入到数组a中，然后将a逆序复制到数组b中，并输出b中各元素的值。
// print_arr
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

void reverse_arr(int *arr1, int *arr2, int size){
    int i;
    for(i = 0; i < size; i++){
        arr2[i] = arr1[size - i - 1];
    }
}

int main(){
    int arr1[] = {1,2,3,4,5};
    int size = sizeof(arr1) / sizeof(int);
    int arr2[size];

    reverse_arr(arr1, arr2, size);
    print_arr(stdout, arr2, size);
    return 0;
}