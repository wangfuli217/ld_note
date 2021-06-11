---
title: IPC
comments: true
---

# 管道

    #include <unistd.h>
    #include <fcntl.h>              /* Obtain O_* constant definitions */

    int pipe(int pipefd[2]);
    int pipe2(int pipefd[2], int flags);

半双工，只能在公共祖先两个进程之间，pipefd[0] 为读而打开，pipefd[1]为写而打开

* 读一个写端已经被关闭的管道时，所有数据读取后，read返回0，表示文件结束。可以在关闭后再复制文件描述符打开。
* 写一个读端被关闭的管道，产生信号SIGPIPE，如果忽略该信号或者捕捉该信号并从其处理函数返回后，write返回-1，errno设置为EPIPE。
* 读一个没有数据的管道将阻塞。

<!--more-->

PIPE_BUF规定了内核管道缓冲区大小。如果写管道一次性小于PIPE_BUF，则不会和其它进程对同一管道或FIFO的write操作产生交叉。注意管道缓冲区不是管道大小，管道没有大小

## PIPE例子

    #include "apue.h"
    #include <sys/wait.h>

    #define	DEF_PAGER	"/bin/more"		/* default pager program */

    int
    main(int argc, char *argv[])
    {
    	int		n;
    	int		fd[2];
    	pid_t	pid;
    	char	*pager, *argv0;
    	char	line[MAXLINE];
    	FILE	*fp;

    	if (argc != 2)
    		err_quit("usage: a.out <pathname>");

    	if ((fp = fopen(argv[1], "r")) == NULL)
    		err_sys("can't open %s", argv[1]);
    	if (pipe(fd) < 0)
    		err_sys("pipe error");

    	if ((pid = fork()) < 0) {
    		err_sys("fork error");
    	} else if (pid > 0) {								/* parent */
    		close(fd[0]);		/* close read end */

    		/* parent copies argv[1] to pipe */
    		while (fgets(line, MAXLINE, fp) != NULL) {
    			n = strlen(line);
    			if (write(fd[1], line, n) != n)
    				err_sys("write error to pipe");
    		}
    		if (ferror(fp))
    			err_sys("fgets error");

    		close(fd[1]);	/* close write end of pipe for reader */

    		if (waitpid(pid, NULL, 0) < 0)
    			err_sys("waitpid error");
    		exit(0);
    	} else {										/* child */
    		close(fd[1]);	/* close write end */
    		if (fd[0] != STDIN_FILENO) {
    			if (dup2(fd[0], STDIN_FILENO) != STDIN_FILENO)
    				err_sys("dup2 error to stdin");
    			close(fd[0]);	/* don't need this after dup2 */
    		}

    		/* get arguments for execl() */
    		if ((pager = getenv("PAGER")) == NULL)
    			pager = DEF_PAGER;
    		if ((argv0 = strrchr(pager, '/')) != NULL)
    			argv0++;		/* step past rightmost slash */
    		else
    			argv0 = pager;	/* no slash in pager */

    		if (execl(pager, argv0, (char *)0) < 0)
    			err_sys("execl error for %s", pager);
    	}
    	exit(0);
    }

    #include "apue.h"
    #include <sys/wait.h>

    #define	PAGER	"${PAGER:-more}" /* environment variable, or default */

    int
    main(int argc, char *argv[])
    {
    	char	line[MAXLINE];
    	FILE	*fpin, *fpout;

    	if (argc != 2)
    		err_quit("usage: a.out <pathname>");
    	if ((fpin = fopen(argv[1], "r")) == NULL)
    		err_sys("can't open %s", argv[1]);

    	if ((fpout = popen(PAGER, "w")) == NULL)
    		err_sys("popen error");

    	/* copy argv[1] to pager */
    	while (fgets(line, MAXLINE, fpin) != NULL) {
    		if (fputs(line, fpout) == EOF)
    			err_sys("fputs error to pipe");
    	}
    	if (ferror(fpin))
    		err_sys("fgets error");
    	if (pclose(fpout) == -1)
    		err_sys("pclose error");

    	exit(0);
    }

## 协同进程

    #include "apue.h"

    int
    main(void)
    {
    	int		n, int1, int2;
    	char	line[MAXLINE];

    	while ((n = read(STDIN_FILENO, line, MAXLINE)) > 0) {
    		line[n] = 0;		/* null terminate */
    		if (sscanf(line, "%d%d", &int1, &int2) == 2) {
    			sprintf(line, "%d\n", int1 + int2);
    			n = strlen(line);
    			if (write(STDOUT_FILENO, line, n) != n)
    				err_sys("write error");
    		} else {
    			if (write(STDOUT_FILENO, "invalid args\n", 13) != 13)
    				err_sys("write error");
    		}
    	}
    	exit(0);
    }

    #include "apue.h"

    static void	sig_pipe(int);		/* our signal handler */

    int
    main(void)
    {
    	int		n, fd1[2], fd2[2];
    	pid_t	pid;
    	char	line[MAXLINE];

    	if (signal(SIGPIPE, sig_pipe) == SIG_ERR)
    		err_sys("signal error");

    	if (pipe(fd1) < 0 || pipe(fd2) < 0)
    		err_sys("pipe error");

    	if ((pid = fork()) < 0) {
    		err_sys("fork error");
    	} else if (pid > 0) {							/* parent */
    		close(fd1[0]);
    		close(fd2[1]);

    		while (fgets(line, MAXLINE, stdin) != NULL) {
    			n = strlen(line);
    			if (write(fd1[1], line, n) != n)
    				err_sys("write error to pipe");
    			if ((n = read(fd2[0], line, MAXLINE)) < 0)
    				err_sys("read error from pipe");
    			if (n == 0) {
    				err_msg("child closed pipe");
    				break;
    			}
    			line[n] = 0;	/* null terminate */
    			if (fputs(line, stdout) == EOF)
    				err_sys("fputs error");
    		}

    		if (ferror(stdin))
    			err_sys("fgets error on stdin");
    		exit(0);
    	} else {									/* child */
    		close(fd1[1]);
    		close(fd2[0]);
    		if (fd1[0] != STDIN_FILENO) {
    			if (dup2(fd1[0], STDIN_FILENO) != STDIN_FILENO)
    				err_sys("dup2 error to stdin");
    			close(fd1[0]);
    		}

    		if (fd2[1] != STDOUT_FILENO) {
    			if (dup2(fd2[1], STDOUT_FILENO) != STDOUT_FILENO)
    				err_sys("dup2 error to stdout");
    			close(fd2[1]);
    		}
    		if (execl("./add2", "add2", (char *)0) < 0)
    			err_sys("execl error");
    	}
    	exit(0);
    }

    static void
    sig_pipe(int signo)
    {
    	printf("SIGPIPE caught\n");
    	exit(1);
    }
    #include "apue.h"

    int
    main(void)
    {
    	int		int1, int2;
    	char	line[MAXLINE];

    	while (fgets(line, MAXLINE, stdin) != NULL) {
    		if (sscanf(line, "%d%d", &int1, &int2) == 2) {
    			if (printf("%d\n", int1 + int2) == EOF)
    				err_sys("printf error");
    		} else {
    			if (printf("invalid args\n") == EOF)
    				err_sys("printf error");
    		}
    	}
    	exit(0);
    }

协同进程改成标准IO因为标准IO默认是全缓存，导致父进程和子进程同时阻塞在读，可以改成

    static void
    sig_pipe(int signo)
    {
    	printf("SIGPIPE caught\n");
    	exit(1);
    }
    #include "apue.h"

    int
    main(void)
    {
    	int		int1, int2;
    	char	line[MAXLINE];
      if (setvbuf(stdin, NULL, _IOLBF, 0) != 0)
        err_sys("setvbuf error");
      if (setvbuf(stdout, NULL, _IOLBF, 0) != 0)
        err_sys("setvbuf error");
    	while (fgets(line, MAXLINE, stdin) != NULL) {
    		if (sscanf(line, "%d%d", &int1, &int2) == 2) {
    			if (printf("%d\n", int1 + int2) == EOF)
    				err_sys("printf error");
    		} else {
    			if (printf("invalid args\n") == EOF)
    				err_sys("printf error");
    		}
    	}
    	exit(0);
    }

# FIFO

    #include <sys/stat.h>
    int mkfifo(const char *path, mode_t mode);
    int mkfifoat(int fddir, const char *path, mode_t mode);

半双工，可以在任意进程之间可以用来通信

path是绝对路径，忽略fddir，如果是相对路径，并且fddir为AT_FDCWD，则相对当前工作路径，否则相对fddir指向的路径。

写一个无读端的FIFO，产生SIGPIPE，若FIFO最后一个写进程关闭了该FIFO，则读端产生文件结束标志。

PIPE_BUF说明了可被原子写入FIFO的最大数量。

没有指定O_NONBLOCK

* 只读open管道时会阻塞到其它进程写open这个管道
* 只写open管道会阻塞到其它进程读open这个管道

指定O_NONBLOCK

* 读open立即返回
* 写open时，假如没有读端，open返回-1， errno置为ENXIO

管道和命名管道(FIFO)都是半双工，但是有全双工管道和全双工命名管道。进程终止时管道将被销毁，FIFO名字留在系统中，但是数据被删除。IPC则不会。

int mknod(const char *pathname, mode_t mode, dev_t dev);
int mknodat(int dirfd, const char *pathname, mode_t mode, dev_t dev);

# XSI IPC

消息队列、信号量、共享存储

优点、优缺点：

IPC结构存在系统范围内，没有引用计数。 XSI IPC在系统中没有名字，不能配合select、poll、epoll使用。

    int ipc(unsigned int call, int first, int second, int third, void *ptr, long fifth);

IPC结构标志的标识符是连续的

key为IPC_PRIVATE总是创建一个新的IPC结构，这个结构fork，exec后都可以用。
创建一个新的IPC结构，而且要确保没有引用具有同一标识符的现有IPC结构，必须在flag同时指定IPC_CREAT和IPC_EXCL，如果IPC结构已经存在会出错返回，返回EEXIST


    #include <sys/ipc.h>
    key_t ftok(const char *path, int id);

按照路径取其stat结构中st_dev和st_ino字段和id结合起来，对于不同的两个路径，如果使用同一个项目id，可能产生相同的键。

    struct ipc_perm {
        key_t          __key;    /* Key supplied to shmget(2) */
        uid_t          uid;      /* Effective UID of owner */
        gid_t          gid;      /* Effective GID of owner */
        uid_t          cuid;     /* Effective UID of creator */
        gid_t          cgid;     /* Effective GID of creator */
        unsigned short mode;     /* Permissions + SHM_DEST and
                                    SHM_LOCKED flags */
        unsigned short __seq;    /* Sequence number */
    };

mode不能包含执行权限

    struct shmid_ds {
        struct ipc_perm shm_perm;    /* Ownership and permissions */
        size_t          shm_segsz;   /* Size of segment (bytes) */
        time_t          shm_atime;   /* Last attach time */
        time_t          shm_dtime;   /* Last detach time */
        time_t          shm_ctime;   /* Last change time */
        pid_t           shm_cpid;    /* PID of creator */
        pid_t           shm_lpid;    /* PID of last shmat(2)/shmdt(2) */
        shmatt_t        shm_nattch;  /* No. of current attaches */
        ...
    };

    struct shminfo {
        unsigned long shmmax; /* Maximum segment size */
        unsigned long shmmin; /* Minimum segment size;
                                 always 1 */
        unsigned long shmmni; /* Maximum number of segments */
        unsigned long shmseg; /* Maximum number of segments
                                 that a process can attach;
                                 unused within kernel */
        unsigned long shmall; /* Maximum number of pages of
                                 shared memory, system-wide */
    };

    struct shm_info {
        int           used_ids; /* # of currently existing
                                   segments */
        unsigned long shm_tot;  /* Total number of shared
                                   memory pages */
        unsigned long shm_rss;  /* # of resident shared
                                   memory pages */
        unsigned long shm_swp;  /* # of swapped shared
                                   memory pages */
        unsigned long swap_attempts;
                                /* Unused since Linux 2.4 */
        unsigned long swap_successes;
                                /* Unused since Linux 2.4 */
    };

## 消息队列

### msgget、msgctl

    #include <sys/types.h>
    #include <sys/ipc.h>
    #include <sys/msg.h>

    int msgget(key_t key, int msgflg);
    int msgctl(int msqid, int cmd, struct msqid_ds *buf);

msqid：

*  IPC_STAT
*  IPC_SET
*  IPC_RMID 有效用户ID等于msg_perm.cuid或msg_perm.uid或者是超级用户进程

### msgsnd、msgrcv

    struct msgp {
        long mtype;       /* message type, must be > 0 */
        char mtext[1];    /* message data */
    };

    int msgsnd(int msqid, const void *msgp, size_t msgsz, int msgflg);
    ssize_t msgrcv(int msqid, void *msgp, size_t msgsz, long msgtyp, int msgflg);

msgflag:

* IPC_NOWAIT 则调用立即返回，若无空间，出错返回EAGAIN。否则一直阻塞到有空间容纳要发送的消息，或者从系统中删除了此队列，或者被信号中断。被删除返回EIDRM错误，信号中断返回EINTR

**消息队列没有引用计数。**

若读取消息msgflag设置了MSG_NOERROR，若返回消息大于msgsz，则消息会截断，不会通知，否则出错返回E2BIG，消息仍在队列中。msgflag设置为IPC_NOWAIT，若没有指定消息返回-1，errno置为ENOMSG

msgtyp指定想要哪种消息

* type == 0 返回队列中第一个消息
* type > 0 返回消息类型为type的第一个消息
* type < 0 返回消息类型值小于type绝对值的消息，如果有若干，则取类型值最小的消息。


## 信号量

### semget、semctl

    union semun {
        int              val;    /* Value for SETVAL */
        struct semid_ds *buf;    /* Buffer for IPC_STAT, IPC_SET */
        unsigned short  *array;  /* Array for GETALL, SETALL */
        struct seminfo  *__buf;  /* Buffer for IPC_INFO
                                    (Linux-specific) */
    };

    struct ipc_perm {
        key_t          __key; /* Key supplied to semget(2) */
        uid_t          uid;   /* Effective UID of owner */
        gid_t          gid;   /* Effective GID of owner */
        uid_t          cuid;  /* Effective UID of creator */
        gid_t          cgid;  /* Effective GID of creator */
        unsigned short mode;  /* Permissions */
        unsigned short __seq; /* Sequence number */
    };

    struct shmid_ds {
        struct ipc_perm shm_perm;    /* Ownership and permissions */
        size_t          shm_segsz;   /* Size of segment (bytes) */
        time_t          shm_atime;   /* Last attach time */
        time_t          shm_dtime;   /* Last detach time */
        time_t          shm_ctime;   /* Last change time */
        pid_t           shm_cpid;    /* PID of creator */
        pid_t           shm_lpid;    /* PID of last shmat(2)/shmdt(2) */
        shmatt_t        shm_nattch;  /* No. of current attaches */
        ...
    };

    #include <sys/types.h>
    #include <sys/ipc.h>
    #include <sys/sem.h>

    int semget(key_t key, int nsems, int semflg);

    int semctl(int semid, int semnum, int cmd, .../* union semun arg */);

IPC_STAT

* 获取semid_ds结构，存储在arg.buf指向结构中

IPC_SET

* 设置sem_perm.uid, sem_perm.gid, sem_perm.mode。进程有效ID等于sem_perm.cuid或sem_perm.uid或者是超级进程

IPC_RMID

* 删除是立即生效的，删除时仍在使用此信号量的其它进程，下次试图对此信号量集合进行操作时，出错返回EIDRM。进程有效ID等于sem_perm.cuid或sem_perm.uid或者是超级进程

GETVAL

* 返回semnum中semval

SETVAL

* 设置semnum semval

GETPID

* 获取semnum中sempid

GETNCNT

* 获取semnum中semncnt

GETZCNT

* 获取semnum中semzcnt

GETALL

* 获取集合中所有信号量值，存储在arg.array

SETALL

* 设置集合中所有信号量值为arg.array

**信号量的创建semget和初始化semctl不是原子的。**

### semop、semtimedop

    struct sembuf {
      unsigned short sem_num;
      short          sem_op;
      short          sem_flag;//IPC_NOWAIT, SEM_UNDO
    }

    int semop(int semid, struct sembuf *sops, size_t nsops);
    int semtimedop(int semid, struct sembuf *sops, size_t nsops, const struct timespec *timeout);

sem_op为正值时，如果设置了SEM_UNDO，则从此进程信号量调整值中减去sem_op，否则加到信号量值上。
如果信号量值小于sem_op绝对值

* 若指定了IPC_NOWAIT，semop出错返回EAGAIN
* 未指定IPC_NOWAIT，该信号量semncnt值加1，然后挂起进程直到一下事件发生：
   1. 此信号量值大于sem_op绝对值，此信号量的semncnt减1，并且如果指定了SEM_UNDO，则从信号量值中加上sem_op，否则从信号量值减去sem_op
   2. 系统中删除了此信号量，此时返回出错返回EIDRM
   3. 被信号中断返回，此时semncnt也减1，sem_op出错返回EINTR

* 若sem_op为0， 表示进程希望等待该信号量变成0
  - 如果信号量为0， 立即返回
  - 信号量值不为0，则：
    1. 若指定IPC_NOWAIT，semop出错返回EAGAIN
    2. 未指定IPC_NOWAIT，信号量值semzcnt加1，然后进程挂起直到下列事件发生：
        - 此信号量变成0， semzcnt减1
        - 系统删除了此信号量，函数出错返回EIDRM
        - 被信号中断返回，semzcnt减1。函数出错返回EINTR。

semop函数具有原子性，要么执行数组中所有操作，或者一个也不做

进程退出时，系统会清理进程占用的信号量资源，如果用SETVAL或SETALL命令semctl设置了一个信号量值，则进程退出时，其它使用该信号量的进程值调整为0.


信号量，记录锁和互斥量，互斥量性能最好，这三者都可以在多个进程间用来同步。

## POSIX信号量

POSIX信号量比xsi信号量有更好的性能，接口更简单，没有信号量集，信号量有引入计数。

POSIX信号量分为命名信号量和未命名信号量，未命名信号量只能存在内存中。

### sem_open

    #include <fcntl.h>           /* For O_* constants */
    #include <sys/stat.h>        /* For mode constants */
    #include <semaphore.h>

    sem_t *sem_open(const char *name, int oflag);
    sem_t *sem_open(const char *name, int oflag, mode_t mode, unsigned int value);

打开一个已经存在的信号量不允许指定模式。oflag参数为O_CREAT | O_EXCL时，如果信号量已经存在，sem_open失败。

name应该以/开头，如果使用了文件系统，则/mysem和//mysem是相同的，但是如果没有使用文件系统，两者不同

### sem_close、sem_unlink

    int sem_close(sem_t *sem);

关闭打开的信号量

    int sem_unlink(const char *name);

删除信号量

### 获取信号量，sem_wait、sem_trywait、sem_timedwait、sem_post

    int sem_wait(sem_t *sem);
    int sem_trywait(sem_t *sem);
    int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout);

实现信号量减1操作

    int sem_post(sem_t *sem);

信号量加1操作

## 未命名信号量

    int sem_init(sem_t *sem, int pshared, unsigned int value);

pshared非0则在多个进程中共享此信号量，如果共享，sem指向的信号量需要在各个进程共享的内存范围

### 删除未命名信号

    int sem_destroy(sem_t *sem);

### 获取当前信号量值

    int sem_getvalue(sem_t *sem, int *sval);

当一个线程对一个普通互斥量加锁，另一个线程试图解锁时，错误检查互斥量和递归互斥量会产生错误。对于基于信号量的互斥原语，一个线程加锁，另一个线程解锁不会有问题。

### 信号量例子

    #include "slock.h"
    #include <stdlib.h>
    #include <stdio.h>
    #include <unistd.h>
    #include <errno.h>

    struct slock *
    	s_alloc()
    {
    	struct slock *sp;
    	static int cnt;

    	if ((sp = malloc(sizeof(struct slock))) == NULL)
    		return(NULL);
    	do {
    		snprintf(sp->name, sizeof(sp->name), "/%ld.%d", (long)getpid(),
    			cnt++);
    		sp->semp = sem_open(sp->name, O_CREAT | O_EXCL, S_IRWXU, 1);
    	} while ((sp->semp == SEM_FAILED) && (errno == EEXIST));
    	if (sp->semp == SEM_FAILED) {
    		free(sp);
    		return(NULL);
    	}
    	sem_unlink(sp->name);
    	return(sp);
    }

    void
    s_free(struct slock *sp)
    {
    	sem_close(sp->semp);
    	free(sp);
    }

    int
    s_lock(struct slock *sp)
    {
    	return(sem_wait(sp->semp));
    }

    int
    s_trylock(struct slock *sp)
    {
    	return(sem_trywait(sp->semp));
    }

    int
    s_unlock(struct slock *sp)
    {
    	return(sem_post(sp->semp));
    }

## 共享内存

### shmget、shmctl

    struct shmid_ds {
        struct ipc_perm shm_perm; /* see Section 15.6.2 */
        size_t shm_segsz; /* size of segment in bytes */
        pid_t shm_lpid; /* pid of last shmop() */
        pid_t shm_cpid; /* pid of creator */
        shmatt_t shm_nattch; /* number of current attaches */
        time_t shm_atime; /* last-attach time */
        time_t shm_dtime; /* last-detach time */
        time_t shm_ctime; /* last-change time */
        ...
    };

    #include <sys/ipc.h>
    #include <sys/shm.h>
    int shmget(key_t key, size_t size, int shmflg);
    int shmctl(int shmid, int cmd, struct shmid_ds *buf);

key:

IPC_STAT

* 获取shmid_ds结构，存储在buf指向的结构中

IPC_SET

* 设置sem_perm.uid, sem_perm.gid, sem_perm.mode。进程有效ID等于sem_perm.cuid或sem_perm.uid或者是超级进程

IPC_RMID

* 从系统中删除共享存储段，因为有连接计数，除非最后一个进程终止或者分离，不会立即删除该存储段。进程有效ID等于sem_perm.cuid或sem_perm.uid或者是超级进程

SHM_LOCK

* 对共享存储的加锁，只能由超级进程进行

SHM_UNLOCK

* 对共享存储的解锁，只能由超级进程进行

### 映射内存地址，shmat

    void *shmat(int shmid, const void *shmaddr, int shmflg);

* shmaddr为0，由内核选择段在内存的位置
* shmaddr非0，未指定了SHM_RND，连接到shmaddr指定的内存上
* shmaddr非0，指定SHM_RND,此段连接到shmaddr - (shmaddr % SHMLBA)的地址上

flag指定了SHM_RDONLY以只读连接此段

### 从笨进程空间删除共享内存，shmdt

    int shmdt(const void *shmaddr);

# UNIX域套接字

    int socketpair(int domain, int type, int protocol, int sv[2]);

UNIX域套接字因为没有网络报头，校验和等，在本机进程间通信，比socket要快。

XSI消息队列不能和文件描述符关联，所以不能和select，poll或epoll一起使用。可以将消息和UNIX域套接字绑定，消息到达时，就写入UNIX域套接字。

    #include "apue.h"
    #include <poll.h>
    #include <pthread.h>
    #include <sys/msg.h>
    #include <sys/socket.h>

    #define NQ		3		/* number of queues */
    #define MAXMSZ	512		/* maximum message size */
    #define KEY		0x123	/* key for first message queue */

    struct threadinfo {
    	int qid;
    	int fd;
    };

    struct mymesg {
    	long mtype;
    	char mtext[MAXMSZ];
    };

    void *
    helper(void *arg)
    {
    	int					n;
    	struct mymesg		m;
    	struct threadinfo	*tip = arg;

    	for(;;) {
    		memset(&m, 0, sizeof(m));
    		if ((n = msgrcv(tip->qid, &m, MAXMSZ, 0, MSG_NOERROR)) < 0)
    			err_sys("msgrcv error");
    		if (write(tip->fd, m.mtext, n) < 0)
    			err_sys("write error");
    	}
    }

    int
    main()
    {
    	int					i, n, err;
    	int					fd[2];
    	int					qid[NQ];
    	struct pollfd		pfd[NQ];
    	struct threadinfo	ti[NQ];
    	pthread_t			tid[NQ];
    	char				buf[MAXMSZ];

    	for (i = 0; i < NQ; i++) {
    		if ((qid[i] = msgget((KEY+i), IPC_CREAT|0666)) < 0)
    			err_sys("msgget error");

    		printf("queue ID %d is %d\n", i, qid[i]);

    		if (socketpair(AF_UNIX, SOCK_DGRAM, 0, fd) < 0)
    			err_sys("socketpair error");
    		pfd[i].fd = fd[0];
    		pfd[i].events = POLLIN;
    		ti[i].qid = qid[i];
    		ti[i].fd = fd[1];
    		if ((err = pthread_create(&tid[i], NULL, helper, &ti[i])) != 0)
    			err_exit(err, "pthread_create error");
    	}

    	for (;;) {
    		if (poll(pfd, NQ, -1) < 0)
    			err_sys("poll error");
    		for (i = 0; i < NQ; i++) {
    			if (pfd[i].revents & POLLIN) {
    				if ((n = read(pfd[i].fd, buf, sizeof(buf))) < 0)
    					err_sys("read error");
    				buf[n] = 0;
    				printf("queue id %d, message %s\n", qid[i], buf);
    			}
    		}
    	}

    	exit(0);
    }

    #include "apue.h"
    #include <sys/msg.h>

    #define MAXMSZ 512

    struct mymesg {
    	long mtype;
    	char mtext[MAXMSZ];
    };

    int
    main(int argc, char *argv[])
    {
    	key_t key;
    	long qid;
    	size_t nbytes;
    	struct mymesg m;

    	if (argc != 3) {
    		fprintf(stderr, "usage: sendmsg KEY message\n");
    		exit(1);
    	}
    	key = strtol(argv[1], NULL, 0);
    	if ((qid = msgget(key, 0)) < 0)
    		err_sys("can't open queue key %s", argv[1]);
    	memset(&m, 0, sizeof(m));
    	strncpy(m.mtext, argv[2], MAXMSZ-1);
    	nbytes = strlen(m.mtext);
    	m.mtype = 1;
    	if (msgsnd(qid, &m, nbytes, 0) < 0)
    		err_sys("can't send message");
    	exit(0);
    }

# 命名UNIX域套接字

    struct sockaddr_un {
        sa_family_t sun_family;               /* AF_UNIX */
        char        sun_path[108];            /* pathname */
    };

命名UNIX域套接字就是bind时绑定UNIX类型地址。

## UNIX域套接字例子

## 传送文件描述符

    #include "apue.h"
    #include <sys/socket.h>
    #include <sys/un.h>
    #include <errno.h>

    #define QLEN	10

    /*
     * Create a server endpoint of a connection.
     * Returns fd if all OK, <0 on error.
     */
    int
    serv_listen(const char *name)
    {
    	int					fd, len, err, rval;
    	struct sockaddr_un	un;

    	if (strlen(name) >= sizeof(un.sun_path)) {
    		errno = ENAMETOOLONG;
    		return(-1);
    	}

    	/* create a UNIX domain stream socket */
    	if ((fd = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
    		return(-2);

    	unlink(name);	/* in case it already exists */

    	/* fill in socket address structure */
    	memset(&un, 0, sizeof(un));
    	un.sun_family = AF_UNIX;
    	strcpy(un.sun_path, name);
    	len = offsetof(struct sockaddr_un, sun_path) + strlen(name);

    	/* bind the name to the descriptor */
    	if (bind(fd, (struct sockaddr *)&un, len) < 0) {
    		rval = -3;
    		goto errout;
    	}

    	if (listen(fd, QLEN) < 0) {	/* tell kernel we're a server */
    		rval = -4;
    		goto errout;
    	}
    	return(fd);

    errout:
    	err = errno;
    	close(fd);
    	errno = err;
    	return(rval);
    }

    #include "apue.h"
    #include <sys/socket.h>
    #include <sys/un.h>
    #include <time.h>
    #include <errno.h>

    #define	STALE	30	/* client's name can't be older than this (sec) */

    /*
     * Wait for a client connection to arrive, and accept it.
     * We also obtain the client's user ID from the pathname
     * that it must bind before calling us.
     * Returns new fd if all OK, <0 on error
     */
    int
    serv_accept(int listenfd, uid_t *uidptr)
    {
    	int					clifd, err, rval;
    	socklen_t			len;
    	time_t				staletime;
    	struct sockaddr_un	un;
    	struct stat			statbuf;
    	char				*name;

    	/* allocate enough space for longest name plus terminating null */
    	if ((name = malloc(sizeof(un.sun_path + 1))) == NULL)
    		return(-1);
    	len = sizeof(un);
    	if ((clifd = accept(listenfd, (struct sockaddr *)&un, &len)) < 0) {
    		free(name);
    		return(-2);		/* often errno=EINTR, if signal caught */
    	}

    	/* obtain the client's uid from its calling address */
    	len -= offsetof(struct sockaddr_un, sun_path); /* len of pathname */
    	memcpy(name, un.sun_path, len);
    	name[len] = 0;			/* null terminate */
    	if (stat(name, &statbuf) < 0) {
    		rval = -3;
    		goto errout;
    	}

    #ifdef	S_ISSOCK	/* not defined for SVR4 */
    	if (S_ISSOCK(statbuf.st_mode) == 0) {
    		rval = -4;		/* not a socket */
    		goto errout;
    	}
    #endif

    	if ((statbuf.st_mode & (S_IRWXG | S_IRWXO)) ||
    		(statbuf.st_mode & S_IRWXU) != S_IRWXU) {
    		  rval = -5;	/* is not rwx------ */
    		  goto errout;
    	}

    	staletime = time(NULL) - STALE;
    	if (statbuf.st_atime < staletime ||
    		statbuf.st_ctime < staletime ||
    		statbuf.st_mtime < staletime) {
    		  rval = -6;	/* i-node is too old */
    		  goto errout;
    	}

    	if (uidptr != NULL)
    		*uidptr = statbuf.st_uid;	/* return uid of caller */
    	unlink(name);		/* we're done with pathname now */
    	free(name);
    	return(clifd);

    errout:
    	err = errno;
    	close(clifd);
    	free(name);
    	errno = err;
    	return(rval);
    }

    #include "apue.h"
    #include <sys/socket.h>
    #include <sys/un.h>
    #include <errno.h>

    #define	CLI_PATH	"/var/tmp/"
    #define	CLI_PERM	S_IRWXU			/* rwx for user only */

    /*
     * Create a client endpoint and connect to a server.
     * Returns fd if all OK, <0 on error.
     */
    int
    cli_conn(const char *name)
    {
    	int					fd, len, err, rval;
    	struct sockaddr_un	un, sun;
    	int					do_unlink = 0;

    	if (strlen(name) >= sizeof(un.sun_path)) {
    		errno = ENAMETOOLONG;
    		return(-1);
    	}

    	/* create a UNIX domain stream socket */
    	if ((fd = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
    		return(-1);

    	/* fill socket address structure with our address */
    	memset(&un, 0, sizeof(un));
    	un.sun_family = AF_UNIX;
    	sprintf(un.sun_path, "%s%05ld", CLI_PATH, (long)getpid());
    printf("file is %s\n", un.sun_path);
    	len = offsetof(struct sockaddr_un, sun_path) + strlen(un.sun_path);

    	unlink(un.sun_path);		/* in case it already exists */
    	if (bind(fd, (struct sockaddr *)&un, len) < 0) {
    		rval = -2;
    		goto errout;
    	}
    	if (chmod(un.sun_path, CLI_PERM) < 0) {
    		rval = -3;
    		do_unlink = 1;
    		goto errout;
    	}

    	/* fill socket address structure with server's address */
    	memset(&sun, 0, sizeof(sun));
    	sun.sun_family = AF_UNIX;
    	strcpy(sun.sun_path, name);
    	len = offsetof(struct sockaddr_un, sun_path) + strlen(name);
    	if (connect(fd, (struct sockaddr *)&sun, len) < 0) {
    		rval = -4;
    		do_unlink = 1;
    		goto errout;
    	}
    	return(fd);

    errout:
    	err = errno;
    	close(fd);
    	if (do_unlink)
    		unlink(un.sun_path);
    	errno = err;
    	return(rval);
    }

    #include "apue.h"

    /*
     * Used when we had planned to send an fd using send_fd(),
     * but encountered an error instead.  We send the error back
     * using the send_fd()/recv_fd() protocol.
     */
    int
    send_err(int fd, int errcode, const char *msg)
    {
    	int		n;

    	if ((n = strlen(msg)) > 0)
    		if (writen(fd, msg, n) != n)	/* send the error message */
    			return(-1);

    	if (errcode >= 0)
    		errcode = -1;	/* must be negative */

    	if (send_fd(fd, errcode) < 0)
    		return(-1);

    	return(0);
    }

    #include "apue.h"
    #include <sys/socket.h>

    /* size of control buffer to send/recv one file descriptor */
    #define	CONTROLLEN	CMSG_LEN(sizeof(int))

    static struct cmsghdr	*cmptr = NULL;	/* malloc'ed first time */

    /*
     * Pass a file descriptor to another process.
     * If fd<0, then -fd is sent back instead as the error status.
     */
    int
    send_fd(int fd, int fd_to_send)
    {
    	struct iovec	iov[1];
    	struct msghdr	msg;
    	char			buf[2];	/* send_fd()/recv_fd() 2-byte protocol */

    	iov[0].iov_base = buf;
    	iov[0].iov_len  = 2;
    	msg.msg_iov     = iov;
    	msg.msg_iovlen  = 1;
    	msg.msg_name    = NULL;
    	msg.msg_namelen = 0;

    	if (fd_to_send < 0) {
    		msg.msg_control    = NULL;
    		msg.msg_controllen = 0;
    		buf[1] = -fd_to_send;	/* nonzero status means error */
    		if (buf[1] == 0)
    			buf[1] = 1;	/* -256, etc. would screw up protocol */
    	} else {
    		if (cmptr == NULL && (cmptr = malloc(CONTROLLEN)) == NULL)
    			return(-1);
    		cmptr->cmsg_level  = SOL_SOCKET;
    		cmptr->cmsg_type   = SCM_RIGHTS;
    		cmptr->cmsg_len    = CONTROLLEN;
    		msg.msg_control    = cmptr;
    		msg.msg_controllen = CONTROLLEN;
    		*(int *)CMSG_DATA(cmptr) = fd_to_send;		/* the fd to pass */
    		buf[1] = 0;		/* zero status means OK */
    	}

    	buf[0] = 0;			/* null byte flag to recv_fd() */
    	if (sendmsg(fd, &msg, 0) != 2)
    		return(-1);
    	return(0);
    }

    #include "apue.h"
    #include <sys/socket.h>		/* struct msghdr */

    /* size of control buffer to send/recv one file descriptor */
    #define	CONTROLLEN	CMSG_LEN(sizeof(int))

    #ifdef LINUX
    #define RELOP <
    #else
    #define RELOP !=
    #endif

    static struct cmsghdr	*cmptr = NULL;		/* malloc'ed first time */

    /*
     * Receive a file descriptor from a server process.  Also, any data
     * received is passed to (*userfunc)(STDERR_FILENO, buf, nbytes).
     * We have a 2-byte protocol for receiving the fd from send_fd().
     */
    int
    recv_fd(int fd, ssize_t (*userfunc)(int, const void *, size_t))
    {
    	int				newfd, nr, status;
    	char			*ptr;
    	char			buf[MAXLINE];
    	struct iovec	iov[1];
    	struct msghdr	msg;

    	status = -1;
    	for ( ; ; ) {
    		iov[0].iov_base = buf;
    		iov[0].iov_len  = sizeof(buf);
    		msg.msg_iov     = iov;
    		msg.msg_iovlen  = 1;
    		msg.msg_name    = NULL;
    		msg.msg_namelen = 0;
    		if (cmptr == NULL && (cmptr = malloc(CONTROLLEN)) == NULL)
    			return(-1);
    		msg.msg_control    = cmptr;
    		msg.msg_controllen = CONTROLLEN;
    		if ((nr = recvmsg(fd, &msg, 0)) < 0) {
    			err_ret("recvmsg error");
    			return(-1);
    		} else if (nr == 0) {
    			err_ret("connection closed by server");
    			return(-1);
    		}

    		/*
    		 * See if this is the final data with null & status.  Null
    		 * is next to last byte of buffer; status byte is last byte.
    		 * Zero status means there is a file descriptor to receive.
    		 */
    		for (ptr = buf; ptr < &buf[nr]; ) {
    			if (*ptr++ == 0) {
    				if (ptr != &buf[nr-1])
    					err_dump("message format error");
     				status = *ptr & 0xFF;	/* prevent sign extension */
     				if (status == 0) {
    					if (msg.msg_controllen RELOP CONTROLLEN)
    						err_dump("status = 0 but no fd");
    					newfd = *(int *)CMSG_DATA(cmptr);
    				} else {
    					newfd = -status;
    				}
    				nr -= 2;
    			}
    		}
    		if (nr > 0 && (*userfunc)(STDERR_FILENO, buf, nr) != nr)
    			return(-1);
    		if (status >= 0)	/* final data has arrived */
    			return(newfd);	/* descriptor, or -status */
    	}
    }

## 传送证书

    #include "apue.h"
    #include <sys/socket.h>

    #if defined(SCM_CREDS)			/* BSD interface */
    #define CREDSTRUCT		cmsgcred
    #define SCM_CREDTYPE	SCM_CREDS
    #elif defined(SCM_CREDENTIALS)	/* Linux interface */
    #define CREDSTRUCT		ucred
    #define SCM_CREDTYPE	SCM_CREDENTIALS
    #else
    #error passing credentials is unsupported!
    #endif

    /* size of control buffer to send/recv one file descriptor */
    #define RIGHTSLEN	CMSG_LEN(sizeof(int))
    #define CREDSLEN	CMSG_LEN(sizeof(struct CREDSTRUCT))
    #define	CONTROLLEN	(RIGHTSLEN + CREDSLEN)

    static struct cmsghdr	*cmptr = NULL;	/* malloc'ed first time */

    /*
     * Pass a file descriptor to another process.
     * If fd<0, then -fd is sent back instead as the error status.
     */
    int
    send_fd(int fd, int fd_to_send)
    {
    	struct CREDSTRUCT	*credp;
    	struct cmsghdr		*cmp;
    	struct iovec		iov[1];
    	struct msghdr		msg;
    	char				buf[2];	/* send_fd/recv_ufd 2-byte protocol */

    	iov[0].iov_base = buf;
    	iov[0].iov_len  = 2;
    	msg.msg_iov     = iov;
    	msg.msg_iovlen  = 1;
    	msg.msg_name    = NULL;
    	msg.msg_namelen = 0;
    	msg.msg_flags = 0;
    	if (fd_to_send < 0) {
    		msg.msg_control    = NULL;
    		msg.msg_controllen = 0;
    		buf[1] = -fd_to_send;	/* nonzero status means error */
    		if (buf[1] == 0)
    			buf[1] = 1;	/* -256, etc. would screw up protocol */
    	} else {
    		if (cmptr == NULL && (cmptr = malloc(CONTROLLEN)) == NULL)
    			return(-1);
    		msg.msg_control    = cmptr;
    		msg.msg_controllen = CONTROLLEN;
    		cmp = cmptr;
    		cmp->cmsg_level  = SOL_SOCKET;
    		cmp->cmsg_type   = SCM_RIGHTS;
    		cmp->cmsg_len    = RIGHTSLEN;
    		*(int *)CMSG_DATA(cmp) = fd_to_send;	/* the fd to pass */
    		cmp = CMSG_NXTHDR(&msg, cmp);
    		cmp->cmsg_level  = SOL_SOCKET;
    		cmp->cmsg_type   = SCM_CREDTYPE;
    		cmp->cmsg_len    = CREDSLEN;
    		credp = (struct CREDSTRUCT *)CMSG_DATA(cmp);
    #if defined(SCM_CREDENTIALS)
    		credp->uid = geteuid();
    		credp->gid = getegid();
    		credp->pid = getpid();
    #endif
    		buf[1] = 0;		/* zero status means OK */
    	}
    	buf[0] = 0;			/* null byte flag to recv_ufd() */
    	if (sendmsg(fd, &msg, 0) != 2)
    		return(-1);
    	return(0);
    }

    #include "apue.h"
    #include <sys/socket.h>		/* struct msghdr */
    #include <sys/un.h>

    #if defined(SCM_CREDS)			/* BSD interface */
    #define CREDSTRUCT		cmsgcred
    #define CR_UID			cmcred_uid
    #define SCM_CREDTYPE	SCM_CREDS
    #elif defined(SCM_CREDENTIALS)	/* Linux interface */
    #define CREDSTRUCT		ucred
    #define CR_UID			uid
    #define CREDOPT			SO_PASSCRED
    #define SCM_CREDTYPE	SCM_CREDENTIALS
    #else
    #error passing credentials is unsupported!
    #endif

    /* size of control buffer to send/recv one file descriptor */
    #define RIGHTSLEN	CMSG_LEN(sizeof(int))
    #define CREDSLEN	CMSG_LEN(sizeof(struct CREDSTRUCT))
    #define	CONTROLLEN	(RIGHTSLEN + CREDSLEN)

    static struct cmsghdr	*cmptr = NULL;		/* malloc'ed first time */

    /*
     * Receive a file descriptor from a server process.  Also, any data
     * received is passed to (*userfunc)(STDERR_FILENO, buf, nbytes).
     * We have a 2-byte protocol for receiving the fd from send_fd().
     */
    int
    recv_ufd(int fd, uid_t *uidptr,
             ssize_t (*userfunc)(int, const void *, size_t))
    {
    	struct cmsghdr		*cmp;
    	struct CREDSTRUCT	*credp;
    	char				*ptr;
    	char				buf[MAXLINE];
    	struct iovec		iov[1];
    	struct msghdr		msg;
    	int					nr;
    	int					newfd = -1;
    	int					status = -1;
    #if defined(CREDOPT)
    	const int			on = 1;

    	if (setsockopt(fd, SOL_SOCKET, CREDOPT, &on, sizeof(int)) < 0) {
    		err_ret("setsockopt error");
    		return(-1);
    	}
    #endif
    	for ( ; ; ) {
    		iov[0].iov_base = buf;
    		iov[0].iov_len  = sizeof(buf);
    		msg.msg_iov     = iov;
    		msg.msg_iovlen  = 1;
    		msg.msg_name    = NULL;
    		msg.msg_namelen = 0;
    		if (cmptr == NULL && (cmptr = malloc(CONTROLLEN)) == NULL)
    			return(-1);
    		msg.msg_control    = cmptr;
    		msg.msg_controllen = CONTROLLEN;
    		if ((nr = recvmsg(fd, &msg, 0)) < 0) {
    			err_ret("recvmsg error");
    			return(-1);
    		} else if (nr == 0) {
    			err_ret("connection closed by server");
    			return(-1);
    		}

    		/*
    		 * See if this is the final data with null & status.  Null
    		 * is next to last byte of buffer; status byte is last byte.
    		 * Zero status means there is a file descriptor to receive.
    		 */
    		for (ptr = buf; ptr < &buf[nr]; ) {
    			if (*ptr++ == 0) {
    				if (ptr != &buf[nr-1])
    					err_dump("message format error");
     				status = *ptr & 0xFF;	/* prevent sign extension */
     				if (status == 0) {
    					if (msg.msg_controllen != CONTROLLEN)
    						err_dump("status = 0 but no fd");

    					/* process the control data */
    					for (cmp = CMSG_FIRSTHDR(&msg);
    					  cmp != NULL; cmp = CMSG_NXTHDR(&msg, cmp)) {
    						if (cmp->cmsg_level != SOL_SOCKET)
    							continue;
    						switch (cmp->cmsg_type) {
    						case SCM_RIGHTS:
    							newfd = *(int *)CMSG_DATA(cmp);
    							break;
    						case SCM_CREDTYPE:
    							credp = (struct CREDSTRUCT *)CMSG_DATA(cmp);
    							*uidptr = credp->CR_UID;
    						}
    					}
    				} else {
    					newfd = -status;
    				}
    				nr -= 2;
    			}
    		}
    		if (nr > 0 && (*userfunc)(STDERR_FILENO, buf, nr) != nr)
    			return(-1);
    		if (status >= 0)	/* final data has arrived */
    			return(newfd);	/* descriptor, or -status */
    	}
    }

## open服务器

### 调用进程使用fork和exec实现

    #include	"open.h"
    #include	<fcntl.h>

    #define	BUFFSIZE	8192

    int
    main(int argc, char *argv[])
    {
    	int		n, fd;
    	char	buf[BUFFSIZE];
    	char	line[MAXLINE];

    	/* read filename to cat from stdin */
    	while (fgets(line, MAXLINE, stdin) != NULL) {
    		if (line[strlen(line) - 1] == '\n')
    			line[strlen(line) - 1] = 0; /* replace newline with null */

    		/* open the file */
    		if ((fd = csopen(line, O_RDONLY)) < 0)
    			continue;	/* csopen() prints error from server */

    		/* and cat to stdout */
    		while ((n = read(fd, buf, BUFFSIZE)) > 0)
    			if (write(STDOUT_FILENO, buf, n) != n)
    				err_sys("write error");
    		if (n < 0)
    			err_sys("read error");
    		close(fd);
    	}

    	exit(0);
    }

    #include	"open.h"
    #include	<sys/uio.h>		/* struct iovec */

    /*
     * Open the file by sending the "name" and "oflag" to the
     * connection server and reading a file descriptor back.
     */
    int
    csopen(char *name, int oflag)
    {
    	pid_t			pid;
    	int				len;
    	char			buf[10];
    	struct iovec	iov[3];
    	static int		fd[2] = { -1, -1 };

    	if (fd[0] < 0) {	/* fork/exec our open server first time */
    		if (fd_pipe(fd) < 0) {
    			err_ret("fd_pipe error");
    			return(-1);
    		}
    		if ((pid = fork()) < 0) {
    			err_ret("fork error");
    			return(-1);
    		} else if (pid == 0) {		/* child */
    			close(fd[0]);
    			if (fd[1] != STDIN_FILENO &&
    			  dup2(fd[1], STDIN_FILENO) != STDIN_FILENO)
    				err_sys("dup2 error to stdin");
    			if (fd[1] != STDOUT_FILENO &&
    			  dup2(fd[1], STDOUT_FILENO) != STDOUT_FILENO)
    				err_sys("dup2 error to stdout");
    			if (execl("./opend", "opend", (char *)0) < 0)
    				err_sys("execl error");
    		}
    		close(fd[1]);				/* parent */
    	}
    	sprintf(buf, " %d", oflag);		/* oflag to ascii */
    	iov[0].iov_base = CL_OPEN " ";		/* string concatenation */
    	iov[0].iov_len  = strlen(CL_OPEN) + 1;
    	iov[1].iov_base = name;
    	iov[1].iov_len  = strlen(name);
    	iov[2].iov_base = buf;
    	iov[2].iov_len  = strlen(buf) + 1;	/* +1 for null at end of buf */
    	len = iov[0].iov_len + iov[1].iov_len + iov[2].iov_len;
    	if (writev(fd[0], &iov[0], 3) != len) {
    		err_ret("writev error");
    		return(-1);
    	}

    	/* read descriptor, returned errors handled by write() */
    	return(recv_fd(fd[0], write));
    }

    #include "apue.h"
    #include <errno.h>

    #define	CL_OPEN "open"			/* client's request for server */

    extern char	 errmsg[];	/* error message string to return to client */
    extern int	 oflag;		/* open() flag: O_xxx ... */
    extern char	*pathname;	/* of file to open() for client */

    int		 cli_args(int, char **);
    void	 handle_request(char *, int, int);

    #include	"opend.h"

    char	 errmsg[MAXLINE];
    int		 oflag;
    char	*pathname;

    int
    main(void)
    {
    	int		nread;
    	char	buf[MAXLINE];

    	for ( ; ; ) {	/* read arg buffer from client, process request */
    		if ((nread = read(STDIN_FILENO, buf, MAXLINE)) < 0)
    			err_sys("read error on stream pipe");
    		else if (nread == 0)
    			break;		/* client has closed the stream pipe */
    		handle_request(buf, nread, STDOUT_FILENO);
    	}
    	exit(0);
    }

    #include	"opend.h"
    #include	<fcntl.h>

    void
    handle_request(char *buf, int nread, int fd)
    {
    	int		newfd;

    	if (buf[nread-1] != 0) {
    		snprintf(errmsg, MAXLINE-1,
    		  "request not null terminated: %*.*s\n", nread, nread, buf);
    		send_err(fd, -1, errmsg);
    		return;
    	}
    	if (buf_args(buf, cli_args) < 0) {	/* parse args & set options */
    		send_err(fd, -1, errmsg);
    		return;
    	}
    	if ((newfd = open(pathname, oflag)) < 0) {
    		snprintf(errmsg, MAXLINE-1, "can't open %s: %s\n", pathname,
    		  strerror(errno));
    		send_err(fd, -1, errmsg);
    		return;
    	}
    	if (send_fd(fd, newfd) < 0)		/* send the descriptor */
    		err_sys("send_fd error");
    	close(newfd);		/* we're done with descriptor */
    }

    #include "apue.h"

    #define	MAXARGC		50	/* max number of arguments in buf */
    #define	WHITE	" \t\n"	/* white space for tokenizing arguments */

    /*
     * buf[] contains white-space-separated arguments.  We convert it to an
     * argv-style array of pointers, and call the user's function (optfunc)
     * to process the array.  We return -1 if there's a problem parsing buf,
     * else we return whatever optfunc() returns.  Note that user's buf[]
     * array is modified (nulls placed after each token).
     */
    int
    buf_args(char *buf, int (*optfunc)(int, char **))
    {
    	char	*ptr, *argv[MAXARGC];
    	int		argc;

    	if (strtok(buf, WHITE) == NULL)		/* an argv[0] is required */
    		return(-1);
    	argv[argc = 0] = buf;
    	while ((ptr = strtok(NULL, WHITE)) != NULL) {
    		if (++argc >= MAXARGC-1)	/* -1 for room for NULL at end */
    			return(-1);
    		argv[argc] = ptr;
    	}
    	argv[++argc] = NULL;

    	/*
    	 * Since argv[] pointers point into the user's buf[],
    	 * user's function can just copy the pointers, even
    	 * though argv[] array will disappear on return.
    	 */
    	return((*optfunc)(argc, argv));
    }

    #include	"opend.h"

    /*
     * This function is called by buf_args(), which is called by
     * handle_request().  buf_args() has broken up the client's
     * buffer into an argv[]-style array, which we now process.
     */
    int
    cli_args(int argc, char **argv)
    {
    	if (argc != 3 || strcmp(argv[0], CL_OPEN) != 0) {
    		strcpy(errmsg, "usage: <pathname> <oflag>\n");
    		return(-1);
    	}
    	pathname = argv[1];		/* save ptr to pathname to open */
    	oflag = atoi(argv[2]);
    	return(0);
    }

## open服务器

daemon形式

    #include	"open.h"
    #include	<sys/uio.h>		/* struct iovec */

    /*
     * Open the file by sending the "name" and "oflag" to the
     * connection server and reading a file descriptor back.
     */
    int
    csopen(char *name, int oflag)
    {
    	int				len;
    	char			buf[12];
    	struct iovec	iov[3];
    	static int		csfd = -1;

    	if (csfd < 0) {		/* open connection to conn server */
    		if ((csfd = cli_conn(CS_OPEN)) < 0) {
    			err_ret("cli_conn error");
    			return(-1);
    		}
    	}

    	sprintf(buf, " %d", oflag);		/* oflag to ascii */
    	iov[0].iov_base = CL_OPEN " ";	/* string concatenation */
    	iov[0].iov_len  = strlen(CL_OPEN) + 1;
    	iov[1].iov_base = name;
    	iov[1].iov_len  = strlen(name);
    	iov[2].iov_base = buf;
    	iov[2].iov_len  = strlen(buf) + 1;	/* null always sent */
    	len = iov[0].iov_len + iov[1].iov_len + iov[2].iov_len;
    	if (writev(csfd, &iov[0], 3) != len) {
    		err_ret("writev error");
    		return(-1);
    	}

    	/* read back descriptor; returned errors handled by write() */
    	return(recv_fd(csfd, write));
    }

    #include "apue.h"
    #include <errno.h>

    #define	CS_OPEN "/tmp/opend.socket"	/* well-known name */
    #define	CL_OPEN "open"				/* client's request for server */

    extern int	 debug;		/* nonzero if interactive (not daemon) */
    extern char	 errmsg[];	/* error message string to return to client */
    extern int	 oflag;		/* open flag: O_xxx ... */
    extern char	*pathname;	/* of file to open for client */

    typedef struct {	/* one Client struct per connected client */
      int	fd;			/* fd, or -1 if available */
      uid_t	uid;
    } Client;

    extern Client	*client;		/* ptr to malloc'ed array */
    extern int		 client_size;	/* # entries in client[] array */

    int		 cli_args(int, char **);
    int		 client_add(int, uid_t);
    void	 client_del(int);
    void	 loop(void);
    void	 handle_request(char *, int, int, uid_t);

    #include	"opend.h"

    #define	NALLOC	10		/* # client structs to alloc/realloc for */

    static void
    client_alloc(void)		/* alloc more entries in the client[] array */
    {
    	int		i;

    	if (client == NULL)
    		client = malloc(NALLOC * sizeof(Client));
    	else
    		client = realloc(client, (client_size+NALLOC)*sizeof(Client));
    	if (client == NULL)
    		err_sys("can't alloc for client array");

    	/* initialize the new entries */
    	for (i = client_size; i < client_size + NALLOC; i++)
    		client[i].fd = -1;	/* fd of -1 means entry available */

    	client_size += NALLOC;
    }

    /*
     * Called by loop() when connection request from a new client arrives.
     */
    int
    client_add(int fd, uid_t uid)
    {
    	int		i;

    	if (client == NULL)		/* first time we're called */
    		client_alloc();
    again:
    	for (i = 0; i < client_size; i++) {
    		if (client[i].fd == -1) {	/* find an available entry */
    			client[i].fd = fd;
    			client[i].uid = uid;
    			return(i);	/* return index in client[] array */
    		}
    	}

    	/* client array full, time to realloc for more */
    	client_alloc();
    	goto again;		/* and search again (will work this time) */
    }

    /*
     * Called by loop() when we're done with a client.
     */
    void
    client_del(int fd)
    {
    	int		i;

    	for (i = 0; i < client_size; i++) {
    		if (client[i].fd == fd) {
    			client[i].fd = -1;
    			return;
    		}
    	}
    	log_quit("can't find client entry for fd %d", fd);
    }

    #include	"opend.h"
    #include	<syslog.h>

    int		 debug, oflag, client_size, log_to_stderr;
    char	 errmsg[MAXLINE];
    char	*pathname;
    Client	*client = NULL;

    int
    main(int argc, char *argv[])
    {
    	int		c;

    	log_open("open.serv", LOG_PID, LOG_USER);

    	opterr = 0;		/* don't want getopt() writing to stderr */
    	while ((c = getopt(argc, argv, "d")) != EOF) {
    		switch (c) {
    		case 'd':		/* debug */
    			debug = log_to_stderr = 1;
    			break;

    		case '?':
    			err_quit("unrecognized option: -%c", optopt);
    		}
    	}

    	if (debug == 0)
    		daemonize("opend");

    	loop();		/* never returns */
    }

    #include	"opend.h"
    #include	<sys/select.h>

    void
    loop(void)
    {
    	int		i, n, maxfd, maxi, listenfd, clifd, nread;
    	char	buf[MAXLINE];
    	uid_t	uid;
    	fd_set	rset, allset;

    	FD_ZERO(&allset);

    	/* obtain fd to listen for client requests on */
    	if ((listenfd = serv_listen(CS_OPEN)) < 0)
    		log_sys("serv_listen error");
    	FD_SET(listenfd, &allset);
    	maxfd = listenfd;
    	maxi = -1;

    	for ( ; ; ) {
    		rset = allset;	/* rset gets modified each time around */
    		if ((n = select(maxfd + 1, &rset, NULL, NULL, NULL)) < 0)
    			log_sys("select error");

    		if (FD_ISSET(listenfd, &rset)) {
    			/* accept new client request */
    			if ((clifd = serv_accept(listenfd, &uid)) < 0)
    				log_sys("serv_accept error: %d", clifd);
    			i = client_add(clifd, uid);
    			FD_SET(clifd, &allset);
    			if (clifd > maxfd)
    				maxfd = clifd;	/* max fd for select() */
    			if (i > maxi)
    				maxi = i;	/* max index in client[] array */
    			log_msg("new connection: uid %d, fd %d", uid, clifd);
    			continue;
    		}

    		for (i = 0; i <= maxi; i++) {	/* go through client[] array */
    			if ((clifd = client[i].fd) < 0)
    				continue;
    			if (FD_ISSET(clifd, &rset)) {
    				/* read argument buffer from client */
    				if ((nread = read(clifd, buf, MAXLINE)) < 0) {
    					log_sys("read error on fd %d", clifd);
    				} else if (nread == 0) {
    					log_msg("closed: uid %d, fd %d",
    					  client[i].uid, clifd);
    					client_del(clifd);	/* client has closed cxn */
    					FD_CLR(clifd, &allset);
    					close(clifd);
    				} else {	/* process client's request */
    					handle_request(buf, nread, clifd, client[i].uid);
    				}
    			}
    		}
    	}
    }

    #include	"opend.h"
    #include	<poll.h>

    #define NALLOC	10	/* # pollfd structs to alloc/realloc */

    static struct pollfd *
    grow_pollfd(struct pollfd *pfd, int *maxfd)
    {
    	int				i;
    	int				oldmax = *maxfd;
    	int				newmax = oldmax + NALLOC;

    	if ((pfd = realloc(pfd, newmax * sizeof(struct pollfd))) == NULL)
    		err_sys("realloc error");
    	for (i = oldmax; i < newmax; i++) {
    		pfd[i].fd = -1;
    		pfd[i].events = POLLIN;
    		pfd[i].revents = 0;
    	}
    	*maxfd = newmax;
    	return(pfd);
    }

    void
    loop(void)
    {
    	int				i, listenfd, clifd, nread;
    	char			buf[MAXLINE];
    	uid_t			uid;
    	struct pollfd	*pollfd;
    	int				numfd = 1;
    	int				maxfd = NALLOC;

    	if ((pollfd = malloc(NALLOC * sizeof(struct pollfd))) == NULL)
    		err_sys("malloc error");
    	for (i = 0; i < NALLOC; i++) {
    		pollfd[i].fd = -1;
    		pollfd[i].events = POLLIN;
    		pollfd[i].revents = 0;
    	}

    	/* obtain fd to listen for client requests on */
    	if ((listenfd = serv_listen(CS_OPEN)) < 0)
    		log_sys("serv_listen error");
    	client_add(listenfd, 0);	/* we use [0] for listenfd */
    	pollfd[0].fd = listenfd;

    	for ( ; ; ) {
    		if (poll(pollfd, numfd, -1) < 0)
    			log_sys("poll error");

    		if (pollfd[0].revents & POLLIN) {
    			/* accept new client request */
    			if ((clifd = serv_accept(listenfd, &uid)) < 0)
    				log_sys("serv_accept error: %d", clifd);
    			client_add(clifd, uid);

    			/* possibly increase the size of the pollfd array */
    			if (numfd == maxfd)
    				pollfd = grow_pollfd(pollfd, &maxfd);
    			pollfd[numfd].fd = clifd;
    			pollfd[numfd].events = POLLIN;
    			pollfd[numfd].revents = 0;
    			numfd++;
    			log_msg("new connection: uid %d, fd %d", uid, clifd);
    		}

    		for (i = 1; i < numfd; i++) {
    			if (pollfd[i].revents & POLLHUP) {
    				goto hungup;
    			} else if (pollfd[i].revents & POLLIN) {
    				/* read argument buffer from client */
    				if ((nread = read(pollfd[i].fd, buf, MAXLINE)) < 0) {
    					log_sys("read error on fd %d", pollfd[i].fd);
    				} else if (nread == 0) {
    hungup:
    					/* the client closed the connection */
    					log_msg("closed: uid %d, fd %d",
    					  client[i].uid, pollfd[i].fd);
    					client_del(pollfd[i].fd);
    					close(pollfd[i].fd);
    					if (i < (numfd-1)) {
    						/* pack the array */
    						pollfd[i].fd = pollfd[numfd-1].fd;
    						pollfd[i].events = pollfd[numfd-1].events;
    						pollfd[i].revents = pollfd[numfd-1].revents;
    						i--;	/* recheck this entry */
    					}
    					numfd--;
    				} else {		/* process client's request */
    					handle_request(buf, nread, pollfd[i].fd,
    					  client[i].uid);
    				}
    			}
    		}
    	}
    }

    #include	"opend.h"
    #include	<fcntl.h>

    void
    handle_request(char *buf, int nread, int clifd, uid_t uid)
    {
    	int		newfd;

    	if (buf[nread-1] != 0) {
    		snprintf(errmsg, MAXLINE-1,
    		  "request from uid %d not null terminated: %*.*s\n",
    		  uid, nread, nread, buf);
    		send_err(clifd, -1, errmsg);
    		return;
    	}
    	log_msg("request: %s, from uid %d", buf, uid);

    	/* parse the arguments, set options */
    	if (buf_args(buf, cli_args) < 0) {
    		send_err(clifd, -1, errmsg);
    		log_msg(errmsg);
    		return;
    	}

    	if ((newfd = open(pathname, oflag)) < 0) {
    		snprintf(errmsg, MAXLINE-1, "can't open %s: %s\n",
    		  pathname, strerror(errno));
    		send_err(clifd, -1, errmsg);
    		log_msg(errmsg);
    		return;
    	}

    	/* send the descriptor */
    	if (send_fd(clifd, newfd) < 0)
    		log_sys("send_fd error");
    	log_msg("sent fd %d over fd %d for %s", newfd, clifd, pathname);
    	close(newfd);		/* we're done with descriptor */
    }

# 存储映射IO

    void *mmap(void *addr, size_t len, int prot, int flag, int fd, off_t off );
    void *mmap2(void *addr, size_t length, int prot,int flags, int fd, off_t pgoffset);
    int mprotect(void *addr, size_t len, int prot);//修改映射权限
    int pkey_mprotect(void *addr, size_t len, int prot, int pkey);

返回映射区起始地址，若出错返回MAP_FAILED

addr指定映射区起始地址，设置为0表示由操作系统选择起始地址。

prot指定映射区保护要求
* PROT_READ  映射区可读
* PROT_WRITE 映射区可写
* PROT_EXEC 映射区可执行
* PROT_NOE 映射区不可访问

flag指定映射区属性

* MAP_FIXED 返回值必须等于addr，为了可移植，addr指定为0
* MAP_SHARED 指定存储操作修改映射文件，也就是操作内存就是操作该文件，不能喝MAP_PRIVATE同时指定
* MAP_PRIVATE 不能和MAP_SHARED同时指定，创建映射文件的一个私有副本，不会影响原文件。

**mmap和memcpy结合，是从内核缓冲区拷贝到另一个内核缓冲区，而read是内核缓冲区到用户缓冲区，write是用户缓冲区到内核缓冲区**

SIGSEGV表示进程试图访问不可用的存储区

SIGBUS 访问映射区不存在的部分

**子进程继承存储映射区，但是exec不继承**

## 冲刷存储映射

    int msync(void *addr, size_t len, int flags);

冲洗修改页到被映射的文件

flags：

* MS_ASYNC  立即返回，不等待冲洗操作完成。
* MS_SYNC 等待冲洗操作完成才返回

## 解除映射

    int munmap(void *addr, size_t len);

相关进程之间的存储映射，

* 读/dev/zero时，提供无限0字节资源，写此设备都被忽略
* 多个进程共同祖先对mmap指定了MAP_SHARED标志，这些进程可以共享此存储区
* 存储区初始化为0

## 存储映射间同步

    #include "apue.h"
    #include <fcntl.h>
    #include <sys/mman.h>

    #define	NLOOPS		1000
    #define	SIZE		sizeof(long)	/* size of shared memory area */

    static int
    update(long *ptr)
    {
    	return((*ptr)++);	/* return value before increment */
    }

    int
    main(void)
    {
    	int		fd, i, counter;
    	pid_t	pid;
    	void	*area;

    	if ((fd = open("/dev/zero", O_RDWR)) < 0)
    		err_sys("open error");
    	if ((area = mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
    	  fd, 0)) == MAP_FAILED)
    		err_sys("mmap error");
    	close(fd);		/* can close /dev/zero now that it's mapped */

    	TELL_WAIT();

    	if ((pid = fork()) < 0) {
    		err_sys("fork error");
    	} else if (pid > 0) {			/* parent */
    		for (i = 0; i < NLOOPS; i += 2) {
    			if ((counter = update((long *)area)) != i)
    				err_quit("parent: expected %d, got %d", i, counter);

    			TELL_CHILD(pid);
    			WAIT_CHILD();
    		}
    	} else {						/* child */
    		for (i = 1; i < NLOOPS + 1; i += 2) {
    			WAIT_PARENT();

    			if ((counter = update((long *)area)) != i)
    				err_quit("child: expected %d, got %d", i, counter);

    			TELL_PARENT(getppid());
    		}
    	}

    	exit(0);
    }

# 匿名存储映射

mmap指定MAP_ANON标志，并将文件描述符置为-1。此时不需要通过文件描述符和一个路径相结合。

    if ((area = mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_ANON | MAP_SHARED, -1, 0)) == MAP_FAILED)

# 内存锁

    #include <sys/mman.h>
    int mlock(const void *addr, size_t len);
    int mlock2(const void *addr, size_t len, int flags);
    int munlock(const void *addr, size_t len);
    int mlockall(int flags);
    int munlockall(void);
