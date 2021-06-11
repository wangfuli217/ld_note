---
title: 高级IO
comments: true
---

# select、pselect

    #include <sys/select.h>
    int select(int maxfdp1, fd_set *restrict readfds, fd_set *restrict writefds, fd_set *restrict exceptfds, struct timeval *restrict tvptr);

    int pselect(int maxfdp1, fd_set *restrict readfds, fd_set *restrict writefds, fd_set *restrict exceptfds, const struct timespec *restrict tsptr, const sigset_t *restrict sigmask);


* 返回准备的文件描述符数目，0表示超时，出错返回-1，select会修改fd_set值，select函数被信号中断不会自重启，指定SA_RESTART选项也是这样的
* 一个描述符是否阻塞不影响select是否阻塞
* 一个文件达到尾端，select会将该fd放入正常集合，不是异常集合

<!--more-->

tvptf, pvptf:

* tvptr == NULL 永远等待，若被信号中断则返回-1，errno置为EINTR
* tvptr->tv_sec == 0 && tvptf->tv_usec == 0 不等待，测试所有指定的描述符立即返回。这是select找到多个描述符状态且不阻塞的方法
* tvptr->tv_sec != 0 && tvptf->tv_usec != 0 等待指定时间

## FD_ISSET、FD_CLR、FD_SET、FD_ZERO

    #include <sys/select.h>
    int FD_ISSET(int fd, fd_set *fdset);
    fd在set中返回非0值
    void FD_CLR(int fd, fd_set *fdset);
    void FD_SET(int fd, fd_set *fdset);
    void FD_ZERO(fd_set *fdset);

# poll

    struct pollfd {
      int fd; /* file descriptor to check, or <0 to ignore */
      short events; /* events of interest on fd */
      short revents; /* events that occurred on fd */
    };

    #include <poll.h>
    int poll(struct pollfd fdarray[], nfds_t nfds, int timeout);

返回准备的文件描述符数目，0表示超时，出错返回-1，描述符是否阻塞不影响poll函数，被信号中断不会自重启，指定SA_RESTART选项也是这样的

timeout：

* timeout == -1 永远等待，当指定描述符中一个准备好时，或捕捉到信号时返回。有信号中断返回-1，errno置为EINTR
* timeout == 0 不等待，找到多个描述符状态且不阻塞poll函数
* timeout > 0 超时返回或者描述符准备好，超时返回0


标志名 | 输入至events |  从revents得到结果 | 说明
------|--------------|-------------------|----
POLLIN | Y           | Y                 | 不阻塞地读取高优先级数据以外的数据（等效于POLLRDNORM|POLLRDBAND)
POLLRDNORM  | Y      | Y                 | 不阻塞地读取普通数据
POLLRDBAND  | Y      |  Y                | 不阻塞地读取优先级数据
POLLPRI     |  Y     | Y                 | 不阻塞地读取高优先级数据
POLLOUT     |  Y     |  Y                | 不阻塞地读取普通数据
POLLWRNORM  |  Y     |    Y              | 与POLLOUT相同
POLLWRBAND  |  Y     |    Y              | 不阻塞地读取优先级数据
POLLERR  |           |    Y              | 已出错
POLLHUP  |           |    Y              | 已挂断
POLLNVAL  |          |    Y              | 描述符没有关联一个打开文件

# 异步IO

## sigevent、aiocb

    struct sigevent {
      int sigev_notify; /* notify type */
      int sigev_signo; /* signal number */
      union sigval sigev_value; /* notify argument */
      void (*sigev_notify_function)(union sigval); /* notify function */
      pthread_attr_t *sigev_notify_attributes; /* notify attrs */
    };

sigev_notify字段控制通知类型。

* SIGEV_NONE   异步IO请求完成后，不通知进程
* SIGEV_SIGNAL 异步IO完成后，产生由sigev_signo字段指定的信号。如果进程捕捉该信号，并且指定了SA_SIGINFO标志，则该信号将被入队列，给信号处理函数传递一个siginfo结构，该结构的si_value字段被设置为sigev_value。
* SIGEV_THREAD 异步IO完成后，由sigev_notify_function字段指定函数被调用。sigev_value作为唯一参数。除非sigev_notify_attributes字段设定了pthread属性结构的地址，且该结构指定了一个另外的线程属性，否则该函数将在分离状态下的一个单独线程中执行。

## aiocb

    struct aiocb {
    	int aio_fildes; /* file descriptor */
    	off_t aio_offset; /* file offset for I/O */
    	volatile void *aio_buf; /* buffer for I/O */
    	size_t aio_nbytes; /* number of bytes to transfer */
    	int aio_reqprio; /* priority */
    	struct sigevent aio_sigevent; /* signal information */
    	int aio_lio_opcode; /* operation for list I/O */
    };

异步IO接口必须指定偏移量，不会影响操作系统维护的文件偏移量。不能把异步IO系统调用和传统IO系统调用在同一个文件描述符混用。如果异步IO接口以追加模式打开文件写入数据，aio_offset字段被系统忽略。

## aio_read, aio_write

    #include <aio.h>
    int aio_read(struct aiocb *aiocb);
    int aio_write(struct aiocb *aiocb);

正常返回0，出错-1

函数返回成功时，异步IO请求只是被操作系统放入到等待队列中，这些函数返回值与实际IO操作没有任何关系。IO操作在等待时，AIO控制块和数据库缓冲区保持稳定。除非IO操作完成，否则。

## 冲洗异步IO数据，aio_fsync

    int aio_fsync(int op, struct aiocb *aiocb);

AIO控制块总的aio_filedes字段指定了异步操作的文件，如果op设定为O_DSYNC，操作执行起来就像调用了fdatasync。op设置为O_SYNC，就像调用了fsync。aio_fsync返回时，数据并不一定已经持久化。

## 判断异步IO完成状态，aio_error

    int aio_error(const struct aiocb *aiocb);

获取异步读写或者同步操作的完成状态

>0  异步操作完成。需要调用aio_return函数获取操作返回值
>
>-1 对aio_error调用失败。这种情况下，errno会告诉我们
>
EINPROGRESS  读写或同步操作仍在等待

## 获取异步IO返回，aio_return

    ssize_t aio_return(const struct aiocb *aiocb);

异步操作完成前，不要调用aio_return，本身失败返回-1，并置errno。

## 等待异步IO完成，aio_suspend

    int aio_suspend(const struct aiocb *const list[], int nent, const struct timespec *timeout);

阻塞进程，直到所有异步IO操作完成

* 成功返回0
* 出错返回-1
* 被信号中断返回-1，errno置为EINTR
* 超时返回-1，errno置为EAGAIN
* timeout为NULL永久等待

## 取消未完成异步IO，aio_cancel

    int aio_cancel(int fd, struct aiocb *aiocb);

取消未完成的异步IO操作，aiocb为NULL，系统将会取消fd上所有未完成异步IO。

aio_cancel返回值

* AIO_ALLDONE  所有操作已经在取消前完成
* AIO_CANCELED 操作已经被取消
* AIO_NOTCANCELED 至少有一个要求操作没有被取消
* -1 对aio_cancel调用失败，置errno

## 列表操作，lio_listio

    int lio_listio(int mode, struct aiocb *restrict const list[restrict], int nent, struct sigevent *restrict sigev);

* mode为LIO_WAIT，函数是同步的，函数在列表指定的所有IO操作完成后返回。此时sigev被忽略
* mode为IO_NOWAIT，函数将IO请求入队后立即返回。IO操作完成后按照sigev参数指定的被异步通知。可以将sigev置为NULL

aio_lio_opcode字段LIO_READ交由aio_read函数处理，LIO_WRITE交由aio_write处理，LIO_NOP被忽略。

## 异步IO操作例子

    #include "apue.h"
    #include <ctype.h>
    #include <fcntl.h>
    #include <aio.h>
    #include <errno.h>

    #define BSZ 4096
    #define NBUF 8

    enum rwop {
    	UNUSED = 0,
    	READ_PENDING = 1,
    	WRITE_PENDING = 2
    };

    struct buf {
    	enum rwop     op;
    	int           last;
    	struct aiocb  aiocb;
    	unsigned char data[BSZ];
    };

    struct buf bufs[NBUF];

    unsigned char
    translate(unsigned char c)
    {
    	if (isalpha(c)) {
    		if (c >= 'n')
    			c -= 13;
    		else if (c >= 'a')
    			c += 13;
    		else if (c >= 'N')
    			c -= 13;
    		else
    			c += 13;
    	}
    	return(c);
    }

    int
    main(int argc, char* argv[])
    {
    	int					ifd, ofd, i, j, n, err, numop;
    	struct stat			sbuf;
    	const struct aiocb	*aiolist[NBUF];
    	off_t				off = 0;

    	if (argc != 3)
    		err_quit("usage: rot13 infile outfile");
    	if ((ifd = open(argv[1], O_RDONLY)) < 0)
    		err_sys("can't open %s", argv[1]);
    	if ((ofd = open(argv[2], O_RDWR|O_CREAT|O_TRUNC, FILE_MODE)) < 0)
    		err_sys("can't create %s", argv[2]);
    	if (fstat(ifd, &sbuf) < 0)
    		err_sys("fstat failed");

    	/* initialize the buffers */
    	for (i = 0; i < NBUF; i++) {
    		bufs[i].op = UNUSED;
    		bufs[i].aiocb.aio_buf = bufs[i].data;
    		bufs[i].aiocb.aio_sigevent.sigev_notify = SIGEV_NONE;
    		aiolist[i] = NULL;
    	}

    	numop = 0;
    	for (;;) {
    		for (i = 0; i < NBUF; i++) {
    			switch (bufs[i].op) {
    			case UNUSED:
    				/*
    				 * Read from the input file if more data
    				 * remains unread.
    				 */
    				if (off < sbuf.st_size) {
    					bufs[i].op = READ_PENDING;
    					bufs[i].aiocb.aio_fildes = ifd;
    					bufs[i].aiocb.aio_offset = off;
    					off += BSZ;
    					if (off >= sbuf.st_size)
    						bufs[i].last = 1;
    					bufs[i].aiocb.aio_nbytes = BSZ;
    					if (aio_read(&bufs[i].aiocb) < 0)
    						err_sys("aio_read failed");
    					aiolist[i] = &bufs[i].aiocb;
    					numop++;
    				}
    				break;

    			case READ_PENDING:
    				if ((err = aio_error(&bufs[i].aiocb)) == EINPROGRESS)
    					continue;
    				if (err != 0) {
    					if (err == -1)
    						err_sys("aio_error failed");
    					else
    						err_exit(err, "read failed");
    				}

    				/*
    				 * A read is complete; translate the buffer
    				 * and write it.
    				 */
    				if ((n = aio_return(&bufs[i].aiocb)) < 0)
    					err_sys("aio_return failed");
    				if (n != BSZ && !bufs[i].last)
    					err_quit("short read (%d/%d)", n, BSZ);
    				for (j = 0; j < n; j++)
    					bufs[i].data[j] = translate(bufs[i].data[j]);
    				bufs[i].op = WRITE_PENDING;
    				bufs[i].aiocb.aio_fildes = ofd;
    				bufs[i].aiocb.aio_nbytes = n;
    				if (aio_write(&bufs[i].aiocb) < 0)
    					err_sys("aio_write failed");
    				/* retain our spot in aiolist */
    				break;

    			case WRITE_PENDING:
    				if ((err = aio_error(&bufs[i].aiocb)) == EINPROGRESS)
    					continue;
    				if (err != 0) {
    					if (err == -1)
    						err_sys("aio_error failed");
    					else
    						err_exit(err, "write failed");
    				}

    				/*
    				 * A write is complete; mark the buffer as unused.
    				 */
    				if ((n = aio_return(&bufs[i].aiocb)) < 0)
    					err_sys("aio_return failed");
    				if (n != bufs[i].aiocb.aio_nbytes)
    					err_quit("short write (%d/%d)", n, BSZ);
    				aiolist[i] = NULL;
    				bufs[i].op = UNUSED;
    				numop--;
    				break;
    			}
    		}
    		if (numop == 0) {
    			if (off >= sbuf.st_size)
    				break;
    		} else {
    			if (aio_suspend(aiolist, NBUF, NULL) < 0)
    				err_sys("aio_suspend failed");
    		}
    	}

    	bufs[0].aiocb.aio_fildes = ofd;
    	if (aio_fsync(O_SYNC, &bufs[0].aiocb) < 0)
    		err_sys("aio_fsync failed");
    	exit(0);
    }

**异步IO可能会导致IO性能下降，因为系统的提前读失效**

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

# 文件访问模式设定

    int posix_fadvise(int fd, off_t offset, off_t len, int advice);
