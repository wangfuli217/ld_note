https://blog.csdn.net/breaksoftware/article/category/6964888

epoll的相关系统调用
epoll只有epoll_create,epoll_ctl,epoll_wait 3个系统调用。

1. 如果事件 fd 被注册到多个 epoll 中, 事件发生发生时, 每个 epoll 都能触发
2. 如果注册到 epoll 的 fd 被关闭, 会被自动清除出 epoll, 即不需要 epoll_ctl EPOLL_CTL_DEL.
3. epoll_wait() 会一直监听 epollhup 事件, 即不需要手工添加 EPOLLHUP events.
4. 为了避免大量 IO 时, ET 模式下 fd 被饿死的情况, Linux 下建议在拥有 fd 的数据结构中增加 ready 位,
   epoll_wait() 触发事件后仅做置位, 在消费者线程中轮询置位的 fd 列表处理, 即朴素的生产者－消费者模型.
5. fd 的注册的 events 类型清空之后, 需要 epoll_ctl(epoll_fd, EPOLL_CTL_MOD, fd, &events) 来重设监听 events 类型.
6. epoll_ctl() 和 epoll_wait() 可以不在一个线程, epoll_ctl() 加入事件之后, epoll_wait() 立即就能知道.
7. 在 LT 模式下, 如果对端 socket 关闭, 会一直触发 EPOLLIN. 如果是 ET 模式, 触发 EPOLLIN, 如果此时处理程序只做了一次 recv,
   并根据收到的长度来判断后续处理, 将丢失这一条 socket 关闭事件. 可以在这种情况下尝试多做一次 recv.
8. epoll_create() 的参数 size, 只要大于 0 即可

在nginx中，epoll_wait时间是最快发生的事件的时间，根据上面几点就不难理解了，可以很好的解决超时问题，
而varnish中直接是永远等待，因为epoll作为单独线程加超时检测线程，效率也不错。

epoll_create(打开一个epoll文件描述符){
int epoll_create(int size);
1. 创建一个epoll的句柄。自从linux2.6.8之后，size参数是被忽略的。
2. close用于关闭；销毁和释放相关的资源用于重复利用
3. EPOLL_CLOEXEC|FD_CLOEXEC-fcntl-> O_CLOEXEC int epoll_create1(int flags);
EINVAL：size不能为负值值；或者flag这个值被设置了错误的标识。
EMFILE： /proc/sys/fs/epoll/max_user_instances
ENFILE：文件描述符不足
ENOMEM：系统内存不足
    需要注意的是，当创建好epoll句柄后，它就是会占用一个fd值，在linux下如果查看/proc/进程id/fd/，是能够看到这个fd的，
所以在使用完epoll后，必须调用close()关闭，否则可能导致fd被耗尽。
}

epoll_ctl(epoll文件描述符的控制接口){
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
对epfd文件描述符控制的系统调用，对文件描述符fd执行op操作。
第二个参数表示动作，用三个宏来表示：
  EPOLL_CTL_ADD：将fd和event信息注册到epfd
  EPOLL_CTL_MOD：修改注册到epfe的fd和event信息
  EPOLL_CTL_DEL：将fd和event信息从epfd注销掉，此时event可以NULL
第三个参数是需要监听的fd
第四个参数是告诉内核需要监听什么事
EBADF： epfd 或 fd 不是一个有效文件描述符
EEXIST：执行了EPOLL_CTL_ADD，但是fd已经注册存在
EINVAL：epfd不是epoll_create创建的文件描述符或者op不支持fd文件描述符对应操作--将epfd注册到epfd中
ENOENT： EPOLL_CTL_MOD 或 EPOLL_CTL_DEL操作时，fd没有注册
ENOMEM： 没足够内存
ENOSPC：  /proc/sys/fs/epoll/max_user_watches 限制epoll使用的内存量；32bit每个文件描述符需要90bytes
EPERM：                                                              64bit每个文件描述符需要120bytes
}
epoll_event(感兴趣的事件和被触发的事件){
__uint32_t events; /* Epoll events */  
epoll_data_t data; /* User data variable */  

events可以是以下几个宏的集合：
EPOLLIN ：可以读；                          read
EPOLLOUT：可以写；                          write
EPOLLPRI：有紧急的数据可读；                read
EPOLLERR：发生错误；                        无需注册
EPOLLHUP：被挂断；对端调用shutdown半关闭    无需注册
EPOLLET： 将EPOLL设为边缘触发模式，默认是水平触发。 边缘触发要求read|write直到EAGAIN终止。
EPOLLONESHOT：只监听一次事件，当监听完这次事件之后，如果还需要继续监听这个socket的话，需要再次把这个socket加入到EPOLL队列里
}
epoll_data(保存触发事件的某个文件描述符相关的数据){
void *ptr;  
int fd;  
__uint32_t u32;  
__uint64_t u64;  
}
epoll_wait(等待epoll文件描述符上的IO事件){
int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
events   ：能够获得的足够多的事件
maxevents：必须大于0；最多maxevents个事件被返回。
timeout  ：毫秒，
           0，不阻塞立即返回
           -1，阻塞直到监听的一个fd上有一个感兴趣事件发生
           大于0，阻塞指定时间(单位毫秒)。直到监听的fd上有感兴趣事件发生，或者捕捉到信号
如果函数调用成功，返回对应I/O上已准备好的文件描述符数目，如返回0表示已超时。
>0  : 有IO事件
    通常遍历events[0]~events[返回值-1]的元素。这些都是就绪的。并且保存了就绪的事件。
    events下标与fd并不相同
=0  : 没有IO事件，超过设定时间
= -1: 异常
  EBADF    epfd 不是合法文件描述符
  EFAULT   events关联的内存没有写权限
  EINTR    超时或者信号中断
  EINVAL   epfd不是epoll_create创建文件描述符，或maxevents等于0
  
  
}
epoll_pwait(屏蔽信号触发){
ready = epoll_pwait(epfd, &events, maxevents, timeout, &sigmask);
sigmask=NULL时，epoll_pwait = epoll_wait
sigset_t origmask;
sigprocmask(SIG_SETMASK, &sigmask, &origmask);
ready = epoll_wait(epfd, &events, maxevents, timeout);
sigprocmask(SIG_SETMASK, &origmask, NULL);
}

select(BSD){
int select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout); 
select 第一个参数 nfds 的意思是"最大文件描述符编号值加 1"; # /usr/include# grep "FD_SETSIZE" * -rn 
中间 3 个参数 readfds（读）、writefds（写） 和 exceptfds（异常） 是指向描述符集的指针
timeout 的取值有以下 3 中情况：
timeout == NULL
    永远等待。如果捕捉到一个信号则中断此无限期等待。当所指定的描述符中的已准备好或捕捉到一个信号则返回。如果捕捉到一个信号，则 select 返回 -1，errno 设置为 EINTR。 
timeout->tv_sec == 0 && timeout->tv_usec == 0
    根本不等待。测试所有指定的描述符并立即返回。这是轮询系统找到多个描述符状态而不阻塞 select 函数的方法。
timeout->tv_sec != 0 || timeout->tv_usec ！= 0
    等待指定的秒数和微妙数。当指定的描述符之一已准备好，或当指定的时间值已经超过时立即返回。如果在超时到期时还没有一个描述符准备好，则返回值是 0。

返回值
返回值 -1表示出错。
    这是可能发生的，例如，在所指定的描述符一个都没准备好时捕捉到一个信号。在此情况下，一个描述符集都不修改。
返回值 0 表示没有描述符准备好。
    若指定的描述符一个都没准备好，指定的时间就过去了，那么就会发生这种情况。此时，所有描述符集都会置 0.
一个正返回值说明了已经准备好的描述符数。
    该值是 3 个描述符集中已准备好的描述符数之和，所以如果同一描述符已准备好读和写，那么在返回值中会对
其计两次数。在这种情况下，3 个描述符集中仍旧打开对的位对应于已准备好的描述符。

    select 的超时值用 timeval 结构指定，但 pselect 使用 timespec 结构。timespec 结构以秒和纳秒表示超时值，
而非秒和微妙。如果平台支持这样的时间精度，那么 timespec 就能提供精确的超时时间。
    pselect 的超时值被声明为 const，这保证了调用 pselect 不会改变此值。
    pselect 可使用可选信号屏蔽字。若 sigmask 为 NULL，那么在与信号有关的方面，pselect 的运行状况和 select
相同。否则，sigmask 指向一信号屏蔽字，在调用 pselect 时，以原子操作的方式安装该信号屏蔽字。在返回时，
恢复以前的信号屏蔽字。
}

poll(System V){
int poll(struct pollfd *fds, nfds_t nfds, int timeout);  
1、参数解析
与 select 不同，poll 不是为每个条件（可读性、可写性和异常条件）构造一个描述符集，而是构造一个 pollfd 结构的数组，
每个数组元素指定一个描述符 编号以及我们队该描述符感兴趣的条件。
struct pollfd {  
               int   fd;         /* file descriptor */  
               short events;     /* requested events */  
               short revents;    /* returned events */  
           };  
fds 数组中的元素数由 nfds 指定。
POLLIN | POLLPRI 等价于 select() 的读事件，
POLLOUT |POLLWRBAND 等价于 select() 的写事件。
POLLIN 等价于 POLLRDNORM |POLLRDBAND，而 POLLOUT 则等价于 POLLWRNORM。
timeout == -1
    永远等待。（某些系统在 <stropts.h>中定义了常量 INFTIM，其值通常是 -1）当所指定的描述符中的一个已准备好，或捕捉到一个信号时返回。如果捕捉到一个信号，则 poll 返回 -1，errno 设置为 EINTR。
timeout == 0
    不等待。测试所有描述符并立即返回。这是一种轮询系统的方法，可以找到多个描述符的状态而不阻塞 poll 函数。
timeout > 0
    等待 timeout 毫秒。当指定的描述符之一已准备好，或 timeout 到期时还没有一个描述符准备好，则返回值是 0.（如果系统不提供毫秒级精度，则 timeout 值取整到最近的支持值）。
}

select_poll(){
poll()与select()返回正数时，其含义有差别：
  select()： 如果同一个文件描述符在多个fd集(select有三个fd集合)中返回，则返回值也统计多次
  poll()：即使同一个fd出现在多个pollfd元素的revents成员中，也只被统计一次。
}