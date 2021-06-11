/*  In alarm.c, the first function, ding, simulates an alarm clock.  */

/* Linuix ����ϵͳ���źŻ���
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
};��ͬ���ź��в�ͬ�ĺ���
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
//ͨ���ź���ģ���ж�����
int main(void)
{
    int pid;

    printf("alarm application starting\n");
	/* �������0����ʾ�����ӽ��̳ɹ���
	�������0����ʾ���ڽ����Ǹ����̣�
	���С��0����ʾ�����ӽ���ʧ�ܡ�*/
    if((pid = fork()) == 0)
	{
       sleep(10);
		/*ɱ�������̣�Ȼ���ӽ��̽����Լ�*/
		/*�ӽ��̼ȿ��Ը������̷���������Ϣ
		Ҳ����ɱ�������̣�
		�ػ����̾����ø�������������Ȼ���ӽ��̱��"�¶�"
		����*/
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
		//�ý���ֹͣ���У�ֱ���źų���
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
//�������̴������ӽ����Ժ����Ծ�ִ���Լ��Ĵ��롣
//���ӽ��̱������Ժ����Ϳ�ʼ��������ռ�Ĵ��롣
//���ӽ��̷����ź��򸸽��̵�ʱ�򣬸�����ֹͣ��ǰ���еĴ��룻
//���������źŵ�����[�źű����Ͼ����ж�]
