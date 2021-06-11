---
title: Linux tips
comments: true
---

# 出错处理

    extern int *_ _errno_location(void);
    #define errno (*_ _errno_location())
    #include <string.h>
    char *strerror(int errnum);
    void perror(const char *msg);

首先输出msg，然后冒号和空格，加上当前errno值对应的信息

<!--more-->

# 特殊按键组合

    CTRL+D  输入输出结束
    CTRL+C  中断
    CTRL+\  退出

# Linux标准关系

    Single UNIX Specification > POSIX.1 > XSI

    SVR4 UNIX System V Release4 UNIX标准

# 进程时间概念

日历时间 time_t

进程时间，也就是CPU时间，clock_t，可以用sysconf函数得到每秒钟时间滴答数

    * 时钟时间， 即墙上始终时间，进程运行时间总量，包括被调度，不运行时间
    * 用户cpu时间，执行用户指令时间，
    * 系统cpu时间，执行系统调用时间

用户CPU时间+系统CPU时间=CPU时间

CPU时间+调度时间+休眠时间=时钟时间

# Linux系统参数

    #include <unistd.h>
    long sysconf(int name);
    long fpathconf(int fd, int name);
    long pathconf(const char *path, int name);
    size_t confstr(int name, char *buf, size_t len);//获取配置相关说明

出错都返回-1

## 路径名长度

    #include "apue.h"
    #include <errno.h>
    #include <limits.h>

    #ifdef	PATH_MAX
    static long	pathmax = PATH_MAX;
    #else
    static long	pathmax = 0;
    #endif

    static long	posix_version = 0;
    static long	xsi_version = 0;

    /* If PATH_MAX is indeterminate, no guarantee this is adequate */
    #define	PATH_MAX_GUESS	1024

    char *
    path_alloc(size_t *sizep) /* also return allocated size, if nonnull */
    {
    	char	*ptr;
    	size_t	size;

    	if (posix_version == 0)
    		posix_version = sysconf(_SC_VERSION);

    	if (xsi_version == 0)
    		xsi_version = sysconf(_SC_XOPEN_VERSION);

    	if (pathmax == 0) {		/* first time through */
    		errno = 0;
    		if ((pathmax = pathconf("/", _PC_PATH_MAX)) < 0) {
    			if (errno == 0)
    				pathmax = PATH_MAX_GUESS;	/* it's indeterminate */
    			else
    				err_sys("pathconf error for _PC_PATH_MAX");
    		}
    		else {
    			pathmax++;		/* add one since it's relative to root */
    		}
    	}

    	/*
    	* Before POSIX.1-2001, we aren't guaranteed that PATH_MAX includes
    	* the terminating null byte.  Same goes for XPG3.
    	*/
    	if ((posix_version < 200112L) && (xsi_version < 4))
    		size = pathmax + 1;
    	else
    		size = pathmax;

    	if ((ptr = malloc(size)) == NULL)
    		err_sys("malloc error for pathname");

    	if (sizep != NULL)
    		*sizep = size;
    	return(ptr);
    }

## 最多能打开多少文件数目

    #include "apue.h"
    #include <errno.h>
    #include <limits.h>

    #ifdef	OPEN_MAX
    static long	openmax = OPEN_MAX;
    #else
    static long	openmax = 0;
    #endif

    /*
    * If OPEN_MAX is indeterminate, this might be inadequate.
    */
    #define	OPEN_MAX_GUESS	256

    long
    open_max(void)
    {
    	if (openmax == 0) {		/* first time through */
    		errno = 0;
    		if ((openmax = sysconf(_SC_OPEN_MAX)) < 0) {
    			if (errno == 0)
    				openmax = OPEN_MAX_GUESS;	/* it's indeterminate */
    			else
    				err_sys("sysconf error for _SC_OPEN_MAX");
    		}
    	}
    	return(openmax);
    }

# 系统日志设施

系统提供的日志设施一方面是方便没有控制终端的守护进程处理出错信息，另一方面，整合各个进程的日志信息

    * 内核进程可以调用log函数，产生的日志信息在/dev/klog，用户进程可以读这个文件
    * 本地进程可以用syslog函数产生的消息发往/dev/log这个UNIX域数据报套接字
    * 远程进程可以将syslog产生的日志发往UDP端口514。

## openlog、syslog、closelog、setlogmask、vsyslog、klogctl

    #include <syslog.h>
    void openlog(const char *ident, int option, int facility);//可选，syslog会进行判断
    void syslog(int priority, const char *format, ...);
    void closelog(void);
    int setlogmask(int maskpri);
    void vsyslog(int priority, const char *format, va_list arg);

    #include <sys/klog.h>
    int klogctl(int type, char *bufp, int len);

ident用来标志产生日志信息的进程
option 指定各种选项的位屏蔽

option | 说明
-------|------
LOG_CONS  |   若消息不能通过UNIX域数据报发送到syslogd，则消息写到控制台
LOG_NDELAY  |  立即打开到syslogd的UNIX域数据报套接字，不等到第一条消息已经被记录时才打开
LOG_NOWAIT  |  不要等待在将消息写入日志过程中可能已经创建的子进程。因为在syslog调用wait时，应用进程可能已经获得子进程状态，这种处理阻止了捕捉SIGCHLD信号进程之间的冲突
LOG_ODELAY  |  第一条消息被记录前延迟打开至syslogd守护进程的连接
LOG_PERROR  |  除将日志消息发往syslogd外，还写到标准出错
LOG_PID  |  每条消息包含进程ID

facility:

facility | 说明
---------|-----
LOG_AUDIT  |  审计设施
LOG_AUTH  | 授权程序： login、su、getty等
LOG_AUTHPRIV  | 授权程序: login、su、getty等，但写日志文件有权限限制
LOG_CONSOLE  | 消息写入/dev/console
LOG_CRON  | cron和at
LOG_DAEMON  | 系统守护进程： inetd、routed等
LOG_FTP  | FTP守护进程
LOG_KERN  | 内核产生的消息
LOG_LOCAL0  |保留本地使用
LOG_LOCAL1  |保留本地使用
LOG_LOCAL2  |保留本地使用
LOG_LOCAL3  |保留本地使用
LOG_LOCAL4  |保留本地使用
LOG_LOCAL5  |保留本地使用
LOG_LOCAL6  |保留本地使用
LOG_LOCAL7  |保留本地使用
LOG_LPR  | 行式打印机系统：lpd、lpc等
LOG_MAIL  | 邮件系统
LOG_NEWS  | USENET网络新闻系统
LOG_NTP  | 网络时间协议系统
LOG_SECURITY  | 安全子系统
LOG_SYSLOG  | syslogd守护进程本身
LOG_USER  | 其它用户进程消息
LOG_UUCP  | UUCP系统

level:

level | 说明
---------|---------------------------------
LOG_EMERG  | 紧急（系统不可使用）（最高优先级）
LOG_ALERT  | 必须立即修复的情况
LOG_CRIT  | 严重情况（硬件设备出错）
LOG_ERR  | 出错情况
LOG_WARNING  | 警告情况
LOG_NOTICE  | 正常但是重要情况
LOG_INFO  | 信息性消息
LOG_DEBUG  | 调试消息

syslog prioryty参数是facility和level的组合

setlogmask设置打印log的优先级屏蔽字，返回之前日志记录优先级屏蔽字

创建临时文件后立刻unlink可以在程序退出后删除文件。

# 环境变量

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

# getopt

    #include <unistd.h>
    int getopt(int argc, char * const argv[], const char *optstring);
    extern char *optarg;
    extern int optind, opterr, optopt;

    #include <getopt.h>
    int getopt_long(int argc, char * const argv[], const char *optstring, const struct option *longopts, int *longindex);

    int getopt_long_only(int argc, char * const argv[], const char *optstring, const struct option *longopts, int *longindex);
    int getsubopt(char **optionp, char * const *tokens, char **valuep);

# setjmp, sigsetjmp, longjmp, siglongjmp

    #include <setjmp.h>
    int setjmp(jmp_buf env);
    int sigsetjmp(sigjmp_buf env, int savesigs);
    void longjmp(jmp_buf env, int val);
    void siglongjmp(sigjmp_buf env, int val);

## 例子

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

# 资源控制getrlimit、 setrlimit

    struct rlimit {
    	rlim_t rlim_cur;  /* Soft limit */
    	rlim_t rlim_max;  /* Hard limit (ceiling for rlim_cur) */
    };

    #include <sys/time.h>
    #include <sys/resource.h>

    int getrlimit(int resource, struct rlimit *rlim);
    int setrlimit(int resource, const struct rlimit *rlim);

    int prlimit(pid_t pid, int resource, const struct rlimit *new_limit, struct rlimit *old_limit);

# 运行时资源使用情况，getrusage
    #include <sys/time.h>
    #include <sys/resource.h>
    int getrusage(int who, struct rusage *usage);

获取进程运行时的资源使用情况

# 获取设置用户进程打开文件数目

    #include <ulimit.h>
    long ulimit(int cmd, long newlimit);

# fork, exec, signal, thread

# 辅助函数

    #include <stddef.h>
    size_t offsetof(type, member);

获取一个struct中member位置

# 读写内核参数

    #include <unistd.h>
    #include <linux/sysctl.h>
    int _sysctl(struct __sysctl_args *args);

# 获取系统信息

    #include <sys/utsname.h>
    int uname(struct utsname *name);

# 获取登录名

  char *getlogin(void);

# 链接库

        typedef struct {
            const char *dli_fname;  /* Pathname of shared object that
                                       contains address */
            void       *dli_fbase;  /* Base address at which shared
                                       object is loaded */
            const char *dli_sname;  /* Name of symbol whose definition
                                       overlaps addr */
            void       *dli_saddr;  /* Exact address of symbol named
                                       in dli_sname */
        } Dl_info;

        typedef struct  {
            Elf64_Word    st_name;     /* Symbol name */
            unsigned char st_info;     /* Symbol type and binding */
            unsigned char st_other;    /* Symbol visibility */
            Elf64_Section st_shndx;    /* Section index */
            Elf64_Addr    st_value;    /* Symbol value */
            Elf64_Xword   st_size;     /* Symbol size */
        } Elf64_Sym;

        struct link_map {
            ElfW(Addr) l_addr;  /* Difference between the
                                   address in the ELF file and
                                   the address in memory */
            char      *l_name;  /* Absolute pathname where
                                   object was found */
            ElfW(Dyn) *l_ld;    /* Dynamic section of the
                                   shared object */
            struct link_map *l_next, *l_prev;
                                /* Chain of loaded objects */

            /* Plus additional fields private to the
               implementation */
        };

        struct dl_phdr_info {
            ElfW(Addr)        dlpi_addr;  /* Base address of object */
            const char       *dlpi_name;  /* (Null-terminated) name of
                                             object */
            const ElfW(Phdr) *dlpi_phdr;  /* Pointer to array of
                                             ELF program headers
                                             for this object */
            ElfW(Half)        dlpi_phnum; /* # of items in dlpi_phdr */

            /* The following fields were added in glibc 2.4, after the first
               version of this structure was available.  Check the size
               argument passed to the dl_iterate_phdr callback to determine
               whether or not each later member is available.  */

            unsigned long long int dlpi_adds;
                            /* Incremented when a new object may
                               have been added */
            unsigned long long int dlpi_subs;
                            /* Incremented when an object may
                               have been removed */
            size_t dlpi_tls_modid;
                            /* If there is a PT_TLS segment, its module
                               ID as used in TLS relocations, else zero */
            void  *dlpi_tls_data;
                            /* The address of the calling thread's instance
                               of this module's PT_TLS segment, if it has
                               one and it has been allocated in the calling
                               thread, otherwise a null pointer */
    };

    typedef struct {
        Elf32_Word  p_type;    /* Segment type */
        Elf32_Off   p_offset;  /* Segment file offset */
        Elf32_Addr  p_vaddr;   /* Segment virtual address */
        Elf32_Addr  p_paddr;   /* Segment physical address */
        Elf32_Word  p_filesz;  /* Segment size in file */
        Elf32_Word  p_memsz;   /* Segment size in memory */
        Elf32_Word  p_flags;   /* Segment flags */
        Elf32_Word  p_align;   /* Segment alignment */
    } Elf32_Phdr;

    struct link_map {
        ElfW(Addr) l_addr;  /* Difference between the
                               address in the ELF file and
                               the address in memory */
        char      *l_name;  /* Absolute pathname where
                               object was found */
        ElfW(Dyn) *l_ld;    /* Dynamic section of the
                               shared object */
        struct link_map *l_next, *l_prev;
                            /* Chain of loaded objects */

        /* Plus additional fields private to the
           implementation */
    };

    typedef struct {
        size_t dls_size;           /* Size in bytes of
                                      the whole buffer */
        unsigned int dls_cnt;      /* Number of elements
                                      in 'dls_serpath' */
        Dl_serpath dls_serpath[1]; /* Actually longer,
                                      'dls_cnt' elements */
    } Dl_serinfo;

    typedef struct {
        char *dls_name;            /* Name of library search
                                      path directory */
        unsigned int dls_flags;    /* Indicates where this
                                      directory came from */
    } Dl_serpath;

    #include <dlfcn.h>
    void *dlopen(const char *filename, int flags);
    int dlclose(void *handle);
    void *dlmopen (Lmid_t lmid, const char *filename, int flags);
    char *dlerror(void);
    void *dlsym(void *handle, const char *symbol);
    void *dlvsym(void *handle, char *symbol, char *version);
    int dladdr(void *addr, Dl_info *info);
    int dladdr1(void *addr, Dl_info *info, void **extra_info, int flags);

    #include <link.h>
    int dl_iterate_phdr(int (*callback) (struct dl_phdr_info *info, size_t size, void *data), void *data);
    int dlinfo(void *handle, int request, void *info);

Link with -ldl.

# 进程性能剖析

    #include <unistd.h>
    int profil(unsigned short *buf, size_t bufsiz, size_t offset, unsigned int scale);

    #include <linux/perf_event.h>
    #include <linux/hw_breakpoint.h>
    int perf_event_open(struct perf_event_attr *attr, pid_t pid, int cpu, int group_fd, nsigned long flags);

# 上下文环境，getcontext、setcontext

    #include <ucontext.h>
    int getcontext(ucontext_t *ucp);
    int setcontext(const ucontext_t *ucp);

# 特殊文件

## 接收信号的文件描述符

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

## 内存中创建一个匿名文件

    #include <sys/memfd.h>
    int memfd_create(const char *name, unsigned int flags);

## 用户空间页错误文件描述符

    int userfaultfd(int flags);创建一个文件描述符来处理用户空间的页错误


# 模式匹配

# shell 模式匹配

    #include <fnmatch.h>
    int fnmatch(const char *pattern, const char *string, int flags);

    typedef struct {
        size_t   gl_pathc;    /* Count of paths matched so far  */
        char   **gl_pathv;    /* List of matched pathnames.  */
        size_t   gl_offs;     /* Slots to reserve in gl_pathv.  */
    } glob_t;

    #include <glob.h>
    int glob(const char *pattern, int flags, int (*errfunc) (const char *epath, int eerrno), glob_t *pglob);
    void globfree(glob_t *pglob);


    #include <wordexp.h>
    int wordexp(const char *s, wordexp_t *p, int flags);
    void wordfree(wordexp_t *p);

# 冲洗

## 脏页冲洗设置

    struct file_handle {
        unsigned int  handle_bytes;   /* Size of f_handle [in, out] */
        int           handle_type;    /* Handle type [out] */
        unsigned char f_handle[0];    /* File identifier (sized by
                                         caller) [out] */
    };

    #include <sys/kdaemon.h>
    int bdflush(int func, long *address);
    int bdflush(int func, long data);
    start, flush, or tune buffer-dirty-flush daemon

    #include <unistd.h>
    int fsync(int fd);
    int fdatasync(int fd);
    void sync(void);
    int syncfs(int fd);
    int sync_file_range(int fd, off64_t offset, off64_t nbytes, unsigned int flags);
    int msync(void *addr, size_t length, int flags);
    int sync_file_range(int fd, off64_t offset, off64_t nbytes, unsigned int flags);

* sync只将修改过的块缓冲区排入写队列，就返回，不等实际写磁盘操作结束，会更新文件系统属性。
* fsync函数只对fd关联文件起作用，会等待磁盘写操作结束后返回，同步更新文件属性。
* fdatasync类似fsync，但是只更新数据部分。
* syncfs和sync类似，但是不会更新文件系统属性
* sync_file_range可以精细化控制文件同步部分
* msync文件内存映射同步

## 标准IO缓冲和fork

标准I/O缓冲会在fork后复制到子进程

## _exit和exit区别：

* exit会冲洗标准IO缓冲，_exit不会

# utility

## 重启被信号中断的进程

    int restart_syscall(void);

被信号中断后重启系统调用

## indirect system call

    #include <unistd.h>
    #include <sys/syscall.h>   /* For SYS_xxx definitions */
    long syscall(long number, ...);

## 允许信号中断系统调用

    int siginterrupt(int sig, int flag);

## 从vector获取值

    unsigned long getauxval(unsigned long type); retrieve a value from the auxiliary vector

# 本地化

    #include <locale.h>
    char *setlocale(int category, const char *locale);
    locale_t uselocale(locale_t newloc);
    #include <stdlib.h>
    int rpmatch(const char *response);
    #include <locale.h>
    struct lconv *localeconv(void);
    locale_t newlocale(int category_mask, const char *locale, locale_t base);
    void freelocale(locale_t locobj);
    locale_t duplocale(locale_t locobj);

    #include <langinfo.h>

    char *nl_langinfo(nl_item item);
    char *nl_langinfo_l(nl_item item, locale_t locale);

    #include <libintl.h>

    char * gettext (const char * msgid);
    char * dgettext (const char * domainname, const char * msgid);
    char * dcgettext (const char * domainname, const char * msgid, int category);

    char * ngettext (const char * msgid, const char * msgid_plural, unsigned long int n);
    char * dngettext (const char * domainname, const char * msgid, const char * msgid_plural, unsigned long int n);
    char * dcngettext (const char * domainname, const char * msgid, const char * msgid_plural,unsigned long int n, int category);
    char * bindtextdomain (const char * domainname, const char * dirname);
    char * textdomain (const char * domainname);
