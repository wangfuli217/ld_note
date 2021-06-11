#include <stdio.h>
#include <string.h>
#include <malloc.h>

int main(int argc,char *argv[]){
    int i=0;
    printf("argc = %d\n",argc);
    for(i = 0;i<argc;i++){
        printf("argv[%d] = %s\n",i,argv[i]);
    }
    return 0;
}

// template_arg.exe -a -b -c -d hello.txt
// 有些C程序员采用了一种约定，带'--'的参数，表示从这个参数开始，后面的参数都不是选项开关，即便它是以连字符开头。
