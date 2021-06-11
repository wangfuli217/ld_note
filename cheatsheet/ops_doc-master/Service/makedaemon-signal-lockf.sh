moosefs(makedaemon)
{
1. 清空stdout和stderr缓冲区，创建pipe管道
2. 新进程运行，父进程wait(&f)新(子)进程，
3. 父进程关闭close(piped[1]);管道写文件描述符；阻塞于管道等待子进程发送过来的通知消息。
4. 创建新的会话，设置进程组setpgid(0,getpid());创建新的子进程，从父进程中退出。
5. 注册信号处理函数
6. 关闭STDIN_FILENO，打开/dev/null；关闭STDOUT_FILENO，dup(STDIN_FILENO)，关闭STDERR_FILENO，dup(piped[1])。关闭close(piped[1]);

7. close_msg_channel() 用于关闭close(STDERR_FILENO);然后重新定义STDERR_FILENO为NULL。

关于管道：
1. 如果子进行创建进程失败会返回错误；
2. 子进程在守护状态下，将输出信息通过管道输出到父进程的输出部分。
}

moosefs(main)
{
setsid();
setpgid(0,getpid());
if ((i = open("/dev/null", O_RDWR, 0)) != -1) {
    (void)dup2(i, STDIN_FILENO);
    (void)dup2(i, STDOUT_FILENO);
    (void)dup2(i, STDERR_FILENO);
    if (i>2) close (i);
}
}

redis(daemonize)
{
1. 新进程运行，父进程退出；
2. 创建新的会话
3. 将STDIN_FILENO、STDOUT_FILENO、STDERR_FILENO重定向到/dev/null
4. 关闭打开/dev/null的文件描述符
}


tcpcopy(daemonize)
{
1. 新进程运行，父进程退出；
2. 创建新的会话
3. 将STDIN_FILENO、STDOUT_FILENO、STDERR_FILENO重定向到/dev/null
4. 关闭打开/dev/null的文件描述符
}

1. moosefs内common中main.c的makedaemon和close_msg_channel共同实现了守护进程的功能，在初始化的过程中，父进程可以将子进程的
   错误输出打印到前台，当子进程各个模块初始化成功的时候，调用close_msg_channel完成对外输出。当子进程异常退出初始化的时候，也会调用
   close_msg_channel函数。
   保证子进程尽可能将初始化阶段错误信息通知的父进程。

2. redis和moosefs退出进程调用的是exit(1);而tcpcopy调用的是_exit(EXIT_SUCCESS);函数，exit和_exit
   _exit 函数的作用是：直接使进程停止运行，清除其使用的内存空间，并清除其在内核的各种数据结构；exit 函数则在这些基础上
   做了一些小动作，在执行退出之前还加了若干道工序。exit() 函数与 _exit() 函数的最大区别在于exit()函数在调用exit 系统调用
   前要检查文件的打开情况，把文件缓冲区中的内容写回文件。也就是图中的“清理I/O缓冲”
   
3. tcpcopy和moosefs有更多的异常打印信息，而redis更加简单，没有任何异常输出打印。

moosefs(signal)
{
管道通知：发送1个字节。
SIGTERM                                                  通知进程退出                             \001
SIGHUP                                                   通知进程重新加载配置文件                 \002
SIGINFO或者SIGUSR1                                       通知输出进程状态信息                     \004
SIGCHLD或者SIGCLD                                        子进程信号处理                           \003
SIGQUIT、SIGPIPE、SIGTSTP、SIGTTIN、SIGTTOU和SIGUSR2     忽略类型信号                             SIG_IGN
SIGALRM、SIGVTALRM、SIGPROF                              定时器信号                               \005
SIGINT                                                   守护进程忽略此信号，前台运行不忽略此信号 忽略或者默认信号处理函数


}

printf(format)
{
printf("\12");
Produces the decimal character 10 (x0A Hex).

printf("\xFF");
Produces the decimal character -1 or 255 (depending on sign).

printf("\x123");
Produces a single character (value is undefined). May cause errors.

printf("\0222");
Produces two characters whose values are implementation-specific.
}

redis(signal)
{
SIGTERM                                                  通知进程退出 
SIGSEGV、SIGBUS、SIGFPE、SIGILL    sigsegvHandler        打印进程的堆栈信息
SIGALRM                                                  定时器信号     watchdogSignalHandler 喂狗检测进程长时间阻塞。

}

dnsmasq(signal)
{
管道通知：发送以event_desc为头的数据报文
SIGUSR1                                                   通知输出进程状态信息
SIGUSR2                                                   重新打开日志输出文件
SIGHUP                                                    通知进程重新加载配置文件 
SIGTERM                                                   通知进程退出  
SIGALRM                                                   更新udcp的租期
SIGCHLD                                                   子进程信号处理  
SIGPIPE                                                   忽略类型信号
}


tcpcopy(signal)
{
基本都忽略
SIGINT
SIGPIPE
SIGHUP
SIGTERM
}

sheepdog()
{
install_sighandler 安装信号处理函数；
install_crash_handler[SIGSEGV、SIGABRT、SIGBUS、SIGILL、SIGFPE] 安装异常处理函数
SIGPIPE  忽略
SIGHUP   日志回滚
SIGUSR2  线程池暂停

}

dnsmasq:sig_handler(int sig)根据信号值不同执行不同的处理流程；还是每个信号注册不同的信号处理函数。

moosefs: void set_signal_handlers(int daemonflag) 
         void termhandle(int signo)
         void reloadhandle(int signo) 
         void chldhandle(int signo)
         void infohandle(int signo) 
         void alarmhandle(int signo) 
         

1、将信号映射成命令行参数或选项；
2、将多个信号的处理函数收敛为一个处理函数；
3、将信号处理转换为基于管道的的多路IO阻塞处理框架。

需要忽略的(主要使用SIGQUIT、SIGPIPE、SIGTSTP、SIGTTIN、SIGTTOU)；
进程终止的(主要使用SIGTERM)；
进程配置文件重新加载的(主要使用SIGHUP)；
进程异常的(主要为SIGSEGV、SIGABRT、SIGBUS、SIGILL、SIGFPE的信号处理)；
子进程的(moosefs利用SIGCHLD实现子进程僵尸状态回收处理)；
进程内部状态输出的(dnsmasq和moosefs利用SIGUSER1将进程内部的状态输出出来)；
特定功能调试的(线程池)(sheepdog利用SIGUSER信号实现线程池调试)；
多路IO处理阻塞超时喂狗类型的(redis利用定时器实现软喂狗，防止主线程被阻塞在特定的请求下)；
实现统计功能(moosefs利用定时器实现磁盘IO数据和网络IO数据的统计)。



moosefs(lock)
{
mylock   : 给指定文件添加互斥锁；如果加锁成功:0; 如果加锁失败:-1; 如果加锁由于被互斥:进程pid
wdunlock : 关闭锁文件
wdlock   : 打开锁文件，给指定文件加锁，如果返回进程pid:
         进程的pid大于等于0，即当前进程正在运行
                                                  RM_TEST  测试进程是否运行
                                                  RM_START 启动进程执行
                                                  RM_RELOAD指示进程重新加载配置文件
                                                  RM_KILL  杀死指定pid的进程
                                                  RM_STOP  通知指定pid的进程退出
         进程的pid等于0.即当前进程正在运行中
                                                  RM_START和RM_RESTART 写锁文件
                                                  RM_TRY_RESTART       试图重启
                                                  RM_STOP和RM_KILL     停止失败
                                                  RM_RELOAD            配置文件重新加载失败
                                                  RM_INFO              进程打印状态信息失败
                                                  RM_TEST              进程还为运行                                             
}

redis(flock)
{
int clusterLockConfig(char *filename)            创建锁文件   创建文件&&文件加锁：成功返回0，失败返回-1

}

sheepdog(lockf)
{
static int create_pidfile(const char *filename)  创建锁文件   创建文件&&文件加锁：成功返回0，失败返回-1； 会向文件中写入进程Pid
int lock_base_dir(const char *d)                 创建锁文件   创建文件&&文件加锁：成功返回0，失败返回-1
}

1. 首先要知道flock函数只能对整个文件上锁，而不能对文件的某一部分上锁，这是于fcntl/lockf的第一个重要区别，后者可以对文件的某个区域上锁。
2. 其次，flock只能产生劝告性锁。我们知道，linux存在强制锁（mandatory lock）和劝告锁（advisory lock）。
       所谓强制锁，比较好理解，就是你家大门上的那把锁，最要命的是只有一把钥匙，只有一个进程可以操作。
       所谓劝告锁，本质是一种协议，你访问文件前，先检查锁，这时候锁才其作用，如果你不那么kind，不管三七二十一，就要读写，
       那么劝告锁没有任何的作用。而遵守协议，读写前先检查锁的那些进程，叫做合作进程。
3. 再次，flock和fcntl/lockf的区别主要在fork和dup。


过函数参数功能可以看出fcntl是功能最强大的，它既支持共享锁又支持排他锁，即可以锁住整个文件，又能只锁文件的某一部分。
   下面看fcntl/lockf的特性：
(1) 上锁可递归，如果一个进程对一个文件区间已经有一把锁，后来进程又企图在同一区间再加一把锁，则新锁将替换老锁。
(2) 加读锁（共享锁）文件必须是读打开的，加写锁（排他锁）文件必须是写打开。
(3) 进程不能使用F_GETLK命令来测试它自己是否再文件的某一部分持有一把锁。F_GETLK命令定义说明，返回信息指示是否现存的锁阻止调用进程设置它自己的锁。因为，F_SETLK和F_SETLKW命令总是替换进程的现有锁，所以调用进程绝不会阻塞再自己持有的锁上，于是F_GETLK命令绝不会报告调用进程自己持有的锁。
(4) 进程终止时，他所建立的所有文件锁都会被释放，队医flock也是一样的。
(5) 任何时候关闭一个描述符时，则该进程通过这一描述符可以引用的文件上的任何一把锁都被释放（这些锁都是该进程设置的），这一点与flock不同。
(6) 由fork产生的子进程不继承父进程所设置的锁，这点与flock也不同。
(7) 在执行exec后，新程序可以继承原程序的锁，这点和flock是相同的。（如果对fd设置了close-on-exec，则exec前会关闭fd，相应文件的锁也会被释放）。
(8) 支持强制性锁：对一个特定文件打开其设置组ID位(S_ISGID)，并关闭其组执行位(S_IXGRP)，则对该文件开启了强制性锁机制。再Linux中如果要使用强制性锁，则要在文件系统mount时，使用_omand打开该机制。

两种锁的关系
那么flock和lockf/fcntl所上的锁有什么关系呢？答案时互不影响。


moosefs(uid gid)
{
void changeugid(void) 根据配置文件修改进程的uid和gid。
}

dnsmasq(uid gid)
{
main函数
}

moosefs(setrlimit){main}
redis(setrlimit){adjustOpenFilesLimit}

moosefs(setpriority){setpriority(PRIO_PROCESS,getpid(),nicelevel);}

moosefs(chdir){}
redis(chdir){}
dnsmasq(chdir){}

moosefs(umask){}
dnsmasq(umask){}

dnsmasq(rand){void rand_init()}

getopt(dnsmasq, moosefs, tcpcopy){}
getopt_long(dnsmasq){}
redis使用for循环处理参数；有个程序使用while处理参数。两个都行且灵活性更高。

