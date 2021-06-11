#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>

#define MAP_SRC_ELEM int
#define MAP_DEST_ELEM int
#define FILTER_ELEM int

/*
    一辆卡车违反交通规则，撞人后逃跑。现场有三人目击事件，但都没有记住车号，只记下
车号的一些特征。甲说：牌照的前两位数字是相同的；乙说：牌照的后两位数字是相同的，
但与前两位不同；丙是数学家，他说：四位的车号刚好是一个整数的平方。请根据以上线索找出车号。
*/
MAP_DEST_ELEM* map(MAP_DEST_ELEM(*callback)(MAP_SRC_ELEM, int),
                   MAP_SRC_ELEM *arr, int size){
    int i;
    MAP_DEST_ELEM* ret_arr = malloc(sizeof(MAP_DEST_ELEM) * size);
    assert(ret_arr != NULL);
    for(i = 0; i < size; i++){
        ret_arr[i] = callback(arr[i], i);
    }
    return ret_arr;
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

int square_num(int num, int idx){return num * num;}
int check_num(int num, int idx){
    int a = num % 10;
    int b = (num/10) % 10;
    int c = (num/100) % 10;
    int d = (num/1000) % 10;
    return a==b && c==d && a!=c;
}
int main(){
    int arr[100];
    int size = range((int)sqrt(1000), (int)sqrt(10000), 1, arr);
    int *ret_arr = map(square_num, arr, size);
    size = filter(check_num, ret_arr, size);
    print_arr(stdout, ret_arr, size);
    free(ret_arr);

    return 0;
}