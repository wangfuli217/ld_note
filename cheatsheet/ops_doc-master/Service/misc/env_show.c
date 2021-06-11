#include <stdio.h>
#include <stdlib.h>

//宏：分割两个不同的部分
#define SEPARATE() printf("\n= = = = =\n\n")

extern char **environ;

void main()
{
    //打印指定的环境变量值
    printf("打印指定的环境变量值\n");
    char *var, *value;
    var = "USER";
    value = getenv(var);
    if (value)
    {
        printf("[%s]: %s\n", var, value);
    }
    else
    {
        printf("[%s] 没有这个环境变量\n", var);
    }

    SEPARATE();

    //添加一个环境变量
    printf("添加一个环境变量\n");
    var = "TEST_20140926";
    value = getenv(var);
    if (!value)
    {
        printf("没有环境变量 %s\n", var);
    }
    if (putenv("TEST_20140926=12345678") == 0)
    {
        printf("添加环境变量 TEST_20140926\n");
    }
    else
    {
        printf("环境变量 TEST_20140926 添加失败\n");
        exit(EXIT_FAILURE);
    }
    value = getenv(var);
    if (value)
    {
        printf("[%s]: %s\n", var, value);
    }

    //注意：这个新增的环境变量仅仅对这个程序本身有效
    //这是因为变量的值不会从子进程（本程序）传播到父进程（Shell）

    SEPARATE();

    return 0;

    //打印全部环境变量
    printf("打印全部环境变量\n");
    char **env = environ;
    while (*env)
    {
        printf("%s\n", *env);
        env++;
    }

    exit(EXIT_SUCCESS);
}
