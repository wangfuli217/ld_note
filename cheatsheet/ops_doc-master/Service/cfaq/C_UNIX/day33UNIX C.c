关键字：signal()   kill()  raise()   sleep()  alarm()
	信号的处理

/*中断的概念和分类*/
	中断就是指停止当前程序的执行转而执行其他程序或者处理意外情况的过程；

中断分为两种：硬件中断 和软件中断；


/*信号的处理*/
基本概念：
	信号本质就是一种软件中断，它既可以作为两个进程间通信的一种方式，也可以中断一个程序的执行，它更多的被用于处理意外情况；

基本特性：
	1. 信号是异步的，进程并不知道信号何时会到达；(没有一个共同的时钟控制)
	2. 进程既可以处理信号，也可以发送信号；
	3. 每个信号都有一个名字，使用SIG开头；

基本命令和分类
	kill -l  表示显示当前系统所支持的所有信号

 1) SIGHUP        2) SIGINT        3) SIGQUIT       4) SIGILL        5) SIGTRAP
 6) SIGABRT       7) SIGBUS        8) SIGFPE        9) SIGKILL      10) SIGUSR1
11) SIGSEGV      12) SIGUSR2      13) SIGPIPE      14) SIGALRM      15) SIGTERM
16) SIGSTKFLT    17) SIGCHLD      18) SIGCONT      19) SIGSTOP      20) SIGTSTP
21) SIGTTIN      22) SIGTTOU      23) SIGURG       24) SIGXCPU      25) SIGXFSZ
26) SIGVTALRM    27) SIGPROF      28) SIGWINCH     29) SIGIO        30) SIGPWR
31) SIGSYS       34) SIGRTMIN     35) SIGRTMIN+1   36) SIGRTMIN+2   37) SIGRTMIN+3
38) SIGRTMIN+4   39) SIGRTMIN+5   40) SIGRTMIN+6   41) SIGRTMIN+7   42) SIGRTMIN+8
43) SIGRTMIN+9   44) SIGRTMIN+10  45) SIGRTMIN+11  46) SIGRTMIN+12  47) SIGRTMIN+13
48) SIGRTMIN+14  49) SIGRTMIN+15  50) SIGRTMAX-14  51) SIGRTMAX-13  52) SIGRTMAX-12
53) SIGRTMAX-11  54) SIGRTMAX-10  55) SIGRTMAX-9   56) SIGRTMAX-8   57) SIGRTMAX-7
58) SIGRTMAX-6   59) SIGRTMAX-5   60) SIGRTMAX-4   61) SIGRTMAX-3   62) SIGRTMAX-2
63) SIGRTMAX-1   64) SIGRTMAX

	在linux系统中支持的信号范围是1～64，不保证连续，
	其中1～31之间的信号叫做不可靠信号，不支持排队，信号可能会丢失，也叫做非实时信号；
	其中34~64之间的信号叫做可靠信号，支持排队，信号不会丢失，也叫做实时信号； 

要求掌握的信号：
	SIGINT  2  	采用ctrl+c来产生该信号，默认处理方式为终止进程
	SIGQUIT	3	采用ctrl+\来产生该信号，默认处理方式为终止进程
	SIGKILL	9	采用kill -9命令来产生，默认处理方式为终止进程

/*信号处理方式*/
1. 默认处理，绝大多数信号的默认处理方式都是终止进程；
2. 忽略处理
3. 自定义处理/捕获处理



signal()函数 		ANSI C signal handling	
       #include <signal.h>

       typedef void (*sighandler_t)(int);

       sighandler_t signal(int signum, sighandler_t handler);

函数原型解析：
	typedef void (*sighandler_t)(int);
     =>	typedef void (*)(int) sighandler_t;
 /*例如语句 typedef int *apple; 理解它的正确步骤是这样的：先别看typedef，就剩下int *apple; 这个语句再简单不过，就是声明了一个指向整型变量的指针apple (注意：定义只是一种特殊的声明)，加上typedef之后就解释成声明了一种指向整型变量指针的类型apple 。

现在，回过来看上面的这个函数原型 typedef void (*sighandler_t)(int)，盖住 typedef不看 ，再简单不过，sighandler_t就是一个函数指针，指向的函数接受一个整型参数并返回一个无类型指针 。加上typedef之后sighandler_t就是一种新的类型，就可以像int一样地去用它，不同的是它声明是一种函数指针，这种指针指向的函数接受一个整型参数并返回一个无类型指针*/ 

	sighandler_t signal(int signum, sighandler_t handler);

     => void (*)(int) signal(int signum,void (*)(int)handler);
     => void (*)(int) signal(int signum,void (*handler)(int));

     => void (*signal(int signum,void (*handler)(int)))(int);

signal是一个函数
	具有两个参数：一个参数是int类型，另外一个是函数指针类型
	返回值类型是函数指针类型
	第二个参数：是一个指向参数为int类型，返回值为void类型的函数的指针；

函数功能：
	第一个参数：信号值/信号名称（表示对哪个信号处理）
		    signal() sets the disposition of the signal signum to handler
	第二个参数：函数指针类型，用于指定处理方式（怎么样处理）
		SIG_IGN - 忽略处理
		SIG_DFL - 默认处理
		自定义函数的地址 - 自定义处理

       signal() sets the disposition of the signal signum to handler, which is
       either SIG_IGN, SIG_DFL, or the address of a  programmer-defined  func‐
       tion (a "signal handler").

	返回值：成功返回之前的处理方式，失败返回SIG_ERR;

	函数功能：
		用于设置指定信号的处理方式；

//使用signal函数设置信号的处理方式
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<signal.h>

void fa(int signo)
{
	printf("捕获到了信号%d\n",signo);
}

int main()
{
	printf("pid=%d\n",getpid());
	//设置对信号2进行忽略处理
	if(SIG_ERR==signal(/*2*/SIGINT,SIG_IGN))
	{
		perror("signal"),exit(-1);
	}
	printf("设置对信号2的忽略处理成功\n");
	//设置对信号3进行自定义处理
	if(SIG_ERR==signal(/*3*/SIGQUIT,fa))
	{
		perror("signal"),exit(-1);
	}
	printf("设置对信号3的自定义处理成功\n");
	while(1);
	return 0;
}


练习：
	使用signal函数设置对信号2进行自定义处理，设置对信号3进行忽略处理，
	再使用fork函数创建子进程，打印子进程的进程号后，子进程进入无限循环，父进程直接结束，
	另起一个终端使用kill命令发送信号2 3 9给子进程，观察处理结果

#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<signal.h>

void fa(int signo)
{
	printf("捕获%d头猪\n",signo);
}

int main()
{
	if(SIG_ERR==signal(SIGINT,fa))
	{
		perror("signal"),exit(-1);
	}
	printf("对信号2进行自定义处理\n");

	if(SIG_ERR==signal(SIGQUIT,SIG_IGN))
	{
		perror("signal"),exit(-1);
	}
	printf("对信号3进行忽略处理\n");
	pid_t pid=fork();
	if(-1==pid)
	{
		perror("fork"),exit(-1);
	}
	if(pid==0)
	{
		printf("子进程进程号：%d\n",getpid());
		while(1);
	}
	return 0;
}

结果：	对信号2进行自定义处理
	对信号3进行忽略处理
	[tarena@~/UNIX]$子进程进程号：8876
	捕获2头猪


/*父子进程对信号的处理方式*/
	1. 对于fork函数创建的子进程来说，子进程完全照搬父进程中对信号的处理方式，
		也就是父进程默认，子进程也默认；父进程忽略，子进程也忽略；父进程自定义处理，子进程也自定义处理；
	2. 对于vfork()和execl()函数启动的子进程来说，父进程默认，子进程也默认；父进程忽略，子进程也忽略；
		/*父进程自定义，子进程采用默认*/；(自定义函数不受控，没有改变函数内的信号值，所以是默认)



/*发送信号的方式*/
1. 采用键盘发送信号（只能发送部分特殊的信号）
	使用ctrl+c发送信号SIGINT 2
	... ...

2. 程序出错发送信号（只能发送部分特殊的信号）
	段错误 引起 信号SIGSEGV 11
	... ...

3. 使用kill命令发送信号（全部信号都可以发）
	kill -信号值 进程号
	kill -9	3305

4. 采用系统函数发送信号（发送大部分信号）
	kill()/raise()/alarm()/sigqueue()

/*发送信号的函数解析*/
1. kill()函数		send signal to a process
       	#include <sys/types.h>
       	#include <signal.h>

       	int kill(pid_t pid, int sig);

第一个参数：进程号（给谁发信号）
	>0 表示发送信号sig给进程号为pid的进程（单发，重点）
	If pid is positive, then signal sig is sent to the process with the ID specified by pid.

	=0 表示发送信号sig给当前正在调用进程的同一进程组里的每一个进程（群发，了解）
	If pid equals 0, then sig is sent to every process in the process group of the calling process.
	
	-1 表示发送信号sig给每一个当前进程拥有发送信号权限的进程，除了进程1(init)（群发，了解）
	If pid equals -1, then sig is sent to  every  process  for  which  the
        calling  process  has permission to send signals, except for process 1
        (init), but see below.
	
       <-1 表示发送信号sig给进程组ID为-pid的每一个进程（群发，了解）
	If pid is less than -1, then sig is  sent  to  every  process  in  the
        process group whose ID is -pid.
	
第二个参数：信号值/信号名称（发送什么样的信号）
	0 表示不会发送信号，只是检查指定的进程是否存在

函数功能：
	用于给指定的进程发送指定的信号；


//使用kill函数发送信号
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<signal.h>

void fa(int signo)
{
	printf("捕获到了信号%d\n",signo);
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
		signal(40,fa);
		while(1);
	}
	sleep(1);  //给子进程反映时间
	//3.父进程使用kill函数发送信号40给子进程
	if(0==kill(pid,0))
	{
		printf("父进程开始发送信号40\n");
		kill(pid,40);
	}
	return 0;
}


结果：	子进程13446开始启动
	父进程开始发送信号40
	[tarena@~]$捕获到了信号40


2. raise()函数		send a signal to the caller  //给调用者发生一个信号
       	#include <signal.h>

       	int raise(int sig);

函数功能：
	用于给当前正在调用的进程/线程发送参数指定的信号，对于单线程的程序来说，等价于kill(getpid(),sig);
	成功调用时返回0，失败返回非0；

//使用raise函数发送信号
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<signal.h>

void fa(int signo)
{
    printf("捕获到了信号%d\n",signo);
}

int main()
{
    //1.设置对信号2进行自定义处理
    signal(2,fa);
    //2.使用raise函数发送信号2
    sleep(10);
    int res=raise(2);
    if(0!=res)
    {   
        perror("raise"),exit(-1);
    }   
    return 0;
}

结果：捕获到了信号2


3. sleep()函数		Sleep for the specified number of seconds  //使进程进入seconds时间睡眠
       	#include <unistd.h>

       	unsigned int sleep(unsigned int seconds);

函数功能：
	用于使得当前正在调用的进程进入睡眠状态，当指定的秒数睡够了则返回0，
		当指定的秒数没有睡够但一个不能忽略的信号到来了，则返回剩余没有来得及睡的秒数；
	
	Zero if the requested time has elapsed, or the number of seconds  left
        to sleep, if the call was interrupted by a signal handler.


4. alarm()函数 		set an alarm clock for delivery of a signal //设置seconds时间的闹钟
       	#include <unistd.h>

       	unsigned int alarm(unsigned int seconds);

       alarm() arranges for a SIGALRM signal to be delivered to the calling
       process in seconds seconds.

       If seconds is zero, no new alarm() is scheduled.

       In any event any previously set alarm() is canceled.

函数功能：
	用于经过参数指定的秒数后给当前正在调用的进程发送SIGALRM信号，如果参数为0，则表示没有新的闹钟被设置，每次设置闹钟时都会取消之前的闹钟；
	如果之前有闹钟则返回/*之前*/闹钟没有来得及响的剩余秒数，否则返回0；

//使用alarm函数发送信号
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<signal.h>

void fa(int signo)
{
    printf("捕获到了信号%d\n",signo);
}

int main()
{
    //设置对信号SIGALRM进行自定义处理
    signal(SIGALRM,fa);
    //设置5秒后响的闹钟
    int res=alarm(5);
    printf("res=%d\n",res); //0 

    sleep(2);
    //设置10秒后响的闹钟
    res=alarm(10);
    printf("res=%d\n",res);//3

    //设置0秒后的闹钟 取消闹钟
    res=alarm(0);
    printf("res=%d\n",res);//10

    while(1);
    return 0;
}


结果：	res=0
	res=3
	res=10


4. sigqueue()函数


作业：
	查询sigaction函数


