// 输入某年某月某日，判断这一天是这一年的第几天？
#include <stdio.h>

#define MONTH_SIZE 12
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

int is_leap_year(int year){
    if(year % 400 == 0)  return 1;
    if((year % 4 == 0) && (year % 100 != 0)) return 1;
    return 0;
}
void copy_arr(int *souce, int *dest, int size){
    while(size >= 0) {dest[size-1] = souce[size-1]; size--;}
}
void get_months(int year, int *month_days){
    static int s_month_days[] = {31,0,31,30,31,30,31,31,30,31,30,31};
    copy_arr(s_month_days, month_days, MONTH_SIZE);
    month_days[1] = is_leap_year(year) ? 29 : 28;
}
int add(int acc, int num, int idx){return acc + num;}
int day_in_year(int year, int month, int day){
    int month_days[MONTH_SIZE];
    get_months(year, month_days);
    return reduce(add, month_days, month-1, 0) + day;
}
int main(){
    printf("%d\n", day_in_year(1998,1,1));
    printf("%d\n", day_in_year(1998,2,1));
    printf("%d\n", day_in_year(1998,3,1));

    printf("%d\n", day_in_year(2000,1,1));
    printf("%d\n", day_in_year(2000,2,1));
    printf("%d\n", day_in_year(2000,3,1));
    printf("%d\n", day_in_year(2000,12,31));

    return 0;
}