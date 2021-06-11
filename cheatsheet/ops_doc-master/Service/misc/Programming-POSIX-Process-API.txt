---
title: Linux学习总结（六）——进程
date: 2016-12-16 15:54:55
categories: Linux学习记录
tags: [进程]
---

进程是一个程序的一次执行的过程，它包括程序的创建，执行，调度，消亡。从宏观上讲进程是并行的，但微观层面是串行的。

<!--more-->
## 一、进程的概念      
进程和程序的区别：     
 程序是静态的，它是一些保存在磁盘上的指令的有序集合，没有任何执行的概念。     
 进程是一个动态的概念，它是程序执行的过程，包括创建、调度。
常见的进程可以分为三类：
* 交互进程            
  该类进程是由shell控制和运行的。            
  * 前台进程
  例如：`./a.out`，既可以有输入，也可以有输出
  * 后台进程
  例如：`./a.out &`, 只有输出，没有输入
* 批处理进程
* 守护进程         
  该类进程在后台运行。它一般在Linux启动时开始执行，系统关闭时才结束。它是 提供服务的进程。

## 二、进程的运行状态
运行态：此时进程或者正在运行，或者准备运行。
等待态：此时进程在等待一个事件的发生或某种系统资源。又分为可中断和不可中断两种。
停止态：此时进程被中止。使用 `ctrl + Z` 时进程的状态。  
僵尸态：这是一个已终止的进程，但还在进程向量数组中占有一个task_struct结构。

|代码|英文|解释|
|----|---|----|
|D    |uninterruptible sleep (usually IO)|  不可中断的睡眠态       |
|R    |running or runnable (on run queue)  |   运行态       |
|S    |interruptible sleep (waiting for an event to complete) |可中断睡眠态       |
|T    |stopped, either by a job control signal or because it is being traced. |停止态     |  
|X    |dead (should never be seen)  |死亡态， 不可见       |
|Z    |defunct ("zombie") process, terminated but not reaped by its parent. |僵尸态|
||For BSD formats and when the stat keyword is used, additional characters may be displayed: |
|<    |high-priority (not nice to other users)  | 高优先级     |  
|L    |has pages locked into memory (for real-time and custom IO)   ||    
|N    ||低优先级       |
|s    |is a session leader   |回话组的组长       |
|l    |is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)  |进程中包含线程    |   
|+    |is in the foreground process group.  |前台进程|

## 三、进程的创建
`pid_t fork(void);`
功能：创建子进程    
返回值：成功时，在父亲进程中得到子进程进程号，在子进程中得到0；出错返回-1。

子进程，精确复制了父亲进程的内容，包括父亲进程的缓存区  也拷贝。除了 父亲进程pid。。
子进程从 fork 之后，pid 赋值之前进行执行的。

`pid_t getpid(void);`     
功能：得到正在调用此函数进程的进程号

`pid_t getppid(void);`     
功能：得到正在调用此函数进程父亲的进程号

## 四、子进程的回收     
`pid_t wait(int *status);`     
功能：阻塞等待任意的儿子进程的结束，回收儿子进程的资源     
返回值：成功返回子进程的进程号，失败返回-1;

`pid_t waitpid(pid_t pid, int *status, int options);`     
功能：等待指定的子进程的结束     
参数：
  `pid > 0` 等待指定的 `pid` 进程的结束；`pid = -1`等待任意的一个子进程的结束；
  `status` 子进程退出的状态标识位            
  `options` 为 `WNOHANG` 不阻塞，返回 `0`（没有回收到），`pid号`（成功回收到）；为 `0` 阻塞，失败返回 `-1` ，成功返回 `pid号`
返回值：就是上面的情况

僵尸进程：当父进程存在，子进程退出，父进程没有给子进程回收资源，子进程就变成了僵尸进程（`task_struct` 资源没有被释放）。

如何避免僵尸的产生？     
 * 父亲先死，儿子活着，此时 儿子进程  /init 进程 收养。不会产生僵尸。（父亲的尸体 由 bash 给回收，儿子以后再死的话，init 进程收尸）
 * 父亲活着，儿子先死，父亲调用 wait函数进行收尸，所以没有僵尸产生。

## 五、进程的退出    
`void _exit(int status);`
功能：结束正在调用的进程，程序结束前不刷新缓存区

`void exit(int status);`
功能：结束正在调用的进程，程序结束前会刷新缓存区

## 六、exec 函数族      
功能：在一个进程中，启动执行另外一个进程。没有产生新的进程，            
将这个进程中img 镜像，替换掉原来执行进程的img 镜像。      
l ：参数以列表形式，展现出来。
v ：参数以数组形式表现。   
e ：可传递新进程的环境变量。   
p ：执行文件查找方式为文件名。      


## 七、守护进程的创建      
1. 创建子进程，父进程退出。`fork();`
2. 在子进程中创建新会话。`pid_t setsid(void);`
3. 改变当前目录为根目录。`int chdir(const char *path);`
4. 重设文件权限掩码。`umask(0);`
5. 关闭文件描述符。`int getdtablesize(void);`

一个完整的创建守护进程的代码如下所示：
````C
void init_demon(void) {
  int pid;
  int i;

  //创建子进程,关闭父进程
  if(pid=fork()) {
    exit(0)；
  } else if (pid< 0) {
    perror("fail to fork");
    exit(1);
  }

	//设置会话组组长
  setsid();
  if(pid=fork())
    exit(0);
  else if(pid< 0)
    exit(1);

	//关闭打开的文件描述符, 改变工作目录到/tmp, 重设文件创建掩模
  for(i=0;i< getdtablesize();++i)
    close(i);

  chdir("/tmp");
  umask(0);
}
````