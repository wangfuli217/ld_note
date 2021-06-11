/*  In alarm.c, the first function, ding, simulates an alarm clock.  */

/* Linuix 操作系统的信号机制
long linux_to_solaris_signals[] = {
        0,
	SOLARIS_SIGHUP,		SOLARIS_SIGINT,	
	SOLARIS_SIGQUIT,	SOLARIS_SIGILL,
	SOLARIS_SIGTRAP,	SOLARIS_SIGIOT,
	SOLARIS_SIGEMT,		SOLARIS_SIGFPE,
	SOLARIS_SIGKILL,	SOLARIS_SIGBUS,
	SOLARIS_SIGSEGV,	SOLARIS_SIGSYS,
	SOLARIS_SIGPIPE,	SOLARIS_SIGALRM,
	SOLARIS_SIGTERM,	SOLARIS_SIGURG,
	SOLARIS_SIGSTOP,	SOLARIS_SIGTSTP,
	SOLARIS_SIGCONT,	SOLARIS_SIGCLD,
	SOLARIS_SIGTTIN,	SOLARIS_SIGTTOU,
	SOLARIS_SIGPOLL,	SOLARIS_SIGXCPU,
	SOLARIS_SIGXFSZ,	SOLARIS_SIGVTALRM,
	SOLARIS_SIGPROF,	SOLARIS_SIGWINCH,
	SOLARIS_SIGUSR1,	SOLARIS_SIGUSR1,
	SOLARIS_SIGUSR2,	-1,
};

long solaris_to_linux_signals[] = {
        0,
        SIGHUP,		SIGINT,		SIGQUIT,	SIGILL,
        SIGTRAP,	SIGIOT,		SIGEMT,		SIGFPE,
        SIGKILL,	SIGBUS,		SIGSEGV,	SIGSYS,
        SIGPIPE,	SIGALRM,	SIGTERM,	SIGUSR1,
        SIGUSR2,	SIGCHLD,	-1,		SIGWINCH,
        SIGURG,		SIGPOLL,	SIGSTOP,	SIGTSTP,
        SIGCONT,	SIGTTIN,	SIGTTOU,	SIGVTALRM,
        SIGPROF,	SIGXCPU,	SIGXFSZ,        -1,
	-1,		-1,		-1,		-1,
	-1,		-1,		-1,		-1,
	-1,		-1,		-1,		-1,
};不同的信号有不同的含义
*/
#include <signal.h>
#include <stdio.h>
#include <unistd.h>

static int alarm_fired = 0;

void ding(int sig)
{
	printf("Bell Alarm !\n");
    alarm_fired = 1;
}

/*  In main, we tell the child process to wait for five seconds
    before sending a SIGALRM signal to its parent.  */
//通过信号来模拟中断请求
int main(void)
{
    int pid;

    printf("alarm application starting\n");
	/* 如果等于0，表示创建子进程成功；
	如果大于0，表示现在进的是父进程；
	如果小于0，表示创建子进程失败。*/
    if((pid = fork()) == 0)
	{
       sleep(10);
		/*杀死父进程，然后子进程结束自己*/
		/*子进程既可以给父进程发送响铃消息
		也可以杀死父进程，
		守护进程就是让父进程跳出来，然后子进程变成"孤儿"
		进程*/
		//alarm(2);
       kill(getppid(), SIGALRM);
		printf("----Parent PID=%d  self PID=%d\n",getppid(),getpid());
		printf("child killall\n");
       exit(0);
    }

/*  The parent process arranges to catch SIGALRM with a call to signal
    and then waits for the inevitable.  */
	
   printf("waiting for alarm to go off\n");
	printf("~~~~Parent PID=%d  self PID=%d\n",getppid(),getpid());
	 (void) signal(SIGALRM, ding);
   // (void) signal(SIGKILL, ding);
		//让进程停止运行，直到信号出现
    	//pause();
		while(1) 
		{
				printf("~~~~Parent PID=%d  self PID=%d\n",getppid(),getpid());
				sleep(1);
		}
			
		
    if (alarm_fired)
        printf("Ding!\n");

    printf("done\n");
    exit(0);
}
//当父进程创建好子进程以后，它仍旧执行自己的代码。
//当子进程被创建以后，它就开始运行自身空间的代码。
//当子进程发送信号向父进程的时候，父进程停止当前运行的代码；
//接收外来信号的请求。[信号本质上就是中断]
