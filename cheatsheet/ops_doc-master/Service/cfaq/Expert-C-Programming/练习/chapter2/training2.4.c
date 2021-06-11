#include <stdio.h>
#include <stdlib.h>

int main()
{
    char *available_resources[] = {
        "color monitor",
        "big disk",

        "Cray" //少了个逗号
        "on-line drawing routhines",

        "mouse",
        "keyboard",
        "power cables",     //这个多余的逗号会引起什么问题吗？
    };
    int i;
//    printf("%d\n",sizeof(char *)); //char *是4个字节
    printf("total:%lu\n", sizeof(available_resources)/sizeof(available_resources[0]));

    for(i=0; i< sizeof(available_resources)/sizeof(available_resources[0]); i++)
        printf("%s\n",available_resources[i]);
    return 0;
}
