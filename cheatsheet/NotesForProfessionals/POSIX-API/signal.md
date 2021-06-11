---
title: 信号
---


# 信号来源

信号事件的发生有两个来源：硬件来源(比如我们按下了键盘或者其它硬件故障)；软件来源，最常用发送信号的系统函数是kill, raise, alarm和setitimer以及sigqueue函数，软件来源还包括一些非法运算等操作。

# 可靠信号和不可靠信号

## 不可靠信号

信号值小于SIGRTMIN的信号为不可靠信号

> - **每次进入信号处理函数，系统就将对信号的响应设置为默认动作**。如果不希望这样的操作，那么就要在信号处理函数结尾再一次调用，重新安装该信号，现在的singal函数都是由sigaction函数实现，不会自动将信号响应设置为默认动作，除非手动指定。
> - 信号可能丢失，即多次发生同一信号，只有一个信号会进入信号队列。
> - 信号是否可靠只跟信号的编号相关，小于SIGRTMIN的信号，对于多个相同信号，系统只会把一个信号放入信号队列。

## 可靠信号

信号值位于SIGRTMIN和SIGRTMAX之间的信号都是可靠信号。信号的可靠与不可靠只与信号值有关，与信号的发送及安装函数无关。可靠信号支持排队，不会丢失。

## tips

1. signal()及sigaction()来说，它们都不能把SIGRTMIN以前的信号变成可靠信号（都不支持排队，仍有可能丢失，仍然是不可靠信
号，而且对SIGRTMIN以后的信号都支持排队。

2. signal安装的信号不能向信号处理函数传递信息，sigaction函数可以。

3. signal不能在不改变信号处理方式的前提下获取当前的信号处理方式，sigaction可以。

4. 若信号A中断了信号B处理函数，并在这个A信号处理函数调用了longjmp或者siglongjmp，将导致B信号处理函数提前终止，不会再执行剩余部分。

5. 信号被阻塞，但是依然在队列中，解除阻塞后将传递

6. fork时子进程继承父进程的信号处理函数，但是exec后失效

7. SIGSTOP、SIGKILL不能被捕捉，SIGABORT即使被忽略也会递送到进程。

8. 忽略信号就是信号递给进程，但是进程直接忽略，阻塞信号在解除阻塞后，再递送。

9. 当对一个信号产生4种停止信号(SIGTSTP、SIGSTOP、SIGTTIN、SIGTTOU)中任意一种信号，该进程任意未决SIGCONT信号被丢失

10.  SIGCONT 如果进程已经停止，让进程继续运行，否则忽略这个信号，这个信号被阻塞或者忽略也会让停止进程继续

<!--more-->

# 进程对信号的响应

进程可以通过三种方式来响应一个信号：

1. 忽略信号，即对信号不做任何处理，其中，有两个信号不能忽略：**SIGKILL及SIGSTOP**；

2. 捕捉信号。定义信号处理函数，当信号发生时，执行相应的处理函数；

3. 执行缺省操作，Linux对每种信号都规定了默认操作。注意，进程对实时信号的缺省反应是进程终止。


# 信号发送函数

发送信号的主要函数有：kill()、raise()、 sigqueue()、alarm()、setitimer()以及abort()。

## kill

    #include <sys/types.h>
    #include <signal.h>
    int kill(pid_t pid,int signo)

>pid > 0	进程ID为pid的进程，需要相应权限
>
>pid == 0	同一个进程组的进程，不包括系统进程(内核进程和init)
>
>pid < 0 pid != -1	进程组ID为 -pid的所有进程
>
>pid == -1	除发送进程自身外，发送给所有有发送权限的进程
>
>signo == 0 只执行错误检查，但不发送信号，常用来判断进程是否存在，对于不存在的进程kill返回-1，errno置为ESRCH，这种测试不是原子的

kill只有是超级用户或者发送者实际用户ID或有效用户ID必须等于接收者实际用户ID或有效用户ID，才能向目标进程发送信号，对于支持_POSIX_SAVED_IDS检查保存设置用户ID，而不是检查有效用户ID。SIGCONT可以发送给属于同一会话的任意其它进程，没有上面的权限要求。

## raise

    #include <signal.h>
    int raise(int signo)

向进程本身发送信号，参数为即将发送的信号值。调用成功返回 0；否则，返回 -1。

## sigqueue

    typedef union sigval {
    	int  sival_int;
    	void *sival_ptr;
    }sigval_t;

    #include <sys/types.h>
    #include <signal.h>
    int sigqueue(pid_t pid, int sig, const union sigval val);
    int rt_sigqueueinfo(pid_t tgid, int sig, siginfo_t *uinfo);
    int rt_tgsigqueueinfo(pid_t tgid, pid_t tid, int sig, siginfo_t *uinfo);

如果signo=0，将会执行错误检查，但实际上不发送任何信号，0值信号可用于检查pid的有效性以及当前进程是否有权限向目标进程发送信号。
当队列中排队信号数目大于SIGQUEUE_MAX时，sigqueue将失败，errno置为EAGAIN，sigqueue可以船体，使用排队信号需要sigaction函数指定SA_SIGINFO标志。一般使用sigaction结构中的sa_sigaction指定的信号处理函数，而不是sa_handler字段指定的信号处理函数。val可以向信号处理函数传递参数

## alarm

    #include <unistd.h>
    unsigned int alarm(unsigned int seconds)

专门为SIGALRM信号而设，在指定的时间seconds秒后，将向进程本身发送SIGALRM信号。进程调用alarm后，任何以前的alarm()调用都将无效。如果参数seconds为零，那么进程内将不再包含任何闹钟时间。不捕捉SIGALRM将导致进程终止。

## pause

    #include <unistd.h>
    int pause(void);

pause将进程挂起直到收到一个信号，要在信号处理函数返回后，pause才返回。

## setitimer

    struct timeval {
    	long tv_sec;                /* seconds */
    	long tv_usec;               /* microseconds */
    };

    struct itimerval {
    	struct timeval it_interval; /* 计时器重启动的间歇值 */
    	struct timeval it_value;    /* 计时器安装后首先启动的初始值 */
    };

    #include <sys/time.h>
    int setitimer(int which, const struct itimerval *value, struct itimerval *ovalue));

tv_sec提供秒级精度，tv_usec提供微秒级精度，以值大的为先，注意1s = 1000000us。setitimer()比alarm功能强大，支持3种类型的定时器：

* ITIMER_REAL：	设定绝对时间；经过指定的时间后，内核将发送SIGALRM信号给本进程；
* ITIMER_VIRTUAL 设定程序执行时间；经过指定的时间后，内核将发送SIGVTALRM信号给本进程；
* ITIMER_PROF 设定进程执行以及内核因本进程而消耗的时间和，经过指定的时间后，内核将发送ITIMER_VIRTUAL信号给本进程

## abort

    #include <stdlib.h>
    void abort(void);

向进程发送SIGABORT信号，默认情况下进程会异常退出，可定义自己的信号处理函数。即使SIGABORT被进程设置为阻塞信号，调用abort()后，SIGABORT仍然能被进程接收，从该信号处理函数返回后进程将退出。SIGABORT信号处理函数调用exit、_exit、_Exit、longjmp、siglongjmp可以不正常退出。让进程捕捉SIGABRT的意图是进程终止前由信号处理函数执行所需清理函数。调用abort会冲刷流。

    #include <signal.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <unistd.h>

    void abort(void)			/* POSIX-style abort() function */
    {
    	sigset_t			mask;
    	struct sigaction	action;

    	/* Caller can't ignore SIGABRT, if so reset to default */
    	sigaction(SIGABRT, NULL, &action);
    	if (action.sa_handler == SIG_IGN) {
    		action.sa_handler = SIG_DFL;
    		sigaction(SIGABRT, &action, NULL);
    	}
    	if (action.sa_handler == SIG_DFL)
    		fflush(NULL);			/* flush all open stdio streams */

    								/* Caller can't block SIGABRT; make sure it's unblocked */
    	sigfillset(&mask);
    	sigdelset(&mask, SIGABRT);	/* mask has only SIGABRT turned off */
    	sigprocmask(SIG_SETMASK, &mask, NULL);
    	kill(getpid(), SIGABRT);	/* send the signal */

    								/* If we're here, process caught SIGABRT and returned */
    	fflush(NULL);				/* flush all open stdio streams */
    	action.sa_handler = SIG_DFL;
    	sigaction(SIGABRT, &action, NULL);	/* reset to default */
    	sigprocmask(SIG_SETMASK, &mask, NULL);	/* just in case ... */
    	kill(getpid(), SIGABRT);				/* and one more time */
    	exit(1);	/* this should never be executed ... */
    }

# 信号安装函数

## signal

    #include <signal.h>
    void (*signal(int signum, void (*handler))(int)))(int);

如果signal()调用成功，返回最后一次为安装信号signum而调用signal()时的handler值；失败则返回SIG_ERR。fork后子进程继承父进程的信号处理函数，exec后失效。

## sigaction

    union sigval {
    	int sival_int;
    	void *sival_ptr;
    };

    struct siginfo_t {
    	int      si_signo;  /* 信号值，对所有信号有意义*/
    	int      si_errno;  /* errno值，对所有信号有意义*/
    	int      si_code;   /* 信号产生的原因，对所有信号有意义*/
    	pid_t    si_pid;    /* 发送信号的进程ID,对kill(2),实时信号以及SIGCHLD有意义 */
    	uid_t    si_uid;    /* 发送信号进程的真实用户ID，对kill(2),实时信号以及SIGCHLD有意义 */
    	int      si_status; /* 退出状态，对SIGCHLD有意义*/
    	clock_t  si_utime;  /* 用户消耗的时间，对SIGCHLD有意义 */
    	clock_t  si_stime;  /* 内核消耗的时间，对SIGCHLD有意义 */
    	sigval_t si_value;  /* 信号值，对所有实时有意义，是一个联合数据结构，
    						/*可以为一个整数（由si_int标示，也可以为一个指针，由si_ptr标示）*/
    	void *   si_addr;   /* 触发fault的内存地址，对SIGILL,SIGFPE,SIGSEGV,SIGBUS 信号有意义*/
    	int      si_band;   /* 对SIGPOLL信号有意义 */
    	int      si_fd;     /* 对SIGkPOLL信号有意义 */
    };



若传递的信号是SIGCHLD，将设置si_pid, si_status, si_uid字段，若是SIGBUS、SIGILL、SIGFPE、SIGSEGV，则si_addr包含造成故障的根地址源地址，该地址并不准确，si_errno字段包含错误编号。

    struct sigaction {
        void (*sa_handler)(int)；
        sigset_t sa_mask；//在进入信号处理函数前，将该sa_mask加入到进程信号屏蔽字中，包括正在被递送的信号，从
                          //信号处理函数返回时，恢复原先值
        int  sa_flags；
        void (*sa_sigaction)(int signo, siginfo_t *, void *context)；
    };

    #include <signal.h>
    int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact));
    sa_flags:信号处理选项
    SA_INTERUPT           由此信号中断的系统调用不自动重启
    SA_NOCLDSTOP          如果此信号是SIGCHLD，子进程停止（作业控制），不产生此信号，但是终止时仍产生
    SA_NOCLDWAIT          若此信号是SIGCHLD，当子进程终止时，不创建僵死进程，若此进程随后调用wait，会阻塞到它所有子进程都
                          终止才返回-1，errno设置为ECHILD
    SA_NODEFER            捕捉此信号时，除非sa_mask包含此信号，否则系统不自动阻塞此信号
    SA_ONSTACK            若用sigaltstack声明了一个替换栈，此信号发送给替换栈上的进程
    SA_RESETHAND          在此信号捕捉函数入口处，将此信号处理方式重置为SIG_DFL，并清除SA_SIGINFO标志，
    SA_RESTART            此信号中断的系统调用自动重启
    SA_SIGINFO            此选项对信号处理程序提供了附加信息，siginfo指针和一个进程上下文标志服指针，即如果设置了这个标志
                          按下列方式调用信号处理程序，即调用第二个函数指针：
                              void handler(int signo, siginfo_t *info, void *context);

context至少包含ucontext_t *uc_link, sigset_t uc_sigmask, stack_t uc_stack, mcontext_t uc_mcontext, uc_stack至少包含void *ss_sp, size_t ss_size, int ss_flags



信号          | 代码    | 原因
-------------|---------|-----------------------
SIGILL       | ILL_ILLOPC<br>ILL_ILLOPN<br>ILL_ILLADR<BR>ILL_ILLTRP<BR>ILL_PRVOPC<BR>ILL_PRVREG<BR>ILL_COPROC<BR>ILL_BADSTK  | 非法操作码<BR>非法操作数<BR>非法地址模式<br>非法陷入<br>特权操作码<br>特权寄存器<br>协处理器出错<br>内部栈出错
SIGFPE       | FPE_INTDIV<BR>FPE_INTOVF<BR>FPE_FLTDIV<BR>FPE_FLTOVF<BR>FPE_FLTUND<BR>FPE_FLTRES<BR>FPE_FLTINV<BR>FPE_FLTSUB            | 整数除以0<br>整数溢出<br>浮点除以0<br>浮点向上溢出<br>浮点向下溢出<br>浮点不精确结果<br>无效浮点操作<br>下标超出范围
SIGSEGV      | SEGV_MAPERR<br>SEGV_ACCERR           | 地址不映射至对象<BR>对于映射对象无权限
SIGBUG       | BUS_ADRALN<BR>BUS_ADRERR<BR>BUS_OBJERR   | 无效地址对齐<br>不存在的物理地址<br>对象特定硬件错误
SIGTRAP      | TRAP_BRKPT<BR>TRAP_TRACE  | 进程断点陷入<br>进程跟踪陷入
SIGCHLD      | CLD_EXITED<BR>CLD_KILLED<BR>CLD_DUMPED<BR>CLD_TRAPPED<BR>CLD_STOPPED<BR>CLD_CONTINUED  | 子进程已终止<br>子进程已移除终止，无core<br>子进程已异常终止，有core<br>被跟踪子进程已陷入<br>子进程已停止<br>停止的子进程已继续

为SIGKILL及SIGSTOP定义信号处理函数将导致出错，第二、第三个参数都设为NULL，那么该函数可用于检查信号的有效性。指定SA_NODEFER和SA_RESETHAND可以模拟传统不可靠信号，要让中断的系统调用不自启动可以使用**SA_INTERUPT**，用SA_SIGINFO标志建立的信号处理函数在支持实时信号扩展时，信号可靠地排队

![Alt text](../image/signalparametersflow.png "Optional title")
![](./pic/pic1_50.png =100x20)

# 信号集及信号集操作函数

    typedef struct {
    	unsigned long sig[_NSIG_WORDS]；
    } sigset_t

    #include <signal.h>
    int sigemptyset(sigset_t *set)；
    int sigfillset(sigset_t *set)；
    int sigaddset(sigset_t *set, int signum)
    int sigdelset(sigset_t *set, int signum)；
    int sigismember(const sigset_t *set, int signum)；
    sigemptyset(sigset_t *set)初始化由set指定的信号集，信号集里面的所有信号被清空；
    sigfillset(sigset_t *set)调用该函数后，set指向的信号集中将包含linux支持的64种信号；
    sigaddset(sigset_t *set, int signum)在set指向的信号集中加入signum信号；
    sigdelset(sigset_t *set, int signum)在set指向的信号集中删除signum信号；
    sigismember(const sigset_t *set, int signum)判定信号signum是否在set指向的信号集中。

## sigprocmask、、sigtimedwait、sigwaitinfo

    #include <signal.h>
    int sigprocmask(int how, const sigset_t *set, sigset_t *oldset))；检测和更改进程信号屏蔽字
    int sigwaitinfo(const sigset_t *set, siginfo_t *info);
    int sigtimedwait(const sigset_t *set, siginfo_t *info, const struct timespec *timeout);

sigwaitinfo 阻塞一个进程直到特定信号发生，但信号到来时不执行信号处理函数，而是返回信号值

sigprocmask()函数能够根据参数how来实现对信号集的操作，操作主要有三种，由how指定：

      SIG_BLOCK	在进程当前阻塞信号集中添加set指向信号集中的信号
      SIG_UNBLOCK	如果进程阻塞信号集中包含set指向信号集中的信号，则解除对该信号的阻塞
      SIG_SETMASK	更新进程阻塞信号集为set指向的信号集

## sigsuspend

    int sigsuspend(const sigset_t *mask))；

设置进程屏蔽字为mask，然后挂起直到捕捉到不在mask中的信号，在该信号处理函数返回后再返回，返回时会恢复之前的信号屏蔽字

    #include "apue.h"

    static void	sig_int(int);

    int
    main(void)
    {
    	sigset_t	newmask, oldmask, waitmask;

    	pr_mask("program start: ");

    	if (signal(SIGINT, sig_int) == SIG_ERR)
    		err_sys("signal(SIGINT) error");
    	sigemptyset(&waitmask);
    	sigaddset(&waitmask, SIGUSR1);
    	sigemptyset(&newmask);
    	sigaddset(&newmask, SIGINT);

    	/*
    	 * Block SIGINT and save current signal mask.
    	 */
    	if (sigprocmask(SIG_BLOCK, &newmask, &oldmask) < 0)
    		err_sys("SIG_BLOCK error");

    	/*
    	 * Critical region of code.
    	 */
    	pr_mask("in critical region: ");

    	/*
    	 * Pause, allowing all signals except SIGUSR1.
    	 */
    	if (sigsuspend(&waitmask) != -1)
    		err_sys("sigsuspend error");
      //在这里用CTRL + C产生中断信号，此时屏蔽字包含SIGUSR1和SIGINT，SIGINT是系统自动加进来的
    	pr_mask("after return from sigsuspend: ");

    	/*
    	 * Reset signal mask which unblocks SIGINT.
    	 */
    	if (sigprocmask(SIG_SETMASK, &oldmask, NULL) < 0)
    		err_sys("SIG_SETMASK error");

    	/*
    	 * And continue processing ...
    	 */
    	pr_mask("program exit: ");

    	exit(0);
    }

    static void
    sig_int(int signo)
    {
    	pr_mask("\nin sig_int: ");
    }


用sigsuspend阻塞主进程等待某个信号发生，由信号处理函数设置一个全局变量唤醒主进程

    #include <stdio.h>
    #include <signal.h>

    volatile sig_atomic_t	quitflag;	/* set nonzero by signal handler */

    static void
    sig_int(int signo)	/* one signal handler for SIGINT and SIGQUIT */
    {
    	if (signo == SIGINT)
    		printf("\ninterrupt\n");
    	else if (signo == SIGQUIT)
    		quitflag = 1;	/* set flag for main loop */
    }

    int
    main(void)
    {
    	sigset_t	newmask, oldmask, zeromask;

    	if (signal(SIGINT, sig_int) == SIG_ERR)
    		err_sys("signal(SIGINT) error");
    	if (signal(SIGQUIT, sig_int) == SIG_ERR)
    		err_sys("signal(SIGQUIT) error");

    	sigemptyset(&zeromask);
    	sigemptyset(&newmask);
    	sigaddset(&newmask, SIGQUIT);

    	/*
    	* Block SIGQUIT and save current signal mask.
    	*/
    	if (sigprocmask(SIG_BLOCK, &newmask, &oldmask) < 0)
    		err_sys("SIG_BLOCK error");

    	while (quitflag == 0)
    		sigsuspend(&zeromask);

    	/*
    	* SIGQUIT has been caught and is now blocked; do whatever.
    	*/
    	quitflag = 0;

    	/*
    	* Reset signal mask which unblocks SIGQUIT.
    	*/
    	if (sigprocmask(SIG_SETMASK, &oldmask, NULL) < 0)
    		err_sys("SIG_SETMASK error");

    	exit(0);
    }

## sigpending

    int sigpending(sigset_t *set));返回未决信号

sigpending信号被阻塞，但是依然在队列中，解除阻塞后将传递

    #include "apue.h"

    static void	sig_quit(int);

    int
    main(void)
    {
    	sigset_t	newmask, oldmask, pendmask;

    	if (signal(SIGQUIT, sig_quit) == SIG_ERR)
    		err_sys("can't catch SIGQUIT");

    	/*
    	 * Block SIGQUIT and save current signal mask.
    	 */
    	sigemptyset(&newmask);
    	sigaddset(&newmask, SIGQUIT);
    	if (sigprocmask(SIG_BLOCK, &newmask, &oldmask) < 0)
    		err_sys("SIG_BLOCK error");

    	sleep(5);	/* SIGQUIT here will remain pending */

    	if (sigpending(&pendmask) < 0)
    		err_sys("sigpending error");
    	if (sigismember(&pendmask, SIGQUIT))
    		printf("\nSIGQUIT pending\n");

    	/*
    	 * Restore signal mask which unblocks SIGQUIT.
    	 */
    	if (sigprocmask(SIG_SETMASK, &oldmask, NULL) < 0)
    		err_sys("SIG_SETMASK error");
    	printf("SIGQUIT unblocked\n");

    	sleep(5);	/* SIGQUIT here will terminate with core file */
    	exit(0);
    }

    static void
    sig_quit(int signo)
    {
    	printf("caught SIGQUIT\n");
    	if (signal(SIGQUIT, SIG_DFL) == SIG_ERR)
    		err_sys("can't reset SIGQUIT");
    }

# 作业控制信号

> 1. SIGCHLD 子进程已停止或终止
> 2. SIGCONT 如果进程已经停止，让进程继续运行，否则忽略这个信号，这个信号被阻塞或者忽略也会让停止进程继续
> 3. SIGSTOP 停止信号（不能被捕捉或忽略）
> 4. SIGTSTP 交互式停止信号 (CTRL + Z)
> 5. SIGTTIN 后台进程组成员读控制终端，默认停止该进程
> 6. SIGTTOU 后台进程组成员写控制终端，默认停止该进程

当对一个信号产生4种停止信号(SIGTSTP、SIGSTOP、SIGTTIN、SIGTTOU)中任意一种信号，该进程任意未决SIGCONT信号被丢失。

一个程序处理作业控制是，通常所使用规范代码序列。

    #include "apue.h"

    #define	BUFFSIZE	1024

    static void
    sig_tstp(int signo)	/* signal handler for SIGTSTP */
    {
    	sigset_t	mask;

    	/* ... move cursor to lower left corner, reset tty mode ... */

    	/*
    	 * Unblock SIGTSTP, since it's blocked while we're handling it.
    	 */
    	sigemptyset(&mask);
    	sigaddset(&mask, SIGTSTP);
    	sigprocmask(SIG_UNBLOCK, &mask, NULL);

    	signal(SIGTSTP, SIG_DFL);	/* reset disposition to default */

    	kill(getpid(), SIGTSTP);	/* and send the signal to ourself */

    	/* we won't return from the kill until we're continued */

    	signal(SIGTSTP, sig_tstp);	/* reestablish signal handler */

    	/* ... reset tty mode, redraw screen ... */
    }

    int
    main(void)
    {
    	int		n;
    	char	buf[BUFFSIZE];

    	/*
    	 * Only catch SIGTSTP if we're running with a job-control shell.
    	 */
    	if (signal(SIGTSTP, SIG_IGN) == SIG_DFL)
    		signal(SIGTSTP, sig_tstp);

    	while ((n = read(STDIN_FILENO, buf, BUFFSIZE)) > 0)
    		if (write(STDOUT_FILENO, buf, n) != n)
    			err_sys("write error");

    	if (n < 0)
    		err_sys("read error");

    	exit(0);
    }

因为进程收到SIGTSTP需要做某些动作才去停止，因此需要捕捉SIGTSTP，由于进入信号处理函数时，系统自动将信号阻塞，因此sig_tstp需要先解除阻塞，恢复为默认动作，然后再次给自己发送SIGTSTP,当收到SIGCONT信号时，进程从sig_tstp函数中kill的下一条语句继续运行。

仅当SIGTSTP信号配置为SIG_DFL时才安排捕捉该信号，因为不支持作业控制的shell，init进程会将SIGTSTP、SIGTTIN、SIGTTOU设置为SIG_IGN，所有登录shell会继承。支持作业的shell会设置为SIG_DFL


# 附录

## 可重入函数
abcde         | fghijkl     | lmnopqr           | s           | stuvwxyz
--------------|-------------|-------------------|-------------|----------------
abort	        | faccessat	  | linkat	          | select	    | socketpair
accept	      | fchmod	    | listen	          | sem_post	  | stat
access	      | fchmodat	  | lseek	            | send	      | symlink
aio_error	    | fchown	    | lstat	            | sendmsg	    | symlinkat
aio_return	  | fchownat	  | mkdir	            | sendto	    | tcdrain
aio_suspend	  | fcntl	      | mkdirat	          | setgid	    | tcflow
alarm	        | fdatasync	  | mkfifo	          | setpgid	    | tcflush
bind	        | fexecve	    | mkfifoat	        | setsid	    | tcgetattr
cfgetispeed 	| fork	      | mknod	            | setsockopt	| tcgetpgrp
cfgetospeed	  | fstat	      | mknodat	          | setuid	    | tcsendbreak
cfsetispeed	  | fstatat	    | open	            | shutdown	  | tcsetattr
cfsetospeed	  | fsync	      | openat	          | sigaction	  | tcsetpgrp
chdir	        | ftruncate	  | pause	            | sigaddset	  | time
chmod	        | futimens	  | pipe            	| sigdelset	  | timer_getoverrun
chown	        | getegid	    | poll	            | sigemptyset	| timer_gettime
clock_gettime |	geteuid	    | posix_trace_event	| sigfillset	| timer_settime
close	        | getgid	    | pselect	          | sigismember	| times
connect	      | getgroups	  | raise	            | signal	    | umask
creat	        | getpeername	| read	            | sigpause	  | uname
dup	          | getpgrp	    | readlink	        | sigpending	| unlink
dup2	        | getpid	    | readlinkat       	| sigprocmask |	unlinkat
execl	        | getppid	    | recv	            | sigqueue	  | utime
execle	      | getsockname	| recvfrom	        | sigset	    | utimensat
execv	        | getsockopt	| recvmsg	          | sigsuspend	| utimes
execve	      | getuid	    | rename	          | sleep	      | wait
_Exit	        | kill	      | renameat	        | sockatmark	| waitpid
_exit	        | link	      | rmdir	            | socket	    | write

为了增强程序的稳定性，在信号处理函数中应使用可重入函数。信号处理程序中应当使用可可重入函数（注：所谓可重入函数是指一个可以被多个任务调用的过程，任务在调用时不必担心数据是否会出错）。

## 不可重入函数，

那么信号处理函数可能会修改原来进程中不应该被修改的数据，这样进程从信号处理函数中返回接着执行时，可能会出现不可预料的后果。不可再入函数在信号处理函数中被视为不安全函数。不可重入函数：1.使用了静态数据结构2.进行了堆内存分配。在更新一个数据结构时可能产生信号，在信号处理函数中可能调用siglongjmp和longjmp而不是让信号处理函数完整返回，可能导致整个数据结构只更新一半，因此是不可重入的，这两个函数本身并没有使用静态数据结构或在堆分配内存，或使用了标准I/O函数（标准库I/O函数很多使用了全局变量）

    #include "apue.h"
    #include <pwd.h>

    static void
    my_alarm(int signo)
    {
    	struct passwd	*rootptr;

    	printf("in signal handler\n");
    	if ((rootptr = getpwnam("root")) == NULL)
    			err_sys("getpwnam(root) error");
    	alarm(1);
    }

    int
    main(void)
    {
    	struct passwd	*ptr;

    	signal(SIGALRM, my_alarm);
    	alarm(1);
    	for ( ; ; ) {
    		if ((ptr = getpwnam("sar")) == NULL)
    			err_sys("getpwnam error");
    		if (strcmp(ptr->pw_name, "sar") != 0)
    			printf("return value corrupted!, pw_name = %s\n",
    					ptr->pw_name);
    	}
    }

因为getpwnam会malloc内存并free，并且是static保存内存数据结构，所以不是可重入的，信号处理函数可能在main函数调用getpwnam，getpwnam完成malloc后，尚未进行free时中断main，信号处理也调用getpwnam，此时free一次内存，返回到main会再次调用free。可能导致SIGSEGV。

## 信号表格

signal        | Description          | Default action |  Specification
--------------|----------------------|----------------| ---------------
SIABRT        | 异常终止              | 终止 + core    |
SIGALRM       | 定时器超时            | 终止           | alarm和setitimer函数超时产生此信号
SIGBUS        | 硬件故障              | 终止 + core    | 一般是内存故障
SIGCANCEL     | 线程内部使用          | 忽略           | Solaris内部线程库
SIGCHLD       | 子进程状态改变        | 忽略           | 进程终止时发送此信号给父进程
SIGCONT       | 进程继续              | 继续/忽略      | 作业控制信号，让处于停止状态进程继续运行。全屏编辑程序捕捉到此信号，使用信号处理函数重新绘制终端屏幕
SIGEMT        | 硬件故障              | 终止 + core    | 实现定义（不是标准定义）的硬件故障
SIGFPE        | 算术异常              | 终止 + core    | 除以0、浮点溢出等
SIGFREEZE     | 检查点冻结            | 忽略           | 仅由Solaris定义，通知进程在冻结系统状态前采取特定动作，比如系统进入休眠或者挂起时，需要某些处理
SIGHUP        | 连接断开              | 终止           | 终端断开，此信号发送给与终端相关的控制进程（会话首进程），仅当终端CLOCAL标志没有设置时，产生此信号，终端是本地的，就设置CLOCAL标志
SIGILL        | 非法硬件指令          | 终止 + core     | 表示进程已经执行一条非法硬件指令
SIGINFO       | 键盘状态请求          | 忽略            | BSD信号，用户按下(CTRL+T)时，终端驱动程序产生此信号给前台进程组所有进程，一般会在终端显示前台进程组中各进程状态信息
SIGIO         | 异步IO                | 终止/忽略      | 异步I/O事件，Linux中等同于SIGPOLL，因此默认是终止该进程
SIGIOT        | 硬件故障              | 终止 + core    | 实现定义（不是标准定义的）硬件故障
SIGJVM1       | JVM内部使用           | 忽略           | Solaris
SIGJVM2       | JVM内部使用           | 忽略           | Solaris
SIGKILL       | 终止                  | 终止           | 不能被捕捉或忽略
SIGLOST       | 资源丢失              | 终止           | Solaris NFSv4客户端系统恢复阶段不能重新获得锁，产生此信号
SIGLWP        | 线程库内部使用         | 终止/忽略      | Solaris内部线程库使用，FreeBSD中等同于SIGTHR
SIGPIPE       | 写到无读进程           | 终止          | 管道不存在读进程时写管道和类型为SOCK_STREAM套接字不再连接时产生此信号
SIGPOLL       | 可轮询事件            | 终止           | 可轮训设备产生特定事件产生此信号，Linux等同于SIGIO
SIGPROF       | 梗概时间超时           | 终止          | setitimer设置梗概统计间隔定时器(profiling interval timer)已经超时时产生此信号
SIGPWR        | 电源失效/重启          | 终止/忽略      | 电源失效，UPS起作用时产生此信号，UPS也失效时，再次发生此信号，linux默认终止进程
SIGQUIT       | 终端退出符             | 终止 + core   | 键入(ctrl + \)发送给前台进程组所有进程，终止并产生core
SIGSEGV       | 无效内存引用           | 终止 + core   | 段错误，错误内存引用
SIGSTKFLT     | 协处理器栈故障         | 终止          | 仅由Linux定义，并且是早期版本
SIGSTOP       | 停止                  | 停止进程       | 作业控制信号，不能被捕捉或忽略，
SIGSYS        | 无效系统调用           | 终止 + core   | 主要是旧版本内核运行了新版本程序时产生此信号
SIGTERM       | 终止                  | 终止           | 相对于SIGKILL，能够捕捉此信号，进而在进程终止前做某些处理，优雅的终止进程
SIGTHAW       | 检查点解冻             | 忽略          | 仅由Solaris定义，被挂起系统恢复时，通知相关进程
SIGTHR        | 线程库内部使用         | 忽略           | FreeBSD线程库预留信号，值与SIGLWP相同
SIGTRAP       | 硬件故障               | 终止 + core   | 实现定义（非标准定义）硬件故障
SIGTSTP       | 终端停止符             | 停止进程       | 交互停止信号，按(CTRL + Z)，将进程挂起，注意CTRL + S是终止终端输出，用CTRL + Q继续输出。
SIGTTIN       | 后台进程读控制终端     | 停止进程       | 后台进程组进程读终端时产生此信号，但是读进程忽略或阻塞此信号时，或者进程属于孤儿进程组不产生此信号，后一种情况读操作返回出错，errno置为EIO
SIGTTOU       | 后台进程写控制终端      | 停止进程      | 后台进程组进程写终端产生此信号，后台进程可以选择是否允许写终端，在不允许写终端的情况下才产生此信号，写进程忽略或阻塞此信号，或者写进程属于孤儿进程组不产生此信号，后者情况下，写返回出错，errno置为EIO，除写操作外，tcsetattr、tcsendbreak、tcdrain、tcflush、tcflow和tcsetpgrp也能产生此信号
SIGURG        | 紧急情况（套接字）      | 忽略          | 通知进程已经发生一个紧急情况。网络连接接到带外数据时，可选择产生此信号
SIGUSR1       | 自定义                 | 终止          |
SIGUSR2       | 自定义                 | 终止          |
SIGVTALRM     | 虚拟时间闹钟(setitimer) | 终止          | setitimer函数设置的虚拟间隔时间已经超时产生此信号
SIGWATING     | 线程库内部使用          | 忽略          | Solaris线程库内部使用
SIGWINCH      | 终端窗口改变            | 忽略          | 进程可以用ioctl函数得到或设置窗口大小，如果是设置，发送此信号给前台进程组
SIGXCUP       | 超过CPU限制                | 终止/终止+core | 超过软CPU时间限制时，产生此信号，Linux默认动作是终止并产生core文件
SIGXFSZ       | 超过文件长度限制(setrlimit) | 终止/终止+core | 超过软文件长度限制，Linux默认终止并创建core文件
SIGXRES       | 超过资源控制                | 忽略          | 仅由Solaris定义，用于通知进程超过了预配置资源值

停止是让进程不再运行，仅仅是内核不再调度，终止是停止进程，并将进程从内存中清除

## 自启动系统调用

ioctl、read、readv、write、writev、wait、waitpid
中断信号的SA_RESTART标志有效时，才自动重启系统调用

## SIGCLD和SIGCHLD差别

SIGCLD在Linux系统等同于SIGCHLD，并且没有早期SIGCLD所描述的问题，看APUE时，这里可以忽略，没有书上所说的问题。


## sigsetjmp siglongjmp

当进入信号处理函数时，系统将该信号加入到信号屏蔽字中，返回之前自动解除，假如在信号处理函数时调用longjmp返回原来函数，不同Linux版本的longjmp是否解除屏蔽是不一样的，因此需要使用**sigsetjmp**和**siglongjmp**，siglongjmp会恢复sigsetjmp保存的信号屏蔽字，假如sigsetjmp后面修改了信号屏蔽字呢？

    #include "apue.h"
    #include <setjmp.h>
    #include <time.h>

    static void						sig_usr1(int);
    static void						sig_alrm(int);
    static sigjmp_buf				jmpbuf;
    static volatile sig_atomic_t	canjump;

    int
    main(void)
    {
    	if (signal(SIGUSR1, sig_usr1) == SIG_ERR)
    		err_sys("signal(SIGUSR1) error");
    	if (signal(SIGALRM, sig_alrm) == SIG_ERR)
    		err_sys("signal(SIGALRM) error");

    	pr_mask("starting main: ");		/* {Prog prmask} */

    	if (sigsetjmp(jmpbuf, 1)) {

    		pr_mask("ending main: ");

    		exit(0);
    	}
    	canjump = 1;	/* now sigsetjmp() is OK */

    	for ( ; ; )
    		pause();
    }

    static void
    sig_usr1(int signo)
    {
    	time_t	starttime;

    	if (canjump == 0)
    		return;		/* unexpected signal, ignore */

    	pr_mask("starting sig_usr1: ");

    	alarm(3);				/* SIGALRM in 3 seconds */
    	starttime = time(NULL);
    	for ( ; ; )				/* busy wait for 5 seconds */
    		if (time(NULL) > starttime + 5)
    			break;

    	pr_mask("finishing sig_usr1: ");

    	canjump = 0;
    	siglongjmp(jmpbuf, 1);	/* jump back to main, don't return */
    }

    static void
    sig_alrm(int signo)
    {
    	pr_mask("in sig_alrm: ");
    }

canjump的作用是防止sigsetjmp尚未初始化jmpbuf就发生信号，sig_atomic_t在内存是虚拟存储的系统上，这种变量不会跨页，可以用一条机器指令访问。

信号处理函数中又被信号中断的处理

## 信号编号和信号名

### sys_siglist数组
    extern char *sys_siglist[];

### psignal

    #include <signal.h>

    void psignal(int signo, const char *msg);

psignal将msg： 信号名输出到标准错误，msg可以为空

### psiginfo

    #include <signal.h>
    void psiginfo(const siginfo_t *info, const char *msg);

如果在sigaction提供的信号处理函数有siginfo结构体，可以使用psiginfo打印信号信息

### strsignal

    #include <string.h>
    char *strsignal(int signo);

返回信号描述字符串。

### sig2str、str2sig

    #include <signal.h>
    int sig2str(int signo, char *str);
    int str2sig(const char *str, int *signop);

信号编号和信号名相互映射

# 多线程环境信号处理

    #include "apue.h"
    #include <pthread.h>

    int			quitflag;	/* set nonzero by thread */
    sigset_t	mask;

    pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
    pthread_cond_t waitloc = PTHREAD_COND_INITIALIZER;

    void *
    thr_fn(void *arg)
    {
    	int err, signo;

    	for (;;) {
    		err = sigwait(&mask, &signo);
    		if (err != 0)
    			err_exit(err, "sigwait failed");
    		switch (signo) {
    		case SIGINT:
    			printf("\ninterrupt\n");
    			break;

    		case SIGQUIT:
    			pthread_mutex_lock(&lock);
    			quitflag = 1;
    			pthread_mutex_unlock(&lock);
    			pthread_cond_signal(&waitloc);
    			return(0);

    		default:
    			printf("unexpected signal %d\n", signo);
    			exit(1);
    		}
    	}
    }

    int
    main(void)
    {
    	int			err;
    	sigset_t	oldmask;
    	pthread_t	tid;

    	sigemptyset(&mask);
    	sigaddset(&mask, SIGINT);
    	sigaddset(&mask, SIGQUIT);
    	if ((err = pthread_sigmask(SIG_BLOCK, &mask, &oldmask)) != 0)
    		err_exit(err, "SIG_BLOCK error");

    	err = pthread_create(&tid, NULL, thr_fn, 0);
    	if (err != 0)
    		err_exit(err, "can't create thread");

    	pthread_mutex_lock(&lock);
    	while (quitflag == 0)
    		pthread_cond_wait(&waitloc, &lock);
    	pthread_mutex_unlock(&lock);

    	/* SIGQUIT has been caught and is now blocked; do whatever */
    	quitflag = 0;

    	/* reset signal mask which unblocks SIGQUIT */
    	if (sigprocmask(SIG_SETMASK, &oldmask, NULL) < 0)
    		err_sys("SIG_SETMASK error");
    	exit(0);
    }

# utility

## 发送信号给线程，tkill

    int tkill(int tid, int sig);
    int tgkill(int tgid, int tid, int sig);
    int pthread_kill(pthread_t thread, int sig);
    int pthread_sigqueue(pthread_t thread, int sig, const union sigval value);

## 创建一个接受信号的文件描述符

    struct signalfd_siginfo {
    	uint32_t ssi_signo;    /* Signal number */
    	int32_t  ssi_errno;    /* Error number (unused) */
    	int32_t  ssi_code;     /* Signal code */
    	uint32_t ssi_pid;      /* PID of sender */
    	uint32_t ssi_uid;      /* Real UID of sender */
    	int32_t  ssi_fd;       /* File descriptor (SIGIO) */
    	uint32_t ssi_tid;      /* Kernel timer ID (POSIX timers)
    						   uint32_t ssi_band;     /* Band event (SIGIO) */
    	uint32_t ssi_overrun;  /* POSIX timer overrun count */
    	uint32_t ssi_trapno;   /* Trap number that caused signal */
    	int32_t  ssi_status;   /* Exit status or signal (SIGCHLD) */
    	int32_t  ssi_int;      /* Integer sent by sigqueue(3) */
    	uint64_t ssi_ptr;      /* Pointer sent by sigqueue(3) */
    	uint64_t ssi_utime;    /* User CPU time consumed (SIGCHLD) */
    	uint64_t ssi_stime;    /* System CPU time consumed
    						   (SIGCHLD) */
    	uint64_t ssi_addr;     /* Address that generated signal
    						   (for hardware-generated signals) */
    	uint16_t ssi_addr_lsb; /* Least significant bit of address
    						   (SIGBUS; since Linux 2.6.37)
    						   uint8_t  pad[X];       /* Pad size to 128 bytes (allow for
    						   additional fields in the future) */
    };

    int signalfd(int fd, const sigset_t *mask, int flags);

创建一个接受信号的文件描述符

## 系统调用被中断后重启系统调用

    int restart_syscall(void);

## 允许信号中断系统调用
    int siginterrupt(int sig, int flag);

## 从信号处理函数返回，清理栈帧

    int sigreturn(...);
