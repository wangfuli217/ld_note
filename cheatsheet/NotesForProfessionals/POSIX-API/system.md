---
title: system函数
comments: true
---


# system函数

system函数要求忽略SIGINT, SIGQUIT，阻塞SIGCHLD

## tips

<!--more-->

* 设置用户ID或设置组ID程序不应该调用system函数

## system1

    #include	<sys/wait.h>
    #include	<errno.h>
    #include	<unistd.h>

    int system(const char *cmdstring)	/* version without signal handling */
    {
    	pid_t	pid;
    	int		status;

    	if (cmdstring == NULL)
    		return(1);		/* always a command processor with UNIX */

    	if ((pid = fork()) < 0) {
    		status = -1;	/* probably out of processes */
    	}
    	else if (pid == 0) {				/* child */
    		execl("/bin/sh", "sh", "-c", cmdstring, (char *)0);
    		_exit(127);		/* execl error */
    	}
    	else {							/* parent */
    		while (waitpid(pid, &status, 0) < 0) {
    			if (errno != EINTR) {
    				status = -1; /* error other than EINTR from waitpid() */
    				break;
    			}
    		}
    	}

    	return(status);
    }

cmdstring是空指针时，只有命令处理程序(shell)函数可用时，返回非0值，可用利用这一特征检查操作系统是否支持system函数。

1. fork失败或者waitpid返回EINTR之外的错误，system返回-1，并设置errono
2. exec失败（不能执行shell），则返回值如同shell执行了exit
3. fork、exec、waitpid都成功，返回shell的终止状态

对于有设置用户ID的包含system函数的程序，并且该程序由root用户持有，那么将出现安全问题，fork和exec后依然具有root权限，可以更改/bin/sh，检测有效用户ID和实际用户ID不匹配时，将有效用户ID设置为实际用户ID。设置用户ID或设置组ID程序不应该调用system函数。

## systemtest1

    #include "apue.h"
    #include <sys/wait.h>

    int
    main(void)
    {
    	int		status;

    	if ((status = system("date")) < 0)
    		err_sys("system() error");

    	pr_exit(status);

    	if ((status = system("nosuchcommand")) < 0)
    		err_sys("system() error");

    	pr_exit(status);

    	if ((status = system("who; exit 44")) < 0)
    		err_sys("system() error");

    	pr_exit(status);

    	exit(0);
    }

## systemtest2

    #include "apue.h"

    static void
    sig_int(int signo)
    {
    	printf("caught SIGINT\n");
    }

    static void
    sig_chld(int signo)
    {
    	printf("caught SIGCHLD\n");
    }

    int
    main(void)
    {
    	if (signal(SIGINT, sig_int) == SIG_ERR)
    		err_sys("signal(SIGINT) error");
    	if (signal(SIGCHLD, sig_chld) == SIG_ERR)
    		err_sys("signal(SIGCHLD) error");
    	if (system("/bin/ed") < 0)
    		err_sys("system() error");
    	exit(0);
    }

这个程序可以观察到，孙子进程中产生信号，父进程和祖父进程的处理方式

    g++ system1.cpp -o system1 -ggdb3
    ./system1
    a
    hello
    .
    1,$p
    hello
    w t.foo
    6
    ^Ccaught SIGINT

    ?
    q
    caught SIGCHLD

**键入中断字符会将中断信号会递送给前台进程中所有进程，所以system1和ed都会捕捉到该信号。** 因为system1捕捉SIGCHLD，所以当ed进程结束时，system1将捕捉到SIGCHLD，错误的认为/bin/sh结束，假如此时调用wait函数来获取子进程的终止状态，**会阻止system函数获得子进程ed的终止状态来作为返回值。**


## systemtest3

    #include "apue.h"

    int
    main(int argc, char *argv[])
    {
    	int		status;

    	if (argc < 2)
    		err_quit("command-line argument required");

    	if ((status = system(argv[1])) < 0)
    		err_sys("system() error");

    	pr_exit(status);

    	exit(0);
    }

## system2

这个版本system函数实现了信号处理，忽略了SIGINI和SIGQUIT，阻塞了SIGCHLD，在SIGCHLD未决期间，**如若wait或waipid返回了子进程状态，那么SIGCHLD不应该递送给祖父进程，但是假如另一个祖父进程的子进程或孙子进程的状态也可用（即退出，并且不存在祖父进程的子进程wait的情况），此时应该将SIGCHLD递送给祖父进程。**这里需要验证下。

    #include	<sys/wait.h>
    #include	<errno.h>
    #include	<signal.h>
    #include	<unistd.h>

    int
    system(const char *cmdstring)	/* with appropriate signal handling */
    {
    	pid_t				pid;
    	int					status;
    	struct sigaction	ignore, saveintr, savequit;
    	sigset_t			chldmask, savemask;

    	if (cmdstring == NULL)
    		return(1);		/* always a command processor with UNIX */

    	ignore.sa_handler = SIG_IGN;	/* ignore SIGINT and SIGQUIT */
    	sigemptyset(&ignore.sa_mask);
    	ignore.sa_flags = 0;
    	if (sigaction(SIGINT, &ignore, &saveintr) < 0)
    		return(-1);
    	if (sigaction(SIGQUIT, &ignore, &savequit) < 0)
    		return(-1);
    	sigemptyset(&chldmask);			/* now block SIGCHLD */
    	sigaddset(&chldmask, SIGCHLD);
    	if (sigprocmask(SIG_BLOCK, &chldmask, &savemask) < 0)
    		return(-1);

    	if ((pid = fork()) < 0) {
    		status = -1;	/* probably out of processes */
    	} else if (pid == 0) {			/* child */
    		/* restore previous signal actions & reset signal mask */
    		sigaction(SIGINT, &saveintr, NULL);
    		sigaction(SIGQUIT, &savequit, NULL);
    		sigprocmask(SIG_SETMASK, &savemask, NULL);

    		execl("/bin/sh", "sh", "-c", cmdstring, (char *)0);
    		_exit(127);		/* exec error */
    	} else {						/* parent */
    		while (waitpid(pid, &status, 0) < 0)
    			if (errno != EINTR) {
    				status = -1; /* error other than EINTR from waitpid() */
    				break;
    			}
    	}

    	/* restore previous signal actions & reset signal mask */
    	if (sigaction(SIGINT, &saveintr, NULL) < 0)
    		return(-1);
    	if (sigaction(SIGQUIT, &savequit, NULL) < 0)
    		return(-1);
    	if (sigprocmask(SIG_SETMASK, &savemask, NULL) < 0)
    		return(-1);

    	return(status);
    }

注意system函数返回的是shell终止状态，但是shell终止状态并不总是是执行命令字符串进程的终止状态，对于信号终止了命令字符串进程的情况，system返回值是信号值加上128，怎么返回和shell的实现相关。
