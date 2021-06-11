# 根据cmd的不同有以下三种类型的调用  
int fcntl(int fd, int cmd);  
int fcntl(int fd, int cmd, long arg);  
int fcntl(int fd, int cmd, struct flock *lock);  

//良好的写法是： 
int oldflags = fcntl(fd,F_GETFD); 
oldflags |= FD_CLOEXEC;      //设置该标志 
fcntl(fd,F_SETFD,oldflags); 
oldflags &= ~FD_CLOEXEC;     //如果要清除该标志 

F_DUPFD(复制一个文件描述符){  F_DUPFD_CLOEXEC
int fcntl(int fd, int cmd); 
newfd = fcntl(fd, F_DUPFD, 3)
找到一个数值最小空闲的文件描述符，该文件描述符应该大于等于arg指定的文件描述符

int dup(int oldfd):             将最小的空闲文件描述符返回
int dup2(int oldfd, int newfd); 如果newfd是一个有效的文件描述符，关闭newfd文件描述符；将oldfd拷贝给newfd然后返回
1. 如果oldfd不是一个有效文件描述符，不关闭newfd文件描述符，直接返回错误；
2. 如果oldfd  是一个有效文件描述符，newfd等于oldfd时候，不做任何修改直接返回；

a. 共享 offset 和 status
b. 不共享 flag:FD_CLOEXEC
EBADF: oldfd无效；newfd超过了限定范围
EBUSY：存在竞争关系
EINTR：不中断
EMFILE：进程文件描述符超限
}
F_GETFD(文件描述符标志){
cmd = F_GETFD(void) 获得文件描述符标志；                                                         arg被忽略
cmd = F_SETFD(long) 设置文件描述符标志；arg = 描述符标志的值，目前只定义了一个标志： FD_CLOEXEC  arg被指定
int fcntl(int fd, int cmd); 
int fcntl(int fd, int cmd, long arg); 

FD_CLOEXEC: 不需要F_GETFD获取，直接设置即可。
fcntl(sigfd.wr , F_SETFD, FD_CLOEXEC);
fcntl(sigfd.rd , F_SETFD, FD_CLOEXEC);
}
F_GETFL(文件状态标志){
int fcntl(int fd, int cmd);

int flags = fcntl(sigfd.wr, F_GETFL); 
int flags = fcntl(sock, F_GETFL, 0);
说明：F_GETFL的时候，第三个参数可以忽略也可以设置成0。

int fcntl(int fd, int cmd, long arg); 
cmd = F_GETFL(void)
cmd = F_SETFL(long) 1. O_RDONLY, O_WRONLY, O_RDWR                        访问权限
              2. O_CREAT, O_EXCL, O_NOCTTY, O_TRUNC                      创建标识
              3. O_APPEND, O_ASYNC, O_DIRECT, O_NOATIME, and O_NONBLOCK  其他标识
}
F_GETOWN(SIGIO和SIGURG信号){
F_GETOWN, F_SETOWN, F_GETOWN_EX, F_SETOWN_EX, F_GETSIG and F_SETSIG

cmd = F_GETOWN，获得当前接收SIGIO和SIGURG信号的进程ID或进程组ID 
cmd = F_SETOWN，设置接收SIGIO和SIGURG信号的进程ID或进程组ID；arg = 进程ID或进程组ID 
int fcntl(int fd, int cmd); 
int fcntl(int fd, int cmd, long arg); 
}
return(返回值){
对于成功的调用，根据操作类型cmd不同，有以下几种情况： 
       F_DUPFD  返回新的文件描述符 
       F_GETFD  返回文件描述符标志 
       F_GETFL  返回文件状态标志 
       F_GETOWN 进程ID或进程组ID 
       All other commands  返回0 
调用失败， 返回-1，并设置errno。 
}

F_GETLK(概述){
记录锁相当于线程同步中读写锁的一种扩展类型，可以用来对有亲缘或无亲缘关系的进程进行文件读与写的同步。
通过fcntl函数来执行上锁操作。尽管读写锁也可以通过在共享内存区来进行进程的同步，但是fcntl记录上锁往往更容易使用，且效率更高。

记录锁的功能：当一个进程正在读或修改文件的某个部分是，它可以阻止其他进程修改同一文件区。
1. 记录锁不仅仅可以用来同步不同进程对同一文件的操作，还可以通过对同一文件加记录锁，来同步不同进程对某一共享资源的访问，
   如共享内存，I/O设备
2. 对于劝告性上锁(POSIX定义的记录锁即是这种类型的锁)，当一个进程通过上锁对文件进行操作时，它不能阻止另一个
   非协作进程对该文件的修改。
3. 即使是强制性上锁(有些系统定义)，也不能完全保证该文件不会被另一个进程修改。因为强制性锁对unlink函数没有影响，
   所以一个进程可以先删除该文件，然后再将修改后的内容保存为同一文件来实现修改。
}

F_GETLK(锁){
cmd = F_GETLK      测试能否建立一把锁 
cmd = F_SETLK      设置锁 
cmd = F_SETLKW     阻塞设置一把锁 
 
# POSIX只定义fock结构中必须有以下的数据成员，具体实现可以增加  
struct flock {  
      short l_type;    /* 锁的类型: F_RDLCK, F_WRLCK, F_UNLCK */  
      short l_whence;  /* 加锁的起始位置:SEEK_SET, SEEK_CUR, SEEK_END */  
      off_t l_start;   /* 加锁的起始偏移，相对于l_whence */  
      off_t l_len;     /* 上锁的字节数，如果为0，表示从偏移处一直到文件的末尾*/  
      pid_t l_pid;     /* 进程的 ID (l_pid)持有的锁能阻塞当前进程(仅由 F_GETLK 返回) */  
      /*...*/  
};  

F_SETLK：获取(l_type为F_RDLCK或F_WRLCK)或释放由lock指向flock结构所描述的锁，如果无法获取锁时，
         该函数会立即返回一个EACCESS或EAGAIN错误，而不会阻塞。
F_SETLKW：F_SETLKW和F_SETLK的区别是，无法设置锁的时候，调用线程会阻塞到该锁能够授权位置。
F_GETLK： F_GETLK主要用来检测是否有某个已存在锁会妨碍将新锁授予调用进程，如果没有这样的锁，
          lock所指向的flock结构的l_type成员就会被置成F_UNLCK，否则已存在的锁的信息将会写入lock所指向的flock结构中

锁类型： F_RDLCK(共享读锁)、F_WRLCK(独占性写锁)或 F_UNLCK(解锁一个区域)

为了锁整个文件，通常的方法是将l_start说明为0,l_whence说明为SEEK_SET，l_len说明为0。

    记录锁相当于读写锁的一种扩展类型，记录锁和读写锁一样也有两种锁：
共享读锁(F_RDLCK)和独占写锁(F_WRLCK)。在使用规则上和读写锁也基本一样：
  读锁：共享锁，对一个文件的特定区域可以加多把读锁
  写锁，排它锁，对一个文件的特定区域只能加一把写锁

1. 文件给定字节区间，多个进程可以有一把共享读锁，即允许多个进程以读模式访问该字节区；
2. 文件给定字节区间，只能有一个进程有一把独占写锁，即只允许有一个进程已写模式访问该字节区；
3. 文件给定字节区间，如果有一把或多把读锁，不能在该字节区再加写锁，同样，如果有一把写锁，不能再该字节区再加任何读写锁。

    规则只适用于不同进程提出的锁请求，并不适用于单个进程提出的多个锁请求。即如果一个进程对一个文件区间已经有了一把锁，
后来该进程又试图在同一文件区间再加一把锁，那么新锁将会覆盖老锁。

1. 同一进程可以对已加锁的同一文件区间，仍然能获得加锁权限 
2. 不同进程不能对已加写锁的同一文件区间，获得加锁权限
注意： 加锁时，该进程必须对该文件有相应的文件访问权限，即加读锁，该文件必须是读打开，加写锁时，该文件必须是写打开
}

fcntl(moosefs){
mylock(fd) : 0     自己加锁成功
             pid_t 其他进程加锁中
             -1    fcntl调用失败
wdlock(runmode,timeout) -> -t timeout 命令行参数
-> mylock(fd)
-1    fcntl调用失败   -> 退出进程
pid_t 其他进程加锁中  -> RM_TEST   打印pid值退出                       -> return 0
                      -> RM_START  不能start，已经有进程处于start状态  -> return 1
                      -> RM_RELOAD  SIGHUP                             -> 信号成功0，信号失败1
                      -> RM_INFO    SIGUSR1                            -> 信号成功0，信号失败1
                      -> RM_KILL    SIGKILL                            -> 信号失败1
                      -> 其他       SIGTERM                            -> 信号失败1
                     RM_STOP & RM_KILL do{ -> mylock(fd) }
                                          -1    fcntl调用失败   -> 退出进程
                                          pid_t 其他进程加锁中  -> 超时以内发送SIGTERM
                                                                -> 超时以外发送SIGKILL
                                           0     自己加锁成功   -> 此时 mylock(fd)已经将锁pid设置成自己的pid
0     自己加锁成功   -> RM_START           将进程pid写入lock文件
                     -> RM_RESTART         将进程pid写入lock文件
                     -> RM_TRY_RESTART     输出错误提示
                     -> RM_STOP | RM_KILL  输出错误提示
                     -> RM_RELOAD          输出错误提示
                     -> RM_INFO            输出错误提示
                     -> RM_TEST            输出错误提示  
}
mylock(moosefs){
    struct flock fl;
    fl.l_start = 0;
    fl.l_len = 0;
    fl.l_pid = getpid();
    fl.l_type = F_WRLCK;
    fl.l_whence = SEEK_SET;
#     for (;;) {
#         if (fcntl(fd,F_SETLK,&fl)>=0) {               // lock set
#             return 0;                                 // ok
#         }
#         if (errno!=EAGAIN && errno!=EWOULDBLOCK) {    // error other than "already locked"
#             return -1;                                // error
#         }
#         if (fcntl(fd,F_GETLK,&fl)<0) {                // get lock owner
#             return -1;                                // error getting lock
#         }
#         if (fl.l_type!=F_UNLCK) {                     // found lock
#             return fl.l_pid;                          // return lock owner
#         }
#     }
#     return -1;
}

fcntl(busybox:syslogd){
每次写入的时候，写入前 调用fcntl(G.logFD, F_SETLKW, &fl);{fl.l_type = F_WRLCK}
                写入后 调用fcntl(G.logFD, F_SETLKW, &fl);{fl.l_type = F_UNLCK}
该调用没有检查错误值，直接调用
}

lock(记录锁的粒度){
记录上锁：对于UNIX系统而言，"记录"这一词是一种误用，因为UNIX系统内核根本没有使用文件记录这种概念，更适合的术语应该是字节范围锁，
          因为它锁住的只是文件的一个区域。用粒度来表示被锁住文件的字节数目。对于记录上锁，粒度最大是整个文件。
文件上锁：是记录上锁的一种特殊情况，即记录上锁的粒度是整个文件的大小。

之所以有文件上锁的概念是因为有些UNIX系统支持对整个文件上锁，但没有给文件内的字节范围上锁的能力。
}
lock(锁与进程和文件){
1. 锁与进程和文件两方面有关，体现在：
   当一个进程终止时，它所建立的记录锁将全部释放；
   当关闭一个文件描述符时，则进程通过该文件描述符引用的该文件上的任何一把锁都将被释放。
2. 由fork产生的子进程不继承父进程所设置的锁。即对于父进程建立的锁而言，子进程被视为另一个进程。
   记录锁本身就是用来同步不同进程对同一文件区进行操作，如果子进程继承了父进程的锁，
   那么父子进程就可以同时对同一文件区进行操作，这有违记录锁的规则，所以存在这么一条规则。
3. 执行exec后，新程序可以继承原执行程序的锁。但是，如果一个文件描述符设置了close-on-exec标志，
   在执行exec时，会关闭该文件描述符，所以对应的锁也就被释放了，也就无所谓继承了。
}
lock(test1){
lock_header.h

self_wlk_and_rlk.c  # 进程自身重复加锁
fork_wlk_and_rlk.c  # 父进程writew_lock|readw_lock阻塞子进程执行
file_process_lock_next.c file_process_lock_prev.c # file_process_lock_prev阻塞file_process_lock_next执行
file_rlock_children_rwlock # 父进程readw_lock阻塞子进程writew_lock，不阻塞子进程readw_lock
file_wlock_children_rwlock # 父进程writew_lock阻塞子进程writew_lock，阻塞子进程readw_lock
file_wlock_children_rwlock_sleep # 父进程writew_lock阻塞子进程writew_lock，阻塞子进程readw_lock
}

lock(test2){
test_fcntl.h
test_fcntl.c
test_lock.c
}

lock(test3){
readw_lock_s10l20.c # 阻塞读锁start：10 length:20
write_lock_s10end.c # 非阻塞写锁start:10 end
ulock_total.c       # 阻塞解锁total
is_read_lock.c      # 测试是否是read锁
}

flock(建议性锁){
flock 提供的文件锁是建议性质的。所谓 "建议性锁"，通常也叫作非强制性锁，即一个进程可以忽略其他进程加的锁，直接对目标文件进行读写操作。因而，
只有当前进程主动调用 flock去检测是否已有其他进程对目标文件加了锁，文件锁才会在多进程的同步中起到作用。
表述的更明确一点，就是如果其他进程已经用 flock 对某个文件加了锁，当前进程在读写这一文件时，未使用 flock 加锁（即未检测是否已有其他进程锁定文件）
那么当前进程可以直接操作这一文件，其他进程加的文件锁对当前进程的操作不会有任何影响。
这就种可以被忽略、需要双方互相检测确认的加锁机制，就被称为 "建议性" 锁。

文件锁必须作用在一个打开的文件上，即从应用的角度看，文件锁应当作用于一个打开的文件句柄上。知所以需要对打开的
文件加锁，是和 linux 文件系统的实现方式、及多进程下锁定文件的需求共同决定的，在下文对其原理有详细介绍。
}
flock(api){
int flock(int fd, int operation);
当 flock 执行成功时，会返回0；当出现错误时，会返回 -1，并设置相应的 errno 值。

在flock 原型中，参数 operation 可以使用 LOCK_SH 或 LOCK_EX 常量，分别对应共享锁和排他锁。                                      
LOCK_SH 1  当使用 LOCK_SH 共享锁时，多个进程可以都使用共享锁锁定同一个文件，从而实现多个进程对文件的并行读取。                                   
LOCK_EX 2  当使用LOCK_EX 排他锁时，同一时刻只能有一个进程锁定成功，其余进行只能阻塞                                    
LOCK_UN 8                                                                               
LOCK_NB 4 
只有两个进程都对文件加的都是共享锁时，进程可以正常执行，不会阻塞，其他情形下，后加锁的进程都会被阻塞

int ret = flock(open_fd, LOCK_SH | LOCK_NB);
int ret = flock(open_fd, LOCK_EX | LOCK_NB);
}
flock(调用dup 、 fork、execve 时的文件锁){
1. 使用 dup 复制文件描述符
    用 dup 复制文件描述符时，新的文件描述符和旧的文件描述符共享同一个文件表表项，
调用 dup 后，两个描述符指向了相同的文件表项，而flock 的文件锁是加在了文件表项上，
因而如果对 fd0 加锁那么 fd1 就会自动持有同一把锁，释放锁时，可以使用这两个描述符中的任意一个。

2. 通过 fork 产生子进程
    通过fork 产生子进程时，子进程完全复制了父进程的数据段和堆栈段，父进程已经打开的文件描述符也会被复制，
但是文件表项所在的文件表是由操作系统统一维护的，并不会由于子进程的产生而发生变化，
父进程中的 fd0 和子进程中的fd0 持有的是同一个锁，因而在释放锁时，可以使用父进程或子进程中的任意一个fd。

3. 子进程重复加锁
子进程中新加的锁会生效，所有指向同一文件表项的fd 持有的锁都会变为子进程中新加的锁。可以认为，子进程新加的锁起到了修改锁类型的作用。

4. execve 函数族中的文件锁
    在fork 产生子进程后，一般会调用 execve 函数族在子进程中执行新的程序。如果在调用 execve 之前，子进程中某些
打开的文件描述符已经持有了文件锁，那么在执行execve 时，如果没有设置 close-on-exec 标志，那么在新的程序中，
原本打开的文件描述符依然会保持打开，原本持有的文件锁还会继续持有。
}

flock(文件锁的解除){
    文件锁的解除可以通过将 flock 的 operation 参数设置为 LOCK_UN 常量来实现。这时如果有多个fd 指向同一文件表项，
例如给 fd0 加文件锁后，用 dup 复制了fd0 的情况下，用 LOCK_UN 对fd0 解锁后，所有和 fd0 指向同一文件表项的 fd 
都不再持有文件锁。fork 子进程复制父进程文件描述符的情形也是如此

关闭文件时自动解解锁
    对描述符fd加了文件锁后，如果没有显式使用LOCK_UN 解锁，在关闭 fd 时，会自动解除其持有的文件锁。
但是在为 fd 加锁后如果调用 了dup 复制了文件描述符，这时关闭fd 时的表现和调用 LOCK_UN 是不一样的。
}

flock_fcntl(){
1. 首先要知道flock函数只能对整个文件上锁，而不能对文件的某一部分上锁，这是于fcntl/lockf的第一个重要区别，后者可以对文件的某个区域上锁。
2. 其次，flock只能产生劝告性锁。我们知道，linux存在强制锁(mandatory lock)和劝告锁(advisory lock)。
       所谓强制锁，比较好理解，就是你家大门上的那把锁，最要命的是只有一把钥匙，只有一个进程可以操作。
       所谓劝告锁，本质是一种协议，你访问文件前，先检查锁，这时候锁才其作用，如果你不那么kind，不管三七二十一，就要读写，
       那么劝告锁没有任何的作用。而遵守协议，读写前先检查锁的那些进程，叫做合作进程。
3. 再次，flock和fcntl/lockf的区别主要在fork和dup。
}
flock(redis){
clusterLockConfig函数
  flock(fd,LOCK_EX|LOCK_NB) 
    -1: errno == EWOULDBLOCK    已经存在相同的进程
        errno != EWOULDBLOCK    系统接口调用失败
     0: 加锁成功，正常运行
}
flock(busybox:runsv)(
lock_exnb -> flock(fd,LOCK_EX | LOCK_NB); -> 与redis调用类似，返回-1时，返回错误，不再明确错误类型
lock_ex   -> flock(fd,LOCK_EX);
)
flock(toybox:flock){
flock -u 解锁
      -s 共享锁
      -n 非阻塞
 非阻塞锁失败是一种返回类型
 阻塞锁失败是一种返回类型
}
O_ACCMODE(){
当判断一个文件的读写标志时，不能简单的通过 & 操作来判断，因为文件的读写标志有三种状态，
系统中并非设置了三个独立位来表示，实际上是用了两个位来表示的。所以最好使用 O_ACCMODE (0x3)来进行 & 操作。
flags &= O_ACCMODE;
  flags == O_RDONLY
  flags == O_WRONLY
其他的标志可以直接用 & 来判断，如flags&O_APPEND
}
F_GETOWN(设置接收SIGIO信号的进程或进程组ID){
F_GETOWN    获取收到SIGIO信号的进程或进程组ID
F_SETOWN    设置接收SIGIO信号的进程或进程组ID
}