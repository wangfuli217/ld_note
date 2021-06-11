---
title: 进程
comments: true
---

# 进程生命周期

## 有8种方式使进程终止：

1. 从main返回
2. 调用exit
3. 调用_exit或_Exit
4. 最后一个线程从其启动例程返回
5. 从最后一个线程调用pthread_exit

异常终止：

1. abort
2. 被信号终止
3. 最后一个线程对取消请求作出响应

# 进程时间

* 时钟时间（墙上时间）
* 用户CPU时间
* 系统CPU时间

墙上时钟是进程运行的时间总量，与调度有关

## 获取进程CPU时间的时钟ID

    int clock_getcpuclockid(pid_t pid, clockid_t *clock_id);

<!--more-->

## exit, _exit, _Exit

    #include <unistd.h>
    void _exit(int status);
    #include <stdlib.h>
    void _Exit(int status);
    void exit(int status);//总是执行标准IO库的清理关闭操作

如果调用exit，_Exit或_exit不带status或main执行了一个无返回值的return语句，或者main没有声明返回类型，则进程终止状态是未定义的

## atexit

    #include <stdlib.h>
    int atexit(void (*func)(void));
    int on_exit(void (*function)(int , void *), void *arg);

atexit最多只能注册32个函数，注册的函数执行exit或main返回时自动调用。

# 进程内存分布

    地址由高到低
    命令行参数和环境变量
    栈
    堆
    未初始化数据段(BSS)
    初始化数据段
    正文

## 环境变量

    extern char **environ;
    #include <stdlib.h>
    char *getenv(const char *name);
    int putenv(char *string);
    int setenv(const char *name, const char *value, int overwrite);//若name已经存在，如果overwrite为0，不更新name直接返回，否则更改name值
    int unsetenv(const char *name);
    char *secure_getenv(const char *name);
    int clearenv(void);//清除所有环境变量并且置environ为NULL
    #include <sys/auxv.h>
    unsigned long getauxval(unsigned long type);//程序执行时，ELF加载器向用户空间传递信息

# 进程运行时资源和运行轨迹控制

## setjmp, sigsetjmp, longjmp, siglongjmp

    #include <setjmp.h>
    int setjmp(jmp_buf env);
    int sigsetjmp(sigjmp_buf env, int savesigs);
    void longjmp(jmp_buf env, int val);
    void siglongjmp(sigjmp_buf env, int val);

###例子

    #include "apue.h"
    #include <setjmp.h>

    static void	f1(int, int, int, int);
    static void	f2(void);

    static jmp_buf	jmpbuffer;
    static int		globval;

    int
    main(void)
    {
    	int				autoval;
    	register int	regival;
    	volatile int	volaval;
    	static int		statval;

    	globval = 1; autoval = 2; regival = 3; volaval = 4; statval = 5;

    	if (setjmp(jmpbuffer) != 0) {
    		printf("after longjmp:\n");
    		printf("globval = %d, autoval = %d, regival = %d,"
    			" volaval = %d, statval = %d\n",
    			globval, autoval, regival, volaval, statval);
    		exit(0);
    	}

    	/*
    	* Change variables after setjmp, but before longjmp.
    	*/
    	globval = 95; autoval = 96; regival = 97; volaval = 98;
    	statval = 99;

    	f1(autoval, regival, volaval, statval);	/* never returns */
    	exit(0);
    }

    static void
    f1(int i, int j, int k, int l)
    {
    	printf("in f1():\n");
    	printf("globval = %d, autoval = %d, regival = %d,"
    		" volaval = %d, statval = %d\n", globval, i, j, k, l);
    	f2();
    }

    static void
    f2(void)
    {
    	longjmp(jmpbuffer, 1);
    }

## 资源控制getrlimit、 setrlimit

    struct rlimit {
    	rlim_t rlim_cur;  /* Soft limit */
    	rlim_t rlim_max;  /* Hard limit (ceiling for rlim_cur) */
    };

    #include <sys/time.h>
    #include <sys/resource.h>

    int getrlimit(int resource, struct rlimit *rlim);
    int setrlimit(int resource, const struct rlimit *rlim);

    int prlimit(pid_t pid, int resource, const struct rlimit *new_limit, struct rlimit *old_limit);

    #include <sys/time.h>
    #include <sys/resource.h>
    int getrusage(int who, struct rusage *usage);

获取进程运行时的资源使用情况

# 内存分配

    #include <stdlib.h>

    void *malloc(size_t size);
    void free(void *ptr);
    void *calloc(size_t nmemb, size_t size);
    void *realloc(void *ptr, size_t size);
    void *reallocarray(void *ptr, size_t nmemb, size_t size);

## brk, sbrk

    #include <unistd.h>
    int brk(void *addr);
    void *sbrk(intptr_t increment);

 >brk() and sbrk() change the location of the program break, which
       defines the end of the process's data segment (i.e., the program
       break is the first location after the end of the uninitialized data
       segment).  Increasing the program break has the effect of allocating
       memory to the process; decreasing the break deallocates memory.

## 其它内存操作函数

    #include <alloca.h>
    void *alloca(size_t size);//在栈上申请空间
    #include <malloc.h>
    int malloc_info(int options, FILE *stream);//获取内存分配信息
    #include <malloc.h>
    int malloc_trim(size_t pad);//把之前分配的内存还给系统
    #include <malloc.h>
    size_t malloc_usable_size(void *ptr);//返回调用malloc后实际分配的可用内存的大小
    int mallopt(int param, int value);//配置malloc参数

    #include <mcheck.h>
    int mcheck(void(*abortfunc)(enum mcheck_status mstatus));//通知malloc进行一致性检查。它可以检查出内存分配不匹配的情况
    int mcheck_pedantic(void(*abortfunc)(enum mcheck_status mstatus));
    void mcheck_check_all(void);
    enum mcheck_status mprobe(void *ptr);

## 内存调试API

    #include <mcheck.h>
    void mtrace(void);//为malloc等函数安装hook, 用于记录内存分配信息. 在需要内存泄漏检查的代码的结束调用void muntrace
    void muntrace(void);

    #include <stdlib.h>
    int posix_memalign(void **memptr, size_t alignment, size_t size);
    void *aligned_alloc(size_t alignment, size_t size);
    void *valloc(size_t size);

    #include <malloc.h>
    void *memalign(size_t alignment, size_t size);
    void *pvalloc(size_t size);

# 进程控制

## 进程ID

调度进程ID一般为0，也称为swapper，init进程为1

    #include <sys/types.h>
    #include <unistd.h>

    pid_t getpid(void);
    pid_t getppid(void);

    uid_t getuid(void);
    uid_t geteuid(void);
    int getresuid(uid_t *ruid, uid_t *euid, uid_t *suid);

    gid_t getgid(void);
    gid_t getegid(void);
    int getresgid(gid_t *rgid, gid_t *egid, gid_t *sgid);

    char *getlogin(void);//获取执行调用getlogin进程登录时的用户名

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

## 进程会计

#include <unistd.h>
int acct(const char *filename);

## 进程调度

#include <unistd.h>
int nice(int incr);//获取或者更改nice值

nice返回-1，errno为0是调用成功的，不为0则调用失败

#include <sys/resource.h>
int getpriority(int which, id_t who);//返回nice值
int setpriority(int which, id_t who, int value);//value是增加值，成功返回0，否则-1
which:
PRIO_PROCESS  进程
PRIO_PGRP     进程组
PRIO_USER     用户ID
who：
0 根据which表示调用进程、进程组或者用户，如果which作用于多个进程，则返回所有作用进程中优先级最高（最小nice值的）进程

## 进程时间

    struct tms {
    	clock_t tms_utime;
    	clock_t tms_stime;
    	clock_t tms_cutime;
    	clock_t tms_cstime;
    }
    #include <sys/times.h>
    clock_t times(struct tms *buf);//成功返回墙上时间

    #include "apue.h"
    #include <sys/times.h>

    static void	pr_times(clock_t, struct tms *, struct tms *);
    static void	do_cmd(char *);

    int
    main(int argc, char *argv[])
    {
    	int		i;

    	setbuf(stdout, NULL);
    	for (i = 1; i < argc; i++)
    		do_cmd(argv[i]);	/* once for each command-line arg */
    	exit(0);
    }

    static void
    do_cmd(char *cmd)		/* execute and time the "cmd" */
    {
    	struct tms	tmsstart, tmsend;
    	clock_t		start, end;
    	int			status;

    	printf("\ncommand: %s\n", cmd);

    	if ((start = times(&tmsstart)) == -1)	/* starting values */
    		err_sys("times error");

    	if ((status = system(cmd)) < 0)			/* execute command */
    		err_sys("system() error");

    	if ((end = times(&tmsend)) == -1)		/* ending values */
    		err_sys("times error");

    	pr_times(end - start, &tmsstart, &tmsend);
    	pr_exit(status);
    }

    static void
    pr_times(clock_t real, struct tms *tmsstart, struct tms *tmsend)
    {
    	static long		clktck = 0;

    	if (clktck == 0)	/* fetch clock ticks per second first time */
    		if ((clktck = sysconf(_SC_CLK_TCK)) < 0)
    			err_sys("sysconf error");

    	printf("  real:  %7.2f\n", real / (double)clktck);
    	printf("  user:  %7.2f\n",
    		(tmsend->tms_utime - tmsstart->tms_utime) / (double)clktck);
    	printf("  sys:   %7.2f\n",
    		(tmsend->tms_stime - tmsstart->tms_stime) / (double)clktck);
    	printf("  child user:  %7.2f\n",
    		(tmsend->tms_cutime - tmsstart->tms_cutime) / (double)clktck);
    	printf("  child sys:   %7.2f\n",
    		(tmsend->tms_cstime - tmsstart->tms_cstime) / (double)clktck);
    }

# utility

## 注入进程，ptrace

    long ptrace(enum __ptrace_request request, pid_t pid, void *addr, void *data);

## 定制进程能力

    int prctl(int option, unsigned long arg2, unsigned long arg3, unsigned long arg4, unsigned long arg5);

## 判断进程间资源共享

    int unshare(int flags);
    int kcmp(pid_t pid1, pid_t pid2, int type, unsigned long idx1, unsigned long idx2);

比较两个进程是否共享了内核资源

## 安全计算进程状态

    int seccomp(unsigned int operation, unsigned int flags, void *args);
    typedef void * scmp_filter_ctx;
    scmp_filter_ctx seccomp_init(uint32_t def_action);
    int seccomp_reset(scmp_filter_ctx ctx, uint32_t def_action);
    typedef void * scmp_filter_ctx;
    void seccomp_release(scmp_filter_ctx ctx);
    typedef void * scmp_filter_ctx;
    scmp_filter_ctx seccomp_init(uint32_t def_action);
    int seccomp_reset(scmp_filter_ctx ctx, uint32_t def_action);
    typedef void * scmp_filter_ctx;
    int seccomp_load(scmp_filter_ctx ctx);
    typedef void * scmp_filter_ctx;
    int SCMP_SYS(syscall_name);
    struct scmp_arg_cmp SCMP_CMP(unsigned int arg, enum scmp_compare op, ...);
    struct scmp_arg_cmp SCMP_A0(enum scmp_compare op, ...);
    struct scmp_arg_cmp SCMP_A1(enum scmp_compare op, ...);
    struct scmp_arg_cmp SCMP_A2(enum scmp_compare op, ...);
    struct scmp_arg_cmp SCMP_A3(enum scmp_compare op, ...);
    struct scmp_arg_cmp SCMP_A4(enum scmp_compare op, ...);
    struct scmp_arg_cmp SCMP_A5(enum scmp_compare op, ...);

    int seccomp_rule_add(scmp_filter_ctx ctx, uint32_t action, int syscall, unsigned int arg_cnt, ...);
    int seccomp_rule_add_exact(scmp_filter_ctx ctx, uint32_t action, int syscall, unsigned int arg_cnt, ...);

    int seccomp_rule_add_array(scmp_filter_ctx ctx, uint32_t action, int syscall, unsigned int arg_cnt, const struct scmp_arg_cmp *arg_array);
    int seccomp_rule_add_exact_array(scmp_filter_ctx ctx, uint32_t action, int syscall, unsigned int arg_cnt,const struct scmp_arg_cmp *arg_array);
    int seccomp_syscall_resolve_name(const char *name);
    int seccomp_syscall_resolve_name_arch(uint32_t arch_token, const char *name);
    int seccomp_syscall_resolve_name_rewrite(uint32_t arch_token, const char *name);
    char *seccomp_syscall_resolve_num_arch(uint32_t arch_token, int num);

    int SCMP_SYS(syscall_name);

    int seccomp_syscall_priority(scmp_filter_ctx ctx, int syscall, uint8_t priority);

    typedef void * scmp_filter_ctx;
    enum scmp_filter_attr;

    int seccomp_attr_set(scmp_filter_ctx ctx, enum scmp_filter_attr attr, uint32_t value);
    int seccomp_attr_get(scmp_filter_ctx ctx, enum scmp_filter_attr attr, uint32_t *value);

    int seccomp_export_bpf(const scmp_filter_ctx ctx, int fd);
    int seccomp_export_pfc(const scmp_filter_ctx ctx, int fd);

## 进程所有线程退出，exit_group

    #include <linux/unistd.h>
    void exit_group(int status);

让进程中所有线程退出
