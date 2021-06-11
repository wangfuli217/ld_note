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
void clear_up(int sig)  //�յ�exit����kill -9���źţ���Ҫ���������
{
    while(1)
    {
        pid_t p = wait(NULL);
        if(p == -1) break;
        fprintf(stdout,"******recyle %d ok******\n",p);
    }
}
void exit_fuc()//�յ�sigint���źŵĴ���
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
    int pipefd[2];           //�ܵ�������
    int pid_t;               //����������
    open_pf ret;
    ret.pf=NULL;
    ret.pid = -1;

    if(type !='r' && type != 'w')
    {
        printf("myopen() flag error");
        return ret;
    }

    if(pipe(pipefd)<0)        //�����ܵ�
    {
        printf("myopen() pipe create error");
        return ret;
    }

    pid_t=fork();             //�����ӽ���

    if(pid_t < 0)
    {
        printf("mypopen fork error");
        return ret;
    }

    if(0 == pid_t)            //�ӽ�����......
    {
//        prctl(PR_SET_PDEATHSIG, SIGHUP);//ע�⣬ʹ�ú�������Ҫ��֤���ô˽ӿڵ��̲߳�Ҫ�����˳���
        prctl(PR_SET_PDEATHSIG, SIGUSR1);
        if(type == 'r')
        {
            close(pipefd[0]);               //�˺��������ļ�ָ�������ڶ�����ˣ����ӽ�����Ӧ�ý����д��ܵ������������̷��ص��ļ�ָ����ܶ����������ｫ���˹ر�
            dup2(pipefd[1],STDOUT_FILENO);  //exec������ִ�н������ͨ����׼���д������̨�ϣ����������ǲ���Ҫ�ڿ���̨�����������Ҫ��������أ���˽���׼����ض��򵽹ܵ�д��
            close(pipefd[1]);
        }
        else
        {
            close(pipefd[1]);
            dup2(pipefd[0],STDIN_FILENO);
            close(pipefd[0]);
        }

        //���������ڣ�������vos������ģ�鲻����ͬһ����
//        ::setsid();
        //if(execvp("sudo",argv)<0)          //��exec�庯��ִ������
        execl("/bin/sh", "sh", "-c", cmd, (char *) 0);
        printf("execl");
        return ret;
    }
    //wait(0);                                //�ȴ��ӽ��̷���
    ret.pid = pid_t;
    if( type == 'r' )
    {
        close(pipefd[1]);
        ret.pf = fdopen(pipefd[0],"r");   //���ڳ�����Ҫ���صĲ������ļ�ָ�룬�����Ҫ��fdopen�������������򿪣��䷵��ֵΪ��Ӧ���ļ�ָ��
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
    //ֱ�ӵ���system
//    system("./test.sh");
    //����ϵͳ��popen
//    systempoen("./test.sh");
    //����VOSʵ�ֵ�popen
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
