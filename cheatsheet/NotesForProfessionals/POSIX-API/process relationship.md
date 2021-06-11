---
  title: 守护进程和进程组、作业、会话等进程关系
---

# 进程间关系

# 父子进程，fork、exec

## fork

    #include <unistd.h>
    pid_t fork(void);

fork和exec结合起来组成spawn

    #include <sched.h>
    int clone(int(*fn)(void *), void *child_stack, int flags, void *arg, ... /* pid_t *ptid, void *newtls, pid_t *ctid */);

clone可以控制复制哪些部分

    #include <sys/types.h>
    #include <unistd.h>

    pid_t vfork(void);

保证子进程先运行，子进程调用exec或exit后父进程才可能被调度运行

### 子进程继承父进程的属性

1. 实际用户ID， 实际组ID， 有效用户ID， 有效组ID
2. 附属组ID
3. 进程组ID
4. 会话ID
5. 控制终端
6. 设置用户ID标志和设置组ID标志
7. 当前工作目录
8. 根目录
9. 文件模式创建屏蔽字
10. 信号屏蔽和处理函数
11. 文件描述符执行时关闭(close-on-exec)标志
12. 环境变量
13. 共享存储段
14. 存储映像
15. 资源限制

### 子进程和父进程不同属性

1. fork返回值不同
2. 进程ID不同
3. 父进程ID不同
4. 子进程tms_utime、tms_stime、tms_cutime和tms_ustime设置为0
5. 子进程不继承父进程设置的文件锁
6. 子进程未处理闹钟被清除
7. 子进程未处理信号集设置为空集

## 父进程等待子进程退出

### 僵死进程

一个已经终止，但是父进程尚未对其进行善后处理的进程被称为僵死进程。避免僵死进程可以fork两次，让产生的子进程成为init的子进程

### wait, waitpid, waitid, wait3, wait4

***子进程退出时，会将SIGCHLD发送给所有祖先进程***

    #include <sys/types.h>
    #include <sys/wait.h>

    pid_t wait(int *wstatus);
    pid_t waitpid(pid_t pid, int *wstatus, int options);

阻塞直到子进程退出，waitpid可以等待指定进程，并且可以可以通过设置options不阻塞.

>WIFEXITED(wstatus)//若子进程正常终止则为真
>
>WEXITSTATUS(wstatus)//获取子进程传递给exit或_exit参数的低8位
>
>WIFSIGNALED(wstatus)//子进程异常终止，则为真
>
>WTERMSIG(wstatus)//获取使子进程终止的信号编号
>
>WCOREDUMP(wstatus)//子进程退出产生了core文件则为真
>
>WIFSTOPPED(wstatus)//子进程暂停则为真
>
>WSTOPSIG(wstatus)//获取使子进程暂停的信号编号
>
>WIFCONTINUED(wstatus)//在作业控制使子进程暂停后，子进程继续，则为真

waitpid中pid参数：

> pid == -1 等待任意子进程，此时等价于wait
>
> pid > 0 等待进程ID等于pid的子进程
>
> pid == 0 等待组ID等于调用进程组ID的任一子进程
>
> pid < -1 等待组ID等于pid绝对值的任一子进程

option参数

> WCONTINUED 若支持作业控制，pid指定的任一子进程在停止后继续，但其状态尚未报告，返回其状态
>
> WNOHANG pid指定的子进程不是立即可用的（没有退出），waitpid不阻塞，此时waitpid返回0
>
> WUNTRACED 若支持作业控制，pid指定的任一子进程已经停止，且其状态自停止以来还未报告过，则返回其状态。

    int waitid(idtype_t idtype, id_t id, siginfo_t *infop, int options);

idtype：

> P_PID 等待id指定的子进程
>
> P_PGID 等待id指定的进程组中子进程
>
> P_ALL 等待任一子进程，忽略id

options参数和waitpid相同

    #include <sys/types.h>
    #include <sys/time.h>
    #include <sys/resource.h>
    #include <sys/wait.h>

    pid_t wait3(int *wstatus, int options, struct rusage *rusage);
    pid_t wait4(pid_t pid, int *wstatus, int options, struct rusage *rusage);

允许返回终止进程及其所有子进程所使用资源概况。

## exec

    #include <unistd.h>
    int execl(const char *pathname, const char *arg0, ... /* (char *)0 */ );
    int execv(const char *pathname, char *const argv[]);
    int execle(const char *pathname, const char *arg0, ... /* (char *)0, char *const envp[] */ );
    int execve(const char *pathname, char *const argv[], char *const envp[]);
    int execlp(const char *filename, const char *arg0, ... /* (char *)0 */ );
    int execvp(const char *filename, char *const argv[]);
    int fexecve(int fd, char *const argv[], char *const envp[]);
    int execvpe(const char *file, char *const argv[], char *const envp[]);
    int execveat(int dirfd, const char *pathname, char *const argv[], char *const envp[], int flags);
    All seven return: −1 on error, no return on success

exec后，新进程从调用进程继承的属性：

> 进程ID和父进程ID
> 实际用户ID和实际组ID
> 附属组ID
> 进程组ID
> 会话ID
> 控制终端
> 闹钟剩余时间
> 当前工作目录
> 根目录
> 文件模式创建屏蔽字
> 文件锁
> 进程信号屏蔽
> 未处理信号
> 资源限制
> nice值
> tms_utime、tms_stime、tms_cutime和tms_cstime值

* 执行exec时，关闭打开目录流
* 实际用户ID和实际组ID保持不变，有效用户ID取决于是否设置设置用户ID和设置组ID

## 进程组

同一进程组中各进程接受来自同一终端的各种信号，进程组ID等于组长进程ID，组长进程就是开启该进程组的首进程。进程组生命周期直到组里最后一个进程退出，shell中由管道组成的命令组形成进程组

    #include <unistd.h>
    pid_t getpgrp(void); //返回进程组ID
    pid_t getpgid(pid_t pid) //返回指定pid进程的进程组ID，pid为0，返回本进程进程组ID，
    int setpgid(pid_t pid, pid_t pgid);//加入或创建进程组，

对于setpgid函数，将pid进程的进程组设置为pgid，若pid==pgid，则pid创建一个新进程组，并成为组长。若pid为0，则使用调用者进程ID，若pgid为0，则使用pid作为pgid。

## 会话

会话可以有一个控制终端，建立与控制终端联系的进程称为控制进程，会话中的进程组分为一个前台进程和多个后台进程，键盘产生的信号只发往前台进程组所有进程，终端断开将挂断信号发往控制进程。

    #include <unistd.h>
    pid_t setsid(void);
    pid_t getsid(pid_t pid); pid为0，返回调用进程的会话首进程的进程组ID（会话ID）
    #include <termios.h>
    pid_t tcgetsid(int fd);返回fd相关联的终端会话首进程ID

调用该函数的进程不是一个进程组组长，则创建一个新的会话，如果是组长则出错返回

* 该进程成为一个新会话的会话首进程
* 该进程成为一个新进程组的组长进程
* 该进程没有控制终端，有就切断

会话首进程使用TIOCSCTTY作为request参数调用ioctl，或不带O_NOCTTY标志的open /dev/tty来获取控制终端

<!--more-->

## 前台进程组

设置获取前台进程组

    #include <unistd.h>
    pid_t tcgetpgrp(int fd);//返回fd相关联的终端的前台进程组
    int tcsetpgrp(int fd, pid_t pgrpid)
    #include <termios.h>
    pid_t tcgetsid(int fd);

CTRL+Z SIGTSTP，CTRL+C SIGINT, CTRL+\ SIGQUIT，后台作业读终端时，终端驱动程序将向后台进程发生SIGTTIN，但是对于孤儿进程组，读终端出错返回，errno置为EIO。该信号一般是停止此后台作业。后台进程组写终端是可以控制的，假如不允许，将发送SIGTTOU信号，并导致该后台作业阻塞。

## 作业和进程组的区别

所有的作业都是进程组形式呈现的，但是支持作业和不支持作业shell对作业这个进程组的处理方式不同，主要体现在控制终端读写处理方式。支持作业的shell，会将进程组单独创建一个进程组，不支持作业的shell，新创建的进程和shell进程同属一个进程组。

## 孤儿进程组

该组中每个成员的父进程要么是该组的一个成员，要么不是该组所属会话的成员，或者表述成，一个进程组不是孤儿进程组的条件是该组中有一个进程，其父进程在属于同一个会话的另一个组中。

系统会向新的孤儿进程组中处于停止状态的进程发送SIGHUP，然后又发送SIGCONT信号，假如进程是前台进程组成员，但是父进程退出，并且成为孤儿进程组时，子进程会变成后台进程。

# 守护进程

## 守护进程编码规则

编写守护进程时遵循的基本规则，以便防止产生并不需要的交互作用：

1.  调用umask将文件模式创建屏蔽字设置为0。由继承的来的文件模式创建屏蔽字可能会拒绝设置某些权限。更高进程的文件模式创建屏蔽字并不影响父进程的屏蔽字。

2. 调用fork函数，目的是： 如果该守护进程是作为一条简单shell命令启动的，那么父进程终止是的shell认为这条命令已经执行完成。子进程继承父进程的进程组ID，但具有一个新的进程ID，保证了不是一个进程组的组长进程，这是setsid调用的必要前提条件。

3. 调用setsid以创建一个新的会话，调用进程称为新会话的首进程，成为一个新进程组的组长进程，没有控制终端，将发生如下的事情：

     (1) 该进程变成新会话首进程，会话首进程通常是创建该会话的进程，该进程是新会话中的唯一的进程。

     (2) 该进程成为一个新进程组的组长进程，新进程组ID就是调用进程的ID。

     (3) 该进程没有控制终端，如果在调用setsid之前该进程有一个控制终端，那么这种联系将被中断。

通常登陆时将自动建立控制终端，不管标准输入、标准输出是否被重定向，程序都要与控制终端交互，保证程序能读写控制终端的方法是打开
文件/dev/tty，内核中次文件是控制终端的同义词，若没有控制终端，打开该设备将失败。

通常在setsid()之后，会再次调用fork()。目的是确保守护进程将来即使打开一个终端设备，也不会自动获得终端，原因是没有控制终端的会话
首进程打开终端设备时该终端会自动成为这个会话的控制终端，通过第二次的fork可以确保这次生成的子进程不再是一个会话的首进程，因此它
不会获得控制终端。而在fork之前通常会忽略信号，这是因为会话首进程退出时会给该会话中的前台进程组（当打开控制终端后，就有一个前台
进程组）的所有进程发送信号，而信号的默认处理函数通常是进程终止。

4. 将当前工作目录更改为根目录。

5. 关闭不再需要的文件描述符，这使得守护进程不再持有从其父进程继承来的某些文件描述符，可以通过getrlimit函数来判定最大文件描述符
值，并关闭知道该值的所有描述符。

6. 某些守护进程打开/dev/null使其具有文件描述符0、1和2，因此任何一个试图读标准输入、写标准输出或标准错误的库都没有效果。因此守
护进程并不与终端设备关联，并不能在终端设备上显示其输出，也无处从交互式用户接收输入。

守护进程没有控制终端，在发送问题时要用一些其他方式以输出消息，这些消息既有一般的通告消息，也有需管理员处理的紧急事件消息。syslog函数是输出这些消息的标准方式，它将消息发往syslogd守护进程。

###  syslogd守护进程

> Unix系统通常会从一个初始化脚本中启动名为syslogd的守护进程，只要系统不停止，该服务一直运行，在启动时执行如下操作：
>
>        1. 读入配置文件，通常是/etc/syslog.conf。设定守护进程对接收到每次键入的各种等级消息如何处理，消息可能写入一个文件，或
>            发送给指定的用户，或转发给另一台主机上的syslogd进程。
>
>        2. 创建Unix域套接口，给它绑定路径名/var/run/log。
>
>        3. 创建UDP套接字，给它 捆绑端口514(syslog使用的端口号)
>
>        4. 打开路径名/dev/klog，内核中的所有出错信息作为这个设备的输入出现。
>
>        5.  然后syslogd进程运行一个无限循环，调用select等待三个描述字(2、3、4生成的描述字)变为可读，读入登记信息，并按照配置
>             文件对消息进行处理。若接收到SIGHUP信号，会重新读入配置文件。

syslog函数

        void syslog(int  priority, const char *message, ...);

priority参数是级别和设施的组合。message与printf所用的格式化字符串类型。增加了%m，打印出当前error对应的出错消息。

有关设施和级别的目的是允许在/etc/syslog.conf文件中进行配置，使得对相同设施的消息得到同样的处理，或使得相同级别的消息得到同样的处理。

当应用程序第一次调用syslog时，创建一个Unix域数据报套接口，然后调用connect连往syslogd守护进程建立的套接口/var/run/log。该套接口在进程终止前一直打开。

###  void daemonize(const char *cmd)

    #define LOCKFILE "/var/run/daemon.pid"
    #define LOCKMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)
    extern int lockfile(int);

    int
    already_running(void)
    {
    	//只启用一个daemon
    	int fd;
    	char buf[16];
    	fd = open(LOCKFILE, O_RDWR | O_CREAT, LOCKMODE);
    	if (fd < 0) {
    		syslog(LOG_ERR, "can’t open %s: %s", LOCKFILE, strerror(errno));
    		exit(1);
    	}
    	if (lockfile(fd) < 0) {
    		if (errno == EACCES || errno == EAGAIN) {
    			close(fd);
    			return(1);
    		}
    		syslog(LOG_ERR, "can’t lock %s: %s", LOCKFILE, strerror(errno));
    		exit(1);
    	}
    	ftruncate(fd, 0);
    	sprintf(buf, "%ld", (long)getpid());
    	write(fd, buf, strlen(buf) + 1);
    	return(0);
    }

    int daemonize(int *child_exit_status, const char *pid_file)
    {
    	int i, fd0, fd1, fd2;
    	pid_t pid;
    	struct rlimit rl;
    	struct sigaction sa;
    	if (getuid() != 0) {
    		async_logger->error("the master command is reserved for the superuser");
    	}

    	umask(077);

    	if (getrlimit(RLIMIT_NOFILE, &rl) < 0) {
    		async_logger->error("getrlimit error");
    		exit(1);
    	}

    	if ((pid = fork()) < 0) {
    		async_logger->error("first fork failed");
    		exit(1);
    	}
    	else if (pid != 0) {  //parent
    		exit(0);
    	}
    	//child

    	setsid(); //构建新的会话进程，但该会话目前无控制终端，该进程成为会话首进程。
    			  //a process call setsid cannot be a process group leader, or it will fail
    			  //call setsid will generate a new session, this session doesn't have a control terminal, open /dev/tty will attach terminal to session process leader

    			  //信号屏蔽函数是解决会话首进程退出后，前台进程组收到会话首进程的SIGHUP信号，若不屏蔽会出现进程退出的问题。
    	sa.sa_handler = SIG_IGN;
    	//signal (SIGINT , SIG_IGN);
    	//signal (SIGHUP , SIG_IGN);
    	//signal (SIGQUIT , SIG_IGN);
    	//signal (SIGPIPE , SIG_IGN);
    	//signal (SIGTTOU , SIG_IGN);
    	//signal (SIGTTIN , SIG_IGN);
    	//signal (SIGCHLD , SIG_IGN);
    	//signal (SIGTERM , SIG_IGN);
    	sigemptyset(&sa.sa_mask);
    	sa.sa_flags = 0;
    	if (sigaction(SIGHUP, &sa, NULL) < 0) {
    		async_logger->error("sigaction error");
    		exit(1);
    	}

    	/*
    	该fork的作用是防止守护进程打开控制终端，使得会话首进程获得控制终端。
    	子进程会在打开控制终端之后变为前台进程组的进程，确保不会是会话的会话首进程。
    	*/
    	// int nprocs = 0;
    	pid_t child_pid = -1;

    	/* we ignore SIGINT and SIGTERM and just let it be forwarded to the child instead
    	* as we want to collect its PID before we shutdown too
    	*
    	* the child will have to set its own signal handlers for this
    	*/

    	for (;;) {
    		/* try to start the children */
    		// while (nprocs < 1)
    		if (-1 == child_pid) {
    			pid = fork();

    			if (pid == 0) {
    				/* child */
    				//子进程继续运行
    				if (chdir("/") < 0) {
    					async_logger->error("chdir error");
    					exit(1);
    				}

    				//关闭所有打开的文件描述符
    				if (rl.rlim_max == RLIM_INFINITY) {
    					rl.rlim_max = 1024;
    				}

    				for (i = 0; i < rl.rlim_max; i++) {
    					close(i);
    				}

    				//重定向0, 1, 2到/dev/null, fd从最小的开始分配，因此是0, 1, 2
    				fd0 = open("/dev/null", O_RDWR);
    				fd1 = dup(0);
    				fd2 = dup(0);
    				init_log();//attention
    				openlog(APP_NAME, LOG_CONS, LOG_DAEMON);
    				//system call
    				if (fd0 != 0 || fd1 != 1 || fd2 != 2) {
    					syslog(LOG_ERR, "uexpected file descriptors %d %d %d", fd0, fd1, fd2);
    					exit(1);
    				}
    				return 0;
    			}
    			else if (pid < 0) {
    				/* fork() failed */
    				sleep(1);
    				async_logger->error("second fork failed, fork error:%d, %s", errno, strerror(errno));
    				return -1;
    			}
    			else {
    				// parent
    				/* we are the angel, let's see what the child did */
    				/* forward a few signals that are sent to us to the child instead */
    				signal(SIGINT, signal_forward);
    				signal(SIGTERM, signal_forward);
    				signal(SIGHUP, signal_forward);
    				signal(SIGUSR1, signal_forward);
    				signal(SIGUSR2, signal_forward);
    				child_pid = pid;
    				//   nprocs++;
    			}
    		}

    		if (child_pid != -1) {
    			//            struct rusage rusage;
    			int exit_status = 0;
    			pid_t exit_pid;
    			//memset (&rusage , 0 , sizeof(rusage)); /* make sure everything is zero'ed out */
    			exit_pid = waitpid(child_pid, &exit_status, 0);
    			if (exit_pid == child_pid) {
    				/* delete pid file */
    				if (pid_file) {
    					unlink(pid_file);
    				}

    				child_pid = -1;

    				/* our child returned, let's see how it went */
    				if (WIFEXITED(exit_status)) {
    					fprintf(stderr, "child process have exit\n");
    					child_pid = -1;
    					if (child_exit_status) {
    						*child_exit_status = WEXITSTATUS(exit_status);
    						fprintf(stderr, "return child_exit_status\n");
    					}
    				}
    				else if (WIFSIGNALED(exit_status)) {
    					fprintf(stderr, "child process have WIFSIGNALED:%d\n", exit_status);
    					child_pid = -1;
    					//int time_towait = 2;
    					///**
    					//* to make sure we don't loop as fast as we can, sleep a bit between
    					//* restarts
    					//*/
    					//
    					//signal (SIGINT , SIG_DFL);
    					//signal (SIGTERM , SIG_DFL);
    					//signal (SIGHUP , SIG_DFL);
    					//while (time_towait > 0)
    					//time_towait = sleep (time_towait);
    					//
    					//nprocs--;
    					//child_pid = -1;
    				}
    				else if (WIFSTOPPED(exit_status)) {
    					fprintf(stderr, "child process have WIFSTOPPED:%d\n", exit_status);
    				}
    				else {
    					fprintf(stderr, "child process have unknown state:%d\n", exit_status);
    					//g_assert_not_reached ();
    				}

    			}

    			else if (-1 == exit_pid) {
    				/*
    				ECHILD (for waitpid() or waitid()) The process specified by pid (waitpid()) or idtype and id (waitid()) does not exist or is not a  child  of  the  calling
    				process.  (This can happen for one's own child if the action for SIGCHLD is set to SIG_IGN.  See also the Linux Notes section about threads.)
    				*/
    				if (ECHILD == errno) {
    					fprintf(stderr, "wait pid:%d error ECHILD %d,%s\n", (int)child_pid, errno, strerror(errno));
    					child_pid = -1;
    				}
    				else {
    					fprintf(stderr, "wait pid:%d error %d,%s,child_pid don't change\n", (int)child_pid, errno, strerror(errno));
    				}
    				///* EINTR is ok, all others bad */
    				//if (EINTR != errno)
    				//{
    				//  /* how can this happen ? */
    				//  return -1;
    				//}
    			}
    			else {
    				fprintf(stderr, "wait pid:%d can't reach here:%d,%s\n", (int)child_pid, errno, strerror(errno));
    				return -1;
    			}
    		}
    		else {
    			fprintf(stderr, "chilid_pid is -1,can't reach here\n");
    			return -1;
    		}

    		sleep(2);
    	}
    	return 0;
    }

#### 多线程情况

    sigset_t	mask;

    extern int already_running(void);

    void
    reread(void)
    {
    	/* ... */
    }

    void *
    thr_fn(void *arg)
    {
    	int err, signo;

    	for (;;) {
    		err = sigwait(&mask, &signo);
    		if (err != 0) {
    			syslog(LOG_ERR, "sigwait failed");
    			exit(1);
    		}

    		switch (signo) {
    		case SIGHUP:
    			syslog(LOG_INFO, "Re-reading configuration file");
    			reread();
    			break;

    		case SIGTERM:
    			syslog(LOG_INFO, "got SIGTERM; exiting");
    			exit(0);

    		default:
    			syslog(LOG_INFO, "unexpected signal %d\n", signo);
    		}
    	}
    	return(0);
    }

    int
    main(int argc, char *argv[])
    {
    	int					err;
    	pthread_t			tid;
    	char				*cmd;
    	struct sigaction	sa;

    	if ((cmd = strrchr(argv[0], '/')) == NULL)
    		cmd = argv[0];
    	else
    		cmd++;

    	/*
    	* Become a daemon.
    	*/
    	daemonize(cmd);

    	/*
    	* Make sure only one copy of the daemon is running.
    	*/
    	if (already_running()) {
    		syslog(LOG_ERR, "daemon already running");
    		exit(1);
    	}

    	/*
    	* Restore SIGHUP default and block all signals.
    	*/
    	sa.sa_handler = SIG_DFL;
    	sigemptyset(&sa.sa_mask);
    	sa.sa_flags = 0;
    	if (sigaction(SIGHUP, &sa, NULL) < 0)
    		err_quit("%s: can't restore SIGHUP default");
    	sigfillset(&mask);
    	if ((err = pthread_sigmask(SIG_BLOCK, &mask, NULL)) != 0)
    		err_exit(err, "SIG_BLOCK error");

    	/*
    	* Create a thread to handle SIGHUP and SIGTERM.
    	*/
    	err = pthread_create(&tid, NULL, thr_fn, 0);
    	if (err != 0)
    		err_exit(err, "can't create thread");

    	/*
    	* Proceed with the rest of the daemon.
    	*/
    	/* ... */
    	exit(0);
    }

#### 单线程情况

    #include "apue.h"
    #include <syslog.h>
    #include <errno.h>

    extern int lockfile(int);
    extern int already_running(void);

    void
    reread(void)
    {
    	/* ... */
    }

    void
    sigterm(int signo)
    {
    	syslog(LOG_INFO, "got SIGTERM; exiting");
    	exit(0);
    }

    void
    sighup(int signo)
    {
    	syslog(LOG_INFO, "Re-reading configuration file");
    	reread();
    }

    int
    main(int argc, char *argv[])
    {
    	char				*cmd;
    	struct sigaction	sa;

    	if ((cmd = strrchr(argv[0], '/')) == NULL)
    		cmd = argv[0];
    	else
    		cmd++;

    	/*
    	* Become a daemon.
    	*/
    	daemonize(cmd);

    	/*
    	* Make sure only one copy of the daemon is running.
    	*/
    	if (already_running()) {
    		syslog(LOG_ERR, "daemon already running");
    		exit(1);
    	}

    	/*
    	* Handle signals of interest.
    	*/
    	sa.sa_handler = sigterm;
    	sigemptyset(&sa.sa_mask);
    	sigaddset(&sa.sa_mask, SIGHUP);
    	sa.sa_flags = 0;
    	if (sigaction(SIGTERM, &sa, NULL) < 0) {
    		syslog(LOG_ERR, "can't catch SIGTERM: %s", strerror(errno));
    		exit(1);
    	}
    	sa.sa_handler = sighup;
    	sigemptyset(&sa.sa_mask);
    	sigaddset(&sa.sa_mask, SIGTERM);
    	sa.sa_flags = 0;
    	if (sigaction(SIGHUP, &sa, NULL) < 0) {
    		syslog(LOG_ERR, "can't catch SIGHUP: %s", strerror(errno));
    		exit(1);
    	}

    	/*
    	* Proceed with the rest of the daemon.
    	*/
    	/* ... */
    	exit(0);
    }
