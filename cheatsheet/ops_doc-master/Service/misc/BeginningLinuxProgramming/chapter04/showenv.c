#include <stdlib.h>
#include <stdio.h>

extern char **environ;

//Linux操作系统的系统变量放在一个文件中，该文件放了全部的系统变量
//但是，当系统起来的时候，这些全局变量全部放在了一个全局的
//全局变量中，他其实就是一个二维的字符串数组

int main(void)
{
    char **env = environ;

    while(*env) 
	{
        printf("%s\n",*env);
        env++;
    }
    exit(0);
}
