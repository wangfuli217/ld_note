IO(I/O模型:同步I/O){
阻塞式IO: read阻塞进程直至数据被拷贝进用户地址空间；write在数据被拷贝到page cache后结束.
非阻塞式I/O: O_NONBLOCK非阻塞模式打开(open)文件或修改文件fd(fcntl), read时候不阻塞进程, 没数据可读则返回EAGIN错误.
I/O复用(select/poll/epoll): 也称异步阻塞.
信号驱动I/O：内核在描述符就绪时发生SIGIO信号通知程序.
}
IO(I/O模型:异步I/O){
告知内核执行某个操作，待内核在操作完成后通知程序.
与信号驱动I/O区别：信号驱动I/O由内核通知我们何时启动一个I/O操作，异步I/O由内核通知我们何时I/O操作完成.
相关库：libaio(内核支持)和posix aio(用户层，用多线程模拟异步IO).
}
IO(IO编程:类型){
系统IO：面向文件描述符的不带缓冲(unbuffered)的IO，每次read和write调用都直接调用底层系统调用.
标准IO：面向流的带缓冲的IO，目的是尽可能减少read和write调用的次数.
}
IO(IO编程:系统IO){
默认情况下，读写文件都经过页高速缓存(page cache)，可通过open函数的相关flag控制.
STDIN_FILENO、STDOUT_FILENO和STDERR_FILENO.
相关函数：open, read, write, fsync等.
底层使用内核的磁盘高速缓存，该缓存是内核拥有，对内核态的所有进程都可见.
}
IO(IO编程:标准IO){
stdin、stdout和stderr表示三个标准工作流.
相关函数：printf等.
}
IO(系统IO:访问文件的模式){
规范模式：open文件，O_SYNC和O_DIRECT都为0，内容由read和write来存取，read阻塞进程直至数据被拷贝进用户地址空间；write在数据被拷贝到page cache后结束.
同步模式：open文件O_SYNC为1或打开后使用fcntl设置为1，只影响write，write操作将阻塞进程，直至数据被有效写入磁盘.
内存映射模式：打开文件后，调用mmap将文件映射到内存，文件称为ram中的一个数组，可以直接访问，无需通过read和write访问.
直接IO模式：O_DIRECT置为1，读写操作都将数据在用户态地址空间和磁盘间直接传送而不通过页高速缓存，通常会降低性能，但是在特定情况下有用，例如程序有自己的缓存(cache).
异步IO模式.
sync
fsync
fdatasync
}
IO(标准IO:目的){
提供缓冲的目的尽可能减少read和write的调用次数.
缓冲可由标准IO自动刷新(例如填满时)或调用fflush手动触发刷新
}
IO(标准IO:宏){
BUFSIZ, EOF, FILENAME_MAX,FOPEN_MAX, L_cuserid, L_ctermid, L_tmpnam, NULL, SEEK_END, SEEK_SET, SEE_CUR, 
TMP_MAX, clearerr,  feof,  ferror,  fileno,fropen,  fwopen,  getc,  getchar,  putc,  putchar, 
stderr, stdin, stdout.  
       
}
IO(标准IO:三种类型缓冲){
全缓冲：该情况下，只有在填满标准I/O缓冲区后才进行实际的I/O操作。
行缓冲：当输入和输出中遇到换行符时，标准库IO会执行刷新，当涉及到中断时(例如stdin和stdout)时，通常使用行缓冲.
不带缓冲：标准出错.

对于磁盘上的文件，进行标准IO操作时一般都是全缓冲
如果流指向一个终端(通常stdout都是这样)，那么它是行缓冲的。
标准错误流 stderr 默认总是无缓冲的。

相关函数: setbuf和setvbuf改变系统默认的缓冲类型; fflush强制刷新缓冲.
setbuf    流缓冲操作  # setvbuf(stream, buf, buf ? _IOFBF : _IONBF, BUFSIZ);
setbuffer 流缓冲操作  # setvbuf(stream, buf, _IOLBF, size);
setlinebuf流缓冲操作  # setvbuf(stream, (char *)NULL, _IOLBF, BUFSIZ);

setvbuf   流缓冲操作 # 只能在打开一个流，还未对它进行任何其他操作之前使用。
int setvbuf(FILE *stream, char *buf, int mode , size_t size);
mode: _IONBF 无缓冲   _IOLBF 行缓冲  _IOFBF 完全缓冲
     除非是无缓冲的文件，否则参数 buf 应当指向一个长度至少为 size 字节的缓冲
     这个缓冲将取代当前的缓冲。
如果参数buf是NULL，只有这个模式会受到影响；下次read或write操作还将分配一个新的缓冲。
}

文件的打开操作 fopen 打开一个文件

文件的关闭操作 fclose 关闭一个文件

文件的读写操作 fgetc 从文件中读取一个字符
　　　　　　　 fputc 写一个字符到文件中去
　　　　　　　 fgets 从文件中读取一个字符串
　　　　　　　 fputs 写一个字符串到文件中去
　　　　　　　 fprintf 往文件中写格式化数据
　　　　　　　 fscanf 格式化读取文件中数据
　　　　　　　 fread 以二进制形式读取文件中的数据
　　　　　　　 fwrite 以二进制形式写数据到文件中去
　　　　　　　 getw 以二进制形式读取一个整数
　　　　　　　 putw 以二进制形式存贮一个整数

文件状态检查函数 feof 文件结束
　　　　　　　 ferror 文件读/写出错
　　　　　　　 clearerr 清除文件错误标志
　　　　　　　 ftell 了解文件指针的当前位置

文件定位函数 rewind 反绕
　　　　　　　 fseek 随机定位

IO(标准IO:打开标准I/O流){
fopen: 打开路径名为pathname的一个指定文件.                                                       
  r   打开文本文件，用于读。流被定位于文件的开始。    
  r+  打开文本文件，用于读写。流被定位于文件的开始。  
  w   将文件长度截断为零，或者创建文本文件，用于写。流被定位于文件的开始。  
  w+  打开文件，用于读写。如果文件不存在就创建它，否则将截断它。流被定位于文件的开始。
  a   打开文件，用于追加 (在文件尾写)。如果文件不存在就创建它。流被定位于文件的末尾。
  a+  打开文件，用于追加
        (在文件尾写)。如果文件不存在就创建它。读文件的初始位置是文件的开始，但是输出总是被追加到文件的末尾。
任何新建的文件将具有模式  S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH (0666)，然后以进程的掩码值 umask 加以修改. 

r   O_RDONLY
r+  O_RDWR
w   O_WRONLY | O_CREAT | O_TRUNC
w+  O_RDWR | O_CREAT | O_TRUNC
a   O_WRONLY | O_CREAT | O_APPEND
a+  O_RDWR | O_CREAT | O_APPEND

r代表read的简写，+代表可读可写，w代表write，b代表bit二进制位，t代表text
r 打开只读文件，该文件必须存在
r+ 打开可读可写的文件，该文件必须存在(这里的写文件是指将之前的文件覆盖
rt 打开只读文本文件，该文本必须存在
rt+ 读写打开一个文本文件，允许读和写，该文件必须存在(这里的写文件是指将之前的文件覆盖
rb 只读打开一个二进制文件，，该文本必须存在
rb+ 读写打开一个文本文件，允许读和写，该文件必须存在(这里的写文件是指将之前的文件覆盖

w 打开只写文件，若文件存在，则文件长度清零，即文件内容会消失，若文件不存在则建立该文件
w+ 打开可读写文件，若文件存在，则文件长度清零，即文件内容会消失，若文件不存在则建立该文件(这里的读文件，同样需要使用rewind()函数)
wt 打开只写文本文件，若文件存在，则文件长度清零，即文件内容会消失，若文件不存在则建立该文件
wt+ 打开可读写文本文件，若文件存在，则文件长度清零，即文件内容会消失，若文件不存在则建立该文件
wb 打开只写二进制文件，若文件存在，则文件长度清零，即文件内容会消失，若文件不存在则建立该文件
wb+ 打开可读写文件，若文件存在，则文件长度清零，即文件内容会消失，若文件不存在则建立该文件

a以附加的方式打开只写文件，若文件不存在，则建立文件，存在则在文件尾部添加数据,即追加内容
a+以附加的方式打开可读写文件，不存在则建立文件，存在则写入数据到文件尾(这里的读文件，同样需要使用rewind()函数，但是写文件不需要rewind()函数，a是追加)
at二进制数据的追加，不存在则创建，只能写。
at+读写打开一个文本文件，允许读或在文本末追加数据(这里的读文件，同样需要使用rewind()函数，但是写文件不需要rewind()函数，a是追加)
ab二进制数据的追加，不存在则创建，只能写。
ab+读写打开一个二进制文件，不存在则创建,允许读或在文本末追加数据(这里的读文件，同样需要使用rewind()函数，但是写文件不需要rewind()函数，a是追加)


fdopen: 取一个已存在的文件描述符的(open, socket等创建的)的标准I/O流.
   流的模式mode  (取值为 "r", "r+", "w", "w+", "a", "a+" 之一)必须与文件描述符的模式相匹配。
   新的流的定位标识被设置为  fildes  原有的值，错误和文件结束标记被清除。
   模式  "w"  或者  "w+"不会截断文件。
   文件描述符不会被复制，在关闭由 fdopen 创建的流时，也不会被关闭。
   对共享内存对象实施 fdopen 的结果是未定义的。
   
freopen:函数在一个指定的流上打开一个指定的文件.

int fclose(FILE *stream);
函数fclose 将名为stream的流与它底层关联的文件或功能集合断开。如果流曾用作输出，任何缓冲的数据都将首先被写入，使用fflush(3) 。

void clearerr(FILE *stream) 清除 stream 指向的流中的文件结束标记和错误标记
int feof(FILE *stream);  测试指向的流中的文件结束标记，如果已设置就返回非零值。文件结束标记只能用函数 clearerr 清除。
int ferror(FILE *stream);测试 stream 指向的流中的错误标记，如果已设置就返回非零值。错误标记只能用函数 clearerr 重置
 
 
1. fdopen和socket 实现HTTP、SMTP、SIP、SOAP等等全都是文本协议处理。
  FILE *fdopen(int fildes, const char *mode);
假设sockfd是用socket()建立的一个socket描述符。调用
  fpin=fdopen(sockfd,"r");
  fpout=fdopen(dup(sockfd),"w");
可以建立两个FILE指针fpin和fpout。
调用
  setlinebuf(fpin);
  setlinebuf(fpout);
可以将缓冲模式设置成行缓冲。

现在在这两个FILE指针上就可以调用fgets、fputs、fprintf等函数了。
}
IO(标准IO:读/写流){
每次一个字符的读取.
每次一行的读取.
直接IO: 每次读写指定数量的对象, 而每个对象具有指定的长度, 常用于二进制文件读写: fread和fwrite.

家族名     目的              可用于所有的流  只用于stdin和stdout 
getchar    字符输入          fgetc，getc     getchar
putchar    字符输出          fputc，putc     putchar
gets       文本行输入        fgets           gets
puts       文本行输出        fputs           puts
scanf      格式化输入        fscanf          scanf
printf     格式化输出        fprintf         printf

注意点：
fgetc和fputc都是真正的函数，但是getc，putc，getchar和putchar都是通过#define指令定义的宏，
所以在调用getc，putc，getchar和putchar时不能使用具有副作用的参数。

fgets     char * fgets(char * s,int size,FILE * stream);
用来从参数stream所指的文件内读入字符并存到参数s所指的内存空间，直到
1. 出现换行字符、
2. 读到文件尾或是
3. 已读了size-1个字符为止，
最后会加上NULL作为字符串结束。
如果string无法存放整行，则下一次调用fgets时将从stream的下一个字符开始读取，不会出现数据丢失的情况。

fputs     int fputs(const char * s,FILE * stream);
fputs向指定的文件写入一个字符串(不自动写入字符串结束标记符'\0')

gets从stdin流中读取字符串，直至接受到换行符或EOF时停止，并将读取的结果存放在str指针所指向的字符数组中。
换行符不作为读取串的内容，读取的换行符被转换为null值，并由此来结束字符串。
gets函数不安全，没有限制输入缓冲区的大小，容易造成溢出，所以尽量不要使用gets。
}
IO(IO复用:概述){
(1)种类:
    select/pselect和poll(fs/select.c)
    epoll(fs/eventpoll.c)
(2)select和poll缺点:
    select支持文件描述符有限制(FD_SETSIZE:1024)；poll没有这个缺陷.
    需要遍历所有监听的文件描述符，例如:需使用FD_ISSET来遍历所有描述符看是否有事件发生.
    每次调用select或poll都需要在用户态和内核态拷贝监听的文件描述符.
(3)epoll优点:
    没有描述符限制.
    每次只返回需要处理的文件描述符.
    文件描述符只用在调用epoll_ctl时在用户空间和内核空间拷贝一次.
(4)可读事件种类.
(5)可写事件种类.
}
IO(IO复用:epoll){
(1)概述:
    支持套接字, FIFO等, 但不支持普通文件和目录, epoll_ctl会返回EPERM错误.
(2)两种工作模式:
    LT(Level Triggered):默认，支持阻塞和非阻塞fd.
    ET(Edge Triggered):只支持非阻塞fd，效率更高.
(3)两种模式比较:
    LT:只要一个套接字缓冲区还有数据未处理，内核就不断通知你，总能epoll_wait中获取这个事件，不用担心事件丢失。优点:编码简单，不容易出现问题. 缺点:效率低.
    ET:套接字缓冲区还是数据未处理时，若没有新事件到来，则无法通过epoll_wait来获取该事件。优点:效率高，尤其在大并发情况下，会比LT少很多epoll的系统调用；缺点:编程要求高，易出错。
(4)使用方法:
    epoll_create
    epoll_ctl
    epoll_wait
三 epoll_create:
(1)原型:
    int epoll_create(int size)
    功能: 创建一个epoll 文件描述符.
    创建的epoll文件描述符必须调用close函数关闭.
(2)size参数:
    size并不是限制了epoll能监听的描述符最大数量，只是对内核初始分配数据结构的一个建议.

四 epoll_ctl:
(1)原型:
    int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
    功能: 控制epoll_create创建的描述符(epfd)；根据op类型，对文件描述符(fd)执行相关操作.
(2)参数类型:
    epfd: epoll_create返回的.
    op: EPOLL_CTL_ADD，EPOLL_CTL_MOD，EPOLL_CTL_DEL.
    fd: 普通文件描述符.
(3)epoll_event结构体:

struct epoll_event
{
    __uint32_t events；//Epoll事件，是个bit集，用于位操作.
    epoll_data_t data；//用户数据.
}
typedef union epoll_data
{
  void *ptr；
  int fd: 文件描述符.
  __uint32_t u32；
  __uint64_t u64；
}epoll_data_t；

(4)events种类(用bit代表):
    EPOLLIN: 可读.
    EPOLLOUT: 可写.
    EPOLLRDHUP
    EPOLLPRI
    EPOLLERR
    EPOLLHUP
    EPOLLLET: 设置为边界触发, 默认为水平触发.
    EPOLLONESHOT

五 epoll_wait:
(1)原型:
    int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout)
    功能: 等待epoll文件描述符上的事件就绪，超时时间为timeout毫秒.
(2)参数说明:
    events: 指向所有就绪事件(struct epoll_event)的数组.
    maxevents: 每次返回的最大的事件数量.
    timeout: -1表示无限制等待；0表示不等待；正数表示等待多少毫秒.
}
IO(IO复用: select){
select模型支持IO多路复用，select函数如下
int select (
 IN int nfds,                 //windows下无意义，linux有意义
 IN OUT fd_set* readfds,      //检查可读性
 IN OUT fd_set* writefds,     //检查可写性
 IN OUT fd_set* exceptfds,    //例外数据
 IN const struct timeval* timeout);    //函数的返回时间
逐个解释每个参数意义：
nfds：一个整型变量，表示比最大文件描述符+1
readfds： 这个集合监测读事件的描述符，将要监听读事件的文件描述符放入readfds中，通过调用select，
readfds中将没有就绪的读事件文件描述符清除，留下就绪的读事件描述符，可以通过read或者recv来处理。

writefds：这个集合监测写事件的描述符，将要监听的写事件的文件描述符放入writefds中，通过调用select，
writefds中没有就绪的写事件文件描述符被清除，留下就绪的写事件描述符，可以通过write或者send来处理。

execptfds：这个集合在调用select后会存有错误的文件描述符。根据Linux网络网络编程第二版中介绍，可以
监视带外数据OOB，带外数据使用MSG_OOB标志发送到套接字上，当select()函数返回的时候，readfds将清除
其中的其他文件描述符，留下OOB数据

函数返回值：
当返回0时表示超时，-1表示有错误，大于0表示没有错误。
当监视文件集中有文件描述符符合要求，即读文件描述符集
合中有文件可读，写文件描述符集合中有文件可写，或者
错误文件描述符集合中有错误的描述符，都会返回大于0的数。

timeval结构体解释
struct  timeval {
        long    tv_sec;        //秒
        long    tv_usec;     //毫秒
};
timeval指针为NULL，表示一直等待，直到有符合条件的描述符
触发select返回
如果timeval中个参数均为0，表示立即返回，否则在select没有
符合条件的描述符，等待对应的时间和，然后返回。

另外需要了解一些select的操作宏函数
fd_set是一个SOCKET队列，以下宏可以对该队列进行操作：
FD_CLR( s, fd_set *set) 从队列set删除句柄s;
FD_ISSET( s,fd_set *set) 检查句柄s是否存在与队列set中;
FD_SET( s, fd_set *set )把句柄s添加到队列set中;
FD_ZERO( fd_set *set ) 把set队列初始化成空队列.
}
IO(poll epoll select多路复用IO){
    注意：多路复用IO不适合服务器处理用户的请求非常耗时的场合。
    selelct系统调用会在内核不断扫描套接字，看那个套接字准备好。
    FD_SETSIZE：说明了这个整数有多少bit。
    实现方式1：(最多支持1021个服务器连接，水平触发方式)
    int select(int n, fd_set *read_fds, fd_set *write_fds, fd_set *except_fds, struct timeval *timeout);
    fd_set是一个很大的数字，一般来说1024bit的整数。
    参数一：n表示的是最大描述字加1，因为计算机计套接字数是从0开始计数不能实际表示扫描的个数。
            告诉内核扫描多少个套接字。
    参数二：read_fds,是一个值结果参数，表示关注那些读套接字，程序返回时表示的是那些套接字准备好。
            所以在下次调用select函数要重新设置。
    参数三：write_fds，是一个值结果参数，表示关注那些写套接字，程序返回时表示的是那些套接字准备好。
    参数四：except_fds，是一个值结果参数，表示关注那些异常套接字，程序返回时表示的是那些套接字准备好
            一般不用这个参数，所以调用的时候一般设置��NULL。
    参数五：timeout，值结果参数，超时时间设置，比如3秒，在3秒内没有一个套接字准备好，select函数还是返回。
            一般是将该参数设置��NULL，表示永远等待。
    返回值：大于0，表示有多少个套接字准备好。
            等于0，表示超时返回。
            小于0，出错
            
    void FD_ZERO(fd_set *fdset) 全设置为0
    void FD_SET(int fd,fd_set *fdset) 把fd位bit设置为1
    void FD_CLR(int fd,fd_set *fdset) 把fd位bit设置为0
    int FD_ISSET(int fd,fd_set *fdset) 判断fd位bit是不是1，是1返回真，不是返回0。
    
实现的第二种方式：poll函数(水平触发方式)
     int poll(struct pollfd *fds, nfds_t nfds, int timeout);
     struct pollfd {
                int   fd;         /* file descriptor */
                short events;     /* requested events */表示关注那些事件
                short revents;    /* returned events */表示可以进行的事件
                };
    第一个参数：fds表示的是一个结构体数组(每个数组表示一个套接字)。
    第二个参数：告诉系统，你关注几个数组元素，从0开始。
    第三个参数：timeout 超时时间，以毫秒为单位。
    返回值： >0 表示有多少个套接字(数组)准备好
            =0 超时返回
            <0 出错

    事件：POLLIN：表示读事件
          POLLOUT：写事件
        
    第一步：建立一个大的结构体数组；
    第二步：将结构体中的描述字设置为-1，表示该元素没有使用。
    第三步：加入关注的套接字到结构体数组中。
            
实现的第三种方式：(边沿触发方式)
    epoll:（总共有三个函数）
        int epoll_create(int size);
        size：在2.6.8内核过后没有使用，但这个值必须大于0.
        返回值：epoll的实例，用整数来表示这个实例。

        int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
        //直接往内核注册事件
        参数1：epfd表示的是那个实例。
        参数2：向我们的epoll实例做什么操作
            1）添加关注事件  EPOLL_CTL_ADD
            2）删除关注事件  EPOLL_CTL_DEL
            3）修改关注的事件 EPOLL_CTL_MOD
            4）触发方式：EPOLLET边沿触发(这个选项是epoll高效的关键因素之一)，
                告诉应用程序套接口可读的方式
            (select和poll采用的水平触发)
            注意：采用边沿触发的时候，读数据时一定要把数据读完。
        参数3：表示哪一个套接口
        参数4：是一个结构体epoll_event，如下：
               typedef union epoll_data {
       void        *ptr;
       int          fd; //哪一个套接字
       uint32_t     u32;
       uint64_t     u64;
   } epoll_data_t;

   struct epoll_event {
       uint32_t     events;      /* Epoll events */ 表示关注的事件：EPOLLIN(可读)，EPOLLOUT(可写)，EPOLLET
       epoll_data_t data;        /* User data variable */
   };
        返回值：0：表示成功
            -1：出错

        int epoll_wait(int epfd, struct epoll_event *events,
              int maxevents, int timeout);
        参数1：epfd表示epoll实例
        参数2：events 表示的是准备好的套接字(结构体数组的名字)
        参数3：最大返回多少个套接字(数组大小)
        参数4：timeout表示毫秒数 如果是-1表示永远等待
        返回值：

    采用边沿触发的时候，一定要使用非阻塞方式。(接收数据时必须要把数据接收完,可靠传输)

    
select：1）每次调用select，都要拷贝一次(很大的整数，拷贝到内核）。
2）不断的扫描大整数，扫描最大描述字加一
3）每次通过直结果参数进行返回，所以需要两个fdset大整数。
4）扫描返回的结果，看哪一个套接字准备好
poll：1）每次调用，都要拷贝一次(将结构体数组拷贝到内核)。
2）内核不断扫描结构体数据中的前n个。
3）直接就返回，不需要两个结构体数组。
4）返回后，扫描，看哪一个套接字准备好。
epoll：1）不用每次都拷贝到内核，只设置一次就可以。epoll_ctl直接将描述字及关注事件直接注册到内核。
2）返回后，前面都是有用的。
3）采用边沿触发的方式（高效的原因之一）
4）采用非阻塞方式。

Level_triggered(水平触发):当被监控的文件描述符上有可读写事件发生时，epoll_wait()会通知处理程序去读写。如果这次没有把数据一次性全部读写完(如读写缓冲区太小)，那么下次调用epoll_wait()时，它还会通知你在上没读写完的文件描述符上继续读写，当然如果你一直不去读写，它会一直通知你！如果系统中有大量你不需要读写的就绪文件描述符，而它们每次都会返回，这样会大大降低处理程序检索自己关心的就绪文件描述符的效率！
Edge_triggered(边缘触发): 当被监控的文件描述符上有可读写事件发生时，epoll_wait()会通知处理程序去读写。如果这次没有把数据全部读写完(如读写缓冲区太小)，那么下次调用epoll_wait()时，它不会通知你，也就是它只会通知你一次，直到该文件描述符上出现第二次可读写事件才会通知你！这种模式比水平触发效率高，系统不会充斥大量你不关心的就绪文件描述符！
}
IO(异步IO:概述){
(1)功能:
    内核对AIO(Asynchronous IO)的支持, 通过系统调用(io_submit)提交一个或多个I/O请求无需等待完成, 通过单独的接口io_getevents来获取已完成的I/O操作.
(2)场景:
    O_DIRECT方式打开的文件的AIO, 例如:ext2,ext3等, 不支持非O_DIRECT模式的打开的文件.
    raw或O_DIRECT设备上的AIO.
    不支持socket和管道上的AIO.
(3)备注:
    libaio可设置IO完成后的回调函数.
    libaio可和epoll结合使用.
}
IO(异步IO:源码){
(1)概述:
    头文件libaio.h
(2)系统调用:
    extern int io_setup(int maxevents, io_context_t *ctxp);
    extern int io_destroy(io_context_t ctx);
    extern int io_submit(io_context_t ctx, long nr, struct iocb *ios[]);
    extern int io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt);
    extern int io_getevents(io_context_t ctx_id, long min_nr, long nr, struct io_event *events, struct timespec *timeout);
}
IO(POSIX:AIO){
}
IO(api:read){
read函数的基本原型
ssize_t read(int fd, void *buf, size_t nbytes);
参数fd,是文件描述符；
参数buf用来存放读到的数据内容，(void *)表示通用指针
参数nbytes是请求读取的字节数。
返回值问题：read函数总共会有三种返回值情况
A.若成功，返回读到的字节数
B.若已到文件尾或无可读取的数据，返回0
C.若出错，返回-1.

1. 从普通文件中read数据
当读操作完成以后，文件的读写位置会向后移动，移动的长度就是读取的字节数，下次读操作将从新的读写位置开始。
值得注意的是：如果在到达文件尾之前有30个字节，而要求读100个字节，则read返回30个字节。当下一次再调用read时，它将返回0(文件尾端)
常用的是从一个普通文件中获得相应的数据，当read返回值count <=nbytes，下次调用read时若返回count = 0；则说明文件中的数据读写完毕。

2. 从设备文件中read数据的返回值解释
n = read(STDIN_FILENO, buf, 10);
从设备中只读10个字节，调用read时睡眠等待，直到终端设备输入换行才从read返回，read只读走10个字符，剩下的字符仍然
保存在内核终端设备输入缓冲区中,而read返回的是只读走的字节数。
解释了下面这种情况:
输入：Hello\n 输出：Hello 此时n = 6;
输入：Hello Linux 输出：Hello
Linu 此时n = 10 ;很明显buf空间不够，MAN = 10， 所以n = 10;结果一目了然。

3. read用于套接字时的返回值
若对方结束了连接，则返回0；
在read的过程中，如果信号被中断，若已经读取了一部分数据，则返回已读取的字节数；
若没有读取，则返回-1，且error为EINTR。

4. 在socket read中的阻塞和非阻塞型
A.对于阻塞的socket,当socket的接受缓冲区中没有数据时，read会一直阻塞住，等待返回直到有数据到来才返回。
  不管socket缓冲区中的数据量大于、等于或小于期望读取的数据量，都会返回其实际读取的数据长度。
B.对于非阻塞socket而言，不管socket的接受缓冲区中是否有数据，read都会立刻返回。返回情况与阻塞socket类似；
}
IO(api:read & write返回值){
read: 读取成功                                   write: 写入成功      # >0
          得到想要长度数据=length                         写入数据等于写入长度=length
        未得到想要长度数据<length                         写入数据小于写入长度<length
# 读：1. 接收缓冲器内数据不足(例如管道,终端) 2. 达到文件尾部 3. 数据读取过程被中断打断
# 写：1. 发送缓冲区空间不足 2. 数据写入过程被中断打断 
      读取失败                                   写入失败             # =-1
           可以挽回类型                                      可以挽回类型  # EAGAIN 或 EWOULDBLOCK 或 EINTR
# EINTR  在读取到数据以前调用被信号所中断.
# EAGAIN 使用 O_NONBLOCK 标志指定了非阻塞式输入输出,但当前没有数据可读.
           不可挽回类型                                      不可挽回类型  # 非以上两种类型
      对端关闭socket                                   对端关闭socket # =0

read() 从文件描述符 fd 中读取 count 字节的数据并放入从 buf 开始的缓冲区中.
       如果 count 为零,read()返回0,不执行其他任何操作. 
       如果 count 大于SSIZE_MAX,那么结果将不可预料.
      
      
read： 数据包头
       数据包内容
       
有些程序read之后立刻对接收报文进行处理；有些程序read之后，缓存一下再对报文进行处理。

1. recv(sockfd, buf, len, flags); 等价于 recvfrom(sockfd, buf, len, flags, NULL, 0);
2. recvfrom()的唯一意义就是在udp-server中配合sendto()使用
}
IO(api:send sendto sendmsg){
int send(int s, const void *msg, size_t len, int flags);
int sendto(int s, const void *msg, size_t len, int flags, const struct sockaddr *to, socklen_t tolen);
int sendmsg(int s, const struct msghdr *msg, int flags);
       
1. send 仅仅用于连接套接字,而 sendto 和 sendmsg 可用于任何情况下.
2. 在数据传送过程中所产生的错误不会返回给send.  如果发生本地错误,则返回-1.
3. send(sockfd, buf, len, flags);等价于 sendto(sockfd, buf, len, flags, NULL, 0);

目标地址用to指定,tolen定义其长度.消息的长度用len指定.如果消息太长不能通过下层协议,函数将返回EMSGSIZE错误,消息也不会被送出.

MSG_DONTWAIT
使用非阻塞式操作;如果操作需要阻塞,将返回 EAGAIN 错误(也可以用 F_SETFL fcntl(2) 设置 O_NONBLOCK 实现这个功能.)
MSG_NOSIGNAL
当流式套接字的另一端中断连接时不发送 SIGPIPE 信号,但仍然返回 EPIPE 错误
   
 struct msghdr {
  void         * msg_name;     /*地址选项*/
  socklen_t    msg_namelen;    /*地址长度*/
  struct iovec * msg_iov;      /*消息数组*/
  size_t       msg_iovlen;     /*msg_iov中的元素个数*/
  void         * msg_control;  /*辅助信息,见下文*/
  socklen_t    msg_controllen; /*辅助数据缓冲区长度*/
  int          msg_flags;      /*接收消息标志*/
};
可以使用msg_control和msg_controllen成员发送任何控制信息.内核所能处理的最大控制消息缓冲区长度由 
net.core.optmem_max sysctl对每个套接字进行限定
}

IO(api:listen){
int listen(int s, int backlog);
在接收连接之前,首先要使用 socket(2)  创建一个套接字,然后调用 listen
使其能够自动接收到来的连接并且为连接队列指定一个长度限制. 之后就可以使用accept(2)接收连接.listen调用仅适用于
SOCK_STREAM 或者 SOCK_SEQPACKET 类型的套接字.

参数 backlog 指定未完成连接队列的最大长度.如果一个连接请求到达时未完成连接 队列已满,那么客户端将接收到错误 ECONNREFUSED.
或者,如果下层协议支持重发,那么这个连接请求将被忽略,这样客户端 在重试的时候就有成功的机会.

注意
在TCP套接字中  backlog  的含义在Linux 2.2中已经改变.它指定了已经完成连接正等待应用程序接收的套接字队列的长度,而不是
未完成连接的数目.未完成连接套接字队列的最大长度可以使用 tcp_max_syn_backlog sysctl设置
当打开syncookies时不存在逻辑上的最大长度,此设置将被忽略.
}
IO(api:bind){
int bind(int sockfd, struct sockaddr *my_addr, socklen_t addrlen);

bind 为套接字 sockfd 指定本地地址 my_addr.  my_addr 的长度为 addrlen (字节).传统的叫法是给一个套接字分配一个名字.  当使用
socket(2), 函数创建一个套接字时,它存在于一个地址空间(地址族), 但还没有给它分配一个名字

一般来说在使用 SOCK_STREAM 套接字建立连接之前总要使用 bind 为其分配一个本地地址.参见 accept(2)).

注 意
这条规则用于给每个地址族绑定不同的名称.更多细节请参 考手册页第7册(man7).  对于 AF_INET  参见  ip(7),  对于  AF_UNIX  参见
unix(7),  对于  AF_APPLETALK  参见  ddp(7),  对于 AF_PACKET 参见 packet(7), 对于r AF_X25 参见 x25(7) 对于 AF_NETLINK 参见
netlink(7).
}
IO(opt:ioctl){
其函数需要的头文件及声明如下：
    #include <unistd.h>
    int ioctl(int fd, int request, .../*void *arg/);
第三个参数总是一个指针，但指针的类型依赖于request
把和网络有关的请求分为6类：
(1)套接口操作
SIOCATMARK  在带外标志上                  int
SIOCSPGRP   设置套接口的进程ID或进程组ID  int
SIOCGPGRP   获取套接口的进程ID或进程组ID  int
(2)文件操作
FIONBIO     设置/清除非阻塞标志          int
FIOASYNC    设置/清除异步I/O标志         int
FIONREAD    获取接收缓冲区中的字节数     int
FIOSETOWN   设置文件的进程ID或进程组ID   int
FIOGETOWN   获取文件的进程ID或进程组ID   int
(3)接口操作       
SIOCGIFCONF       获取所有接口的列表    struct ifconf
SIOCSIFADDR       设置接口地址          struct ifreq
SIOCGIFADDR       获取接口地址          struct ifreq
SIOCSIFFLAGS      设置接口标志          struct ifreq
SIOCGIFFLAGS      获取接口标志          struct ifreq
SIOCSIFDSTADDR    设置点到点地址        struct ifreq
SIOCGIFDSTADDR    获取点到点地址        struct ifreq
SIOCGIFBRDADDR    获取广播地址          struct ifreq
SIOCSIFBRDADDR    设置广播地址          struct ifreq
SIOCGIFNETMASK    获取子网掩码          struct ifreq
SIOCSIFNETMASK    设置子网掩码          struct ifreq
SIOCGIFMETRIC     获取接口的测度        struct ifreq
SIOCSIFMETRIC     设置接口的测度 	    struct ifreq
(4)ARP高速缓存操作
SIOCSARP     创建/修改arp项            struct arpreq
SIOCGARP     获取arp项                 struct arpreq
SIOCDARD     删除arp项 	               struct arpreq
(5)路由表操作
SIOCADDRT    增加路径                  struct rtentry
SIOCDELRT    删除路径                  struct rtenrty
(6)流系统
}
IO(opt:reuseable){
一个socket在系统中的表示如下
{<protocol>, <src addr>, <src port>, <dest addr>, <dest port>}
如果指定src addr为0.0.0.0，将不再表示某一个具体的地址，而是表示本地的所有的可用地址。

reuse有三个级别:
    non-reuse: src addr和src port不能冲突(同一个protocol下), 0.0.0.0和其他IP视为冲突
    reuse-addr: src addr和src port不能冲突(同一个protocol下), 0.0.0.0和其他IP视为不冲突
    reuse-port: src addr和src port可以冲突

下边仍然举例说明reuse的特性
系统有两个网口，分别是192.168.0.101和10.0.0.101。
    情形1：
    sock1绑定了192.168.0.101:8080，sock2尝试绑定10.0.0.101:8080
    non-reuse - 可以绑定成功，虽然端口一样，但是addr不同
    reuse - 同上

    情形2
    sock1绑定了0.0.0.0:8080, sock2尝试绑定192.168.0.101:8080
    non-reuse - 不能绑定成功，系统认为0.0.0.0包含了所有的本地ip，发生冲突
    reuse - 可以绑定成功，系统认为0.0.0.0和192.168.0.101不是一样的地址

    情形3
    sock1绑定了192.168.0.101:8080,sock2尝试绑定0.0.0.0:8080
    non-reuse - 不能绑定成功，系统认为0.0.0.0包含了所有的本地ip，发生冲突
    reuse - 可以绑定成功，系统认为0.0.0.0和192.168.0.101不是一样的地址

    情形4
    sock1绑定了0.0.0.0:8080,sock2尝试绑定0.0.0.0:8080
    non-reuse - 不能绑定成功，系统认为0.0.0.0包含了所有的本地ip，发生冲突
    reuse-addr - 不能绑定成功，系统认为0.0.0.0包含了所有的本地ip，发生冲突
    reuse-port - 可以绑定成功

2. 设置reuse
使用setsockopt()
必须设置所有相关的sock。

设置reuse-addr：
setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));

设置reuse-port：
setsockopt(sock, SOL_SOCKET, SO_REUSEPORT, &(int){1}, sizeof(int));

使用event2设置
#inlcude <event2/util.h>
int evutil_make_listen_socket_reuseable(evutil_socket_t sock);
}
IO(api:accept){
int accept(int s, struct sockaddr *addr, socklen_t *addrlen);

accept 函数用于基于连接的套接字 (SOCK_STREAM,  SOCK_SEQPACKET和 SOCK_RDM).
它从未完成连接队列中取出第一个连接请求,创建一个和参数 s 属性相同的连接套接字,并为这个套接字分配一个文件描述符,
然后以这个描述符返回.新创建的描述符不再处于倾听状态.原套接字 s 不受此调用的影响.注意任意一个文件描述符标志 (任何可以被
fcntl以参数 F_SETFL 设置的值,比如非阻塞式或者异步状态)不会被 accept.  所继承.

参数 s 是以 socket(2) 创建,用 bind(2)  绑定到一个本地地址,并且在调用了 listen(2). 之后正在侦听一个连接的套接字. 参数
addr 是一个指向结构sockaddr的指针.这个结构体以连接实体地址填充. 所谓的连接实体,就是众所周知的网络层.参数    addr
所传递的真正的地址格式依赖于所使用的套接字族. (参见 socket(2) 和各协议自己的手册页). addrlen 是一个实时参数:
它的大小应该能够足以容纳参数 addr 所指向的结构体;在函数返回时此参数将以字节数表示出返回地址的 实际长度.若addr
使用NULL作为参数,addrlen将也被置为NULL.

如果队列中没有未完成连接套接字,并且套接字没有标记为非阻塞式, accept
将阻塞直到一个连接到达.如果一个套接字被标记为非阻塞式而队列中没有未完成连接套接字, accept 将返回EAGAIN.

使用 select(2) 或者 poll(2).  可以在一个套接字上有连接到来时产生事件.当尝试一个新的连接时 套接字读就绪,这样我们就可以调用
accept 为这个连接获得一个新的套接字.此外,你还可以设置套接字在唤醒时 接收到信号 SIGIO; 细节请参见 socket(7)

对于那些需要显式确认的协议,比如     DECNet,     accept      可以看作仅仅从队列中取出下一个连接而不做确认.当在这个新的文件
描述符上进行普通读写操作时暗示了确认,当关闭这个新的套接字时暗 示了拒绝.目前在Linux上只有DECNet有这样 的含义.

注 意
  当接收到一个 SIGIO 信号或者  select 或 poll 返回读就绪并不总是意味着有新连接在等待,因为连接可能在调用 accept
  之前已经被异步网络错误或者其他线程所移除.如果发生这种情况, 那么调用将阻塞并等待下一个连接的到来.为确保 accept
  永远不会阻塞,传递的套接字 s 需要置 O_NONBLOCK 标志(参见 socket(7)).
  
accept返回错误码：
EAGAIN or EWOULDBLOCK
    套接口设置的是非阻塞模式，并且现在没有任何连接到来。
ECONNABORTED
    连接已经断开
}
IO(socket:connect){
connect错误码：
    ECONNREFUSED:对端没有监听端口
    EINPROGRESS：代表已经发了SYN，还没有等到对端的SYN+ACK
}
IO(socket:close){
close
注意：对端套接口已经关闭，这时候还在往对端里写数据，就会产生一个SIGPIPE信号，默认忽略SIGPIPE信号
}
IO(tcp){
首先发FIN的无论是服务器还是客户端会进入TIME_WAIT状态
1．	自己如果已经发了FIN，还没有等到对端的ACK，这个时候是FIN_WAIT_1
2．	接收到对端的ACK，还没有接收到对端的FIN，这个时候是FIN_WAIT_2
3．	收到了对端的FIN，然后自己发了ACK，进入TIME_WAIT状态
4． 时间为2MSL

netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' 
TIME_WAIT 8947 等待足够的时间以确保远程TCP接收到连接中断请求的确认 
FIN_WAIT1 15 等待远程TCP连接中断请求，或先前的连接中断s请求的确认 
FIN_WAIT2 1 从远程TCP等待连接中断请求 
ESTABLISHED 55 代表一个打开的连接 
SYN_RECV 21 再收到和发送一个连接请求后等待对方对连接请求的确认 
CLOSING 2 没有任何连接状态 
LAST_ACK 4 等待原来的发向远程TCP的连接中断请求的确认

CLOSED: 还未建立连接或已经断开
LISTEN: 服务器正在监听，可以接受连接
SYN_RECV: 一个连接请求已经到达，等待确认.接收到 SYN 报文，要返回 SYN 和 ACK ，然后会进入 ESTABLISHED 状态。
SYN_SEND: 客户端 SOCKET 执行连接时，发送SYN，然后进入 SYN_SEND.表示客户端已经发送了 SYN.这个状态会很短，因为服务端接收到 SYN 后马上会返回 SYN 和 ACK，然后就进入ESTABLISHED 了。
ESTABLISHED: 正常数据传输
FIN_WAIT1: 当连接处在 ESTABLISHED 时，客户想主动关闭连接，就会向对方发送 FIN.然后进入 FIN_WAIT1.对方收到 FIN 后会回应 ACK，然后进入 FIN_WAIT2。所以FIN_WAIT1很难碰到，就象上面的 SYN_RECV 和 SYN_SEND 一样。
FIN_WAIT2: 另一边已同意释放连接
CLOSING: 两边同时尝试关闭连接。该情况很特殊，正常情况是：你发送 FIN, 然后收到对方的 ACK, 然后再收到对方的 FIN. 但对方的 FIN 却在 ACK 前到了。
TIME_WAIT: 收到对方的 FIN 报文，且已经发送 ACK.就等 2MSL 后即可回到 CLOSED 可用状态。
LAST_ACK: 被动关闭的一方在发送 FIN 后，等待对方的 ACK.什么时候接收到 ACK, 什么时候进入 CLOSED 状态。

在TIME_WAIT状态中收到一个RST引起状态过早地终止。这就叫作TIME_WAIT断开
tcp_keepalive_intvl:探测消息发送的频率
tcp_keepalive_probes:TCP发送keepalive探测以确定该连接已经断开的次数
tcp_keepalive_time:当keepalive打开的情况下，TCP发送keepalive消息的频率

      客户                                         服务器

主动打开 SYN_SENT                                  LISTEN(被动打开)
              |
              V------SYN J----------------------> SYN_RCVD
                                                     |
   ESTABLISHED<---------SYN K, ack J+1---------------V
         |
         V--------------ack K+1------------------>ESTABLISHED



主动关闭 FIN_WAIT_1
          |
          V-----------------FIN M---------------->CLOSE_WAIT(被动关闭)
                                                     |
        FIN_WAIT2<--------ack M+1------------------- V
                                                  LAST_ACK
                                                     |
        TIME_WAIT<--------FIN N----------------------V
          |
          V--------------ack N+1------------------>CLOSED

2MSL(Maximum Segment Lifetime)
--------------------------------
TIME_WAIT阶段
同时打开
-----------------
(主动打开) SYN_SENT                        SYN_SENT
            |                                    |
            V-------SYN J-------------->SYN_RCVD |
                                            |    |
          SYN_RCVD<-----------SYN K---------|--- V
            |                               |
            V---------SYN J, ack K+1--------|--> ESTABLISHED
                                            |
    ESTABLISHED <---------SYN K, ack J+1--- V

同时关闭
-----------------
(主动关闭) FIN_WAIT1                          FIN_WAIT1
            |                                    |
            V-------FIN J-------------->CLOSING  |
                                            |    |
          CLOSING<-----------FIN K----------|--- V
            |                               |
            V----------------ack K+1--------|--> TIME_WAIT
                                            |
    TIME_WAIT <---------ack J+1------------ V
}
IO(protocol){
五元组是:
源IP地址、目的IP地址、协议号、源端口、目的端口
七元组是:
源IP地址、目的IP地址、协议号、源端口、目的端口，服务类型以及接口索引
}
IO(socket:event){
       ┌─────────────────────────────────────────────────────────────┐
       │                          I/O 事件                           │
       ├──────┬──────────┬───────────────────────────────────────────┤
       │事件  │ 轮询标志 │ 发生事件                                  │
       ├──────┼──────────┼───────────────────────────────────────────┤
       │读    │ POLLIN   │ 新数据到达.                               │
       ├──────┼──────────┼───────────────────────────────────────────┤
       │读    │ POLLIN   │ (对面向连接的套接字)建立连接成功          │
       ├──────┼──────────┼───────────────────────────────────────────┤
       │读    │ POLLHUP  │ 另一端套接字发出断开连接请求.             │
       ├──────┼──────────┼───────────────────────────────────────────┤
       │读    │ POLLHUP  │ (仅对面向连接协议)套接字写的时候连接断开. │
       │      │          │ 同时发送 SIGPIPE.                         │
       ├──────┼──────────┼───────────────────────────────────────────┤
       │写    │ POLLOUT  │ 套接字有充足的发送缓冲区用于写入新数据.   │
       ├──────┼──────────┼───────────────────────────────────────────┤
       │读/写 │ POLLIN|  │ 发出的 connect(2) 结束.                   │
       │      │ POLLOUT  │                                           │
       ├──────┼──────────┼───────────────────────────────────────────┤
       │读/写 │ POLLERR  │ 产生一个异步错误.                         │
       ├──────┼──────────┼───────────────────────────────────────────┤
       │读/写 │ POLLHUP  │ 对方已经单向关闭连接.                     │
       ├──────┼──────────┼───────────────────────────────────────────┤
       │例外  │ POLLPRI  │ 紧急数据到达.然后发送 SIGURG.             │
       └──────┴──────────┴───────────────────────────────────────────┘
send(2), sendto(2), 和 sendmsg(2) 通过套接字发送数据，
recv(2), recvfrom(2), recvmsg(2) 从套接字接收数据.  
poll(2) 和 select(2)  等待数据到来或准备好接收数据. 
除此之外, 标准 I/O 操作如 write(2), writev(2), sendfile(2), read(2), 和 readv(2) 也可用来读入(接收)和写出(发送)数据.

可以用fcntl(2)设置O_NONBLOCK标志来实现对套接字的非阻塞I/O操作. O_NONBLOCK是从accept继承来的，
然后原来所有会阻塞的操作会返回EAGAIN.   
connect(2)在此情况下返回EINPROGRESS错误.用户可以通过 poll(2) 或者 select(2) 等待各种事件.
}
IO(){
int gethostname(char *name, size_t len);   # 获取主机名
int getsockname(int sockfd, struct sockaddr *addr, socklen_t *addrlen);   # 获取与socket相连的远程协议的地址
int getpeername(int sockfd, struct sockaddr *addr, socklen_t *addrlen);   # getpeername
struct hostent *gethostbyname(const char *name); # 根据主机名获得主机信息
struct hostent *gethostbyaddr(const void *addr,socklen_t len, int type); # 根据主机地址取主机信息
struct protoent *getprotobyname(const char *name); # 根据协议名取得主机协议信息
struct protoent *getprotobynumber(int proto);      # 根据协议号取得主机协议信息
struct servent *getservbyname(const char *name, const char *proto); # 根据服务名取得相关服务信息
struct servent *getservbyport(int port, const char *proto); # 根据端口号取得相关服务信息
}
IO(五元组){
TCP/UDP是由以下五元组唯一地识别的：
{<protocol>, <src addr>, <src port>, <dest addr>, <dest port>}
这些数值组成的任何独特的组合可以唯一地确一个连接。

协议：                                                     调用socket()初始化的时候就设置
源地址(source address)和源端口(source port):               调用bind()的时候设置
目的地址(destination address)和目的端口(destination port): 调用connect()的时候设置

1. 没有绑定地址的TCP socket会在建立连接时被自动绑定一个本机地址和端口                                自动绑定connect
2. UDP没有显式地调用bind()，操作系统会在第一次发送数据时自动将UDP socket与本机的地址和某个端口绑定   自动绑定connect
3. UDP是无连接的，UDP socket可以在未与目的端口连接的情况下使用

4. 绑定至端口0的意思是让系统自己决定使用哪个端口
   socket可以被绑定到主机上所有接口所对应的地址中的任意一个
   基于连接在本socket的目的地址和路由表中对应的信息，操作系统将会选择合适的地址来绑定这个socket，并用这个地址来取代之前的通配符IP地址。
5. socket绑定了0.0.0.0:21，在这种情况下，任何其他socket不论选择哪一个具体的IP地址，其都不能再绑定在21端口下。因为通配符IP0.0.0.0与所有本地IP都冲突
}
IO(socket:SIGNALS){
另外一个的 poll/select 方法是让内核用SIGIO信号来通知应用程序.  
要这么用的话你必须用fcntl(2)设置套接字文件描述符的FASYNC 标志，并用sigaction(2).给SIGIO信号设置一个的有效信号处理句柄.

当向一个已关闭(被本地或远程终端)的面向联接的套接字写入时, 将向该写入进程发送SIGPIPE信号，并返回EPIPE
如果写入命令声明了 MSG_NOSIGNAL 标识时, 不会发出此信号.

如果与FIOCSETOWN fcntl或SIOCSPGRP  ioctl一起请求，那么当发生I/O事件时发出SIGIO这样我们就可以在信号句柄里使用
 poll(2)或select(2)找出发生事件的套接字. 另一种选择(在  Linux  2.2  中)是用F_SETSIG fcntl设置一个实时信号:
实时信号的处理程序被调用时还会收到它的 siginfo_t 的 si_fd 区域中的文件描述符. 

SIOCGPGRP
  获得当前接收 SIGIO 或者 SIGURG 信号的进程或者进程组, 如果两个信号都没有设置, 则为 0.
  有效的 fcntl:
  FIOCGETOWN
      与 IO 控制中的 SIOCGPGRP 相同.
  FIOCSETOWN
      与 IO 控制中的 SIOCSPGRP 相同. 
}
IO(tcp:错误处理){
    当网络发生错误时，TCP 协议将尝试重新发送数据包，当重发一定失败次数后，产生超时错 ETIMEDOUT
或报告在此连接上最后出错消息。

    有时程序需要更快地侦测到出错状态。这可以通过打开SOL_IP级别的IP_RECVERR 接口选项。当此项打开后，所有入站 (incoming)
错误 被立即送到用户程序中。小心使用该选项-它使 TCP 协议对路由的改 变和其他正常网络状态变化的容错性下降。
}
IO(socket:SYSCTLS){
可以通过目录 /proc/sys/net/core/* 下的文件或者用 sysctl(2) 系统调用来访问内核套接字的网络系统控制(sysctl)信息.
rmem_default
  指明套接字接收缓冲区的默认字节数.
rmem_max
  指明套接字接收缓冲区的最大字节数, 用户可以通过使用 SO_RCVBUF 套接字选项来设置此值.
wmem_default
  指明套接字发送缓冲区的默认字节数.
wmem_max
  指明发送缓冲区的最大字节数，用户可以通过使用套接字的 SO_SNDBUF 选项来设置它的值.
message_cost 和 message_burst
  设定记号存储桶过滤器, 在存储桶中保存一定数量的外部网络 事件导致的警告消息.
netdev_max_backlog
  在全局输入队列中包的最大数目.
optmem_max
  每个套接字的象 iovecs 这样的辅助数据和用户控制数据的最大长度.
}
IO(ip:SYSCTLS){
ip_default_ttl
  设置外发包的缺省生存时间值.此值可以对每个套接字通过 IP_TTL 选项来修改.
ip_forward
  以一个布尔标识来激活IP转发功能.IP转发也可以按接口来设置
ip_dynaddr
  打开接口地址改变时动态套接字地址和伪装记录的重写.这对具有变化的IP地址的拨号接口很有用.
  0表示不重写,1打开其功能,而2则激活冗余模式.
ip_autoconfig
  无文档
ip_local_port_range
  包含两个整数,定义了缺省分配给套接字的本地端口范围. 分配起始于第一个数而终止于第二个数.
  注意这些端口不能与伪装所使用的端口相冲突(尽管这种情况也可以处理).
  同时,随意的选择可能会导致一些防火墙包过滤器的问题,它们会误认为本地端口在使用.
  第一个数必须至少>1024,最好是>4096以避免与众所周知的端口发生冲突， 从而最大可能的减少防火墙问题.
ip_no_pmtu_disc
  如果打开了,缺省情况下不对TCP套接字执行路径MTU发现. 如果在路径上误配置了防火墙(用来丢弃所有
  ICMP包)或者误配置了接口 (例如,设置了一个两端MTU不同的端对端连接),路径MTU发现可能会失败.
  宁愿修复路径上的损坏的路由器,也好过整个地关闭路径MTU发现, 因为这样做会导致网络上的高开销.
ipfrag_high_thresh, ipfrag_low_thresh
       如果排队等待的IP碎片的数目达到 ipfrag_high_thresh , 队列被排空为 ipfrag_low_thresh .  这包含一个表示字节数的整数.
ip_always_defrag
  [kernel 2.2.13中的新功能;在早期内核版本中,该功能在编译时通过 CONFIG_IP_ALWAYS_DEFRAG 选项来控制]
  
  当该布尔标识被激活(不等于0)时 来访的碎片(IP包的一部分,这生成于当一些在源端和目的端之间的主机认
  定包太大而分割成许多碎片的情况下)将在处理之前重新组合(碎片整理), 即使它们马上要被转发也如此．
  
  只在运行着一台与网络单一连接的防火墙或者透明代理服务器时才这么干;    对于正常的路由器或者主机, 永远不要打开它.
  否则当碎片在不同连接中通过时碎片的通信可能会被扰乱.  而且碎片重组也需要花费大量的内存和 CPU 时间．
  这在配置了伪装或者透明代理的情况下自动打开.
}
IO(tcp:SYSCTLS){
可以通过访问  /proc/sys/net/ipv4/*  目录下的文件或通过 sysctl(2) 接口进行访问这些  sysctl. 此外大多数IP sysctl
也同样适用于 TCP; 参见 ip(7).
tcp_window_scaling
  打开 RFC1323 协议中 TCP 滑移数据窗尺寸调整.
tcp_sack
  打开 RFC2018 协议中 TCP 选择性确认.
tcp_timestamps
  打开 RFC1323 协议中 TCP 时间戳.
tcp_fin_timeout
  规定强迫关闭套接字前，等待最后结束数据包的秒数。这确实与TCP协议中有关规定相违背。
  但这是防止拒绝服务攻击所要求的。
tcp_keepalive_probes
  丢弃数据包前，进行最大 TCP 保持连接侦测. 保持连接仅在 SO_KEEPALIVE 套接字选项被打开时才被发送.
tcp_keepalive_time
  从不再传送数据到向连接上发送保持连接信号之间所需的秒数， 默认为 10800 秒(3 小时)。
tcp_max_ka_probes
  在一定时间发送保持连接时间侦测包的数量。为防止突发信号，此 值不宜设置太高。
tcp_stdurg
  使  TCP 紧急指针字段遵循在 RFC973 协议中的严格解释。缺省情况下，紧急指针字段使用与 BSD
  相兼容，指针指向紧急数据后的第一个字节。 在 RFC973 协议中是指向紧急数据后的最后一个字节。打开这一选项
  可能造成操作互换性问题。
tcp_syncookies
  打开 TCP 同步标签(syncookie)，内核必须打开 CONFIG_SYN_COOKIES 项进行编译.
  同步标签(Syncookie)防止一个套接字在有过多试图连接到达时的过载。当使用同步标签时，客户机可能探测不到
  一个超时时间短的过载主机。
tcp_max_syn_backlog
  每个接口中待发数据队列  (backlog)   长度。Linux  2.2  中,在           listen(2)
  中的定义只说明了已建立的套接字中待发数据队列(backlog)长度。每个侦测套接字的还未建立的套接字(在 SYN_RECV
  状态中的)的最大队列长度用这个 sysctl设置。 当更多的连接请求到达时，Linux
  系统将开始丢弃数据包。当同步标签(syncookie)被设置成打开， 数据包仍能被回应时，这个值将被忽略。
tcp_retries1
  定义放弃回应一个 TCP 连接请求前发送重试信号的次数。
tcp_retries2
  定义放弃在已建立通讯状态下一个 TCP 数据包前重发的次数。
tcp_syn_retries
  定义在放弃发送初始同步数据包(SYN  packet)到远端主机前重试的次数并返回出
  错消息，此值必须小于255。这仅对出站(outgoing)连接超时有效；对于进站(incoming)连接重发数由 tcp_retries1 定义。
tcp_retrans_collapse
  在重发时试图发送全尺寸数据包。 用来解决一些堆栈中的 TCP 缺陷(BUG)。
}
IO(icmp:SYSCTLS){
icmp_destunreach_rate
  发送目的地不可到达 ICMP  消息包的最大数据包比率。这限制了发送到任意一个路由或目的地的数据包的比率。
  这个限制不影响发送用来发现数据链路最大传送单位(MTU)的 ICMP_FRAG_NEEDED包 数据包。

icmp_echo_ignore_all
  如果该值不为零,Linux将忽略所有的 ICMP_ECHO 请求。

icmp_echo_ignore_broadcasts
  如果该值不为零,Linux将忽略所有发送到广播地址的 ICMP_ECHO 数据包。

icmp_echoreply_rate
   发送响应 ICMP_ECHOREQUEST 请求的 ICMP_ECHOREPLY 数据包比率的最大值。

icmp_paramprob_rate
  发送 ICMP_PARAMETERPROB 数据包比率的最大值。当一个具有非法 IP 报头数据包到达时将发送这些包。

icmp_timeexceed_rate
  发送 ICMP_TIME_EXCEEDED 包比率的最大值。当一个数据包通过太多网段时，这些包用作防止路由回环。
}
IO(ip){
protocol 指的是要接收或者发送出去的包含在  IP 头标识(header)中的  IP  协议．  
1. 对于TCP套接字而言,唯一的有效  protocol 值是 0 和 IPPROTO_TCP 
2. 对于UDP套接字而言,唯一的有效protocol 值是 0 和 IPPROTO_UDP.  
3. 对于 SOCK_RAW 你可以指定一个在 RFC1700 中定义的有效 IANA IP 协议代码来赋值

当一个进程希望接受新的来访包或者连接时,它应该使用bind(2)绑定一个套接字到一个本地接口地址．
1. 任意给定的本地(地址,端口)对只能绑定一个IP套接字．
2. 当调用bind时中声明了INADDR_ANY时,套接字将会绑定到所有本地接口．
3. 当在未绑定的套接字上调用listen(2)或者connect(2)时,套接字会自动绑定到一个本地地址设置为INADDR_ANY的随机的空闲端口上．

INADDR_LOOPBACK     (127.0.0.1)     总是代表经由回环设备的本地主机；
INADDR_ANY     (0.0.0.0)            表示任何可绑定的地址；
INADDR_BROADCAST    (255.255.255.255)    表示任何主机
}
IO(api:raw){
raw_socket = socket(PF_INET, SOCK_RAW, int protocol );
icmp_socket = socket(PF_INET, SOCK_RAW, IPPROTO_ICMP );
Raw sockets 使得用户端可以实现新的 IPv4 协议。raw socket设备接收或发送不含链接层报头的原始数据包。只有激活接口选项
IP_HDRINCL 时 IPv4 层才会在传输包中添加 IP 报头。而且当激活时，包中必须含有 IP 报头。包中含有 IP 报头才能被接收。

只有 user id 为 0 或具有 CAP_NET_RAW 能力才能打开 raw sockets.
所有匹配为此 raw socket 声明的协议号的包或错误都将被传 送到该 socket.要察看许可的协议列表

IPPROTO_RAW 意味着 IP_HDRINCL 处于激活状态，也意味着接收 所有 IP 协议. 但是不允许传送。
       ┌────────────────────────────────────┐
       │IP_HDRINCL 会在传送时修改 IP 报头。 │
       ├──────────────────┬─────────────────┤
       │IP Checksum       │ 总是写入。      │
       ├──────────────────┼─────────────────┤
       │Source Address    │为 0 时写入。    │
       ├──────────────────┼─────────────────┤
       │Packet Id         │为 0 时写入。    │
       ├──────────────────┼─────────────────┤
       │Total Length      │总是写入。       │
       └──────────────────┴─────────────────┘
如果指定了  IP_HDRINCL  且  IP 报头含有的目的地址不是 0，那么 该 socket 的目的地址用于路由该包。 如果指定了 MSG_DONTROUTE
则目的地址 应指向某个本地接口。否则会进行路有表查找，但是网关路由会被 忽略。如果未设定 IP_HDRINCL 则可通过 setsockopt (2)
在 raw socket 中设定 IP header 选项。

注 意
raw  socket  包长超过接口  MTU  时会把包分成碎片。 另一个更友好和快速的选择是使用路径 MTU 查找。 在 ip (7)
IP_PMTU_DISCOVER 一段有详细描述。

使用 bind (2) 可将 raw  socket 绑定到指定的本地地址。如果没有绑定，则接收所有符合指定的 IP 协议的包。另外用
SO_BINDTODEVICE 可以将 RAW socket 绑定到指定的网络 设备。 详见： socket (7).

IPPROTO_RAW 只能传送。如果你确实想接收所有的 IP 包 用 packet (7) socket 和 ETH_P_IP 协议. 请注意 packet socket不象 raw
socket 那样对 IP 碎片进行重组。

如果想要为一个 datagram socket 接收的所有 ICMP 包，那么最好 在那个 socket 上使用 IP_RECVERR。详见： ip (7).

raw socket 能窃听所有的 IP 协议, 即使象 ICMP 或 TCP 这样在内核中有协议模块的也不例外。这时候包会同时传送到  核心模块和raw
socket. 一个可移植的程序不能依赖这个特性， 许多其他 BSD socket 实现在这方面有局限．

Linux 从不改变用户传输的包 (除了前 面提到的 IP_HDRINCL ，填入一些0字段).这与其他 raw socket 实现方式是不同的．

RAW socket 通常很难移植. socket 传输时使用 sin_port 中设置的 协议，但 Linux2.2 下不行了，解决办法是使用 IP_HDRINCL. 
}

IO(api:非命名的UNIX域套接字:socketpair){
数据报两种接口，UNIX域数据报服务是可靠的，就不会丢失消息也不会传递出错。UNIX域套接字是套接字和管道之间的混合物。
为了创建一对非命名的，相互连接的UNXI域套接字，用户可以使用socketopair函数。
#include<sys/socket.h>  
int socketpair(int domain, int type, int protocol, int sockfd[2]); //若成功则返回0，出错则返回-1.
socketpair(AF_UNIX, SOCK_STREAM, 0, fd) //
}

IO(mkfifo){
一般的文件IO函数都可用于FIFO(close，read，write，unlink)
int mkfifo(const char *pathname, mode_t mode);
    mkfifo("log/supervise/control"+4, 0600);
    mkfifo("log/supervise/control", 0600);
    mkfifo("log/supervise/ok"+4, 0600);
    mkfifo("log/supervise/ok", 0600);

int mknod (const char *pathname, mode_t mode, dev_t dev);
    mknod(*s, S_IFIFO | mode, 0)
}
IO(api:命名的UNIX域套接字:unix){
unix_socket = socket(PF_UNIX, type, 0);
error = socketpair(PF_UNIX, type, 0, int *sv);

PF_UNIX (也称作 PF_LOCAL)套接字族用来在同一机器上的提供有效的进程间通讯.Unix 套接字可以是匿名的(由 socketpair(2) 创建),
也可以与套接字类型文件相关联.  Linux 还支持一种抽象名字空间, 它是独立于文件系统的.

有效的类型有: SOCK_STREAM 用于面向流的套接字,         sock_fd = socket(AF_UNIX, SOCK_STREAM, 0);
SOCK_DGRAM 用于面向数据报的套接字,其可以保存消息界限. sock_fd = socket(AF_UNIX, SOCK_DGRAM, 0)
Unix套接字总是可靠的,而且不会重组数据报.

Unix 套接字支持把文件描述符或者进程的信用证明作为数据报的辅助数据传递给其它进程．

ADDRESS FORMAT(地址格式)
  unix        地址定义为文件系统中的一个文件名或者抽象名字空间中的一个单独的字符串. 由socketpair(2)
  创建的套接字是匿名的.对于非匿名的套接字,目标地址可使用 connect(2) 设置.本地地址可使用 bind(2) 设置.
  当套接字连接上而且它没有一个本地地址时, 会自动在抽象名字空间中生成一个唯一的地址.
    #define UNIX_PATH_MAX   108
    
    struct sockaddr_un {
    sa_family_t     sun_family;     /* AF_UNIX */
    char    sun_path[UNIX_PATH_MAX];        /* 路径名 */
    };
  
  sun_family  总是包含AF_UNIX. 
  sun_path 包含空零结尾的套接字在文件系统中的路径名。
  bind(pathname|unnamed|abstract)
  pathname  null结尾的文件路径名. -> 支持getsockname(2), getpeername(2), and accept(2)获取pathname
            地址长度：sizeof(sa_family_t) + strlen(sun_path) + 1
  unnamed   socketpair(匿名unix)；-> 不支持getsockname(2), getpeername(2获取pathname
            地址长度：sizeof(sa_family_t)
  abstract  sun_path[0]='\0' 后续为null结尾的文件路径名；-> 支持getsockname(2), getpeername(2), and accept(2)获取pathname
            地址长度：sizeof(struct sockaddr_un),
  如果 sun_path 以空零字节开头,它指向由 Unix 协议模块维护的抽象名字空间. 
  该套接字在此名字空间中的地址由 sun_path 中的剩余字节给定.
  注意抽象名字空间的名字都不是空零终止的.

SOCKET OPTIONS(套接字选项)
  由于历史原因, 这些套接字选项通过SOL_SOCKET类型确定, 即使它们是 PF_UNIX 指定的. 它们可以由 setsockopt(2)设置.
  通过指定 SOL_SOCKET 作为套接字族 用 getsockopt(2) 来读取.
  
  SO_PASSCRED 允许接收进程辅助信息发送的信用证明. 当设置了该选项且套接字尚未连接时,
  则会自动生成一个抽象名字空间的唯一名字.  值为一个整数布尔标识.
  
ANCILLARY MESSAGES(辅助信息)
  由于历史原因,这些辅助信息类型通过 SOL_SOCKET 类型确定,即使它们是 PF_UNIX 指定的. 要发送它们, 可设置结构 cmsghdr 的
  cmsg_level 字段为 SOL_SOCKET, 并设置 cmsg_type 字段为其类型. 要获得更多信息, 请参看 cmsg(3).
 
  SCM_RIGHTS
         为其他进程发送或接收一套打开文件描述符.  其数据部分包含一个文件描述符的整型数组.  已传文件描述符的效果就如它们已由
         dup(2) 创建过一样.
  SCM_CREDENTIALS
         发送或者接收 unix 信用证明.  可用作认证.信用证明传送以 struct ucred 辅助信息的形式传送．
 
         struct ucred {
         pid_t   pid;     /* 发送进程的进程标识 */
         uid_t   uid;     /* 发送进程的用户标识 */
         gid_t   gid;     /* 发送进程的组标识 */
         };

  发送者确定的信用证明由内核检查.  一个带有有效用户标识 0  的进程允许指定不与其自身值相
  匹配的值.发送者必须确定其自身的进程标识(除非它带有CAP_SYS_ADMIN), 其用户标识,有效用户标识或者设置用户标识(除非它带有
  CAP_SETUID), 以及其组标识,有效组标识或者设置组标识(除非它带有 CAP_SETGID). 为了接收一条 struct ucred
  消息,必须在套接字上激活 SO_PASSCRED 选项.
}
IO(AF_INET AF_UNIX){
相同点：
  操作系统提供的接口socket(),bind(),connect(),accept(),send(),recv()，
  以及用来对其进行多路复用事件检测的select(),poll(),epoll()都是完全相同的。
  收发数据的过程中，上层应用感知不到底层的差别。
不同点：
1 建立socket传递的地址域，及bind()的地址结构稍有区别：
  socket() 分别传递不同的域AF_INET和AF_UNIX
  bind()的地址结构分别为sockaddr_in(制定IP端口)和sockaddr_un(指定路径名)
2 AF_INET需经过多个协议层的编解码，消耗系统cpu，并且数据传输需要经过网卡，受到网卡带宽的限制。
  AF_UNIX数据到达内核缓冲区后，由内核根据指定路径名找到接收方socket对应的内核缓冲区，
  直接将数据拷贝过去，不经过协议层编解码，节省系统cpu，并且不经过网卡，因此不受网卡带宽的限制。
3 AF_INET不仅可以用作本机的跨进程通信，同样的可以用于不同机器之间的通信
}
IO(pipe){
fcntl(fds[0], F_SETFL, O_NOATIME); 指示pipe在读的时候不更新atime,
pipe也有access time
}
IO(popen pclose){
FILE *popen(const char* cmdstring, const char *type);  # 若成功则返回文件指针，出错则返回NULL。  
int pclose(FILE *fp);                                  # 返回cmdstring的终止状态，若出错则返回-1。  
type: 为只读或者只写，不支持读写模式   "r" 或者 "w" 类型为字符串。
函数popen先执行fork，然后调用exec以执行cmdstring，并返回一个标准IO文件指针，如果type是r，则文件指针连接到
cmdstring的标准输出，如果type是w，则文件指针连接到cmdstring的标准输入。
}
mknod(建立块专用或字符专用文件){
mknod [options] name {bc} major minor
mknod [options] name p
-m mode, --mode=mode # 为新建立的文件设定模式，就象应用命令chmod一样，以后仍然使 用缺省模式建立新目录。
p      FIFO型
b      块文件
c      字符文件

int mknod(const char *pathname, mode_t mode, dev_t dev);
mode : S_IFREG, S_IFCHR, S_IFBLK, S_IFIFO or S_IFSOCK mode & ~umask
dev  : 
  dev_t makedev(int maj, int min);
  int major(dev_t dev);
  int minor(dev_t dev);
}
IO(mkfifo|pipe){ ->  O_NONBLOCK and  O_ASYNC
int mkfifo(const char *pathname, mode_t mode); # 成功则返回0，出错则返回-1.  
mkfifo( "/tmp/cmd_pipe", S_IFIFO | 0666 );
注意。mkfifo函数仅仅是创建FIFO，要想打开它。还必须使用open函数。
并且创建的过程中是隐含了O_CREAT|O_EXCL标志的,也就是说它要么创建一个新的FIFO，要么返回一个EEXIST错误。

unlink()：销毁命名管道

int mknod(const char *path, mode_t mode, dev_t dev); 
# 第一个参数表示你要创建的文件的名称，
# 第二个参数表示文件类型，
# 第三个参数表示该文件对应的设备文件的设备号。只有当文件类型为 S_IFCHR 或 S_IFBLK 的时候该文件才有设备号，创建普通文件时传入0即可。  
eg.mknod(FIFO_FILE,S_IFIFO|0666,0);    

如果试图从管道写端读取数据，或者向管道读端写入数据都将导致错误发生。

FIFO与管道的差别主要有下面两点：
1、创建并打开一个管道仅仅须要调用pipe。创建并打开一个FIFO则须要调用mkfifo后再调用open。
2、管道在全部进程终于都关闭它之后自己主动消失。
FIFO的名字则仅仅有调用unlink才从文件系统中删除。

管道与FIFO都有系统加在他们上面的限制：
1、OPEN_MAX 一个进程在随意时刻打开的最大描写叙述符数。
2、PIPE_BUF 可原子地写一个管道或FIFO的最大数据量。 386:4069; x86:65536

使用open打开FIFO文件：
1、打开FIFO的主要限制是，程序不能以O_RDWR模式打开FIFO文件进行读写操作，由于通常我们仅仅是单向传递数据。假设须要双向传递数据，就要创建一对FIFO。
实现实例请參考之前写的client-server程序，点此进入。
2、打开FIFO文件和打开普通文件的还有一个差别是。对open_flag的O_NOBLOCK选项的使用方法。使用这个选项不仅改变open调用的处理方式。还会改变对这次open调用返回的文件描写叙述符进行的读写请求的处理方式。
a、open(const char *path, O_RDONLY); open调用将堵塞，除非有一个进程以写方式打开同一个FIFO。否则不会返回。
b、open(const char *path, O_RDONLY | O_NONBLOCK);即使没有其它进程以写方式打开FIFO，这个open调用也将成功马上返回。
c、open(const char *path, O_WRONLY); open调用将堵塞，直到有一个进程以读的方式打开同一个FIFO为止。
d、open(const char *path, O_WRONLY | O_NONBLOCK);函数马上返回 errno=ENXIO。正常返回。

read:  写入端close，则read获取完数据之后，读函数返回的读出字节数为0
  当管道的写端存在时 # 阻塞方式
    读请求的字节数目大于PIPE_BUF，则返回管道中现有的数据字节数，
    读请求的字节数目不大于PIPE_BUF，则返回管道中现有数据字节数(此时，管道中数据量小于请求的数据量)
                                            或者返回请求的字节数(此时，管道中数据量不小于请求的数据量)
                                            或者阻塞在读调用(此时，管道中数据量为0)
    # 非阻塞形式
    读请求字节数目大于pipe缓冲区内数据，返回缓冲区内数据大小
    读请求字节数目小于pipe缓冲区内数据，返回请求大小数据大小；
    读缓冲区内没有一个字节数据，则返回-1；errno=EAGAIN
    
write: 读取端close，则write返回-1，sigcatcher=SIGPIPE； 如果忽略SIGPIPE信号，
                    则write返回-1，errno=EPIPE
  向管道中写入数据时，linux将不保证写入的原子性，管道缓冲区一有空闲区域，写进程就会试图向管道写入数据。
缓冲区写满之后，如果读进程不读走管道缓冲区中的数据，那么写操作将一直阻塞。
只有在管道的读端存在时，向管道中写入数据才有意义。
    否则，向管道中写入数据的进程将收到内核传来的SIFPIPE信号，应用程序可以处理该信号，也可以忽略。
     # 非阻塞形式
    写请求字节数目大于pipe缓冲区内数据，返回pipe缓冲区内空闲空间大小；
    写请求字节数目小于pipe缓冲区内数据，返回请求大小数据大小；
    如果缓冲区内没有一个字节数据，这返回-1；errno=EAGAIN
在向管道写入数据时，至少应该存在某一个进程，其中管道读端没有被关闭，否则就会出现上述错误。
一个进程使用pipe和fork之后，应该关闭不使用的管道文件描述符，保证管道获取正确的read=0和write的SIGPIPE/EPIPE。
管道写端关闭后，写入的数据将一直存在，直到读出为止。

对于设置了阻塞标志的写操作： # 设定了保证原子的条件
当要写入的数据量不大于PIPE_BUF时，linux将保证写入的原子性。如果此时管道空闲缓冲区不足以容纳要写入的字节数，则进入睡眠，直到当缓冲区中能够容纳要写入的字节数时，才开始进行一次性写操作。
当要写入的数据量大于PIPE_BUF时，linux将不再保证写入的原子性。FIFO缓冲区一有空闲区域，写进程就会试图向管道写入数据，写操作在写完所有请求写的数据后返回。
对于没有设置阻塞标志的写操作：
当要写入的数据量大于PIPE_BUF时，linux将不再保证写入的原子性。在写满所有FIFO空闲缓冲区后，写操作返回。
当要写入的数据量不大于PIPE_BUF时，linux将不再保证写入的原子性。如果当前FIFO空闲缓冲区能够容纳请求写入的字节数，写完后成功返回；如果当前FIFO空闲缓冲区不能够容纳请求写入的字节数，则返回EAGAIN错误，提醒以后再写；
}
IO(O_CLOEXEC){
关于open函数O_CLOEXEC模式，fcntl函数FD_CLOEXEC选项，总结为如下几点：
1.调用open函数O_CLOEXEC模式打开的文件描述符在执行exec调用新程序中关闭，且为原子操作。
2.调用open函数不使用O_CLOEXEC模式打开的文件描述符，然后调用fcntl 函数设置FD_CLOEXEC选项，
  效果和使用O_CLOEXEC选项open函数相同，但分别调用open、fcntl两个函数，不是原子操作，
  多线程环境中存在竞态条件，故用open函数O_CLOEXEC选项代替之。
3.调用open函数O_CLOEXEC模式打开的文件描述符，或是使用fcntl设置FD_CLOEXEC选项，
  这二者得到(处理)的描述符在通过fork调用产生的子进程中均不被关闭。
4.调用dup族类函数得到的新文件描述符将清除O_CLOEXEC模式。
}
IO(socketpair unix socket pipe mkfifo){ 都支持阻塞和非阻塞
pipe和mkfifo 单向管道-只读或只写，只支持stream，只支持一主一从结构；管道的缓冲区是有限的；文件描述符管理; mkfifo在open时刻也会被阻塞
pipe 需要亲缘关系      mkfilo 不需要亲缘关系 
pipe 文件系统无关      mkfifo文件系统相关
pipe 直接pipe系统调用  mkfifo需要mkfifo和open两个过程
pipe 没有读写权限      mkfifo有读写权限

socketpair和socket(uinx)都是双向管道，支持stream和datagram，支持一主多从结构; 支持在进程间传递fd和进程信任; 文件描述符管理
socketpair匿名unix               socket为命名unix
socketpair不需要sockaddr_un地址  socket需要sockaddr_un地址 : 1.pathname -> getsockname|getpeername|accept # sizeof(sa_family_t) + strlen(sun_path) + 1
                                                             2.unnamed -> socketpair # sizeof(sa_family_t)
                                                             3.abstract -> 开头为'\0' # sizeof(struct sockaddr_un)

posix_mq和systemV_msg : 单向管道-可以同时支持读写，也可只读只写; 只支持datagram, 支持优先级；自定义管理对象；
受消息大小和消息队列长度限制；接口级别支持阻塞发送与接收操作的超时机制
     # Posix消息队列                                          # System V消息队列
读总是返回最高优先级的消息                               读则可以返回任一指定优先级消息
不支持对消息截断                                         支持截断消息
允许产生一个信号或启动一个线程，当往空队列放置消息时     不提供类似机制
直接上关联路径                                           可以不关联路径或者通过一个ftok转换
有mq_close操作用于释放进程资源                           没提供此类操作；在进程不使用时不用释放
在open时或调用mq_setattr修改阻塞标识                     在发送和接收时直接设置阻塞标识
支持mq_timedsend和mq_timedreceive                        没有超时阻塞的发送和接收函数

Posix消息队列在调用mq_open时候，在mqueue目录下关联一个文件，所以关闭的时候需要调用mq_close释放描述符信息；
当消息队列不需要的时候调用mq_unlink删除
System V创建消息队列的资源没有关联到task_struct结构体上，所以进程没有维护额外的资源，进程只是用到了关联资源
的索引，且索引通过文件系统文件名->ftok->int类型关联起来了。删除系统资源时使用msgctl进行删除
}

IO(icmp){
如果用 IPPROTP_ICMP 打开原始套接字(raw socket)时， 用户协议有可以收到任意本地套接字  ICMP  包。  IPPROTO_ICMP.   请参阅
raw(7) 传递到套接字的 ICMP 包可以用 ICMP_FILTER 套接字选项进行过滤。核心会处理所有 ICMP 包，包括传递到用户的套接字去的。

Linux 对可以到达每个目标主机出错信息包的比率设立了限制。 ICMP_REDIRECT 及 ICMP_DEST_UNREACH 也受进入包的目标路由的限制。
}

IO(api:netlink){
netlink_socket = socket(PF_NETLINK, socket_type, netlink_family);
  Netlink 用于在内核模块与在用户地址空间中的进程之间传递消息的。它包
  含了用于用户进程的基于标准套接字的接口和用于内核模块的一个内部核心
  API。有关这个内部核心接口的资料没有包含在此手册页中。同样还有一个过时的通过  netlink
  字符设备的接口也没有包含在此，它只是提供 向下兼容特性。
  
  Netlink 是一个面向数据包的服务。 SOCK_RAW 和 SOCK_DGRAM 都是 socket_type  的有效值。然而  netlink  协议对数据包  datagram
  和原套接字(raw sockets) 并不作区分。
  
  netlink_family 选择核心模块或 netlink 组进行通讯。现有可指定的 netlink 的种类有：
  
  NETLINK_ROUTE
         接收路由更新信息，可以用来修改 IPv4 的路由表。(参见 rtnetlink(7))。
  
  NETLINK_FIREWALL
         接收 IPv4 防火墙编码发送的数据包。
  
  NETLINK_ARPD
         用以维护用户地址空间里的 arp 表
  
  NETLINK_ROUTE6
         接收和发送 IPv6 路由表更新消息。
  
  NETLINK_IP6_FW
         接收未通过 IPv6 防火墙检查的数据包(尚未实现)
         
  NETLINK_TAPBASE...NETLINK_TAPBASE+15
          是 ethertap 设备实例。Ethertap 是从用户程序空间对以太网驱动程序进行 仿真的“伪”网络通道设备。
  
   NETLINK_SKIP
          Enskip 的保留选项。
  
   NETLINK_USERSOCK
          为今后用户程序空间协议用保留选项。
Netlink   数据信息由具有一个或多个   nlmsghdr   数据报头及其有效数据的字节流组成。对于分成多个数据包的   Netlink   信息，
       数据报头中的  NLM_F_MULTI  标志位将被设置，除了最后一个包的报头具有标志   NLMSG_DONE外。   字节流应只能用标准的   NLMSG_*
       宏来访问，参阅 netlink(3).

  Netlink  不是可靠的协议。它只是尽可能地将信息传输到目的地，但在内存耗
  尽或发生其他错误时，它会丢失信息。为保证信息可靠传输，可以设置标志 NLM_F_ACK  来要求接收方确认。数据接收确认是一个
  NLMSG_ERROR 数据包，包中的出错字段设置为 0。应用程序必须自己创建收到信息确认消息。
  在信息传送过程中，内核一直(尝试)对每个出错的数据包发送 NLMSG_ERROR 消息。用户进程也应当遵循这一个惯例。
  
  每一个   netlink    数据类都有一个32位广播分组，当    对套接字调用    bind(2)    时，    sockaddr_nl    中的    nl_groups
  字段设置成所要侦听的广播组的位掩码。其默认值为 0，表示不接收任何广播。
  
  一个套接字可以对任意一个多址广播组广播消息，只要在调用    sendmsg(2)    或调用    connect(2)    时，将位掩码    nl_groups
  设置成要发送消息的广播组的值就可以了。 只有具有有效 uid 为 0 的用户或具有
  
  CAP_NET_ADMIN 权限的用户才可能发送或侦听针对 netlink 多址广播组的消息。 任何一个对多址广播组消息的响应需发回进程标识  pid
  和广播组地址。
  
         struct nlmsghdr
         {
         __u32 nlmsg_len; /* 包括报头在内的消息长度*/
         __u16 nlmsg_type; /* 消息正文 */
         __u16 nlmsg_flags; /* 附加标志*/
         __u32 nlmsg_seq; /* 序列号*/
         __u32 nlmsg_pid; /* 发送进程号 PID */
         };
  
         struct nlmsgerr
         {
         int error; /* 负数表示的出错号 errno 或为 0 要求确认 acks*/
         struct nlmsghdr msg; /* 造成出错的消息报头*/
         };
  
  在每个   nlmsghdr   后跟随着有效数据。   nlmsg_type   可以成为标准消息的类型：  NLMSG_NOOP  可以忽略的消息，  NLMSG_ERROR
  发出错误发生的消息，有关数据中包含一个 nlmsgerr 结构， NLMSG_DONE 一个多数据包消息结束的信息。
  
  一个 netlink 类通常指定更多的消息类型，请参阅有关手册页，如 NETLINK_ROUTE.  中的 rtnetlink(7)
  
    nlmsg_flags 的标准标志位
    NLM_F_REQUEST    设置全部请求消息
    NLM_F_MULTI     此消息是多数据包消息之一，通过标志
                    NLMSG_DONE 结束。
    NLM_F_ACK        数据成功接收返回确认消息
    NLM_F_ECHO       要求响应请求信息
    
    为 GET 请求设立的附加标志位
    NLM_F_ROOT      返回对象表而不是单个数据项
    NLM_F_MATCH     尚未实现
    NLM_F_ATOMIC    返回对象表的原子快照(atomic snapshot)
    NLM_F_DUMP      尚未列入文档
    
    对新建 NEW 请求设立的附加标志位
    NLM_F_REPLACE    替换现有的对象
    NLM_F_EXCL       如对象已存在，不作替换
    NLM_F_CREATE     创建对象，如果对象不存在
    NLM_F_APPEND     对象表添加对象项
    
    注 NLM_F_ATOMIC 要求用户有 CAP_NET_ADMIN 或超级用户权。

地址格式
  sockaddr_nl  描述了在用户空间或在核心空间里一个 netlink 客户对象的数据结构。 一个 sockaddr_nl 对象可以是单址广播或对一个
  netlink 多址组 (nl_groups 不为 0).
  
    struct sockaddr_nl
    {
    sa_family_t nl_family; /* AF_NETLINK */
    unsigned short nl_pad; /* 零 */
    pid_t nl_pid; /* 进程标识号pid */
    __u32 nl_groups; /* 多址广播组掩码*/
    };
  
  nl_pid 是用户空间中 netlink 的进程标识号 pid，如果是在内核时此值为 0。 nl_groups 是一个代表 neltlink 组号的位掩码。
}
IO(ip:sockopt){
IP_OPTIONS
  设置或者获取将由该套接字发送的每个包的 IP 选项．该参数是一个指向包含选项和选项长度的存储缓冲区的指针．
  setsockopt(2) 系统调用设置与一个套接字相关联的 IP 选项. IPv4 的最大选项长度为 40 字节参阅 RFC791获取可用的选项．
  如果一个 SOCK_STREAM 套接字收到的初始连接请求包包含 IP 选项时，IP选项自动设置为来自初始包的选项，同时反转路由头．
  在连接建立以后将不允许来访的包修改选项．
  缺省情况下是关闭对所有来访包的源路由选项的，你可以用 accept_source_route sysctl来激活．
  仍然处理其它选项如时间戳(timestamp)． 
  对于数据报套接字而言，IP 选项只能由本地用户设置．调用带 IP_OPTIONS 的 getsockopt(2) 会把当前用于发送的 IP 选项放到你提供的缓冲区中．

IP_PKTINFO
  传递一条包含 pktinfo 结构(该结构提供一些来访包的相关信息)的 IP_PKTINFO 辅助信息.
  这个选项只对数据报类的套接字有效．
  
  struct in_pktinfo
  {
    unsigned int ipi_ifindex; /* 接口索引 */
    struct in_addr ipi_spec_dst; /* 路由目的地址 */
    struct in_addr ipi_addr; /* 头标识目的地址 */
  };
  ipi_ifindex 指的是接收包的接口的唯一索引． ipi_spec_dst 指的是路由表记录中的目的地址，而 ipi_addr
  指的是包头中的目的地址． 如果给  sendmsg  (2)传递了IP_PKTINFO，那么外发的包会通过在 ipi_ifindex 中指定的接口
  发送出去，同时把 ipi_spec_dst 设置为目的地址．
  
IP_RECVTOS
  如果打开了这个选项，则 IP_TOS, 辅助信息会与来访包一起传递．它包含一个字节用来指定包头中的服务/优先级字段的类型．
  该字节为一个布尔整型标识．

IP_RECVTTL
  当设置了该标识时，传送一条带有用一个字节表示的接收包生存时间(time to live)字段的 IP_RECVTTL 控制信息．
  此选项还不支持 SOCK_STREAM 套接字．

IP_RECVOPTS
  用一条 IP_OPTIONS 控制信息传递所有来访的 IP 选项给用户． 路由头标识和其它选项已经为本地主机填好． 此选项还不支持
  SOCK_STREAM 套接字．

IP_RETOPTS
  等同于 IP_RECVOPTS 但是返回的是带有时间戳的未处理的原始选项和在这段路由中未填入的路由记录项目．

IP_TOS 设置或者接收源于该套接字的每个IP包的 Type-Of-Service(TOS 服务类型)字段．它被用来在网络上区分包的优先级．TOS
  是单字节的字段．定义了一些的标准  TOS 标识：IPTOS_LOWDELAY 用来为交互式通信最小化延迟时间，IPTOS_THROUGHPUT
  用来优化吞吐量，IPTOS_RELIABILITY  用来作可靠性优化，IPTOS_MINCOST
  应该被用作"填充数据"，对于这些数据，低速传输是无关紧要的．至多只能声明这些 TOS
  值中的一个．其它的都是无效的，应当被清除． 缺省时,Linux首先发送IPTOS_LOWDELAY 数据报,
  但是确切的做法要看配置的排队规则而定.   一些高优先级的层次可能会要求一个有效的用户标识  0 或者 CAP_NET_ADMIN 能力.
  优先级也可以以于协议无关的方式通过( SOL_SOCKET, SO_PRIORITY )套接字选项(参看 socket(7) )来设置.

IP_TTL 设置或者检索从此套接字发出的包的当前生存时间字段.

IP_HDRINCL
  如果打开的话, 那么用户可在用户数据前面提供一个 ip 头. 这只对  SOCK_RAW有效.参看 raw(7)
  以获得更多信息.当激活了该标识之后,其值由 IP_OPTIONS 设定,并且 IP_TOS 被忽略.
  
IP_PMTU_DISCOVER
  为套接字设置或接收Path MTU Discovery setting(路径MTU发现设置). 当允许时,Linux会在该套接字上执行定
  义于RFC1191中的Path MTU Discovery(路径MTU发现). do not 段标识会设置在所有外发的数据报上.
  系统级别的缺省值是这样的： SOCK_STREAM 套接字由 ip_no_pmtu_disc sysctl
  控制，而对其它所有的套接字都被都屏蔽掉了，对于非 SOCK_STREAM 套接字而言,
  用户有责任按照MTU的大小对数据分块并在必要的情况下进行中继重发.如果设置了该标识 (用EMSGSIZE),内核会拒绝比已知路径MTU更大的包.
  
  Path MTU discovery(路径MTU发现)标识   含义
  IP_PMTUDISC_WANT                      对每条路径进行设置.
  IP_PMTUDISC_DONT                      从不作Path MTU Discovery(路径MTU发现).
  IP_PMTUDISC_DO                        总作Path MTU Discovery(路径MTU发现).
  
  当允许 PMTU(路径MTU)搜索时, 内核会自动记录每个目的主机的path MTU(路径MTU).当它使用 connect(2)
  连接到一个指定的对端机器时,可以方便地使用 IP_MTU 套接字选项检索当前已知的path  MTU(路径MTU)(比如，在发生了一个
  EMSGSIZE 错误后).它可能随着时间的推移而改变.  对于带有许多目的端的非连接的套接字,一个特定目的端的新到来的 MTU
  也可以使用错误队列(参看 IP_RECVERR) 来存取访问. 新的错误会为每次到来的 MTU 的更新排队等待.
  
  当进行 MTU 搜索时,来自数据报套接字的初始包可能会被丢弃. 使用 UDP  的应用程序应该知道这个并且考虑
  其包的中继传送策略.
  
  为了在未连接的套接字上引导路径 MTU 发现进程, 我们可以用一个大的数据报(头尺寸超过64K字节)启动, 并令其通过更新路径
  MTU 逐步收缩.
  
  为了获得路径MTU连接的初始估计,可通过使用 connect(2) 把一个数据报套接字连接到目的地址,并通过调用带 IP_MTU选项的
  getsockopt(2) 检索该MTU.
  
IP_MTU 检索当前套接字的当前已知路径MTU.只有在套接字被连接时才是有效的.返回一个整数.只有作为一个 getsockopt(2) 才有效.

IP_ROUTER_ALERT
  给该套接字所有将要转发的包设置IP路由器警告(IP RouterAlert option)选项.只对原始套接字(raw
  socket)有效,这对用户空间的 RSVP后 台守护程序之类很有用.
  分解的包不能被内核转发,用户有责任转发它们.套接字绑定被忽略, 这些包只按协议过滤.  要求获得一个整型标识.

IP_MULTICAST_TTL
  设置或者读取该套接字的外发多点广播包的生存时间值. 这对于多点广播包设置可能的最小TTL很重要.
  缺省值为1,这意味着多点广播包不会超出本地网段, 除非用户程序明确地要求这么做.参数是一个整数.

IP_MULTICAST_LOOP
  设置或读取一个布尔整型参数以决定发送的多点广播包是否应该被回送到本地套接字.

IP_ADD_MEMBERSHIP
  加入一个多点广播组.参数为 struct ip_mreqn 结构.
  struct ip_mreqn
  {
  struct in_addr imr_multiaddr; /* IP多点传送组地址 */
  struct in_addr imr_address; /* 本地接口的IP地址 */
  int imr_ifindex; /* 接口索引 */
  };
  
  imr_multiaddr 包含应用程序希望加入或者退出的多点广播组的地址.    它必须是一个有效的多点广播地址.     imr_address
  指的是系统用来加入多点广播组的本地接口地址;如果它与   INADDR_ANY  一致,那么由系统选择一个合适的接口.   imr_ifindex
  指的是要加入/脱离 imr_multiaddr 组的接口索引,或者设为0表示任何接口.
  
  由于兼容性的缘故,老的   ip_mreq    接口仍然被支持.它与    ip_mreqn    只有一个地方不同,就是没有包括    imr_ifindex
  字段.这只在作为一个 setsockopt(2) 时才有效.
       
IP_DROP_MEMBERSHIP
  脱离一个多点广播组.参数为 ip_mreqn 或者 ip_mreq 结构,这与 IP_ADD_MEMBERSHIP 类似.

IP_MULTICAST_IF
  为多点广播套接字设置本地设备.参数为 ip_mreqn 或者 ip_mreq 结构,它与 IP_ADD_MEMBERSHIP 类似.
  当传递一个无效的套接字选项时,返回 ENOPROTOOPT .
}
IO(tcp:sockopt){
TCP_NODELAY
  关闭   Nagle 算法。这意味着数据包将尽可能快地被发送而没有因有网
  络中更多的数据包造成的延时，期待一个整数表示的布尔标志。

TCP_MAXSEG
  设置或接收最大出站 TCP 数据段尺寸。如果这个选项在建立连接前的设置，它将改变发送到另一端初始信息包中的MSS
  值。这个值大于 MTU 接口值将被忽略而不起作用。

TCP_CORK
  设置此项将不发送部份帧。所有排队的部份帧只在此项清除后，才能发送。在调用sendfile(2)
  前准备数据报头或对网络吞吐量进行优化有用处。 此选项不能与 TCP_NODELAY 联用.

输入输出控制字 IOCTLS
这些 ioctl 可以用 ioctl(2) 进行访问。正确调用句法为:
  int value;
  error = ioctl(tcp_socket, ioctl_type, &value);

FIONREAD
  返回接收缓存中排队的未读数据的数量。 变量参数是指向一个整数的指针。

SIOCATMARK
  如果用户程序已经接收了所有紧急数据，此项返回值为 0。它与 SO_OOBINLINE
  联用。变量参数是对测试结果，指向一个整数的指针。

TIOCOUTQ
  返回在接口(socket)发送队列中待发送数据数，该指针返回是一个整数数值。
}
IO(netdevice){
  Linux 支持一些配置网络设备的标准 ioctl. 他们用于任意的套接字描述符, 而无须了解其类型或系列. 他们传递 一个
  ifreq 结构:
  struct ifreq
  {
    char            ifr_name[IFNAMSIZ];   /* Interface name */
    union {
       struct sockaddr       ifr_addr;
       struct sockaddr       ifr_dstaddr;
       struct sockaddr       ifr_broadaddr;
       struct sockaddr       ifr_netmask;
       struct sockaddr       ifr_hwaddr;
       short                 ifr_flags;
       int                   ifr_ifindex;
       int                   ifr_metric;
       int                   ifr_mtu;
       struct ifmap          ifr_map;
       char                  ifr_slave[IFNAMSIZ];
       char                  ifr_newname[IFNAMSIZ];
       char *                ifr_data;
    };
  }
  
  struct ifconf
  {
    int ifc_len;                          /* size of buffer */
    union {
      char *                ifc_buf; /* buffer address */
      struct ifreq *ifc_req; /* array of structures */
    };
  };
   一般说来, ioctl 通过把 ifr_name 设置为接口的名字来指定将要操作的设备. 结构的其他成员可以分享内存.

IOCTLS
  如果某个ioctl 标记为特权操作, 那么操作时需要有效uid 为 0, 或者拥有 CAP_NET_ADMIN 能力. 否则将返回 EPERM .
  SIOCGIFNAME
    给定 ifr_ifindex, 返回 ifr_name 中的接口名字. 这是唯一返回ifr_name内容的 ioctl.
  SIOCGIFINDEX
    把接口的索引存入 ifr_ifindex.
  SIOCGIFFLAGS, SIOCSIFFLAGS
    读取 或 设置 设备的 活动标志字.  ifr_flags 包含 下列值 的 屏蔽位:
                        设备标志
    IFF_UP             接口正在运行.
    IFF_BROADCAST      有效的广播地址集.
    IFF_DEBUG          内部调试标志.
    IFF_LOOPBACK       这是自环接口.
    IFF_POINTOPOINT    这是点到点的链路接口.
    IFF_RUNNING        资源已分配.
    IFF_NOARP          无arp协议, 没有设置第二层目的地址.
    IFF_PROMISC        接口为杂凑(promiscuous)模式.
    IFF_NOTRAILERS     避免使用trailer .
    IFF_ALLMULTI       接收所有组播(multicast)报文.
    IFF_MASTER         主负载平衡群(bundle).
    IFF_SLAVE          从负载平衡群(bundle).
    IFF_MULTICAST      支持组播(multicast).
    IFF_PORTSEL        可以通过ifmap选择介质(media)类型.
    IFF_AUTOMEDIA      自动选择介质.
    IFF_DYNAMIC        接口关闭时丢弃地址.
    设置活动标志字是特权操作, 但是任何进程都可以读取标志字.
         
  SIOCGIFMETRIC, SIOCSIFMETRIC
    使用 ifr_metric 读取或设置设备的 metric 值. 该功能目前还没有实现. 读取操作使 ifr_metric 置 0, 而设置操作
    则 返回 EOPNOTSUPP.

  SIOCGIFMTU, SIOCSIFMTU
    使用 ifr_mtu 读取或设置设备的 MTU(最大传输单元).  设置MTU是特权操作. 过小的MTU可能导致内核崩溃.

  SIOCGIFHWADDR, SIOCSIFHWADDR
    使用 ifr_hwaddr 读取或设置设备的硬件地址. 设置硬件地址是 特权操作.

  SIOCSIFHWBROADCAST
    使用 ifr_hwaddr 读取或设置设备的硬件广播地址. 这是个特权操作.

  SIOCGIFMAP, SIOCSIFMAP
    使用 ifr_map 读取或设置接口的硬件参数. 设置 这个参数是特权操作.
    struct ifmap
    {
        unsigned long   mem_start;
        unsigned long   mem_end;
        unsigned short  base_addr;
        unsigned char   irq;
        unsigned char   dma;
        unsigned char   port;
    };
    对 ifmap 结构的解释取决于设备驱动程序和体系结构.

  SIOCADDMULTI, SIOCDELMULTI
    使用ifr_hwaddr在设备的链路层组播过滤器(multicase  filter) 中添加或删除地址.  这些是特权操作. 参看
    packet(7).

  SIOCGIFTXQLEN, SIOCSIFTXQLEN
    使用 ifr_qlen 读取 或 设置 设备的 传输队列长度.  设置 传输队列长度 是 特权操作.

  SIOCSIFNAME
    把 ifr_ifindex 中 指定的 接口名字 改成 ifr_newname.  这是个 特权操作.
       
  SIOCGIFCONF
    返回 接口地址(传输层)列表. 出于兼容性, 目前只代表AF_INET 地址.  用户传送一个ifconf结构作为 ioctl 的参数.
    其中 ifc_req 包含一个指针指向 ifreq 结构数组, 他的长度以字节为单位存放在 ifc_len 中. 内核用所有当前的
    L3(第三层?) 接口地址 填充 ifreqs, 这些接口正在运行: ifr_name 存放接口名字 (eth0:1等), ifr_addr 存放地址. 内核
    在 ifc_len 中返回实际长度; 如果他等于初始长度, 表示溢出了, 用户应该换一个 大些的缓冲区重试 一下.  没有
    发生错误时 ioctl 返回 0, 否则 返回 -1, 溢出不算错误.
}

arping
IO(packet){
分组(也译为数据包)，PF_PACKET - 在设备层的分组接口.
packet_socket=socket(PF_PACKET,intsocket_type,intprotocol);

  分组套接口(也译为插口或套接字)被用于在设备层(OSI的链路层)收发原始(raw)分组。它允许用户在用户空间实现在物理层之上的
协议模块。
  对于包含链路层报头的原始分组，socket_type参数是SOCK_RAW
  对于去除了链路层报头的加工过的分组，socket_type参数是SOCK_DGRAM。
  链路层报头信息可在作为一般格式的  sockaddr_ll  中 的中得到。
  socket 的 protocol 参数指的是 IEEE 802.3 的按网络层排序的协议号，在头文件中有所有被允许的协议的列表。
  当 protocol 被设置为htons(ETH_P_ALL)时，可以接收所有的协议。
  到来的此种类型的分组在传送到在内核实现的协议之前要先传送给分组套接口。
  
  只有有效 uid 是0或有 CAP_NET_RAW 能力的进程可以打开分组套接口。
  
  传送到设备和从设备传送来的SOCK_RAW分组不改变任何分组数据。当收到一个SOCK_RAW分组时, 地址仍被分析并传送到一个标准的
sockaddr_ll 地址结构中。当发送一个 SOCK_RAW 分组时,  用户供给的缓冲区应该包含物理层报头。接着此分组不加修改的放入目的
地址定义的接口的网络驱动程序的队列中。一些设备驱动程序总是增加其他报头。SOCK_RAW 分组与已被废弃的Linux 2.0的
SOCK_PACKET 分组类似但不兼容。
  对 SOCK_DGRAM 分组的操作要稍微高一层次。在分组被传送到用户之前物理报头已被去除。从SOCK_DGRAM分组套接口送出的分组在被
放入网络驱动程序的队列之前，基于在 sockaddr_ll 中的目的地址 得到一个适合的物理层报头。
  缺省的所有特定协议类型的分组被发送到分组套接口。为了只从特 定的接口得到分组，使用bind(2)来指定一个在sockaddr_ll结构
中的地址，以此把一个分组套接口绑定到一个接口上。只有地址字段 sll_protocol 和 sll_ifindex 被绑定用途所使用。

ADDRESS TYPES 地址类型
  sockaddr_ll 是设备无关的物理层地址。
    struct sockaddr_ll
    {
      unsigned short sll_family; /* 总是 AF_PACKET */
      unsigned short sll_protocol; /* 物理层的协议 */
      int sll_ifindex; /* 接口号 */
      unsigned short sll_hatype; /* 报头类型 */
      unsigned char sll_pkttype; /* 分组类型 */
      unsigned char sll_halen; /* 地址长度 */
      unsigned char sll_addr[8]; /* 物理层地址 */
    };
    sll_protocol 是在  linux/if_ether.h  头文件中定义的按网络层排序的标准的以太桢协议类型。
    sll_ifindex  是接口的索引号(参见netdevice(2))；0  匹配所有的接口(当然只有合法的才用于绑定)。
    sll_hatype   是在 linux/if_arp.h 中定义的 ARP 硬件地址类型。
    sll_pkttype  包含分组类型。有效的分组类型是：目标地址是本地主机的分组用的PACKET_HOST，
                               物理层广播分组用的PACKET_BROADCAST
                               发送到一个物理层多路广播地址的分组用的PACKET_MULTICAST
                               在混杂(promiscuous)模式下的设备驱动器发向其他主机的分组用的 PACKET_OTHERHOST
                               本源于本地主机的分组被环回到分组套接口用的PACKET_OUTGOING。
    sll_addr  和  sll_halen  包括物理层(例如 IEEE 802.3)地址和地址长度。精确的解释依赖于设备。
    物理地址(最高位为0)，
    多路广播地址 (最高位为1)，
    广播地址(全是1)
OPTIONS
   PACKET_ADD_MEMBERSHIP
   PACKET_DROP_MEMBERSHIP
    struct packet_mreq
    {
        int mr_ifindex; /* 接口索引号 */
        unsigned short mr_type; /* 动作 */
        unsigned short mr_alen; /* 地址长度 */
        unsigned char mr_address[8]; /* 物理层地址 */
    };
    mr_ifindex 包括接口的接口索引号，mr_ifindex  的状态是可以改变的。
    mr_type  参数指定完成那个动作。PACKET_MR_PROMISC  允许接收在共享介质上的所有分组，这种接受状态常被称为混杂模式；   
    PACKET_MR_MULTICAST 把套接口绑定到由mr_address  和  mr_alen
指定的物理层多路广播组上；PACKET_MR_ALLMULTI 设置套接口接 收所有的来到接口的多路广播分组。

}

mmap(){
    根据APUE(3rd)的对比分析，对于不太大的文件（测试中使用300MB大小的文件），
Linux下使用mmap的文件复制速度要慢于使用read/write的文件复制速度。

对于产生这种性能差距的原因分析，网上有一段个人认为较为有道理的论述：
    不能简单的说哪个效率高，要看具体实现与具体应用。
    无论是通过mmap方式或read/write方式访问文件在内核中都必须经过两个缓存：一个是用 address_space来组织的以页为基础的缓存；一个是以buffer来组织的缓存，但实际上这两个缓存只是同一个缓冲池里内容的不同组织方式。当需要从文件读写内容时，都经过 address_space_operation中提供的函数也就是说路径是一致的。如果是用read/write方式，用户须向内核指定要读多少，内核再把得到的内容从内核缓冲池拷向用户空间；写也须要有一个大致如此的过程。
    mmap的优势在于通过把文件的某一块内容映射到用户空间上，用户可以直接向内核缓冲池读写这一块内容，这样一来就少了内核与用户空间的来回拷贝所以通常更快。但 mmap方式只适用于更新、读写一块固定大小的文件区域而不能做像诸如不断的写内容进入文件导到文件增长这类的事。
    二者的主要区别在于，与mmap和memcpy相比，read和write执行了更多的系统调用，并做了更多的复制。read和write将数据从内核缓冲区中复制到应用缓冲区，然后再把数据从应用缓冲区复制到内核缓冲区。而mmap和memcpy则直接把数据从映射到地址空间的一个内核缓冲区复制到另一个内核缓冲区。当引用尚不存在的内存页时，这样的复制过程就会作为处理页错误的结果而出现（每次错页读发生一次错误，每次错页写发生一次错误）。
    所以他们两者的效率的比较就是系统调用和额外的复制操作的开销和页错误的开销之间的比较，哪一个开销少就是哪一个表现更好。
}
IO(信号驱动式 I/O 模型){
应用进程建立 SIGIO 的信号处理程序，发出sigaction系统调用，内核立刻返回，同时等待数据。这里应用进程没有阻塞
内核得到数据，向应用进程的信号处理程序递交 SIGIO，同时开始复制数据
应用进程发出recvfrom系统调用，同时阻塞
内核数据复制完成，返回成功指示，应用进程处理数据
}
IO(异步 I/O 模型 ){
应用进程发出aio_read系统调用，内核立刻返回，应用进程没有被阻塞
内核等到数据，并复制数据
内核把数据复制完成，递交在aio_read中指定的信号
应用进程中的信号处理程序处理数据
}
IO(同步与异步){
1. 同步与异步关注的是事件结果的通知机制，具体到代码层面，就是指调用结果的返回方式。
2. 如果进行一个过程调用，返回值就是这个过程处理的结果，就可以说这个调用是同步的。
3. 如果进行一个过程调用，返回值不能代表过程处理的结果，需要调用者不断通过其它同步调用去查询结果，或者通过异步回调注册的方式去等待结果，就可以说这样的调用时异步的。
4. 轮询和回调是异步调用的两种结果获取方式，因为轮询的低效和延时，一般都是采用回调配合异步。
5. 需要注意的是，异步的调用没有回调机制也是可以工作的；使用了回调的过程，也不一定都是异步的。

}