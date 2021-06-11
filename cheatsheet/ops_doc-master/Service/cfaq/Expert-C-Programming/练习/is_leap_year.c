#include <stdio.h>

/*
闰年判断，四年一闰，百年不闰，四百年一闰（if, else if）
*/
int is_leap_year(int);
int main(){
    int years[] = {1900,1901,1904,1996,2000,2004,2005};
    int i, count = sizeof(years)/sizeof(int);
    for(i = 0; i < count; i++){
        if(is_leap_year(years[i]))
            printf("%d is a leap year\n", years[i]);
        else
            printf("%d is not a leap year\n", years[i]);
    }
    return 0;
}

int is_leap_year(int year){
    if(year % 400 == 0)  return 1;
    else if((year % 4 == 0) && (year % 100 != 0)) return 1;
    return 0;
}