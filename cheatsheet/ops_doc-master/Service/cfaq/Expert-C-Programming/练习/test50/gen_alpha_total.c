// 随机产生N个大写字母输出，然后统计其中共有多少个元音字符。（设N为50）
#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

#define N 50
#define REDUCE_CACHE int
#define REDUCE_ELEM char

//= require reduce

void gen_alpha(char *arr, int size){
    srand(time(NULL));
    int i;
    for(i = 0; i < size; i++){
        arr[i] = rand()%26 + 'A';
    }
}

int count(int acc, char ch, int idx){
    return acc + (ch == 'A' || ch == 'E' ||
            ch == 'I' || ch == 'O' || ch == 'U');
}

int main(){
    char str[N+1];
    gen_alpha(str, N);
    str[N] = '\0';
    printf("%s\n", str);
    printf("%d\n", reduce(count,str,N,0));
    return 0;
}