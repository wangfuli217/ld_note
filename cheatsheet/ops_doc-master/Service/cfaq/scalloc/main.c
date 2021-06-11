#include <stdio.h>
#include "scalloc.h"

/*
 * 测试内存管理, 得到内存注册信息
 */
int main(int argc, char * argv[]) {
    int * piyo = malloc(10);
    free(piyo);
    
    puts("start testing...");

    // 简单测试一下
    free(piyo);

    getchar();
    return 0;
}