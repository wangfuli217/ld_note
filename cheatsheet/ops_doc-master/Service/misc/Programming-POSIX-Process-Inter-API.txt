---
title: Linux学习总结（七）——进程间通信
date: 2016-12-16 15:54:55
categories: Linux学习记录
tags: [进程间通信, 消息队列, 共享内存, 信号量]
---
Linux 的进程间通信方式是从 UNIX 平台继承而来的。传统的 UNIX 进程间通信方式有三种：管道、FIFO、信号。System V 进程间通信包括 System V 消息队列、 System V 信号量和 System V 共享内存。POSIX 进程间通信机制包括 POSIX 消息队列、POSIX 信号量和 POSIX 共享内存区。
 <!--more-->
现在 Linux 中主要使用的进程间通信方式有：
 * 无名管道（pipe）和有名管道（fifo）
 * 信号（signal）
 * 消息队列（message queue）
 * 共享内存（shared memory）
 * 信号量（semaphore）
 * 套接字（socket）


## 一、管道通信
1. 无名管道 pipe 
 无名管道是 Linux 中管道通信的一种原始方式，只能在具有亲缘关系的进程间进行通信。它是基于文件描述符的通信方式。相应的创建函数为：

 ````c     
int pipe(int pipefd[2]);````
 功能：在内核中创建一个管道，用来进行进程间通信。      
 参数：`pipefd[]`数组 ，用来保存2个文件描述符的。            
    pipefd[0]  读端            
    pipefd[1]  写端
 返回： 成功返回0， 出错返回-1

 需要注意的有以下几点： 
  * 无名管道的大小只有64K。
  * 管道中没有数据 ，读阻塞            
  * 管道中装满数据， 写阻塞。一旦有空闲空间（4k），写操作继续进行。            
  * 写端关闭，管道有部分数据，读端可以把数据读出。            
  * 读端关闭，向管道写数据，没有任何的意义，会造成管道破裂，内核会向进程发送一个SIGPIPE 信号。进程被杀死。
  * 无名管道通信，只能用于具有亲缘关系的进程间通信。

2. 有名管道 fifo     
 有名管道可以使互不相关的两个进程互相通信。有名管道可以通过路径名来指出，并且在文件系统中可见，使用 `mkfifo()` 函数创建管道后，就可以使用 `open();` `read();` `write()` 等函数来进行进程间通信了。

 ````c
 int mkfifo(const char *pathname, mode_t mode);````
 功能：创建一个有名管道。  
 参数：`pathname`管道名；`mode`权限。
 返回值：成功返回0，出错返回-1。
 
 > 缺省情况下，如果当前 FIFO 没有数据，读进程会一直阻塞，直到有数据写入或是所有的写端都被关闭。
 对于写进程，只要 FIFO 有数据，就可以进行写入，空间不足时，写进程会阻塞到全部数据写入。

## 二、信号
信号是在软件层次上对中断机制的一种模拟，是一种异步通信方式。产生信号的来源可以是硬件：比如键盘操作等，也可以是软件。产生信号的事件对进程来讲是随机出现的，进程不能通过检测某个标志等方式判断是否产生了一个信号，而是应该告诉内核**当某个信号产生时，执行下列动作**。当信号产生时，有三种处理方式：
  * 忽略信号：对信号不做任何处理，但是有两个信号不能忽略：即 `SIGKILL` 及 `SIGSTOP`。        
  * 捕捉信号：定义信号处理函数，当信号发生时，执行相应的处理函数。        
  * 执行缺省操作：Linux 对每种信号都规定了默认操作。

1. 信号的发送
 信号的发送有两个函数 `kill()` 和 `raise()`。

 ````C
 int kill(pid_t pid, int sig);````
 功能：给指定的进程，发送信号    
 参数： `pid` 指定的进程，当 `pid` 为0的时候，信号发送给当前进程组的所有进程，等于-1的时候，发送给所有进程（系统进程集中的除外）；`sig` 需要发送的信号。
 返回值：成功返回0， 出错返回-1

 ````C     
 int raise(int sig);````
 功能：给正在调用此函数的进程发送信号。
    
2. 定时器信号
 使用 `alarm()` 函数可以设置一个定时器，在将来某个时刻定时器超时的时候，产生一个 `SIGALARM` 信号。进程被杀死。

 ````C
    unsigned int alarm(unsigned int seconds);````
 功能：定义一个闹钟， 注意它没有阻塞功能    
 参数：`seconds` 秒数
 返回值：如果之前没有定义闹钟，成功返回0 ，出错返回-1。如果 `alarm` 之前定义过闹钟，成功返回上一次闹钟距离这一次闹钟所剩下的时间，出错返回-1。

 使用 `pause()` 函数可以使当前进程挂起直到捕捉到相应的信号。

3. 信号的设置
 ````C
 typedef void (*sighandler_t)(int);   /
 sighandler_t signal(int signum, sighandler_t handler);````
 功能：注册一个信号     
 参数：`signum` 信号, `handler` 函数指针变量     
 返回值：函数指针

 > 子进程会继承父进程对信号的设置。

 ````C
 int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact);````
 参数： `signum` 信号类型， `act` 对特定信号的处理，`oldact` 保留信号原来的处理方式。
 `struct sigaction` 结构体定义如下：
   ````C
   struct sigaction {
       void (*sa_handler)(int signo); //信号处理函数
       sigset_t sa_mask;              //信号集合，那些信号被屏蔽
       int sa_flags;                  //标志位 SA_NODEFER/SA_NOMASK(执行处理函数时，不屏蔽当前信号) 
                                      //       SA_NOCLDSTOP（忽略子进程的信号） 
                                      //       SA_RESTART （重新执行被信号中断的系统调用）
                                      //       SA_ONESHOT/SA_RESETHAND（自定义信号处理函数只生效一次）
       void (*sa_restore)(void);
   }````
 返回值：成功返回0，失败返回-1.

## 三、IPC对象
接下来讲的三种通信方式都是基于 SystemV IPC 对象的，每个内核中的 IPC结构（共享内存，消息队列，信号灯集）都用一个非负整数的标识符加以引用。标识符是 IPC 对象的内部名，每个 IPC 对象都与一个键 `key` 相关联，`key` 值相当于是 IPC 对象通信的外部名字。使用下面的函数生成一个 `key`。

````C       
key_t ftok(const char *pathname, int proj_id);````

功能：产生一个独一无二的key值       
参数：`pathname` 已经存在的可访问文件的名字，`proj_id`一个字符（只用低8位）       
返回值：成功返回相应的 `key`，出错返回-1。

## 四、信号灯集     
信号灯(semaphore)，也叫信号量。它是不同进程间或一个给定进程内部不同线程间同步的机制。

1. PV 原子操作
  P 操作，如果有可用资源，则占用一个资源，如果没有可用资源，则阻塞
  V 操作，如果该信号量的等待队列中有任务在等待资源，则唤醒一个阻塞任务，如果没有，则释放一个资源。

2. 信号量的使用步骤
   1. 创建或者打开信号灯         
      ````C
      int semget(key_t key, int nsems, int semflg);````
     参数：`key` 键值；`nsems` 信号灯的数目；`semflg` 同 `open()` 函数的权限位。  
     返回值：成功返回相应的 `shmid`，出错返回-1。
   2. 资源申请，释放资源
     ````C         
     int semop(int semid, struct sembuf *sops, unsigned nsops);````
     参数：`semid` 信号灯集ID；`sops` 指向信号量操作数组，`nops`  要操作的信号灯的个数        
     `struct sembuf` 结构体定义如下
     ````C
    struct sembuf {         
    short  sem_num;  //  要操作的信号灯的编号         
    short  sem_op;   //    0 :  等待，直到信号灯的值变成0                               
                     //    1 :  释放资源，V操作                               
                     //   -1 :  分配资源，P操作                              
    short  sem_flg;  // 0,  IPC_NOWAIT,  SEM_UNDO        
    };````
     返回：成功 0， 失败 -1
  3. 信号灯的控制操作   
     ````C      
     int semctl ( int semid, int semnum,  int cmd，…/*union semun arg*/);````
     功能：信号灯的操作         
     参数：`semid` 信号灯集id号；`semnum` 要对第几个信号灯进行操作，信号灯的编号（从0 开始；`cmd` 为 `IPC_STAT` 表示获取信号量 `IPC_SETVAL` 表示设置为 `arg` 的值 `IPC_GETVAL` 表示返回当前值 `IPC_RMID` 表示删除信号量；`arg` 信号量结构体，定义如下：          
     ````C
     union semun {               
      int              val;    /* Value for SETVAL */               
      struct semid_ds *buf;    /* Buffer for IPC_STAT, IPC_SET */               
      unsigned short  *array;  /* Array for GETALL, SETALL */               
      struct seminfo  *__buf;  /* Buffer for IPC_INFO                                           
      (Linux-specific) */           
    };````
    返回值：成功 0， 出错 -1

## 五、消息队列     
消息队列就是一个消息的列表。用户可以在消息队列中添加消息、读取消息等。

1. 创建或打开消息队列          
 ````C
 int msgget(key_t key, int msgflg);````
 参数： `key` 键值；`msgflg` 打开的方式。
 返回值：成功 msgid，出错 -1

2. 添加消息
 ````C
 int msgsnd(int msqid, const void *msgp, size_t msgsz, int msgflg);````
 参数：`msgid` 消息队列的id号；`msgp` 发送的消息的结构体地址；`msgsz` 消息正文的大小；`msgflg`  0 阻塞，如果队列中的消息满了，它会阻塞等待，`IPC_NOWAIT` 如果添加消息不成功，立即返回。          
 返回值：成功 0， 出错 -1
 用户自定义消息结构体:
 ````C
 struct msgbuf {               
   long mtype;       /* message type, must be > 0 */               
   char mtext[1];    /* message data */           
  };````

3. 读取消息          
 ````C
 ssize_t msgrcv(int msqid, void *msgp, size_t msgsz, long msgtyp, int msgflg);````
 功能：从消息队列中，取出消息          
 参数：`msgid` 消息id号；`msgp` 接收消息结构体；`msgsz` 消息正文的大小；`msgtyp` 消息的类型，0 表示从第一个开始读取，按队列的规则，> 0 表示按照指定的type类型进行读取，<0 　表示和他的绝对值相等的类型进行读取；`msgflg` 0 阻塞， `IPC_NOWAIT` 不阻塞。
 返回值：成功 表示读取消息正文的字节数，出错 -1

4. 控制消息队列          
 ````C
 int msgctl(int msqid, int cmd, struct msqid_ds *buf);````
 参数：`msgid`  消息队列的id号                `cmd`    `IPC_STAT`  获取                       `IPC_SET `  设置                       `IPC_RMID`  删除                buf    属性信息          返回值：成功 0，出错 -1

5. 对消息队列的手动处理
`ipcs  -q`   查看系统中共享内存的使用情况信息        
`ipcrm  -q  msgid`   手动删除共享内存        
`ipcrm  -Q  key`     手动删除共享内存


## 六、共享内存通信     

共享内存是一种最为高效的进程间通信方式，进程可以直接读写内存，而不需要任何数据的拷贝。为了在多个进程间交换信息，内核专门留出了一块内存区，可以由需要访问的进程将其映射到自己的私有地址空间，进程就可以直接读写这一内存区而不需要进行数据的拷贝，从而大大提高的效率。由于多个进程共享一段内存，因此也需要依靠某种同步机制，如互斥锁和信号量等。 


1. 生成 IPC 对象: `ftok()`
2. 创建或者打开共享内存
    ````C
    int shmget(key_t key, size_t size, int shmflg);````
    参数：`key` 键值，`size` 共享内存的大小，`shmflg` 同 `open()` 函数的权限位。         
    返回值：成功返回相应的 `shmid`，出错返回-1。
3. 映射共享内存，即把指定的共享内存映射到进程的地址空间用于访问
    ````C
    void *shmat(int shmid, const void *shmaddr, int shmflg);````         
    参数：`shmid` 共享内存的 id 号；`shmaddr` 一般为NULL，表示映射到进程的地址，由操作系统自由选择；`shmflg` 为 `SHM_RDONLY` 表示内存只读，默认为0 可读写。
    返回值：成功返回映射后的地址， 出错返回-1。
4. 撤销共享内存映射         
    ````C
    int shmdt(const void *shmaddr);````
6. 删除共享内存         
    ````C
    int shmctl(int shmid, int cmd, struct shmid_ds *buf);````         
    功能：对共享内存进行各种操作         
    参数：`shmid` 共享内存的id号；`cmd` 为 `IPC_STAT` 表示要获取 `shmid` 属性信息，为 `IPC_SET` 表示设置 `shmid` 属性信息，为 `IPC_RMID` 表示删除共享内存;`buf` 属性信息结构体。
    返回值：成功返回0，出错返回-1。

2. 对共享内存的手动处理
 `ipcs  -m`   查看系统中共享内存的使用情况信息       
 `ipcrm  -m  shmid`   手动删除共享内存       
 `ipcrm  -M  key`     手动删除共享内存


## 七、六种通信方式的对比

|通信类型|描述|
|--|--|
|pipe:|具有亲缘关系的进程间，单工，数据在内存中|
|fifo:| 可用于任意进程间，双工，有文件名，数据在内存|
|signal:|唯一的异步通信方式|
|msg:|常用于cs模式中， 按消息类型访问 ，可有优先级|
|shm:|效率最高(直接访问内存) ，需要同步、互斥机制|
|sem:|配合共享内存使用，用以实现同步和互斥|