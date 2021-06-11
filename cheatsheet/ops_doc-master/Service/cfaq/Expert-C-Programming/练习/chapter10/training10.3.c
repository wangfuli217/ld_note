#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define UMPTEEN 50
int main()
{
    char *turnip1[UMPTEEN],*turnip2[UMPTEEN];
    char my_string[] = "your message here";
    int i;
    //共享字符串，拷贝指针
    for(i=0; i<UMPTEEN; i++)
        turnip1[i] = &my_string[0];
    //拷贝字符串
    for(i=0; i<UMPTEEN; i++)
    {
        turnip2[i] = malloc(strlen(my_string)+1);
        strcpy(turnip2[i],my_string);
    }
    printf("%s\n",turnip1[0]);
    printf("%s\n",turnip2[0]);
}
