关键字： sigprocmask()  sigpending()
	sigaction()  sigqueue()
	setitimer()
	信号的处理
	进程间的通信技术

/*信号集*/
基本概念
	由若干个信号组成的集合；

如何采用最节省内存的方式来设计信号集的数据类型？
	采用每一个二进制位代表一个信号 => 64个二进制 = 8个字节 (1个字节8位) 
	.... .... 0010 0111 => 信号 1，2，3，6

结论：
	操作系统中提供的信号集类型是：/*sigset_t*/ 类型，
		底层是一个超级大的整数，采用每一个二进制位来代表该信号是否存在，其中0表示该信号不存在，1表示信号存在；

typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int)))];
  } __sigset_t;

typedef __sigset_t sigset_t;


基本操作
	sigemptyset() 	- 	清空信号集	
	sigfillset() 	- 	填满信号集
	sigaddset() 	- 	增加信号到信号集中
	sigdelset() 	- 	删除信号集中指定的信号
	sigismember() 	- 	判断信号是否存在信号集中

       #include <signal.h>

       ;

RETURN VALUE
       sigemptyset(), sigfillset(), sigaddset(), and sigdelset() return  0  on
       success and -1 on error.

       sigismember()  returns  1  if signum is a member of set, 0 if signum is
       not a member, and -1 on error.


//信号集的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<signal.h>

int main()
{
	sigset_t set;
	printf("sizeof(sigset_t)=%d\n",sizeof(sigset_t));
	printf("set=%d\n",set);

	//清空信号集
	if(-1==sigemptyset(&set))
	{
		perror("sigemptyset"),exit(-1);
	}
	printf("set=%d\n",set);   //0
	//增加信号2到信号集中，打印
	if(-1==sigaddset(&set,2))
	{
		perror("sigaddset"),exit(-1);
	}
	printf("set=%d\n",set);   //2
	//增加信号3到信号集中，打印
	sigaddset(&set,3);
	printf("set=%d\n",set);  //2+4
	//增加信号7到信号集中，打印
	sigaddset(&set,7);
	printf("set=%d\n",set);   //2+4+64

	//删除信号3，打印
	sigdelset(&set,3);
	printf("set=%d\n",set);   //2+64

	//判断信号2是否存在
	if(1==sigismember(&set,2))
	{
		printf("信号2存在\n");
	}
	printf("set=%d\n",set);   //2+64
	//判断信号3是否存在
	if(1==sigismember(&set,3))
	{
		printf("信号3存在\n");
	}
	printf("set=%d\n",set);   //2+64
	
	//填满信号集，打印
	sigfillset(&set);
	printf("set=%d\n",set);   
	return 0;
}

结果：	sizeof(sigset_t)=128
	set=-1076174994
	set=0
	set=2
	set=6
	set=70
	set=66
	信号2存在
	set=66
	set=66
	set=2147483647   	2^31


/*信号的屏蔽*/
	在某些特殊程序的执行过程中，是不能被信号打断的，此时需要使用信号的屏蔽技术来解决该问题；

1. sigprocmask()函数		examine and change blocked signals
       #include <signal.h>

       int sigprocmask(int how, const sigset_t *set, sigset_t *oldset);
第一个参数：具体的屏蔽方式（怎么屏蔽）
	SIG_BLOCK - 表示进程中已经屏蔽的信号集 + 参数set的信号集
			（ABC + CDE => ABCDE）
	SIG_UNBLOCK - 表示进程中已经屏蔽的信号集 - 参数set信号集
			（ABC - CDE => AB）
	SIG_SETMASK - 表示进程中已经屏蔽的信号集被参数set信号集替代
			（ABC   CDE => CDE）
第二个参数：信号集类型的指针，用于传递新的信号集
第三个参数：信号集类型的指针
	如果该参数不为空，则带出设置之前进程已经屏蔽的信号集；
	如果该参数为空，则啥也不会带出；

函数功能：
	用于提取/修改当前进程中的信号屏蔽集合；

注意：
	信号屏蔽并不是信号的删除，只是相当于用一个隔板将所有屏蔽的信号阻挡起来，
	对于可靠信号来说（34-64），发送多少次则排队等待的就是多少个信号，
	而对于不可靠信号来说（1-31），无论发送多少次，排队的信号只有1个，
		当信号屏蔽被解除，相当于将阻挡的隔板移开，因此所有阻挡的信号都会被依次处理；


//使用sigprocmask函数设置信号屏蔽
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<signal.h>
#include<sys/types.h>

void fa(int signo)
{
 	printf("捕获到了信号%d\n",signo);
}

int main()
{
	printf("pid=%d\n",getpid());
	//1.设置对信号2，3，50进行自定义处理
	signal(2,fa);
	signal(3,fa);
	signal(50,fa);
	//2.睡眠20秒 观察效果
	int res = sleep(20);
	if(0==res)
	{
		printf("美美睡一觉\n");
	}
	else
	{
		printf("没有信号屏蔽，睡眠被打断，睡里%d秒\n",20-res);
	}
	//3.使用sigprocmask设置屏蔽信号 2 3 50
	printf("开始进行信号的屏蔽...\n");
	//准备信号集类型的变量 作为sigprocmask的实参
	sigset_t set,old;
	sigemptyset(&set);
	sigemptyset(&old);
	//添加信号2 3 50 到信号集set中
	sigaddset(&set,2);
	sigaddset(&set,3);
	sigaddset(&set,50);
	//设置信号的屏蔽
	res=sigprocmask(SIG_SETMASK,&set,&old);
	if(-1==res)
	{
		perror("sigprocmask"),exit(-1);
	}
	printf("设置信号的屏蔽成功，old=%d\n",old);
	//4.睡眠30秒 观察效果
	res=sleep(30);
	if(0==res)
	{
		printf("信号屏蔽了\n");
	}
	else
	{
		printf("一般不会执行到\n");//没有屏蔽的信号到来 就会执行这句话
	}
	//5.恢复系统中默认的屏蔽
	sigprocmask(SIG_SETMASK,&old,NULL);
	return 0;
}

pid=3436
捕获到了信号3
没有信号屏蔽，睡眠被打断，睡里16秒
开始进行信号的屏蔽...
设置信号的屏蔽成功，old=0
信号屏蔽了
捕获到了信号50
捕获到了信号50
捕获到了信号50
捕获到了信号50
捕获到了信号50
捕获到了信号3
捕获到了信号2 	//会按到从大到小的顺序(数字大小)  即使先发信号2 也是先捕获到信号3 (好像不时因为数字大小的原因(待定))
		//先发信号2 也是会先捕获大的信号 后输出小的信号



2. sigpending()函数		examine pending signals
       #include <signal.h>

       int sigpending(sigset_t *set);

函数功能：
	获取信号屏蔽期间来过但没有来得及处理的信号，将所有获取到的信号存放在参数指定的信号集set中，通过参数带出去；

////使用sigpending函数设置信号屏蔽
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<signal.h>
#include<sys/types.h>

void fa(int signo)
{
 	//printf("捕获到了信号%d\n",signo);
}

int main()
{
	printf("pid=%d\n",getpid());
	//1.设置对信号2，3，50进行自定义处理
	signal(2,fa);
	signal(3,fa);
	signal(50,fa);
	//2.睡眠20秒 观察效果
	int res = sleep(20);
	if(0==res)
	{
		printf("美美睡一觉\n");
	}
	else
	{
		printf("没有信号屏蔽，睡眠被打断，睡里%d秒\n",20-res);
	}
	//3.使用sigprocmask设置屏蔽信号 2 3 50
	printf("开始进行信号的屏蔽...\n");
	//准备信号集类型的变量 作为sigprocmask的实参
	sigset_t set,old;
	sigemptyset(&set);
	sigemptyset(&old);
	//添加信号2 3 50 到信号集set中
	sigaddset(&set,2);
	sigaddset(&set,3);
	sigaddset(&set,50);
	//设置信号的屏蔽
	res=sigprocmask(SIG_SETMASK,&set,&old);
	if(-1==res)
	{
		perror("sigprocmask"),exit(-1);
	}
	printf("设置信号的屏蔽成功，old=%d\n",old);
	//4.睡眠30秒 观察效果
	res=sleep(30);
	if(0==res)
	{
		printf("信号屏蔽了\n");
	}
	else
	{
		printf("一般不会执行到\n");//没有屏蔽的信号到来 就会执行这句话
	}
	//准备信号集类型的变量并初始化
	sigset_t pend;
	sigemptyset(&pend);
	//获取信号屏蔽期间来过的信号
	res=sigpending(&pend);
	if(-1==res)
	{
		perror("sigpending"),exit(-1);
	}
	//判断是否信号2来过
	if(1==sigismember(&pend,2))
	{
		printf("信号2来过\n");
	}
	if(1==sigismember(&pend,3))
	{
		printf("信号3来过\n");
	}
	if(1==sigismember(&pend,50))
	{
		printf("信号50来过\n");
	}
	//5.恢复系统中默认的屏蔽
	sigprocmask(SIG_SETMASK,&old,NULL);
	return 0;
}

pid=3622
没有信号屏蔽，睡眠被打断，睡里15秒
开始进行信号的屏蔽...
设置信号的屏蔽成功，old=0
信号屏蔽了
信号2来过
信号3来过


/* 其他信号相关函数 */
1. sigaction()函数 => signal函数的增强版 		examine and change a signal action
       #include <signal.h>

       	int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact);

第一个参数：信号值/信号名称（设置哪个信号的处理方式）
	可以指定任何有效的信号，但是不能指定SIGKILL和SIGSTOP

第二个参数：结构体指针，用于指定信号的最新处理方式

           struct sigaction {
               void     (*sa_handler)(int);
		//函数指针类型，用于设置信号的处理方式，取值可以是：SIG_DFL  SIG_IGN  自定义函数地址
		//与signal函数的第二个参数取值一样，类型一样


               void     (*sa_sigaction)(int, siginfo_t *, void *);
		//函数指针类型，用于设置信号的处理方式，取值可以是：SIG_DFL  SIG_IGN  自定义函数地址
		//是否选用该成员设置信号的处理方式，取决于第四个成员


               sigset_t   sa_mask;
		//主要用于设置在执行信号处理函数期间需要屏蔽的信号集
		//自动屏蔽与/*触发信号处理函数相同的信号*/


               int        sa_flags;
		//SA_SIGINFO  表示选择第二个函数指针作为信号的处理函数
		//SA_NODEFER  表示解除对/*触发信号*/处理函数信号的屏蔽 （不延时，不屏蔽进行处理）
		//SA_RESETHAND  表示一旦调用信号处理函数之后则恢复默认处理方式（RE_SET_HAND）
			      //表示一旦自定义处理一次之后恢复默认处理


               void     (*sa_restorer)(void); 
		//过时（现保留）的成员，暂时不被使用
           };

第三个参数：结构体指针，用于带出设置之前的信号处理方式

函数功能：
	用于检查和修改指定信号的处理方式；


       The siginfo_t argument to sa_sigaction is a struct with  the  following elements:

         siginfo_t {
               int      si_signo;    /* Signal number */
               int      si_errno;    /* An errno value */
               int      si_code;     /* Signal code */
               int      si_trapno;   /* Trap number that caused
                                        hardware-generated signal
                                        (unused on most architectures) */

               pid_t    si_pid;      /* Sending process ID */		//发送信号的进程号

               uid_t    si_uid;      /* Real user ID of sending process */
               int      si_status;   /* Exit value or signal */
               clock_t  si_utime;    /* User time consumed */
               clock_t  si_stime;    /* System time consumed */

               sigval_t si_value;    /* Signal value */			//伴随信号到来的附加数据

               int      si_int;      /* POSIX.1b signal */
               void    *si_ptr;      /* POSIX.1b signal */
               int      si_overrun;  /* Timer overrun count; POSIX.1b timers */
               int      si_timerid;  /* Timer ID; POSIX.1b timers */
               void    *si_addr;     /* Memory location which caused fault */
               long     si_band;     /* Band event (was int in
                                        glibc 2.3.2 and earlier) */
               int      si_fd;       /* File descriptor */
               short    si_addr_lsb; /* Least significant bit of address
                                        (since kernel 2.6.32) */
           }



//使用sigaction函数设置对信号的处理方式
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<signal.h>
#include<sys/types.h>


void fa(int signo)
{
	printf("正在处理信号%d,请稍候...\n",signo);
	sleep(10);
	printf("处理信号完毕\n");
}
int main()
{
	printf("pid=%d\n",getpid());
	//准备结构体变量并进行初始化
	struct sigaction action={};
	action.sa_handler=fa;
	//清空信号集
	sigemptyset(&action.sa_mask);
	//添加信号3到信号集中
	sigaddset(&action.sa_mask,3);

	//解除对触发信号处理函数信号的屏蔽
	action.sa_flags=SA_NODEFER;	//再发信号2会重新处理

	//一旦自定义处理一次之后恢复默认处理
	//自动屏蔽与触发信号处理函数相同的信号
	//action.sa_flags=SA_RESETHAND;

	//设置对信号2进行自定义处理
	int res=sigaction(2,&action,NULL);
	if(-1==res)
	{
		perror("sigaction"),exit(-1);
	}
	printf("设置信号的处理方式成功\n");
	while(1);
	return 0;
}


////sigaction   使用void (*sa_sigaction)(int, siginfo_t *, void *);自定义处理函数
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<signal.h>

void fa(int signo,siginfo_t *info,void *pv)
{
	printf("进程%d发送来了信号%d\n",info->si_pid,signo);
}

int main()
{
	printf("pid=%d\n",getpid());
	//准备结构体变量并初始化
	struct sigaction action={};
	//使用第二个函数指针来设置信号的处理方式
	action.sa_sigaction=fa;
	action.sa_flags=SA_SIGINFO;
	//设置对信号2的自定义处理
	int res=sigaction(2,&action,NULL);
	if(-1==res)
	{
		perror("sigaction"),exit(-1);
	}
	printf("设置信号2完成\n");
	while(1);
	return 0;
}

2. sigqueue()函数		queue a signal and data to a process
       #include <signal.h>

       int sigqueue(pid_t pid, int sig, const union sigval value);

第一个参数：进程的编号（给谁发信号）
第二个参数：具体的信号值/信号名称（发送什么样的信号）
第三个参数：伴随信号的附加数据

           union sigval {
               int   sival_int;
               void *sival_ptr;
           };


函数功能：
	用于向指定的进程发送指定的信号和附加数据；


////使用sigqueue函数发送信号和附加数据
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<signal.h>

void fa(int signo,siginfo_t *info,void *pv)
{
	printf("进程%d发来的信号是%d，发送的附加数据是：%d\n",info->si_pid,signo,info->si_value);
}

int main()
{
	//1.创建子进程，使用fork函数
	pid_t pid=fork();
	if(-1==pid)
	{
		perror("fork"),exit(-1);
	}
	//2.子进程启动，设置对信号40进行自定义处理
	if(0==pid)
	{
		printf("子进程%d开始启动\n",getpid());
		//准备结构体变量并初始化
		struct sigaction action={};
		action.sa_sigaction=fa;
		action.sa_flags=SA_SIGINFO;
		//设置对信号40进程自定义处理
		sigaction(40,&action,NULL);
		while(1);
	}
	//3.父进程启动，使用sigqueue函数发送信号40和1～100之间整数给子进程
	sleep(1);
	printf("父进程%d开始启动\n",getpid());
	int i=0;
	for(i=1;i<=100;i++)
	{
		//定义联合变量并初始化
		union sigval val;
		val.sival_int =i;
		int res=sigqueue(pid,40,val);
		if(-1==res)
		{
			perror("sigqueue"),exit(-1);
		}
		sleep(1);
	}
	return 0;
}

结果：	子进程5624开始启动
	父进程5623开始启动
	进程5623发来的信号是40，发送的附加数据是：1
	进程5623发来的信号是40，发送的附加数据是：2
	进程5623发来的信号是40，发送的附加数据是：3
	进程5623发来的信号是40，发送的附加数据是：4
	进程5623发来的信号是40，发送的附加数据是：5
	进程5623发来的信号是40，发送的附加数据是：6
	.... ....




/*计时器*/
	在linux系统中，为每个进程都维护三种计时器，分别为：真实计时器，虚拟计时器，以及实用计时器，一般采用真实计时器进行计时；

setitimer()函数/getitimer()函数			get or set value of an interval timer
       #include <sys/time.h>

       int getitimer(int which, struct itimerval *curr_value);
       int setitimer(int which, const struct itimerval *new_value,
                     struct itimerval *old_value);

第一个参数：计时器的类型（选用哪一种计时器）
	ITIMER_REAL - 真实计时器，统计进程执行的真实时间
		       - 该计时器通过产生SIGALRM信号进行工作的；
	ITIMER_VIRTUAL - 虚拟计时器，统计进程在用户态消耗的时间
		       - 该计时器通过产生SIGVTALRM信号进行工作的；
	ITIMER_PROF - 实用计时器，统计进程在用户态和内核态下共同消耗的时间
		    - 该计时器通过产生SIGPROF信号进行工作；

第二个参数：结构体指针，用于设置计时器的新值

           struct itimerval {
               struct timeval it_interval; /* next value */ //间隔时间
               struct timeval it_value;    /* current value */ //启动/开始时间
           };

           struct timeval {
               long tv_sec;                /* seconds */  	//秒
               long tv_usec;               /* microseconds */	//微秒 1秒10^6微秒
           };

第三个参数：结构体指针，用于带出计时器之前的旧值

函数功能：
	用于获取/设置计时器的参数信息；


//计时器的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/time.h>
#include<signal.h>


void fa(int signo)
{
	printf("捕获到了信号%d\n",signo);
}

int main()
{果有我就循环调用getchar()清空缓冲区数据。
               // int c;
	//1.设置对信号SIGALRM进行自定义处理
	signal(SIGALRM,fa);
	//准备结构体变量 初始化
	struct itimerval timer;
	//设置间隔时间
	timer.it_interval.tv_sec=1;
	timer.it_interval.tv_usec=300000;
	//设置启动时间
	timer.it_value.tv_sec=5;
	timer.it_value.tv_usec=0;
	//2.使用setitimer启动计时器
	int res=setitimer(ITIMER_REAL,&timer,NULL);
	if(-1==res)
	{
		perror("setitimer"),exit(-1);
	}
	printf("设置计时器成功\n");
	
	getchar(); //清空缓冲区数据（可能会输入的数据）
	//3.关闭计时器
	timer.it_value.tv_sec=0;
	res=setitimer(ITIMER_REAL,&timer,NULL);
	if(-1==res)
	{
		perror("setitimer"),exit(-1);
	}
	printf("关闭计时器\n");

//	while(1);
	return 0;
}





/*进程间的通信技术*/
基本概念
	两个进程之间的信息交互

常用的进程间通信技术
1. 文件
2. 信号
3. 管道（了解）
4. 共享内存
5. 消息队列（重点）
6. 信号量集
7. 网络（重点）
... ...
其中 4 5 6 三种通信方式统称为 XSI IPC通信方式
（X/open System Interface Inter-Process Communication）


作业：使用计时器技术让控制台版的贪吃蛇动起来

