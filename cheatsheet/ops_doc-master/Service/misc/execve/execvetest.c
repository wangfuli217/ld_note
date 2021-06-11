/*
 * =====================================================================================
 *
 *       Filename:  execvetest.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年12月04日 22时05分45秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */
//1.exec家族一共有六个函数，分别是：
//(1)int execl(const char *path, const char *arg, ......);
//(2)int execle(const char *path, const char *arg, ...... , char * const envp[]);
//(3)int execv(const char *path, char *const argv[]);
//(4)int execve(const char *filename, char *const argv[], char *const envp[]);
//(5)int execvp(const char *file, char * const argv[]);
//(6)int execlp(const char *file, const char *arg, ......);
//exec函数名对应位含义：
//前4位：均为exec
//第5位：L：参数传递为逐个列举的方式，其语法为const char *arg
//			 V：参数传递为构造指针数组的方式，其语法为char *const argv[]
//第6位：E：可传递新进程环境变量
//			 P：执行文件查找可以只给出文件名，系统就会自动按照环境变量"$PATH"所指定的路径进行查找
/*exec函数示例*/
#include <stdio.h>
#include <unistd.h>
#include<sys/types.h>
#include<sys/wait.h>

int main(void)
{
    int flag;
    pid_t pid;
    char * const argv[] =
    { "%U", "--user-data-dir=/home/Administrator/.chromiun", NULL };
    char * const argv1[] =
    { "no", "hello advantech", NULL };
    char *envp[] =
    { "PATH=.:/bin", NULL };
    //exec把当前进程印象替换成新的程序文件，故调用进程被覆盖

    printf("(1)\n");
    //$PATH does't work,use file name with full path.
    if ((pid = fork()) == 0)
    {
        printf("in child process execl......\n");
        flag = execl("/bin/ls", "ls", "-al", "/etc/passwd", (char *) 0);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    if ((pid = fork()) == 0)
    {
        printf("in child process execv......\n");
        flag = execl("ls", "ls", "-al", "/etc/passwd", (char *) 0);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    printf("(2)\n");
    //pass different  environment
    if ((pid = fork()) == 0)
    {
        printf("in child process execv......\n");
        flag = execle("hello", "ls", "-al", "/etc/passwd", NULL,envp);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    if ((pid = fork()) == 0)
    {
        printf("in child process execv......\n");
        char *envp[] ={ "PATH=/bin:/sbin", NULL };
        flag = execle("hello", "ls", "-al", "/etc/passwd", NULL,envp);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    printf("(3)\n");
    if ((pid = fork()) == 0)
    {
        printf("in child process execv......\n");
        flag = execv("hello", argv);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    if ((pid = fork()) == 0)
    {
        printf("in child process execv......\n");
        flag = execv("./hello", argv1);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    printf("(4)\n");
    // 如果不指定全路径，则只检查PATH变量中存储的命令
    if ((pid = fork()) == 0)
    {
        printf("in child process execve......\n");
        //envp变量的用

        flag = execve("hello", argv, envp);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    if ((pid = fork()) == 0)
    {
        printf("in child process execve......\n");
        //envp变量的用
        flag = execve("hello", argv, NULL);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    printf("(5)\n");
    // 如果不指定全路径，则只检查PATH变量中存储的命令
    if ((pid = fork()) == 0)
    {
        printf("in child process execvp......\n");
        flag = execvp("./hello", argv);
        //envp变量的用
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    printf("(6):\n");
    // -al does't work
    if ((pid = fork()) == 0)
    {
        printf("in child process execlp......\n");
        //执行ls命令
        flag = execlp("ls", "-al", NULL);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    // -al works
    if ((pid = fork()) == 0)
    {
        printf("in child process execlp......\n");
        //执行ls命令
        flag = execlp("ls", "-al", "-al", NULL);
        if (flag == -1)
        {
            perror("exec error!");
            return 0;
        }
    }
    waitpid(pid, NULL, 0);

    printf("in parent process ......\n");
    return 0;
}
