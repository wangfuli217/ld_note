// 输入一行字符，分别统计出其中英文字母、空格、数字和其它字符的个数。
#include <stdio.h>
#include <string.h>
#include "utils.h"

typedef struct{
    int alpha;
    int digit;
    int space;
    int other;
} STAT;

#define REDUCE_CACHE STAT*
#define REDUCE_ELEM char

//= require reduce

STAT* statistics(STAT* acc,  char ch, int idx){
    if(isalpha(ch)) acc->alpha++;
    else if(isdigit(ch)) acc->digit++;
    else if(isspace(ch)) acc->space++;
    else acc->other++;
    return acc;
}

int main(){
    STAT stat = {0,0,0,0};
    char* str = "this is test, 1237 !";
    reduce(statistics, str, strlen(str), &stat);
    printf("alpha: %d\ndigit: %d\nspace: %d\nother: %d\n",
            stat.alpha, stat.digit, stat.space, stat.other);
    return 0;
}