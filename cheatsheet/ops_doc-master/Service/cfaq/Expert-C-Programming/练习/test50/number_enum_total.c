#include <stdio.h>
#include <stdlib.h>

// 要将5张100元的大钞票，换成等值的50元，20元，10元，5元一张的小钞票，每种面值至少1张，编程求需要多少张纸币。
int TARGET = 500;
int COUNT = 0;

typedef struct{
    int cnt_50;
    int cnt_20;
    int cnt_10;
    int cnt_5;
}STAT;

int rules[] = {50, 20, 10, 5};

int _get_total(STAT stat){
    int i = 0, ret = 0, size = sizeof(rules) / sizeof(int);
    while(i < size){
        ret += ((int*)&stat)[i] * rules[i];
        i++;
    }
    return ret;
}

int _all_count_than_zero(STAT stat){
    int i = 0, ret = 0, size = sizeof(rules) / sizeof(int);
    while(i < size){
        if (((int*)&stat)[i] == 0) return 0;
        i++;
    }
    return 1;
}

int check_is_done(STAT stat){
    return _get_total(stat) > TARGET;
}

int check_accord(STAT stat){
    return _get_total(stat) == TARGET && _all_count_than_zero(stat);
}

void push_result(STAT stat){
    printf("[%4d](", ++COUNT);
    int i = 0, size = sizeof(rules) / sizeof(int);
    while(i < size){
        printf("%4d", ((int*)&stat)[i]);
        i++;
    }
    printf(")\n");
}

void product(int size, int idx, STAT stat){
    if (idx == size) return;
    while(!check_is_done(stat)){
        product(size, idx + 1, stat);
        ((int*)&stat)[idx] += 1;
        if(check_accord(stat))
            push_result(stat);
    }
}

int main(void){
    int size = sizeof(rules) / sizeof(int);
    int stat[size];
    int i = 0;
    while(i < size) stat[i++] = 0;
    product(size, 0, *((STAT*)stat));
    return 0;
}