#include <stdio.h>

int main(int argc,char **argv){
#if 0
// 这个指针不能用于修改这个整型数，但是在任何时候，这个指针本身的值却可改变。
// 我给你一个指向它的指针，但你不能修改它。
const int limit = 10;
const int *limitp = &limit ;
int i = 27;
limitp = &i;
#endif

#if 0
// warning: initialization discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
const int limit = 10;
int *limitp = &limit ;
*limitp = 20;
printf("%d",limit);
#endif

#if 0
// error: assignment of read-only location '*limitp'
const int limit = 10;
const int *limitp = &limit ;
*limitp = 20;
printf("%d",limit);
#endif

printf("hello world\n");
}