#include <stdio.h>
#include <stdlib.h>

int TARGET_COUNT = 100;
int TARGET_VALUE = 100;
int COUNT = 0;

typedef struct{
    int cnt_male;
    int cnt_female;
    int cnt_children;
}STAT;

typedef struct
{
    int count;
    int value;
}RULE;

RULE rules[] = {{1,3}, {1,2}, {3,1}};

void _get_total(STAT stat, int *total){
    int i = 0, size = sizeof(rules) / sizeof(RULE);
    while(i < size){
        total[0] += ((int*)&stat)[i] * rules[i].count;
        total[1] += ((int*)&stat)[i] * rules[i].value;
        i++;
    }
}

int check_is_done(STAT stat){
    int total[] = {0,0};
    _get_total(stat, total);
    return total[0] > TARGET_COUNT || total[1] > TARGET_VALUE;
}

int check_accord(STAT stat){
    int total[] = {0,0};
    _get_total(stat, total);
    return total[0] == TARGET_COUNT && total[1] == TARGET_VALUE;
}

void push_result(STAT stat){
    printf("[%4d](", ++COUNT);
    int i = 0, size = sizeof(rules) / sizeof(RULE);
    while(i < size){
        printf("%4d", ((int*)&stat)[i] * rules[i].count);
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

int main(){
    int size = sizeof(rules) / sizeof(RULE);
    int stat[size];
    int i = 0;
    while(i < size) stat[i++] = 0;
    product(size, 0, *((STAT*)stat));
    return 0;
}