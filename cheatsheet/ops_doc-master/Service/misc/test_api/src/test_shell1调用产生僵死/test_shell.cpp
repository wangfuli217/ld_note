#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/prctl.h>
#include <errno.h>

#define TDATA 888
void clear_up(int sig)  //收到exit或者kill -9的信号，需要处理的事情
{
    while(1)
    {
        pid_t p = wait(NULL);
        if(p == -1) break;
        fprintf(stdout,"******recyle %d ok******\n",p);
    }
}
void exit_fuc()//收到sigint的信号的处理
{
    printf("*********exit %d******\n",getpid());
    exit(0);
}

typedef struct open_pf
{
    FILE * pf;
    int pid;
}open_pf;

open_pf mypopen(const char *cmd,char type)
{
    int pipefd[2];           //管道描述符
    int pid_t;               //进程描述符
    open_pf ret;
    ret.pf=NULL;
    ret.pid = -1;

    if(type !='r' && type != 'w')
    {
        printf("myopen() flag error");
        return ret;
    }

    if(pipe(pipefd)<0)        //建立管道
    {
        printf("myopen() pipe create error");
        return ret;
    }

    pid_t=fork();             //建立子进程

    if(pid_t < 0)
    {
        printf("mypopen fork error");
        return ret;
    }

    if(0 == pid_t)            //子进程中......
    {
//        prctl(PR_SET_PDEATHSIG, SIGHUP);//注意，使用函数，需要保证调用此接口的线程不要主动退出。
        prctl(PR_SET_PDEATHSIG, SIGUSR1);
        if(type == 'r')
        {
            close(pipefd[0]);               //此函数返回文件指针是用于读，因此，在子进程中应该将结果写入管道，这样父进程返回的文件指针才能读，所以这里将读端关闭
            dup2(pipefd[1],STDOUT_FILENO);  //exec函数的执行结果将会通过标准输出写到控制台上，但这里我们不需要在控制台输出，而是需要将结果返回，因此将标准输出重定向到管道写端
            close(pipefd[1]);
        }
        else
        {
            close(pipefd[1]);
            dup2(pipefd[0],STDIN_FILENO);
            close(pipefd[0]);
        }

        //设置组属于，这样和vos的拉起模块不属于同一个组
//        ::setsid();
        //if(execvp("sudo",argv)<0)          //用exec族函数执行命令
        execl("/bin/sh", "sh", "-c", cmd, (char *) 0);
        printf("execl");
        return ret;
    }
    //wait(0);                                //等待子进程返回
    ret.pid = pid_t;
    if( type == 'r' )
    {
        close(pipefd[1]);
        ret.pf = fdopen(pipefd[0],"r");   //由于程序需要返回的参数是文件指针，因此需要用fdopen函数将描述符打开，其返回值为相应的文件指针
    }
    else
    {
        close(pipefd[0]);
        ret.pf = fdopen(pipefd[1],"w");
    }
    if ( NULL == ret.pf )
    {
        printf("ret.pf is NULL, errno=%s", strerror(errno));
    }
    return ret;
}

int VOS_DoShell(const char *cmd,char type)
{
    int ret,ret2 = 0;
    open_pf opf;
    //int w;
    //char buffer[80];
    opf=mypopen(cmd, type);

    while (waitpid(opf.pid, &ret, 0) < 0)
    {
        if (errno != EINTR)
        {
            printf("VOS_DoShell waitpid err %d", errno);

            if ( NULL == opf.pf )
            {
               printf("VOS_DoShell opf.pf NULL");
               return(-1);
            }
            ret = fclose(opf.pf);
            return(-1); /* error other than EINTR from waitpid() */
        }
    }

    if (WIFEXITED(ret))
    {
        //printf( "VOS_DoShell exited, ret=%d\n", WEXITSTATUS(ret));
    }
    else if (WIFSIGNALED(ret))
    {
        printf( "VOS_DoShell, killed by ret %d\n", WTERMSIG(ret));
    }
    else if (WIFSTOPPED(ret))
    {
        printf( "VOS_DoShell stopped by ret %d\n", WSTOPSIG(ret));
    }
    else if (WIFCONTINUED(ret))
    {
        printf( "VOS_DoShell continued\n");
    }


    if ( NULL == opf.pf )
    {
       printf("VOS_DoShell opf.pf NULL,ret=%d",ret);
       return(-1);
    }
    ret2 = fclose(opf.pf);

    return ret;
}

int systempoen(char * cmd)
{
    int ret = 0;
    if(popen(cmd, "r") != NULL)
    {

    }
    else
    {
        printf("popen err %d", errno);
    }
    return ret;
}
void * test_shell(void *arg)
{
    //直接调用system
//    system("./test.sh");
    //调用系统的popen
//    systempoen("./test.sh");
    //调用VOS实现的popen
    VOS_DoShell("./test.sh", 'r');
    return NULL;
}

int main(void) {
        printf("I am a child =%d,my parent =%d\n",getpid(),getppid());
        pthread_t tid1;
        pthread_create(&tid1, NULL, test_shell, NULL);
        tcpServer(NULL);
//        system("./test.sh");
//        VOS_DoShell("./test.sh", 'r');
        printf("do test.sh ok\n");
        while(1)
            sleep(3);
//    }

    return 0;
}
