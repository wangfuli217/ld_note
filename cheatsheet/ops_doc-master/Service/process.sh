http://www.cnblogs.com/xiaojiang1025/p/5934317.html
https://blog.csdn.net/ZX714311728/article/details/53056927
http://www.cnblogs.com/Anker/p/3271773.html

http://man7.org/tlpi/index.html
http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/contents.html

https://www.linuxjournal.com/

1. vfork()用户终止进程时必须调用_exit(),而不是exit(). --> 多见于init进程
   vfork调用成功时，其执行结果和fork()是一样的，除了子进程会立即执行一次exec系统调用，或者调用_exit()退出。vfork()
   系统调用会通过挂起父进程，直到子进程终止或执行新的二进制镜像，从而避免地址空间和页表拷贝。在这个过程中，父进程和
   子进程共享相同的地址空间和页表空间，并不使用写时复制。
vfork()调用只完成一件事：复制内部的内核数据结果。因此，子进程也就不能修改地址空间中的任何内存。
严格来说，vfork()的所有时间都是bug的：考虑一下这种情况：如果exec调用失败了，父进程将被一直挂起，直到子进程采取措施或退出。
程序应更倾向于使用简单明了的fork()调用。

2. pid_t /proc/sys/kernel/pid_max 32768 
内核分配进程ID是以严格的线性方式执行的。这种分配方式至少可以保证pid在短时间内是稳定且唯一的。
pid_t通常定义为C语言的int类型。
printf("pid:%jd\n", getpid()); 把返回值强制类型转换成intmax_t类型，它是一种C类型，能够确保可以存储系统上的任意有符号整数值。

3. exec
int execl(const char *path, const char *arg, ...);
execl("/bin/vi", "vi", NULL);  /bin/vi对应Path，而vi对应argv[0], NULL对应argv[1];
在很多情况下，用户会看到有些系统工具具有不同的名字，实际上这些名字都是执行同一个程序的硬链接。
busybox mfstool等等。
l:列表 v:向量 p:绝对路径path下查找 e:新进程提供新的环境变量。

4. execlp()和execvp()的安全隐患：当需要设置组ID和设置用户ID操作时，进程应该以二进制程序的组或用户权限运行，而不应该以
   调用方的组或用户身份运行----不要调用shell或那些会调用shell操作。否则会产生安全泄露，调用方可以会设置环境来操作shell
   行为。路径注入。
5. system()调用的安全隐患：存在和execlp()和execvp()调用相同的安全隐患。
   system() 用于创建新进程并等待它结束，可以把它想象成是同步创建进程。
   
malloc            简单、方便，最常用                       返回的内存为用零初始化
calloc            使数组分配变得容易，用0初始化内存        再分配非数组空间时显得较复杂
realloc           调整已分配的空间大小                     只能用来调整已分配空间的大小
brk和sbrk         允许堆进行深入控制                       对大多数使用者来说过于底层
匿名内存映射      使用简单，可共享，允许开发者调整         不适合小分配
                  保护等级并提供建议，适合大空间的分配     
posix_memalign    分配的内存按照任何合理的大小进行对齐     
memalign和valloc  相比posix_memalign在其他UNIX系统更常见   
alloca            最快的分配方式                           
变长数组          与alloca类似                             
                                                           

semaphore(){

#include<semaphore.h>
#include<sys/stat.h>
#include<fcntl.h>
sem_open()        //初始化并打开有名信号量
sem_init()        //创建/获得无名信号量
sem_wait()/sem_trywait()/sem_timedwait()/sem_post()/sem_getvalue()    //操作信号量
sem_close()       //退出有名信号量
sem_unlink()      //销毁有名信号量
sem_destroy()     //销毁无名信号量

sem_open()

//创建/打开一个有名信号量，成功返回新信号量的地址，失败返回SEM_FAILED设errno
// <semaphore.h>
//#define SEM_FAILED    ((sem_t *) 0
//#define SEM_VALUE_MAX     (2147483647)
//Link with -pthread.
sem_t *sem_open(const char *name, int oflag);
sem_t *sem_open(const char *name, int oflag, mode_t mode, unsigned int value);

oflag

    O_CREAT如果信号量不存在就创建信号量，信号量的UID被设为调用进程的effective UID，GID被设为调用程序的GID，可以在mode指定权限
    O_EXCL和O_CREAT连用，确保可以创建新的信号量，如果已存在就报错

value :配合O_CREAT使用，设置信号量的初始值
sem_init()

//初始化无名信号量，成功返回0,失败返回-1设errno
//Link with -pthread.
int sem_init(sem_t *sem, int pshared, unsigned int value);

sem 创建无名信号量的指针
pthread指定信号量是在线程间使用还是进程间使用

    0表示信号量在一个进程内的线程间使用，此时信号量应该分配的在线程可见的内存区域(eg,全局区，BSS段，堆区)
    非0表示信号量在进程间使用，此时信号量应该分配在共享内存里，If pshared !=0,

sem_wait()/sem_trywait()/sem_timedwait()

//Link with -pthread.
//成功返回降低后的信号量的值，失败返回-1设errno
//试图占用信号量，如果信号量值>0,就-1,如果已经=0,就block，直到>0
int sem_wait(sem_t *sem);

//试图占用信号量，如果信号量已经=0，立即报错
int sem_trywait(sem_t *sem);

//试图占用信号量
//如果信号量=0,就block abs_timeout那么久，从 Epoch, 1970-01-01 00:00:00 +0000 (UTC).开始按纳秒计
//如果时间到了信号量还没>0，报错
int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout);

struct timespec {
    time_t  tv_sec;      /* Seconds */
    long    tv_nsec;     /* Nanoseconds [0 .. 999999999] */
};

sem_post()

//归还信号量，成功返回0,失败返回-1设errno
//Link with -pthread.
int sem_post(sem_t *sem);

sem_getvalue()

//获得信号量sem的当前的值，放到sval中。如果有线程正在block这个信号量，sval可能返回两个值，0或“-正在block的线程的数目”，Linux返回0
//成功返回0,失败返回-1设errno
//Link with -pthread.
int sem_getvalue(sem_t *sem, int *sval);

sem_close()

//关闭有名信号量，成功返回0,失败返回-1设errno
//Link with -pthread.
int sem_close(sem_t *sem);

sem_unlink()

//试图销毁信号量，一旦所有占用该信号量的进程都关闭了该信号量，那么就会销毁这个信号量
//成功返回0,失败返回-1设errno
//Link with -pthread.
int sem_unlink(const char *name);

sem_destroy()

//销毁信号量，成功返回0,失败返回-1设errno
//Link with -pthread.
int sem_destroy(sem_t *sem);
}

mqueue()
{
模型：

#include<mqueue.h>
#include <sys/stat.h>
#include <fcntl.h>
mq_open()   //创建/获取消息队列fd       
mq_get()    //设置/获取消息队列属性   
mq_send()/mq_receive()    //发送/接收消息 
mq_close()      //脱接消息队列            
mq_unlink()     //删除消息队列            

POSIX mq VS Sys V mq的优势

    更简单的基于文件的应用接口
    完全支持消息优先级（优先级最终决动队列中消息的位置）
    完全支持消息到达的异步通知，这通过信号或是线程创建实现
    用于阻塞发送与接收操作的超时机制

消息队列名

由 man mq_overview知：消息队列由一个形如'/somename'的名字唯一标识，名字字符串的最大长度不能朝着哦NAME_MAX(i.e.，255),两个进程通过使用同一个消息队列的名字来通信
mq_open()

//创建一个POSIX消息队列或打开一个已经存在的消息队列,成功返回消息队列描述符mqdes供其他函数使用，失败返回(mqd_t)-1设errno
//Link with -lrt.
mqd_t mq_open(const char *name, int oflag);
mqd_t mq_open(const char *name, int oflag, mode_t mode, struct mq_attr *attr);

oflag
must include one of:

    O_RDONLY表示以只接收消息的形式打开消息队列
    O_WRONLY表示以只发送消息的形式打开消息队列
    O_RDWR表示以可接收可发送的形式打开消息队列

can be Bitwised ORed:

    O_NONBLOCK以nonblocking的模式打开消息队列
    O_CREAT如果一个消息队列不存在就创建它，消息队列的拥有者的UID被设为调用进程的effective UID，GID被设为调用进程的effective GID
    O_EXCL确保消息队列被创建，如果消息队列已经存在，则发生错误

mode如果oflag里有O_CREAT，则mode用来表示新创建的消息队列的权限
attr如果oflag里有O_CREAT，则attr表示消息队列的属性，如果attr是NULL，则会按照默认设置配置消息队列(mq_overview(7) for details.)
mq_setattr() / mq_getattr()

//设置/修改 / 获取消息队列属性,成功返回0,失败返回-1设errno
//Link with -lrt.
int mq_setattr(mqd_t mqdes, const struct mq_attr *newattr, struct mq_attr *oldattr);
int mq_getattr(mqd_t mqdes, struct mq_attr *attr);

mqattr结构体

struct mq_attr {
    long mq_flags;      /* Flags: 0 or O_NONBLOCK */
    long mq_maxmsg;     /* Max. # of messages on queue */
    long mq_msgsize;    /* Max. message size (bytes) */
    long mq_curmsgs;    /* # of messages currently in queue */
};

mq_send() / mq_timesend()

//发送消息到mqdes指向的消息队列。成功返回0，失败返回-1设errno
//Link with -lrt.
int mq_send(mqd_t mqdes, const char *msg_ptr,size_t msg_len, unsigned int msg_prio);

//如果消息队列满
#include<time.h>        //额外的header
int mq_timedsend(mqd_t mqdes, const char *msg_ptr,size_t msg_len, unsigned int msg_prio,const struct timespec *abs_timeout);

msg_len msg_ptr指向的消息队列的长度，这个长度必须<=消息队列中消息长度，可以是0
msg_prio 一个用于表示消息优先级的非0整数，消息按照优先级递减的顺序被放置在消息队列中，同样优先级的消息，新的消息在老的之后，如果消息队列满了，就进入blocked状态，新的消息必须等到消息队列有空间了进入，或者调用被signal中断了。如果flag里有O_NOBLOCK选项，则此时会直接报错
abs_timeout:如果消息队列满了，那么就根据abs_timeout指向的结构体表明的时间进行锁定，里面的时间是从970-01-01 00:00:00 +0000 (UTC)开始按微秒计量的时间，如果时间到了，那么mq_timesend()立即返回

struct timespec {
    time_t tv_sec;        /* seconds */
    long   tv_nsec;       /* nanoseconds */
};

mq_receive()/mq_timedreceive()

//从消息队列中取出优先级最高的里面的最老的消息，成功返回消息取出消息的大小，失败返回-1设errno
//具体功能参照mq_send()/mq_timesend()
//Link with -lrt.
ssize_t mq_receive(mqd_t mqdes, char *msg_ptr, size_t msg_len, unsigned int *msg_prio);
#include<time.h>        //额外的header
ssize_t mq_timedreceive(mqd_t mqdes, char *msg_ptr, size_t msg_len, unsigned int *msg_prio, const struct timespec *abs_timeout);

mq_notify()

//允许调用进程注册或去注册同步来消息的通知，成功返回0,失败返回-1设errno
//Link with -lrt.
int mq_notify(mqd_t mqdes, const struct sigevent *sevp);

sevp指向sigevent的指针

    如果sevp不是NULL，那么这个函数就将调用进程注册到通知进程,只有一个进程可以被注册为通知进程
    如果sevp是NULL且当前进程已经被注册过了，则去注册，以便其他进程注册

union sigval {                  /* Data passed with notification */
    int     sival_int;          /* Integer value */
    void*   sival_ptr;          /* Pointer value */
};
struct sigevent {
    int     sigev_notify;       /* Notification method */
    int     sigev_signo;        /* Notification signal */
    union sigval    sigev_value;    /* Data passed with notification */
    void(*sigev_notify_function) (union sigval); //Function used for thread notification (SIGEV_THREAD)
    void*   sigev_notify_attributes;    // Attributes for notification thread (SIGEV_THREAD)
    pid_t   sigev_notify_thread_id;     /* ID of thread to signal (SIGEV_THREAD_ID) */
};

sigev_notify使用下列的宏进行配置：

    SIGEV_NONE调用进程仍旧被注册，但是有消息来的时候什么都不通知
    SIGEV_SIGNAL通过给调用进程发送sigev_signo指定的信号来通知进程有消息来了
    SIGEV_THREAD一旦有消息到了，就激活sigev_notify_function作为新的线程的启动函数

mq_close()

//关闭消息队列描述符mqdes，如果有进程存在针对这个队列的notification request，那么也会被移除
//成功返回0,失败返回-1设errno
//Link with -lrt.
int mq_close(mqd_t mqdes);

mq_unlink():

//移除队列名指定的消息队列，一旦最后一个进程关闭了针对这个消息队列的描述符，就会销毁这个消息队列
//成功返回0，失败返回-1设errno
//Link with -lrt.
int mq_unlink(const char *name);



}

mmap()
{
模型

#include <unistd.h>         //for fstat()
#include <sys/types.h>      //for fstat()
#include <sys/mman.h>
#include <sys/stat.h> 
#include <fcntl.h>
shm_open()            //创建/获取共享内存fd     
ftruncate()           //创建者调整文件大小       
mmap()                //映射fd到内存         
munmap()              //去映射fd               
shm_unlink()          //删除共享内存          

shm_open

//创建/获取共享内存的文件描述符，成功返回文件描述符，失败返回-1
//Link with -lrt.
int shm_open(const char *name, int oflag, mode_t mode);

oflag

    Access Mode:
    O_RDONLY以只读的方式打开共享内存对象
    O_RDWR以读写的方式打开共享内存对象
    Opening-time flags(Bitwise Or):
    O_CREAT 表示创建共享内存对象，刚被创建的对象会被初始化为0byte可以使用ftuncate()调整大小
    O_EXCL用来确保共享内存对象被成功创建，如果对象已经存在，那么返回错误
    O_TRUNC表示如果共享内存对象已经存在那么把它清空

mode: eg,0664 etc
ftruncate()

//调整fd指向文件的大小，成功返回0,失败返回-1设errno
//VS truncate()
int ftruncate(int fd, off_t length)；

如果原文件大小>指定大小，原文件中多余的部分会被截除

int res=ftruncate(fd,3*sizeof(Emp));//要用sizeof,且是Emp(类型)不是emp(对象)
if(-1==res)
        perror("ftruncate"),exit(-1);

fstat()

//获取文件状态，成功返回0,失败返回-1设errno
//VS stat()
int lstat(const char *pathname,     struct stat *buf);
int fstat(int fd, struct stat *buf);

buf：stat类型的指针

struct stat {
    dev_t   st_dev;                 /* ID of device containing file */
    ino_t   st_ino;                 /* inode number */
    mode_t  st_mode;                /* protection */        八进制            usigned int o%
    nlink_t st_nlink;               /* number of hard links */
    uid_t       st_uid;             /* user ID of owner */
    gid_t       st_gid;             /* group ID of owner */
    dev_t       st_rdev;            /* device ID (if special file) */
    off_t       st_size;            /* total size, in bytes */                      ld%
    blksize_t   st_blksize;         /* blocksize for filesystem I/O */
    blkcnt_t    st_blocks;          /* number of 512B blocks allocated */
    struct timespec st_atim;        /* time of last access */   
    struct timespec st_mtim;    /* time of last modification */     ld%,秒
    struct timespec st_ctim;    /* time of last status change */
};

//eg:
st_mode=100664      //100是文件类型
                    //664是权限, 通过100664和0777BitwiseAND得到
st_mtime=1462787968 //秒

mmap()

//映射文件或设备到进程的虚拟内存空间，映射成功后对相应的文件或设备操作就相当于对内存的操作
//映射以页为基本单位,文件大小, mmap的参数 len 都不能决定进程能访问的大小, 而是容纳文件被映射部分的最小页面数决定传统文件访问
//要求对文件进行可读可写的的打开!!!
//成功返回映射区的指针，失败返回-1设errno           
void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);   //prot:protection, 权限

addr:映射的起始地址, 如果为NULL则由kernel自行选择->最合适的方法
length:映射的区域长度
prot:映射内存的保护权限

    PROT_EXEC表示映射的内存页可执行
    PROT_READ表示映射的内存可被读
    PROT_WRITE表示映射的内存可被写
    PROT_NONE表示映射的内存不可访问

flags

must include one of :

    MAP_SHARED表示共享这块映射的内存，读写这块内存相当于直接读写文件，这些操作对其他进程可见，由于OS对文件的读写都有缓存机制，所以实际上不会立即将更改写入文件，除非带哦用msync()或mumap()
    MAP_PRIVATE表示创建一个私有的copy-on-write的映射， 更新映射区对其他映射到这个文件的进程是不可见的

can be Bitwise ORed:

    MAP_32BIT把映射区的头2GB个字节映射到进程的地址空间，仅限域x86-64平台的64位程序，在早期64位处理器平台上，可以用来提高上下文切换的性能。当设置了MAP_FIXED时此选项自动被忽略
    MAP_ANONYMOUS映射不会备份到任何文件，fd和offset参数都被忽略，通常和MAP_SHARED连用
    MAP_DENYWRITEignored.
    MAP_EXECUTABLEignored
    MAP_FILE用来保持兼容性，ignored
    MAP_FIXED不要对addr参数进行处理确确实实的放在addr指向的地址，此时addr一定时页大小的整数倍，
    MAP_GROWSDOWN用在栈中，告诉VMM映射区应该向低地址扩展
    MAP_HUGETLB (since Linux 2.6.32)用于分配"大页"

fd: file decriptor
offset: 文件中的偏移量

void* pv=mmap(NULL,4,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,0,0);
if(MAP_FAILED==pv)
    perror("mmap"),exit(-1);

映射机制小解

    mmap()就是建立一个指针，这个指针指向页高速缓存的一页，并假设这个页有我们想要访问的文件内容（此时都在虚拟地址空间），当然，这个页描述符会自动的加入的调用进程的页表中。当我们第一次使用这个指针，去访问这个虚拟地址的页时，发现这个页还没有分配物理页框，没有想要的文件，引起缺页中断，系统会把相应的（fd）文件内容放到高速缓存的物理页框（此时才会有对物理地址空间的读写）
    映射过程中使用的文件相当于药引子，因为所有进程都是可以通过VFS访问磁盘文件的，所以这个文件相当于对映射内存的一个标识，有了这个位于磁盘的药引子，很多进程都可以根据它找到同一个物理页框，进而实现内存的共享，并不是说就在磁盘上读写
    页高速缓存的内容不会立即写到磁盘中，会等几秒，这种机制可以提高效率并保护磁盘
    只要内存够大，页高速缓存的内容就会一直存在内存中，以后再有进程对该缓存页的内容访问的需求，就不需要从磁盘中搜索，直接访问缓存页（把这个页加入到进程的页表）就行
    mmap()是系统调用，使用一次的开销比较大，但比文件读写的read()/write()进行内核空间到用户空间的数据复制要快，通常只有需要分配的内存>128KB(malloc一次分配33page就是128KB）的时候才会使用mmap()
    /shm是一个特殊的文件系统，它不对应磁盘中的区域，而是内存中，所以使用mmap()在这个文件系统中创
    /proc 不占用任何磁盘空间
    linux采用的是页式管理机制。对于用mmap()映射普通文件来说，进程会在自己的地址空间新增一块空间，空间大小由mmap()的len参数指定，注意，进程并不一定能够对全部新增空间都能进行有效访问。进程能够访问的有效地址大小取决于文件被映射部分的大小。
    简单的说，能够容纳文件被映射部分大小的最少页面个数决定了进程从mmap()返回的地址开始，能够有效访问的地址空间大小。超过这个空间大小，内核会根据超过的严重程度返回发送不同的信号给进程。
    经过内核！=在内核空间和用户空间来回切换！=在内核空间和用户空间传递复制的数据
    页是内存映射的基本单位, 可以理解为实际分配给物理内存的基本单位, 但不是数据操作的基本单位；
    页机制是操作系统和CPU约定好的一种方式，OS按照页给CPU按页发虚拟地址，CPU按页解析并处理
    操作系统(包括Linux)大量使用的缓存的两个原理:
        CPU访问内存的速度远远大于访问磁盘的速度（访问速度差距不是一般的大，差好几个数量级）
        数据一旦被访问，就有可能在短期内再次被访问（临时局部原理）
    页高速缓存（page cache）是个内存区域，是Linux 内核使用的主要磁盘高速缓存，在绝大多数情况下，内核在读写磁盘时都引用页高速缓存，新页被追加到页高速缓存以满足用户态进程的读请求，如果页不在高速缓存中，新页就被加到高速缓存中，然后就从磁盘读出的数据填充它，如果内存有足够的空闲空间，就让该页在高速缓存中长期保留，使其他进程再使用该页时不再访问磁盘, 即磁盘上的文件缓存到内存后，它的虚拟内存地址可以有多个，但是物理内存地址却只能有一个
    我们要读写磁盘文件时，实质是对页高速缓存进行读写，所以无论读写，都会首先检查页高速缓存有没有这个文件对应的页，如果有，就直接访问，如果没有，就引起缺页中断，给OS发信号，让它把文件放到高速缓存再进行读写，这个过程不经过内核空间到用户空间复制数据
    OS中的页机制，对应到硬件中可不一定在主存中，也可以是高速缓存etc，但不会是磁盘，因为磁盘文件的地址和内存不一样，不是按照32位编址的，而是按照ext2 etc方式编址的，需要使用文件管理系统，在Linux中使用VFS和实际文件管理系统来管理文件,所以对于Linux，有两个方式使用系统资源：VMM，VFS，前者用来管理绝大部分的内存，后者用来管理所有的文件和部分特殊文件系统（eg：/shm是内存的一块区域）
    page cache可以看作二者的桥梁，把磁盘文件放到高速缓存，就可以按照内存的使用方式使用磁盘的文件，使用完再释放或写回磁盘page cache中的页可能是下面的类型：
        含有普通文件数据的页
        含有目录的页
        含有直接从块设备（跳过文件系统层）读出的数据的页
        含有用户态进程数据的页，但页中的数据已经被交换到硬盘
        属于他书文件系统文件的页
    映射：一个线性区可以和磁盘文件系统的普通文件的某一部分或者块设备文件相关联，这就意味着内核把对区线性中页内某个字节的访问转换成对文件中相应字节的操作
    TLB（Translation Lookaside Buffer）高速缓存用于加快线性地址的转换，当一个线性地址第一次被使用时，通过慢速访问RAM中的页表计算出相应的物理地址，同时，物理地址被存放在TLB表项（TLB entry），以便以后对同一个线性地址的引用可以快速得到转换
    在初始化阶段，内核必须建立一个物理地址映射来指定哪些物理地址范围对内核可用，哪些不可用
    swap（内存交换空间）的功能是应付物理内存不足的情况下所造成的内存扩展记录的功能，CPU所读取的数据都来自于内存，那当内存不足的时候，为了让后续的程序可以顺序运行，因此在内存中暂不使用的程序和数据就会被挪到swap中，此时内存就会空出来给需要执行的程序加载，由于swap是使用硬盘来暂时放置内存中的信息，所以用到swap时，主机硬盘灯就会开始闪个不同
    Q：CPU只能对内存进行读写，但又是怎么读写硬盘的呢？？？A：把数据写入page cache，再经由。。。写入磁盘（包括swap） --《鸟哥》P10
    内存本身没有计算能力，寻址之类的都是CPU的事，只是为了简便起见，我们通常画成从内存地址A跳到内存地址B
    OS是软件的核心，CPU是执行的核心
        前者给后者发指令我要干什么，CPU把他的指令变成现实
        二者必须很好的匹配计算机才能很好的工作
    Linux内核中与文件Cache操作相关的API有很多，按其使用方式可以分成两类：一类是以拷贝方式操作的相关接口， 如read/write/sendfile等，其中sendfile在2.6系列的内核中已经不再支持；另一类是以地址映射方式操作的相关接口，如mmap等。
        第一种类型的API在不同文件的Cache之间或者Cache与应用程序所提供的用户空间buffer之间拷贝数据，其实现原理如图7所示。
        第二种类型的API将Cache项映射到用户空间，使得应用程序可以像使用内存指针一样访问文件，Memory map访问Cache的方式在内核中是采用请求页面机制实现的，首先，应用程序调用mmap()，陷入到内核中后调用do_mmap_pgoff。该函数从应用程序的地址空间中分配一段区域作为映射的内存地址，并使用一个VMA（vm_area_struct）结构代表该区域，之后就返回到应用程。当应用程序访问mmap所返回的地址指针时（图中4），由于虚实映射尚未建立，会触发缺页中断。之后系统会调用缺页中断处理函数，在缺页中断处理函数中，内核通过相应区域的VMA结构判断出该区域属于文件映射，于是调用具体文件系统的接口读入相应的Page Cache项，并填写相应的虚实映射表。经过这些步骤之后，应用程序就可以正常访问相应的内存区域了。

mumap()

//接触文件或设备对内存的映射，成功返回0,失败返回-1设errno
int munmap(void *addr, size_t length);

shm_unlink()

//关闭进程打开的共享内存对象，成功返回0,失败返回-1
//Link with -lrt.
int shm_unlink(const char *name);

}

signal(实时信号和标准信号){
如下区别：
    实时信号没有明确的含义，而是由使用者自己来决定如何使用。而标准信号则一般有确定的用途及含义，
并且每种信号都有各自的缺省动作。如按键盘的CTRL+C时，会产生SIGINT信号，进程对该信号的默认反应就是进程终止。
    一个进程可以接受多个同样的实时信号，这些实时信号会被缓存在一个队列中，然后按次序被处理。而标准信号则不能。
在标准信号没有得到处理的时候，多个标准信号会被合为一个。这也造成了标准信号可能丢失的情况。
    实时信号使用sigqueue发送的时候，可以携带附加的数据(int或者pointer)。标准信号不能。
    实时信号具有优先级的概念，数值越低的实时信号其优先级越高。在处理的时候，也是数值低的实时信号优先得到处理。
    实时信号的默认行为都一样，都是结束当前的进程，这个和标准信号是不一样的。
    进程每次处理标准信号后，就将对信号的响应设置为默认动作。在某些情况下，将导致对信号的错误处理。因此，
用户如果不希望这样的操作，那么就要在信号处理函数结尾再一次调用signal()，重新安装该信号    
}
signal(整体){
信号就是软件中断
信号可以终止一个正常程序的执行, 通常被用于处理意外情况
信号是异步的，一个进程不必通过任何操作来等待信号的到达，事实上，进程也不知道信号到底什么时候到达。
不存在编号为0的信号
    Sinno是信号值，当为0时，实际不发送任何信号，但照常进行错误检查，因此，可用于检查目标进程是否存在，
以及当前进程是否具有向目标发送信号的权限
  # root权限的进程可以向任何进程发送信号，非root权限的进程只能向属于同一个session或者同一个用户的进程发送信号
可靠性方面：可靠信号与不可靠信号；
与时间的关系上：实时信号与非实时信号。

一个信号的"生命周期"为：产生(generation)、未决(pending)、递送(delivery)
产生：事件可以是硬件异常(除以0)、软件条件(如：alarm计时器超时)、终端产生的信号或kill函数产生的
1. 信号特性：终止；忽略；内核转存；停止；继续； sigaction(2)或signal(2)可以修改信号处理方式
             终止类型信号；非终止类型信号；posix外扩展信号
   多线程中，所有线程具有相同的信号特性。每个线程具有自己独立的信号掩码pthread_sigmask
   信号可以发送给进程本身kill，也可以发送给进程中某个线程pthread_kill。进程将信号投递给线程掩码没被阻塞的线程体执行。
   线程通过sigpending获得处于挂起的信号，信号可能是通过kill发送，也可能是通过pthread_kill发送的。
   fork子进程继承父进程的信号特征，execve重置父进程的信号特征
   fork子进程继承父进程的信号掩码，execve保留子进程的信号掩码
   fork子进程初始化新的信号pending，execve保留子进程的信号pending
2. 信号处理方式：1.忽略；    2.捕捉；                3.执行系统默认动作(大多数是终止该进程)
                 1. SIG_IGN  2.信号捕捉函数的函数名  3.SIG_DFL   4.SIG_ERR
                 (SIGKILL和SIGSTOP)
                 进程执行在一个栈中，信号处理在另一个栈中：见sigaltstack(2)
3.不可靠信号
  信号可能会丢失：信号会丢失；不排队，多次发送同一个信号只收到一次
  对信号控制能力差：无法阻塞信号
  进程每次接收到信号对其进行处理时，随即将该信号的动作重置为默认值
  不能关闭信号
    在某些情况下，将导致对信号的错误处理；因此，用户如果不希望这样的操作，
  那么就要在信号处理函数结尾再一次调用signal()，重新安装该信号。
    Linux支持不可靠信号，但是对不可靠信号机制做了改进：在调用完信号处理函数后，不必重新调用该信号的安装函数
  因此，Linux下的不可靠信号问题主要指的是信号可能丢失。
  
  注：不要有这样的误解：由sigqueue()发送、sigaction安装的信号就是可靠的。事实上，可靠信号是指后来添加的新信号
  (信号值位于SIGRTMIN及SIGRTMAX之间)；不可靠信号是信号值小于SIGRTMIN的信号。信号的可靠与不可靠只与信号值有关，
  与信号的发送及安装函数无关。
  
4. 中断的系统调用: 低速系统调用和其他系统调用 EINTR
5.可重入函数
  不可重入函数包括：(1)使用静态数据结构，(2)调用malloc或free，(3)标准I/O函数。
  信号处理程序中调用一个不可重入的函数，则结果是不可预测的。
6. 子进程在开始时复制了父进程的内存映像，所以子进程继承父进程的信号处理方式
7. 自动重启动
  信号处理函数被触发是进程被阻塞在库函数或者系统调用的时候：
  1. 该系统调用在信号处理结束后，进行自动重启动
  2. 该系统调用返回错误信号EINTR
  为使应用程序不必处理被中断的系统调用，BSD引进了某些被中断系统调用的自动重启动。
  自动重启动的系统调用有：ioctl、read、readv、write、writev、wait、waitpid
  自动重启动可能会引起问题，所以允许禁用此功能。
  linux下默认是不自动重启动的
  SA_INTERRUPT:中断的系统调用不自动重启动；SA_RESTART：中断的系统调用自动重启动；
8. 给整个系统发送信号kill
   给某个进程组发送信号kill killpg
   给某个进程发送信号kill 
   给进程自身发送信号raise
   给指定线程发送信号pthread_kill tgkill
    $kill -9 3390 #向PID为3390的进程发送编号为9的信号=>一个两个进程间通信的方式之一
    一共62个,不是64个, 历史原因, 没有32,33
    1~31之间的信号叫做不可靠信号, 不支持排队, 信号可能会丢失, 也叫做非实时信号
    34~64之间的信号叫做可靠信号, 支持排队, 信号不会丢失, 也叫做实时信号
    
signal.h: /usr/include/bits/signum.h
绝大多数信号的默认处理方式都是终止进程, 另外两种默认处理方式: 忽略处理, 自定义处理
1) SIGHUP       连接挂断                                终止(默认处理)
2) SIGINT       终端中断,Ctrl+c产生该信号               终止(terminate)
3) SIGQUIT      终端退出,Ctrl+\                         终止+转储
4) SIGILL       *进程试图执行非法指令                   终止+转储  信号不能被捕获 信号不能被忽略
5) SIGTRAP      进入断点                                终止+转储
6) SIGABRT      *进程异常终止,abort()产生               终止+转储
7) SIGBUS       硬件或对齐错误                          终止+转储
8) SIGFPE       *浮点运算异常                           终止+转储
9) SIGKILL      不可以被捕获或忽略的终止信号            终止       信号不能被捕获 信号不能被忽略
10) SIGUSR1     用户定义信号1                           终止
11) SIGSEGV     *无效的内存段访问=>Segmentation error   终止+转储
12) SIGUSR2     用户定义信号2                           终止
13) SIGPIPE     向读端已关闭的管道写入                  终止
14) SIGALRM     真实定时器到期,alarm()产生              终止
15) SIGTERM     可以被捕获或忽略的终止信号              终止
16) SIGSTKFLT   协处理器栈错误                          终止
17) SIGCHLD     子进程已经停止, 对于管理子进程很有用    忽略  缺省动作是忽略这个信号
18) SIGCONT     继续执行暂停进程(用户一般不用)          忽略
19) SIGSTOP     不能被捕获或忽略的停止信号              停止(stop)  信号不能被捕获 信号不能被忽略
20) SIGTSTP     终端挂起,用户产生停止符(Ctrl+Z)         停止
21) SIGTTIN     后台进程读控制终端                      停止
22) SIGTTOU     后台进程写控制终端                      停止
23) SIGURG      紧急I/O未处理                           忽略
24) SIGXCPU     进程资源超限                            终止+转储
25) SIGXFSZ     文件资源超限                            终止+转储
26) SIGVTALRM   虚拟定时器到期                          终止
27) SIGPROF     实用定时器到期                          终止
28) SIGWINCH    控制终端窗口大小改变                    忽略
29) SIGIO       异步I/O事件                             终止
30) SIGPWR      断电                                    终止
31) SIGSYS      进程试图执行无效系统调用                终止+转储

*系统对信号响应应视具体情况而定
发送信号的主要方式:

    键盘 //只能发送部分特殊的信号 eg:Ctrl+C可以发送SIGINT
    程序出错 //只能发送部分特殊的信号 eg: 出现段错误, 可以发送SIGSEGV
    $kill -Signal PID #能发所有信号
    系统函数kill()/raise()/alarm()/sigqueue()
}
signal(moosefs){
main.c # '\001'     '\002'        '\003'      '\004'      '\005'      '\006'
       # termhandle reloadhandle  chldhandle  infohandle  alarmhandle  main_exit
       # SIGTERM    SIGHUP        SIGCHLD     SIGINFO     SIGALRM
       #                          SIGCLD      SIGUSR1     SIGVTALRM
       #                                                  SIGPROF
# SIGINT                                            后台运行忽略
# SIGQUIT SIGPIPE  SIGTSTP SIGTTIN SIGTTOU SIGUSR2  程序运行忽略

init.c # SIGHUP  重新加载配置
       # SIGQUIT restart受管理进程
       # SIGUSR1 halt
       # SIGUSR2 poweroff
       # SIGTERM reboot
       # SIGINT  ctrlaltdel
       # SIGCONT 记录信号
       # SIGSTOP SIGTSTP stop
}
signal(自动重启动){
什么是系统调用的自动重启动？
　　当系统调用被信号中断时，并不返回，而是继续执行。如果read()阻塞等待，当进程接受到信号时，并不将read返回，而是继续阻塞等待。
为什么要引入自动重启动的？
　　有时用户并不知道所使用的输入、输出设备是否是低速设备。如果编写的程序可以用交互方式运行，则他可能读、写低速终端设备。
　　如果在程序中捕捉到信号，而系统调用并不提供重启动功能，则对每次读、写系统调用都要进行是否出错返回的测试，如果是被信号中断，则再调用读、写系统调用。
什么时候引入系统调用的自动重启动？
　　4.2BSD支持某些被中断系统调用的自动重启动。
　　4.3BSD允许进程基于每个信号禁用自动重启动功能(因为也存在某些应用程序并不希望系统调用被中断后自动重启)

默认自动重启动的系统调用包括：ioctl(),read(),readv(),write(),writev(),wait(),waitpid();其中前5个函数只有在对低速设备进行操作时才会被信号中断。而wait和waitpid在捕捉到信号时总是被中断。

    定时器计数到5秒后，会发送alarm信号，从打印可以看出确实接收到了alarm信号，且read()并没有返回而是继续
阻塞接受标准输入；然后在手动发送一个SIGUSR1信号，同样，read()并没有被中断，当输入jfdk后，read能正常读出。
说明signal()默认是将信号设置为自动重启动。
}

1. 这两种定义信号方式相同：
memset(sa, 0, sizeof(struct sigaction));
sa->sa_handler = halt_poweroff_reboot_handler;
sigaction(signal, sa, 0)

signal(SIGUSR1, halt_poweroff_reboot_handler)

signal(信号注册){
经过sigaction安装的信号都能传递信息给信号处理函数，而经过signal安装的信号却不能向信号处理函数传递信息。

typedef void (*sighandler_t)(int); # 信号处理函数被执行过程中，当前信号处于被阻塞状态
sighandler_t signal(int signum, sighandler_t handler);
成功：返回以前的信号配置；出错，返回SIG_ERR
第二个参数：SIG_IGN、SIG_DFL、或信号捕捉函数的函数名。
对signal来说，不改变信号处理方式就不能确定信号的当前处理方式，sigaction可对此作出改善
  子进程在开始时复制了父进程的内存映像，所以子进程继承父进程的信号处理方式
  进程每次接收到信号对其进行处理时，随即将该信号的动作重置为默认值

检查或修改（或检查并修改）与指定信号相关联的处理动作，取代早期的signal函数
int sigaction(int signo, const struct sigaction *restrict act, struct sigaction *restrict oact);
struct sigaction
{
    void (*sa_handler)(int); # 信号处理函数 SIG_DFL | SIG_IGN | handler
    sigset_t sa_mask;
    int sa_flags;            
    void (*sa_sigaction)(int, siginfo_t *, void *); # 有些系统 sa_handler 和 sa_sigaction为同一个地址
    
    # SA_SIGINFO-> sa_sigaction:  则siginfo_t * 有效； void* ucontext_t 有效见getcontext
    # SA_NODEFER-> sa_mask :      信号处理过程中被阻塞的信号集
    # SA_NOCLDSTOP->SIGCHLD： 子进程停止时不接收SIGSTOP, SIGTSTP, SIGTTIN or SIGTTOU SIGCONT 信号
    # SA_NOCLDWAIT->SIGCHLD： 子进程接收不不进入僵死状态
      # SIG_IGN            ： 子进程接收不不进入僵死状态
};
sa_handler:信号捕捉函数的地址；
sa_mask:   调用信号捕捉函数前，该信号集被加到信号屏蔽字中，从而在调用信号捕捉函数时，能阻塞某些信号。
sa_flags:  SA_INTERRUPT:中断的系统调用不自动重启动；
           SA_RESTART：中断的系统调用自动重启动；
           在信号处理程序被调用时，操作系统建立的新信号屏蔽字包括正被递送的信号，也就是说自己也被阻塞，除非设置了SA_NODEFER。
sa_sigaction:替代的信号处理程序，一次只能使用sa_handler和sa_sigaction中的一个。
说明：同一信号多次发生，并不将它们加入队列；
如：某种信号阻塞时发生了5次，解除阻塞后，信号处理函数只调用一次。

http://www.cnblogs.com/black-mamba/p/6876320.html
1. 这个复位动作是sigaction函数内部处理，还是由调用者自己处理呢？
　　由sigaction函数自动复位，不用我自己再去处理。
2. 设置sa_mask的目的？
　　在调用信号处理程序时就能阻塞某些信号。注意仅仅是在信号处理程序正在执行时才能阻塞某些信号，如果信号处理程序执行完了，那么依然能接收到这些信号。
在信号处理程序被调用时，操作系统建立的新信号屏蔽字包括正被递送的信号，也就是说自己也被阻塞，除非设置了SA_NODEFER。
# sa_mask 和 SA_NODEFER
对于不同信号，当信号A被捕捉到并信号A的handler正被调用时，信号B产生了，
3.1如果信号B没有被设置阻塞，那么正常接收信号B并调用自己的信号处理程序。另外，如果信号A的信号处理程序中有sleep函数，那么当进程接收到信号B并处理完后，sleep函数立即返回(如果睡眠时间足够长的话)
3.2如果信号B有被设置成阻塞，那么信号B被阻塞，直到信号A的信号处理程序结束，信号B才被接收并执行信号B的信号处理程序。

　　如果在信号A的信号处理程序正在执行时，信号B连续发生了多次，那么当信号B的阻塞解除后，信号B的信号处理程序只执行一次。
　　如果信号A的信号处理程序没有执行或已经执行完，信号B不会被阻塞，正常接收并执行信号B的信号处理程序。
对于相同信号，当一个信号A被捕捉到并信号A的handler正被调用时，
4.1 又产生了一个信号A，第二次产生的信号被阻塞，直到第一次产生的信号A处理完后才被递送；
4.2 如果连续产生了多次信号，当信号解除阻塞后，信号处理函数只执行一次。
}

signal(siginfo_t){
int      si_signo;  /* 信号值，对所有信号有意义*/
int      si_errno;  /* errno值，对所有信号有意义*/
int      si_code;   /* 信号产生的原因，对所有信号有意义*/
pid_t    si_pid;    /* 发送信号的进程ID,对kill(2),实时信号以及SIGCHLD有意义 */
uid_t    si_uid;    /* 发送信号进程的真实用户ID，对kill(2),实时信号以及SIGCHLD有意义 */
int      si_status; /* 退出状态，对SIGCHLD有意义*/
clock_t  si_utime;  /* 用户消耗的时间，对SIGCHLD有意义 */
clock_t  si_stime;  /* 内核消耗的时间，对SIGCHLD有意义 */
sigval_t si_value;  /* 信号值，对所有实时有意义，是一个联合数据结构，
                          /*可以为一个整数（由si_int标示，也可以为一个指针，由si_ptr标示）*/
     
void *   si_addr;   /* 触发fault的内存地址，对SIGILL,SIGFPE,SIGSEGV,SIGBUS 信号有意义*/
int      si_band;   /* 对SIGPOLL信号有意义 */
int      si_fd;     /* 对SIGPOLL信号有意义 */
}
signal(信号发送){
kill向进程或进程组发送信号，raise向自身发送信号
#include <signal.h>
int kill(pid_t pid, int signo)
int raise(int signo)
返回值：成功，返回0；出错，返回-1
raise(signo)<=>kill(getpid(), signo)
kill的pid:
  pid>0:进程ID为pid的进程
  pid<0:进程组ID为 -pid的所有进程
  pid=0:同一个进程组的进程
  pid=-1:除发送进程自身外，所有进程ID大于1的进程
  
unsigned int alarm(unsigned int seconds); 设置一个信号发送定时器
alarm在seconds秒之后发送一个SIGALRM信号给调用alarm的进程。seconds=0则关闭定时器。
返回值：如果调用alarm()前，进程中已经设置了闹钟时间，则返回上一个闹钟时间的剩余时间，否则返回0。
若seconds=0，则取消以前设置的闹钟时间，余留秒数仍作为返回值

int sigqueue(pid_t pid, int sig, const union sigval value); # 主要是针对实时信号提出的,支持信号带有参数，与函数sigaction()配合使用。
该函数与sigaction一个版本，sigaction是对signal的改进，sigqueue是对kill函数的改进。当sigval等于0的时候，两个函数一样。
# sigqueue()只能向一个进程发送信号，而不能发送信号给一个进程组。

void abort(void);
    向进程发送SIGABORT信号，默认情况下进程会异常退出，当然可定义自己的信号处理函数。
即使SIGABORT被进程设置为阻塞信号，调用abort()后，SIGABORT仍然能被进程接收。该函数无返回值。

int pause(void); 使调用进程挂起，直到捕捉到一个信号
返回值：-1，errno设置为EINTR
    pause函数使调用进程挂起直到捕捉到一个信号，只有执行了一个信号处理程序并从其返回时，pause才返回。
在这种情况下，pause返回-1，并将errno设置为EINTR。
}

signal(alarm|setitimer){
sleep: 使调用线程sleep指定描述，除非一个不能忽略|阻塞的信号到来
0：sleep结束， 非0:被信号中断，剩余时间

sleep(n)函数可将进程挂起n秒，而其在实现上主要依靠alarm系统调用，sleep的工作原理有3部分组成：
1、为SIGALRM设置一个处理函数； —->SIGALRM为alarm计时n秒后发出的信号
2、调用alarm(n);               —->设定一个计时器
3、调用pause                   —->进程一直阻塞在pause，而pause函数只有在收到信号时才返回

在进程中alarm设置计时器到n秒后激发信号。当设定的时间过去之后，内核发送SIGALRM到进程。
如果在调用alarm时计时器已经被设置，则alarm返回剩余秒数。
如果调用alarm(0)意味着关掉闹钟。

ITIMER_REAL：   设定绝对时间；经过指定的时间后，内核将发送SIGALRM信号给本进程；
ITIMER_VIRTUAL  设定程序执行时间；经过指定的时间后，内核将发送SIGVTALRM信号给本进程；
ITIMER_PROF     设定进程执行以及内核因本进程而消耗的时间和，经过指定的时间后，内核将发送SIGALRM信号给本进程；

setitimer：毫秒，间隔；ITIMER_REAL, ITIMER_VIRTUAL, ITIMER_PROF三种类型
alarm    ：秒，  
result = setitimer(int which, const struct itimerval *newval, struct itimerval *oldval)
其中which代表计时器的编码。计算机中有三种计时器(ITIMER_REAL, ITIMER_VIRTUAL, ITIMER_PROF)。
其中后两种与cpu的用户态和内核态有关，暂不考虑。ITIMER_REAL则是真实时间。
newval是函数特有的struct itimeval，it_value储存初始间隔，it_interval储存重复间隔，定义如下：

struct itimerval {
    struct timeval it_interval;
    struct timeval it_value;
};
struct timeval {
    time_t tv_sec;
    suseconds_t tv_usec;
};

其中的new_value参数用来对计时器进行设置，it_interval为计时间隔，it_value为延时时长，

settimer工作机制是，先对it_value倒计时，当it_value为零时触发信号，然后重置为it_interval，继续对it_value倒计时，一直这样循环下去
假如it_value为0是不会触发信号的，所以要能触发信号，it_value得大于0；如果it_interval为零，只会延时，不会定时（也就是说只会触发一次信号)。
}

signal(pause){
pause函数挂起进程直到收到信号，
  如果接收到的信号是将这个进程中止，则进程中止，pause无法返回。
  如果信号处理是忽略，则进程继续挂起，而pause不返回。
  如果信号处理是捕捉，则在调用信号处理函数之后返回-1。
永远都是无法正常返回的，因为pause的目的是无限挂起。
}

signal(信号集){
信号集是一个能表示多个信号的数据类型，用sigset_t定义一个信号集
int sigemptyset(sigset_t *set);  # 初始化，清除所有信号
int sigfillset(sigset_t *set);   # 初始化，包括所有信号
int sigaddset(sigset_t *set, int signo);
int sigdelset(sigset_t *set, int signo);
成功，返回0；出错，返回-1
int sigismember(sigset_t *set, int signo);
若真，返回1；若假，返回0
所有应用程序在使用信号集之前，要对该信号集调用sigemptyset或sigfillset一次
}

signal(信号的阻塞和未决){
pending: signal sigaction   # 处理pending状态  sigpending 获取pending状态
同步处理： sigwait sigwaitinfo sigtimedwait signalfd # 异步使用信号栈，同步不使用信号栈
block  : sigprocmask pthread_sigmask  # 对阻塞信号集的管理
send   : raise kill alarm setitimer killpg(kill) tkill gtkill(tkill) pthread_kill sigqueue abort # 信号发送
misc   : pause sleep sigsetjmp siglongjmp sigsuspend
sigset : sigemptyset sigfillset sigaddset sigdelset sigismember
pthread: pthread_kill pthread_sigmask pthread_sigqueue
sigaction:
  sa_handler:信号捕捉函数的地址；
  sa_mask:   调用信号捕捉函数前，该信号集被加到信号屏蔽字中，从而在调用信号捕捉函数时，能阻塞某些信号。
  sa_flags:  SA_INTERRUPT:中断的系统调用不自动重启动；
             SA_RESTART：中断的系统调用自动重启动；
             在信号处理程序被调用时，操作系统建立的新信号屏蔽字包括正被递送的信号，也就是说自己也被阻塞，除非设置了SA_NODEFER。
  sa_sigaction:替代的信号处理程序，一次只能使用sa_handler和sa_sigaction中的一个。
  说明：同一信号多次发生，并不将它们加入队列；
  如：某种信号阻塞时发生了5次，解除阻塞后，信号处理函数只调用一次。
----------------------------------------------------------------------------
实际执行信号的处理动作称为信号递达(Delivery)，信号从产生到递达之间的状态，称为信号未决(Pending)。
进程可以选择阻塞(Block)某个信号，SIGKILL 和 SIGSTOP 不能被阻塞。
被阻塞的信号产生时将保持在未决状态，直到进程解除对此信号的阻塞，才执行递达的动作。

注意，阻塞和忽略是不同的，只要信号被阻塞就不会递达，而忽略是在递达之后可选的一种处理动作。
        block  pending  handler
SIGHUP    0       0     SIG_DFL
SIGINT    1       1     SIG_IGN
SIGQUIT   1       0      handler
1. SIGHUP信号未阻塞也未产生过，当它递达时执行默认处理动作。
2. SIGINT信号产生过，但正在被阻塞，所以暂时不能递达。虽然它的处理动作是忽略，但在没有解除阻塞之前不能忽略这个信号，因为进程仍有机会改变处理动作之后再解除阻塞。
3. SIGQUIT信号未产生过，一旦产生SIGQUIT信号将被阻塞，它的处理动作是用户自定义函数sighandler。
未决和阻塞标志可以用相同的数据类型sigset_t来存储，sigset_t称为信号集，这个类型可以表示每个信号的"有效"
或"无效"状态，在阻塞信号集中"有效"和"无效"的含义是该信号是否被阻塞，而在未决信号集中"有效"和"无效"
的含义是该信号是否处于未决状态。阻塞信号集也叫做当前进程的信号屏蔽字(Signal Mask)，这里的"屏蔽"应该
理解为阻塞而不是忽略。

int sigprocmask(int how, sigset_t *restrict set, sigset_t *restrict oset); # 获取和改变阻塞信号集
how：
  SIG_BLOCK：set包含我们希望加到当前信号屏蔽字的信号，相当于mask=mask|set
  SIG_UNBLOCK:set包含我们希望从当前信号屏蔽字删除的信号，相当于mask=mask&~set
  SIG_SETMASK:设置当前信号屏蔽字为set，相当于mask=set
oset为非空指针，则当前信号屏蔽字通过oset返回；
set 为空指针，阻塞信号集不变化，如果oset为非空，则当前信号屏蔽字通过oset返回。
成功，返回0；出错，返回-1(EINVAL)

int sigpending(sigset_t *set) # 取出处于未决状态的信号集
成功，返回0；出错，返回-1(EFAULT)
fork函数会为子进程初始化一个空的未决状态的信号集

int sigsuspend(const sigset_t *sigmask);  # sigmask信号集以外的信号触发，并且信号处理函数被执行
      若信号发生且对应的handler已执行，则sigsuspend返回-1，并设置相应的errno(EINTR)，进程的信号掩码恢复sigsuspend设置前状态
      若信号终止了程序运行，则sigsuspend被阻塞，不退出。
      注意：sigsuspend总是返回-1； SIGKILL和SIGSTOP被设置在掩码中秒，不影响进程对这两个信号的捕获。
            sigsuspend调用改变进程的信号掩码状态，阻塞mask中的信号，调用返回时将掩码改为调用前的状态
解决竞争条件: sigprocmask(设置) -> pause(sigsuspend)阻塞 -> sigprocmask(恢复)

sigsuspend捕捉到一个信号并从信号处理程序返回时，sigsuspend返回。
所以中断键引起sig_int被调用，sig_int返回时，sigsuspend返回，并将信号屏蔽字设置为之前的信号屏蔽字（SIGINT）

int sigwaitinfo(const sigset_t *set, siginfo_t *info);  # set信号集内的信号触发，并且信号处理函数未执行
# sigwaitinfo返回值为终止阻塞信号值
如果已经有信号处于pending状态，那么sigwaitinfo会携带siginf_t信号信息立即返回。
与sigwait相比：sigwait返回一个信号值，sigwaitinfo返回信号描述符
               sigwait和sigwaitinfo两个函数返回值不同
  sigwait返回值0，正常，sig信号参数有效； sigwait返回负值，异常，sig信号参数无效；
  sigwait是通过sigwaitinfo函数实现的；负值说明不是指定信号集内的信号中断的；
  sigwaitinfo返回值正值，正常，info信号参数有效；sigwaitinfo返回值-1，异常，info信号参数无效；
  sigwaitinfo的errno=EINTR，说明不是指定信号集内的信号中断的；
# sigtimedwait 在sigwaitinfo基础上增加了超时机制
sigtimedwait()比sigwaitinfo增加了一个超时参数；>1 信号值 =-1 (EAGAIN:超时|EINTR:其他信号中断|EINVAL:错误参数)

sigset_t newmask;
int rcvd_sig; 
siginfo_t info;
sigemptyset(&newmask);
sigaddset(&newmask, SIGRTMIN);
sigprocmask(SIG_BLOCK, &newmask, NULL);
rcvd_sig = sigwaitinfo(&newmask, &info) 
if (rcvd_sig == -1) {
    ..
}


    使用sigwait可以简化信号处理，允许把异步产生的信号用同步的方式处理。为了防止信号中断线程，
可以把信号添加到每个线程的信号屏蔽字中，然后安排专有线程作信号处理。

int signalfd(int fd, const sigset_t *mask, int flags); # 创建一个文件描述符用来接收信号触发
fd  : -1 创建一个新的文件描述符；!= -1 则为signalfd创建的文件描述符，mask替代已设置的mask
mask：指定要接收的信号
flags:  SFD_NONBLOCK|SFD_CLOEXEC
read:signalfd_siginfo对象；
fork，execve都继承此文件描述符
使用signalfd的时候，需要使用sigprocmask阻塞信号集，阻止信号执行默认或阻塞的信号处理函数
}

signal(sigsetjmp|siglongjmp){
函数sigsetjmp和siglongjmp。当从信号处理函数跳出时，应该使用siglongjmp函数。
    int sigsetjmp( sigjmp_buf * env, int savemask );
参数： env：     当前堆栈信息 
       savemask：信号掩码，即此信号从信号处理函数屏蔽中恢复
返回值： 0 ：堆栈保存成功(标签定义成功)
       非0 ： siglongjmp跳转成功(goto 跳转成功)
    void siglongjmp ( sigjmp_buf * env, int val );
参数： env：     sigsetjmp保存的堆栈信息 
       val:      sigsetjmp调用返回值(标签的位置)
    当调用sigsetjmp时， 参数savemask指示是否将当前进程的信号掩码存储在env中；
    在调用siglongjmp时，若env中有之前存储的信号掩码，则恢复进程的信号掩码。
    
jmp_buf jmpbuffer;
void fun(int i){
    siglongjmp(jmpbuffer, 1);
    return;
}
int main(int argc, char** argv) {
    signal(SIGUSR2, fun );
    if( sigsetjmp(jmpbuffer, SIGUSR1) == 1){
        printf("==000====\n");
    }

    struct sigaction act, oact;
    act.sa_handler=fun;
    sigemptyset(&act. sa_mask);
    act. sa_flags = 0;
    sigaction(SIGUSR2, &act, &oact);
    printf("==111====\n");
    sleep(5000);
    return 0;
}

附加说明：setjmp()和sigsetjmp()会令程序不易令人理解，请尽量不要使用
}

signal(setjmp){
1. 使用setjmp的时候，同一个信号只能触发一次

  基于setjmp和longjmp的运行控制方式是Linux平台上C语言处理异常的标准方案，已被广泛运用到由C语言开发的软件系统和
链接库中，例如jpg解析库，加密解密库等等。setjmp和longjmp是以C语言标准库函数的形式提供的，setjmp函数能够保存程序
当前的执行环境，即程序的状态，该被保存的程序状态可以在随后程序执行的某一点被longjmp函数恢复，程序的控制流也将
跳转到调用setjmp时的执行点，实现非本地局部跳转的机制。
问题描述：
  在编写基于异常的代码混淆程序时，signal注册的异常信号处理程序只能执行一次，第二次发生异常时异常处理函数没有被调用。
分析：
1. 搞清楚Linux的信号处理流程：
  [1] 收到信号，例如SIGFPE
  [2] 进入signal注册的信号处理函数，此时，SIGFPE自动被加入到进程信号屏蔽字
  [3] 执行信号处理函数
  [4] 信号处理结束，恢复信号屏蔽字，SIGFPE被取消阻塞
  [5] 返回到产生信号地方继续执行
2. 分析异常处理函数没有被调用的原因：
    异常信号处理函数在结束前没有取消对SIGFPE信号的阻塞，直接调用longjmp()进行控制流转移。所以在后面的执行过程中再次遇到SIGFPE信号，系统会自动根据 信号屏蔽字进行屏蔽，异常处理函数也就无法被调用。
3. 该问题的解决办法：
    使用sigsetjmp和siglongjmp函数替换setjmp和longjmp函数。siglongjmp功能与longjmp类似，不同的是siglongjmp会自动恢复进程的信号屏蔽字，因此相同的异常信号再次发生时就不会被系统屏蔽了。
# https://blog.csdn.net/ZX714311728/article/details/53056927 
  setjmp和longjmp函数用于非局部跳转，在信号处理程序中经常调用longjmp函数以返回到程序的主循环中，而不是从该处理
程序返回。但是调用longjmp有一个问题，当捕捉到一个信号时，进入进行处理函数，此时当前信号被自动加到进程的信号
屏蔽字中。这阻止了后来产生的这种信号中断该信号处理程序。如果用longjmp跳出信号处理程序，那么对此进程的信号屏蔽
字会发生什么呢？
    int setjmp(jmp_buf jb);           # setjmp用于保存当前AR到jb变量中；
    void longjmp(jmp_buf jb, int r);  # longjmp用于设置当前AR为jb，并跳转到调用setjmp()；之后的第一个语句处。
其结果就相当于回到了setjmp()刚执行完毕，只是偷偷的修改了setjmp的返回值。
setjmp()第一次调用时总是返回0，而通过longjmp(jb,r)跳转后其返回值总是被修改为r，并且r不能为0。
这样程序中就很容易根据setjmp()的返回值来判断是否是longjmp()导致了跳转才执行到此。

    throw要负责两件事情：(1)完成跳转；(2)恢复堆栈AR；
    try则负责保存当前AR

jmp_buf jb;
void a();
void b();
void c();

int main(){
    if(setjmp(jb)==0){   // label jb
        a();
    }
    printf("after a(); \n");
    return 0;
}
void a(){
    b();
    printf("a() is called\n");
}
void b(){
    c();
    printf("b() is called\n");
}
void c(){
    printf("c() is called\n");
    longjmp(jb, 1);    // goto jb
}

# ./setimp
c() is called
after a(); 
}

process(fork vfork wait waitpid exec exit _exit){
fork、vfork、wait、waitpid、exec、exit，
此外还介绍了：孤儿进程、僵尸进程、设置进程相关ID、system函数、进程会计、用户标识、进程调度、进程时间

进程标识: 进程ID：非负、唯一、可复用

#include <sys/types.h> 
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
getpid()/getuid()/getgid()                  # 获得PID/UID/GID
getppid(void)/geteuid(void)/getegid(void)   # 父进程ID/有效用户ID/有效组ID
fork()/vfork()                              # 创建子进程
# 子进程在父进程的地址空间中运行；vfork保证子进程先运行，在它调用exec或_exit()之后父进程才可能被调度运行.
exec() family                               # 替代子进程
atexit()/on_exit()/exit()/_exit()/_Exit()   # 退出子进程
子进程的结束和父进程的运行是一个异步过程,即父进程永远无法预测子进程到底什么时候结束。
system的实现中调用了fork、exec、waitpid

wait()
waitpid()                            
waitid 提供了更多有用的语义功能。特别地，从结构体siginfo_t获取的信息可能是很有用的。
P_PID 等待pid值是id的子进程
P_GID 等待进程组ID是id的那些子进程
P_ALL 等待所有子进程，参数id被忽略

wait3(status, options, NULL)      ===   waitpid(-1, status, option)  等待着任意一个子进程改变状态
wait4(pid, status, options, NULL) ===   waitpid(pid, status, options)等待由pid所指定的子进程改变状态

getpid()、getppid()

//getpid() 返回调用进程的PID
//getppid() 返回调用进程的父进程的PID
pid_t getpid(void);         //pid_t是int
pid_t getppid(void); 

getuid()、geteuid()

getuid()返回调用进程的UID
geteuid()返回调用进程的effective UID
uid_t getuid(void);         //uid_t是unsigned int
uid_t geteuid(void); 

getgid()，getegid()

//getgid()返回调用进程的real GID
//getegid()返回调用进程的effective GID
id_t getgid(void);      //gid_t是unsigned int
gid_t getegid(void);

fork() # 创建子进程，在父进程中返回子进程的PID，在子进程中返回0,失败在父进程中返回-1
pid_t fork(void); 

fork()一下干的几件事:
    给P2分配Text段, Data段, Heap段, Stack段的虚拟地址,都指向P1中相应的物理地址
    P2的Text段是铁定和P1共享同一个物理地址了, 剩下的Data,Heap,Stack待定
    如果one of them 改变了这三个段的内容, 就把原来的数据复制一份给P2, 这样P2就有了相应的新的物理地址

vfork(): 创建子进程，阻塞父进程；
  1. vfork与fork类似：返回值和错误码与fork函数相同
  2. vfork是clone函数的一种封装；vfork不拷贝父进程页表的情况下创建新的进程，主要和exec()搭配使用，用于对性能敏感的子进程创建过程；
  3. 创建一个空的子进程，父进程会等待子进程退出之后在继续执行,在子进程执行期间,父进程被挂起，
     此期间子进程和父进程共享所有的内存资源。子进程终止时不能从当前函数返回/调用exit函数, 可以调用_exit(), 
  4. 信号是继承不是共享的，发给父进程的信号待子进程执行结束之后再到达执行
}
process(fork execve){
    exec系列的系统调用是把当前程序替换成要执行的程序，而fork用来产生一个和当前进程一样的进程
(虽然通常执行不同的代码流)。通常运行另一个程序，而同时保留原程序运行的方法是，fork+exec。
signal              复位    SIGCHLD状态为SIG_IGN，会被子进程继承
浮点环境            复位
atexit              不保留
sigaltstack         不保留
mmap                不保留
shmat               如果挂载就分离
shm_open            内存映射卸载
mq_overview         创建就销毁
sem_overview        创建就销毁
timer_create        不保留
opendir             关闭
file descriptor     FD_CLOEXEC关闭； !FD_CLOEXEC保留；文件描述符属性保留； 自动close的lock释放；
set-user-ID or set-group-ID   file descriptors 0, 1, and 2关闭
mlock, mlockall     不保留
atexit on_exit      不保留
fenv                复位

 nice()| semop()|进程ID|父进程ID|进程组ID|会话ID|真实用户ID|真实组ID|附加组ID|alarm()|当前工作路径|根路径|
 umask()|ulimit()|sigprocmask()|sigpending()|times()|资源限制|控制终端|时间间隔定时器  # 予以继承
 
}
process(环境){
1. 存储器分配函数：
#include <stdlib.h>
void *malloc(size_t size);
void *calloc(size_t nmemb,size_t size);
void *realloc(void *ptr, size_t size); //更改以前分配区的长度

void free(void *ptr);
2. 环境变量操作函数如下
#include <stdlib.h>
char *getenv(const char *name); # 指向与name关联的value的指针
int putenv(char *string);  # 取形式为name=value的字符串，将其放到环境表中
int setenv(const char *name, const char *value, int overwrite); # 将name设置为value
int unsetenv(const char *name);     # 删除name的定义
int clearenv(void);     # 删除环境表中所有项
3. 全局跳转函数setjmp和longjmp
#include <setjmp.h>
int setjmp(jmp_buf env);   # 返回值为0为直接调用，从longjmp调用返回非0值
int sigsetjmp(sigjmp_buf env, int savesigs);
4. 进程资源限制函数：getrlimit和setrlimit，资源结果和函数原型如下：
struct rlimit {
    rlim_t rlim_cur; 
    rlim_t rlim_max;  
};

#include <sys/resource.h>
int getrlimit(int resource, struct rlimit *rlim);
int setrlimit(int resource, const struct rlimit *rlim);
}
process(exec PATH){
1. argc argv              传递参数       字符串格式
2. extern char **environ; 环境变量传参   字符串格式

用一个新的进程镜像替代当前的进程映像，失败返回-1设errno  # 执行程序
调用成功的时候 execve()不会返回, 调用失败时返回 -1, 并设置 errno 为相应的值.
extern char **environ;  # execle(), execvpe(), 
int execl(const char *pathname, const char *arg, ...); # file可以是pathname，也可以与PATH一同组成pathname
    ret = execl ("/bin/ls", "ls", "-1", (char *)0);
int execlp(const char *file, const char *arg, ...);
    ret = execlp ("ls", "ls", "-l", (char *)0);
int execle(const char *pathname, const char *arg, ..., char * const envp[]);
    char *env[] = { "HOME=/usr/home", "LOGNAME=home", (char *)0 };
    ret = execle ("/bin/ls", "ls", "-l", (char *)0, env);
int execv(const char *pathname, char *const argv[]);
    char *cmd[] = { "ls", "-l", (char *)0 };
    ret = execv ("/bin/ls", cmd);
int execvp(const char *file, char *const argv[]);
     char *cmd[] = { "ls", "-l", (char *)0 };
     ret = execvp ("ls", cmd);
int execve(const char *filename, char *const argv[], char *const envp[]);
    char *cmd[] = { "ls", "-l", (char *)0 };
    char *env[] = { "HOME=/usr/home", "LOGNAME=home", (char *)0 };
    ret = execve ("/bin/ls", cmd, env);
|----------|-----|-------|-------|--------|
|          | l   |   v   |   p   |   e    |
|----------|-----|-------|-------|--------|
|l: line   | l   |       |   lp  |   le   |
|v: vector |     |   v   |   vp  |   ve   |
|p: path   |     |       |       |        |
|e: env    |     |       |       |        |
|----------|-----|-------|-------|--------|
execl,execlp,和execle中, const char *arg 以及省略号代表的参数可被视为 arg0,  arg1,  ...,  argn.   
                        他们合起来描述了指向null结尾的字符串的指针列表, 即执行程序的参数列表. 
                        作为约定, 第一个arg参数应该指向执行程序名自身. 参数列表必须用NULL指针结束!
execv 和 execvp 函数提供指向 null 结尾的 字符串的指针数组作为新程序的参数列表.  
                作为约定, 指针数组中第一个元素应该指向执行程序名自身. 指针数组必须用NULL指针结束!

execve() 执行 filename 指出的程序. filename必须是二进制可执行文件, 或者以 "#! interpreter [arg]" 行开始的脚本文件.
       后者的interpreter必须是某个可执行文件的有效路径, 这个可执行文件自身不能是脚本程序, 调用形式是 "interpreter
       [arg] filename".
       父进程的未决信号被清除. 所有被调用进程设置过的信号重置为缺省行为.
       如果当前程序正在被 ptrace 跟踪, 成功的调用 execve()后将收到一个 SIGTRAP 信号
       在 #! 格式的 shell 可执行脚本 中, 第一行 的 长度 不得 超过 127 字节.
       Linux 忽略 脚本程序 的 SUID 和 SGID 位.
       
execlp()和execvp() 执行命令解释器

execl(<shell path>, arg0, file, arg1, ..., (char *)0);
1. <shell path> : sh
2. file         : 镜像文件
3. arg0, arg1   : argv[0], argv[1] 
errno:
EACCES       文件或脚本解释器 不正确.
EACCES       没有文件或脚本解释器的执行权限.
EACCES       文件系统 挂载(mount)为 noexec.
EPERM        文件系统 挂载为nosuid, 使用者 不是 超级用户, 以及文件设置了 SUID 或 SGID 位.
EPERM        进程正被跟踪, 使用者不是超级用户, 以及文件设置了 SUID 或 SGID 位.
E2BIG        参数列表过长.
ENOEXEC      可执行文件的文件格式无法识别, 误用在不同的体系结构, 或者其他格式错误导致程序无法执行.
EFAULT       filename 指针超出可访问的地址空间.
ENAMETOOLONG filename 太长.
ENOENT       filename , 脚本解释器, 或 ELF 解释器不存在.
ENOMEM       内核 空间 不足.
ENOTDIR      在 filename , 脚本解释器或ELF 解释器的 前缀 路径 中, 某些成员不是目录.
EACCES       在 filename或 脚本解释器的前缀路径中, 对 某些 目录 没有访问许可.
ELOOP        解析 filename, 脚本解释器 或 ELF 解释器时遇到过多的符号连接.
ETXTBUSY     可执行文件 被 一个 或 多个 进程 以 写方式 打开.
EIO          发生 I/O 错误.
ENFILE       达到 系统 定义的 同时打开文件数限制.
EMFILE       进程 打开了最大数量的文件.
EINVAL       该 ELF 可执行文件 拥有多个PT_INTERP字段 (就是说, 试图定义多个解释器).
EISDIR       ELF 解释器是目录.
ELIBBAD      无法 识别 ELF 解释器的格式.

7种进程终止
    正常终止:
        从 main() 返回
        调用 exit() / _exit() / _Exit()
        最后一个线程从其启动例程返回
        最后一个线程调用pthread_exit()
    异常终止:
        调用abort()
        接到一个信号并终止
        最后一个线程对取消请求作出响应
}
process(解析器文件){
解析器文件是一种文本文件，文件的第一行的形式：#! pathname  [optional-argument]；
其中pathname指的时解析器名称，optional-argument是传递给解析器的参数。其实我们大家最熟悉的解析器文件就是shell脚本文件，shell脚本文件第一行都是#! /bin/sh。
解析器文件是一种文本文件，而解析器是可执行的二进制文件。解析器是由解析器文件的第一行指定的。
int main(int argc, char *argv[])  
{  
    int i;  
    for(i = 0; i<argc ;i++)  
        printf("argv[%d]: %s\n", i,  argv[i]);  
    return 0;  
}  
以displayArgTab为解析器，写一个解析器文件，如下：
    解析器文件名为testInterpreter  
#! /tmp/displayArgTab  arg  

生成的解析器文件testInterpreter也放在/tmp/下。下面通过execl来调用解析器文件：
if(execl("/tmp/testInterpreter", "testInterpreter", "myarg1", "myarg2", (char*)NULL) < 0)  
{  
     printf("execl  error...\n");  
     return 0;  
}   
执行结果为：
argv[0]: /tmp/displayArgTab   -- 解析器名称
argv[1]: arg                  -- 解析器参数
argv[2]: /tmp/testInterpreter -- 解析器脚本名称
argv[3]: myarg1               -- 解析器脚本参数
argv[4]: myarg2               -- 解析器脚本参数
}
process(exit|_exit|_Exit|atexit){
    进程退出意味着进程生命期的结束，系统资源被回收，进程从操作系统环境中销毁。
1. 进程正常退出
退出状态exit status是我们传入到exit()，_exit(),_Exit()函数的参数。进程正常终止的情况下，内核将退出状态转变为终止状态以供
父进程使用wait()，waitpid()等函数获取。终止状态termination status除了上述正常终止进程的情况外，还包括异常终止的情况，如果
进程异常终止，那么内核也会用一个指示其异常终止原因的终止状态来表示进程，当然，这种终止状态也可以由父进程的wait(),waitpid()
进程捕获。
2. 进程异常退出
进程异常退出是进程在运行过程中被意外终止，从而导致进程本来应该继续执行的任务无法完成。
2.1 向进程发送信号导致进程异常退出；
int kill(pid_t pid, int sig); # kill SIG*** PID
 control-C intr
 control-\ quit
 control-z susp
 control-Q start
 control-S stop
2.2 代码错误导致进程运行时异常退出。
进程自身的编程错误，错误的编码执行非法操作，操作系统和硬件制止它的非法操作，并且让进程异常退出。

第一类情况是因为外部环境向进程发送信号，这种情况下发送的信号是异步信号，信号的到来与进程的运行是异步的；
第二类情况是进程非法操作触发处理器异常，然后异常处理函数在内核态向进程发送信号，这种情况下发送的信号是同步信号，信号的到来与进程的运行是同步的。

exit(int status) # 触使进程正常结束
  初始进程正常结束，返回值status & 0377被父进程的wait函数的。
  所有注册给atexit和on_exit的函数将按照反向顺序执行；如果注册函数调用了_exit或者引起信号异常，则后续注册函数将不再被执行；
  推出过程将终止(stdio的缓冲区将不再被flush)；如果一个函数在atexit或on_exit注册了多次，那么该函数将被执行多次。
  1. 所有的stdio缓冲区内内容将被输出
  2. tmpfile创建临时文件将被删除
  3. EXIT_SUCCESS EXIT_FAILURE是标准C定义的两个错误输出值；这两个值更标准，更可移植
  4. 在atexit和on_exit中调用exit和longjmp会出现不可预期的结果
  void exit(int status);
  1. 如果父进程设置SIGCHLD信号为SA_NOCLDWAIT， 或者设置SIGCHLD信号为SIG_IGN，则退出状态将被丢弃
  2. 如果父进程等待子进程结束，则子进程结束
  3. 如果父进程没有等待子进程解说，则子进程变成僵尸进程
  如果支持SIGCHLD信号，该信号将被发送给父进程；如果父进程设置信号为SA_NOCLDWAIT，如何处理SIGCHLD信号未定义；
  如果进程的退出导致一个进程组变成孤儿进程组，如果一个孤儿进程停止；SIGCONT和SIGHUP将被依次发送给进程组内其他进程

int atexit(void (*function)(void)); # 注册一个在进程正常结束时回调的函数 ATEXIT_MAX
  注册一个正常终止进程时执行的函数，这个函数的参数必须是void，注册成功返回0,失败返回非0

on_exit() #  最好不要再调用 on_exit == atexit
int on_exit(void (*function)(int , void *), void *arg); VS int atexit(void (*function)(void));
不同之处是on_exit注册的函数可以带参数，这个function的两个形参分别是通过exit()传入的int型 和 通过on_exit()传入的*arg

_exit()/_Exit(): # 终止被调用进程 _Exit(int status) == _exit(int status)
1. 立即终止进程运行；属于此进程的任何文件描述符将被关闭；任何子进程将成为init的子进程；父进程将接收到SIGCHLD信号；
2. status传递给父进程的wait函数
void _exit(int status);     # <unistd.h>
void _Exit(int status);     # <stdlib.h>
相比exit而言：
1. 不调用atexit和on_exit的注册函数，不刷清stdio信息，不删除tmpfile
}

process(wait|waitpid|waitid){
wait(), waitpid(), waitid()
阻塞等待子进程状态变化，并获取子进程状态变化信息：
1. 子进程结束            WNOHANG      子进程结束
2. 子进程被信号stop      WUNTRACED    stopped
3. 子进程被信号resume    WCONTINUED   SIGCONT
如果子进程已经结束，则调用wait则会立刻返回，否则，会阻塞父进程，直到子进程状态发生变化，或者被其他信号处理函数执行后中断；
waitable: 子进程状态发送变化，子进程的状态信息还未被父进程wait。

wait()   阻塞父进程，直到任意一个子进程结束
waitpid()阻塞或非阻塞父进程，直到指定的子进程终止
wait()相当于waitpid(-1, &status, 0)成功返回子进程的PID，失败返回-1设errno

waitpid增强wait内容
  waitpid等待特定的子进程, 而wait则返回任一终止状态的子进程;
  waitpid提供了一个wait的非阻塞版本;
  waitpid支持作业控制(以WUNTRACED选项).
  wait返回值为子进程pid_t或者-1表示失败； waitpid返回值为子进程pid_t; WNOHANG时，0表示无终止子进程正常退出；-1表示失败

wait 和 SIGCHLD
  已知系统默认是忽略SIGCHLD信号，在一个进程终止或停止时，会将SIGCHLD信号发送给其父进程。
  已知父进程若不调用wait()获取子进程的终止状态,那么子进程就会变成僵尸进程。
  Q3.1:wait()是关于是否产生僵尸进程的问题。
  Q3.2:SIGCHLD信号是关于自己本身的处理方式的选择问题。
    当SIGCHLD的处理方式是系统默认时，父进程调用了wait()以防止子进程变成僵尸进程，那么父进程必须等待子进程结束之后才能执行wait()之后的流程，即同步问题。
    当SIGCHLD的处理方式是捕获时，在其信号处理程序中调用wait()函数，就能获取子进程的终止状态而不产生僵尸进程同时父进程并不会阻塞，做自己想做的事，即异步问题。

    当子进程的状态发生改变时，wait()返回;
    当调用wait()的进程接收到一个被设置为SA_INTERRUPT的信号时，wait()返回;
    因为SIGCHLD信号的产生必然是伴随着子进程状态的改变，所以当有SIGCHLD信号发生时，wait会返回。

waitpid函数扩展
  safe_waitpid     屏蔽EINTR信号
  wait_any_nohang  屏蔽EINTR信号+WNOHANG+等待所有子进程
  wait4pid         屏蔽EINTR信号+阻塞等待+等待指定子进程

pid_t wait(int *status);
理解：
  所有子进程都在运行(没有僵尸子进程)，则阻塞。
  如果成功，wait会返回被收集的子进程的进程ID，
  如果调用进程没有子进程，调用就会失败，此时wait返回-1，同时errno被置为ECHILD。

pid_t waitpid(pid_t pid, int *status, int options);
返回值：
  当正常返回的时候，waitpid返回收集到的子进程的进程ID
  如果设置了选项WNOHANG，而调用中waitpid发现没有已退出的子进程可收集，则返回0
  如果调用中出错，则返回-1，这时errno会被设置成相应的值以指示错误所在
    当pid所指示的子进程不存在，或此进程存在，但不是调用进程的子进程，waitpid就会出错返回，这时errno被设置为ECHILD
errno: EINTR ECHILD EINVAL
pid_t                              
  pid>0       指定pid子进程
  pid=0       组ID等于调用进程ID的任意子进程
  pid=-1      任何子进程  waitpid(-1, &status, 0)
  pid<-1      组ID是PID的子进程

options： 选项之间是OR关系
  WNOHANG     如果没有子进程终止就立即返回
  WUNTRACED   如果一个子进程stoped且没有被traced，那么立即返回
  WCONTINUED (since Linux 2.6.10) //如果stoped的子进程通过SIGCONT复苏，那么立即返回 

wait的输出参数statloc中，某些位表示退出状态(正常返回),
                         其它位则指示信号编号(异常返回),
                             有一位指示是否产生了一个core文件等等。
status
  如果退出不是NULL，wait()会使用形参指针带出退出码，这个退出码可以使用下列宏解读
---- 某些位表示退出状态(正常返回),  # 调用exit(3)或_exit(2)或从main函数中退出
  WIFEXITED(status)       如果子进程正常退出返回真
  WEXITSTATUS(status)     返回子进程的退出码，当且仅当WIFEXITED为真时有效
                          WEXITSTATUS(status)可取得子进程传送给exit、_exit或_Exit参数的低8位;
---- 其它位则指示信号编号(异常返回), # 被信号终止
  WIFSIGNALED(status)     如果子进程被一个信号终止时返回真
  WTERMSIG(status)        返回终止子进程的信号编号，当且仅当WIFSIGNALED为真时有效
---- 指示是否产生了一个core文件 # 被信号终止 #ifdef WCOREDUMP ... #endif
  WCOREDUMP(status)       如果子进程导致了"核心已转储"则返回真，当且仅当WIFSIGNALED为真时有效
---- 等等
  WIFSTOPPED(status)      如果子进程被一个信号暂停时返回真，当且仅当调用进程使用WUNTRACED或子进程正在traced时有效 # WUNTRACED
  WSTOPSIG(status)        返回引起子进程暂停的信号编号，当且仅当WIFSTOPPED为真时有效    # WIFSTOPPED
  WIFCONTINUED(status)(since Linux 2.6.10)  如果子进程收到SIGCONT而复苏时返回真         # SIGCONT
}

process(孤儿进程和僵尸进程 孤儿进程组){
|-|----------------------------------------
|R| running or runnable (on run queue)
|D| uninterruptible sleep (usually IO)
|S| interruptible sleep (waiting for an event to complete)
|T| stopped, either by a job control signal or because it is being traced.
|X| dead (should never be seen)
|Z| defunct ("zombie") process, terminated but not reaped by its parent.
|-|----------------------------------------
孤儿进程：父进程退出，子进程还在运行，子进程将成为孤儿进程。
          孤儿进程的父进程变为init进程，init进程是所有孤儿进程的父进程。
僵尸进程：子进程已终止，但父进程未获取(wait|waitpid)终止子进程的终止状态，那么这些子进程就会变为僵尸进程，
         进程描述符仍然保存在系统中，还占用着系统的资源。
         内核维护了僵尸进程最少信息：进程PID，进程状态，进程资源使用信息和内核进程表(如果表满，则不能再创建进程)
  子进程结束时父进程仍存在，而父进程fork()之前既没安装SIGCHLD信号处理函数调用waitpid()等待子进程结束，
  又没有显式忽略该信号，则子进程成为僵尸进程，无法正常结束，此时即使是root身份kill -9也不能杀死僵尸进程。
清理僵尸进程的方法：杀死僵尸进程的父进程(僵尸进程的父进程必然存在)，僵尸进程成为"孤儿进程"，
                    过继给1号进程init，init始终会负责清理僵尸进程。
总结:
    Orphan/Zombie都是因为在parent中没有wait掉child, 不同之处是orphan的parent已经没了, 由init来接管了,而zombie有个缺德的
    parent, 不wait还不撒手,拖累了系统
    ps 一下Zombie的进程状态是'Z' # ps auwx
    
    unix提供了一种机制可以保证只要父进程想知道子进程结束时的状态信息， 就可以得到。这种机制就是: 在
每个进程退出的时候,内核释放该进程所有的资源,包括打开的文件,占用的内存等。 但是仍然为其保留一定的信息
(包括进程号the process ID,退出状态the termination status of the process,运行时间the amount of CPU 
time taken by the process等)。直到父进程通过wait / waitpid来取时才释放。

避免僵死进程方法：
1) 在SVR4中，如果调用signal或sigset将SIGCHLD的配置设置为忽略,则不会产生僵死子进程。
   另外,使用SVR4版的sigaction,则可设置SA_NOCLDWAIT标志以避免子进程僵死
2) 调用fork两次。
3) 用waitpid等待子进程返回.

孤儿进程组：
    孤儿进程组的条件是进程组中进程的父进程都是当前进程组中的进程，或者是其他session中的进程。
怎样创建孤儿进程组？
    fork()后，子进程继承父进程的gid,然后父进程退出，那么子进程变成了孤儿进程，其所在的进程组也变成了孤儿进程组。
    
特性1：父进程终止后，进程组成为了孤儿进程组。那么新的孤儿进程组中处于停止(stopped)状态的每一个进程都会收到挂断(SIGHUP)信号，接着又收到继续(SIGCONT)信号。
也就是说，进程组成为孤儿进程组后，孤儿进程组中的状态为stopped的进程会被激活。前提是需要对SIGHUP信号自处理，对挂断信号系统默认的动作是终止进程。
特性2：孤儿进程组是后台进程组，且没有控制终端
特性3：孤儿进程组去读控制终端时，read返回出错并将errno设置为EIO。
    只有前台作业能接收终端输入，如果后台作业试图读终端，那么这并不是一个错误，但是终端驱动程序将检测到这种情况，
并且向后台作业发送一个特定的信号SIGTTIN。该信号通常会暂时停止此后台作业。由于孤儿进程组是后台进程组，如果内核用
SIGTTIN信号停止它，那么进程组中的进程就再也不会继续了。
}

process(setsid){
定义：若当前进程不是进程组长，创建一个新会话；若当前进程已经是进程组长，返回错误；
性质：一个新会话创建后，当前进程的PID即是新会话ID又是进程组ID，即当前进程即是session leader又是group leader,
且没有控制终端(若再调用setsid之前该进程又一个控制终端，那么这种联系也会断开)。
一般使用：先调用fork(),然后使其父进程终止，而子进程继续。
}
process(setpgid){
int setpgid(pid_t pid,pid_t pgid);
函数作用：将pid进程的进程组ID设置成pgid，创建一个新进程组或加入一个已存在的进程组
函数性质：
性质1：一个进程只能为自己或子进程设置进程组ID，不能设置其父进程的进程组ID。
性质2：if(pid == pgid), 由pid指定的进程变成进程组长;即进程pid的进程组ID pgid=pid.
性质3：if(pid==0),将当前进程的pid作为进程组ID.
性质4：if(pgid==0),将pid作为进程组ID.
函数使用说明：一般自己调用该函数时，最好是明确指定pid和pgid，方便阅读代码流程；若想特意为之，就要会用性质。
}

process(GNU_SOURCE){
在source file的开头加上
#define _GNU_SOURCE
或者
gcc -D_GNU_SOURCE 

If you define _GNU_SOURCE, you will get:
    access to lots of nonstandard GNU/Linux extension functions
    access to traditional functions which were omitted from the POSIX standard (often for good reason, such as being replaced with better alternatives, or being tied to particular legacy implementations)
    access to low-level functions that cannot be portable, but that you sometimes need for implementing system utilities like mount, ifconfig, etc.
    broken behavior for lots of POSIX-specified functions, where the GNU folks disagreed with the standards committee on how the functions should behave and decided to do their own thing.

#ifdef _GNU_SOURCE
# define basename __basename_gnu
#else
# define basename __basename_nongnu
#endif 
}
extern(C){
extern "C"的主要作用就是为了能够正确实现C++代码调用其他C语言代码。加上extern "C"后，会指示编译器这部分代码
按C语言的进行编译，而不是C++的。由于C++支持函数重载，因此编译器编译函数的过程中会将函数的参数类型也加到编译
后的代码中，而不仅仅是函数名；而C语言并不支持函数重载，因此编译C语言代码的函数时不会带上函数的参数类型，
一般之包括函数名。
}
reboot(halt|poweroff|reboot){
reboot -n -f -hp
-n  在关机或重启之前不对系统缓存进行同步
-f  强制执行 halt 或 reboot 而不去通过init执行
|---------------|-----------|--------------|
|内核事件       |  宕机命令 | init信号处理 |
|---------------|-----------|--------------|
|RB_AUTOBOOT    |  reboot   | SIGTERM      |
|RB_HALT_SYSTEM |  halt     | SIGUSR1      |
|RB_POWER_OFF   |  poweroff | SIGUSR2      |
|---------------|-----------|--------------|
init在调用reboot(RB_AUTOBOOT|RB_HALT_SYSTEM|RB_POWER_OFF) 会调用run_action_from_list(SHUTDOWN);配置相关进程
kill(-1, SIGTERM);  向系统所有进程发送SIGTERM
sync();             同步数据
sleep(1);           等待睡眠
kill(-1,SIGKILL);   向系统所有进程发送SIGKILL
sync();             同步数据
}

toybox(init系统进程管理){
a. 信号处理说明
RB_AUTOBOOT           (reboot|SIGTERM)
RB_HALT_SYSTEM        (halt|SIGUSR1)
RB_POWER_OFF          (poweroff|SIGUSR2)
restart_init_handler  (SIGQUIT) 重启restart类型的进程  当init重新启动时，执行相应的进程，通常此处所执行的进程就是init本身
(CTRLALTDEL)          (SIGINT)  重启restart类型的进程  当按下Ctrl+Alt+Delete组合键时，执行相应的进程

b. SIGTSTP和SIGCONT信号处理
1. 当init接收到SIGTSTP信号之后，进程进入阻塞等待模式，只有init再次接收到SIGCONT信号之后才会继续执行；
   当init接收到SIGTSTP信号之后，init才开始注册SIGCONT信号，且通过waitpid阻塞等待SIGCONT信号到来，一旦到来，忽略SIGCONT信号，继续执行
2. telnet接收到Ctrl-z之后，会向当前进程组的所有信号发送SIGTSTP信号。

c. init功能: 管理系统进程
| ----------|---------------------------------
| 动作      | 结果
| ----------|---------------------------------
| sysinit   | 为init提供初始化命令行的路径          # "/etc/init.d/rcS" # 第一个执行
| respawn   | 每当相应的进程终止执行便会重新启动    # "/sbin/getty -n -l /bin/sh -L 115200 tty1 vt100" # 守护执行
| askfirst  | 类似respawn，不过它的主要用途是减少系统上执行的终端应用程序的数量。它将会促使init在控制台上 # 可能被exec阻塞
|           | 显示"Please press Enter to active this console"的信息，并在重新启动之前等待用户按下enter键
| wait      | 告诉init必须等到相应的进程完成之后才能继续执行 # 顺序执行
| once      | 仅执行相应的进程一次，而且不会等待它完成       # 并发执行
| ctratldel | 当按下Ctrl+Alt+Delete组合键时，执行相应的进程  # 触发执行
| shutdown  | 当系统关机时，执行相应的进程                   # 停机执行
| restart   | 当init重新启动时，执行相应的进程，通常此处所执行的进程就是init本身 # 重启执行
| ----------|---------------------------------
# 进程管理: (开机)初始化流程； (设备)进程守护状态； (设备关停重启)进程结束流程
初始化流程: SYSINIT -> WAIT -> ONCE-> RESPAWN|ASKFIRST
            CTRLALTDEL <---> SIGINT信号
            RESTART    <---> SIGQUIT信号
            ASKFIRST 1.都会转向后台运行，不需要waitpid阻塞等待结束 2.init监控保活 3. fork  创建
            RESPAWN  1.都会转向后台运行，不需要waitpid阻塞等待结束 2.init监控保活 3. vfork 创建
系统宕机流程：SHUTDOWN; kill(-1, SIGTERM); sync(); kill(-1, SIGKILL); sync() reboot(系统调用)

d. 流程：
1. 初始化输出设备
2. 工作目录设为根目录；创建新回话
3. 设置环境变量
4. 启动
4.1 解析/etc/inittab
4.2 注册SIGUSR1、SIGUSR2、SIGTERM、SIGQUIT、SIGTSTP、SIGINT、SIGHUP信号处理函数
4.3 启动SYSINIT、WAIT、ONCE、RESPAWN | ASKFIRST
4.4 通过waitpid函数: 监护RESPAWN | ASKFIRST类型进程; 回收自身领养子进程的僵尸状态  # 守护状态

d. 细节
在shell前加一个'-'前缀表示是一个登陆shell
}

toybox(telnetd会话管理和数据转发){ 伪终端：pseudo-terminal.sh  telnet协议: telnet协议.sh
a. 命令行参数说明
-i  受inet管理
-l  /bin/login
-f  /etc/issue.net      
-F  前台运行            daemon()
-w  设定阻塞超时时间    select(timeout)  # 即telnetd在多久运行结束
-p  PORT
-b ADDR[:PORT] 


1. FD_CLOEXEC
fcntl(new_fd, F_SETFD, FD_CLOEXEC);    # 子进程不继承父进程的listen
fcntl(master_fd, F_SETFD, FD_CLOEXEC); # 子进程不继承父进程的accept
2. telnet协议
# define IAC         255  /* interpret as command: */
# define DONT        254  /* you are not to use option */
# define DO          253  /* please, you use option */
# define WONT        252  /* I won't use option */
# define WILL        251  /* I will use option */
# define SB          250  /* interpret as subnegotiation */
# define SE          240  /* end sub negotiation */
# define NOP         241  /* No Operation */
# define TELOPT_ECHO   1  /* echo */
# define TELOPT_SGA    3  /* suppress go ahead */
# define TELOPT_TTYPE 24  /* terminal type */
# define TELOPT_NAWS  31  /* window size */
telnet协议处理见：handle_iacs 处理协议内容
                  dup_iacs    转注协议内容
3. select模型: 总体比较清晰
4. waitpid 和 SIGCHLD
# while (toys.signal) {
      toys.signal = 0;
      pid = waitpid(-1, &status, WNOHANG);  # 如果pid不小于0，就会等待；等于0也可以吧... 
      if (pid < 0) break;
      toys.signal++;
# }

b. 客户端
write_server -> handle_esc 用于管理telnet终端
l  go to line mode
c  go to character mode
z  suspend telnet
e  exit telnet
read_server -> handle_ddww + handle_negotiations 用于解析协议
}
toybox(syslogd){
syslogd  [-a socket] [-O logfile] [-f config file] [-m interval]
         [-p socket] [-s SIZE] [-b N] [-R HOST] [-l N] [-nSLKD]
}
timer(){
Linux中, 系统为每个系统都维护了三种计时器,分别为: 真实计数器, 虚拟计时器以及实用计时器, 一般情况下都使用真实计时器
getitimer()/setitimer()

//读取/设置内部计时器
#include <sys/time.h>
int getitimer(int which, struct itimerval *curr_value);
int setitimer(int which, const struct itimerval *new_value, struct itimerval *old_value);

which //具体的计时器类型
    ITIMER_REAL :真实计时器
        统计进程消耗的真实时间
        通过定时产生SIGALRM工作
    ITIMER_VIRTUAL :虚拟计时器
        统计继承在用户态下消耗的时间
        通过定时产生SIGVTALRM工作
    ITIMER_PROF :实用计时器
        统计进程在用户态和内核态消耗的总时间
        通过定时产生SIGPROF工作

new_value://结构体指针, 用于设计计时器的新值
old_value://结构体指针, 用于获取计时器的旧值

}

printk ------------>  ________________________________
                     |   /proc/kmsg                        |
                     |  [FIFO queue, length __LOG_BUF_LEN] |
                     |________________________________     |
                                    |
                                    |
                                    ------------> klogd (read file)
                                                         |
                                                         |
                  /etc/syslog.conf -------------> syslogd -----------> /var/log/messages

 
printk  ---->     do_syslog     <-----   kmsg(take it as a normal memory file )

logger(syslog){
(1) 命令接口， logger
logger [-isd] [-f file] [-p pri] [-t tag] [-usocket] [message ...]
上面是logger使用方法，具体的参数含义可以man 1 logger
}
syslog(){
openlog()建立syslogd的连接；
void openlog(const char *ident, int option,int facility)
syslog()向syslogd发送log信息
void syslog(int priority, const char*format, ...);
closelog()断开与syslogd的连接
void closelog(void);
}
dmesg(klogctl){
1. 从kernel 的ring buffer(环缓冲区)中读取信息;
2. 在LINUX中,所有的系统信息(包内核信息)都会传送到ring buffer中.而内核产生的信息由printk()打印出来。
   系统启动时所看到的信息都是由该函数打印到屏幕中。 printk（）打出的信息往往以<0><2>...这的数字表明
   消息的重要级别。高于一定的优先级别会打印到屏幕上， 否则只会保留在系统的缓冲区中(ring buffer)。
}

syslogd -R 192.168.1.1:601
syslogd -R masterlog:514
syslogd(/dev/log ){
syslogd这个守护进程根据/etc/syslog.conf,将不同的服务产生的Log记录到不同的文件中.
    如果klogd 和syslogd 都运行，则无论console_loglevel
为何值，内核消息都将追加到/var/log/messages中，否则按照syslogd的配置文件进行处理。

syslogd 守护进程默认情况下并不从 syslog/udp 端口接受任何消息，除非在命令行上使用了"-r"选项。此外，你还应当仔细看看"-l"和"-s"命令行选项。
syslogd 守护进程默认情况下并不转发任何来自远程主机的消息，这是为了避免可能导致的日志无限循环。"-h"选项可以开启转发功能。
syslogd 会剥除来自同一个域范围内的主机中的每条消息中的本地域(local domain)信息。如果你使用了日志分析程序，请将这一特性牢记在心。
syslogd 不会更改任何文件的属性，所以由它创建的文件将是全局可读的。如果你不想这样(比如"auth.*"被进行了记录)，你必须手动事先创建这些文件并设置相应的权限。
如果某些程序发送了大量的日志消息并且导致硬盘非常忙碌，你可以考虑在每一行后面关闭fsync()特性。不过这样可能会导致系统崩溃以后丢失一些日志消息。
如果你使用 init 来直接启动 klogd 或 syslogd ，那么需要在命令行上使用"-n"选项。
如果 System.map 文件存在并且在 klogd 命令行上使用了"-k"的话，那么它可以解码 EIP 地址。这个特性对于诊断系统崩溃非常有用，但是你必须确保 System.map 文件正确无误。
这两个守护进程都会尝试在收到退出信号时删除他们的 .pid 文件，不过如果系统崩溃或者进程被"kill -9"结束，那么可能就会来不及清理。这样，下次启动时就有可能会获得与以前残留的 .pid 文件中的进程号相同的PID，从而导致无法启动(进程号冲突)。解决这个问题的最佳方案是系统的启动脚本(rc.*)自身能够在系统启动的最初就对这些 .pid 文件进行清理(通常是清空 /var/run 目录)。
大文件支持(可以写入大于 2 GB 的日志)并不是 syslogd 的功能，而是 glibc 的功能(使用不同的内核API进行调用)。要启用大文件支持，你必须将 Makefile 中的相应注释取消(两个含有"-D_FILE_OFFSET_BITS"的行中的一个)。
}
klogd(klogctl /proc/kmsg){
klogd 不使用配置文件，它负责截获内核消息，它既可以独立使用也可以作为 syslogd 的客户端运行。

klogd [ -f file ] [ -iI ] [ -n ] [ -o ] [ -p ] [ -s ] [ -k file ] [ -v ] [ -x ] [ -2 ]
命令行参数说明：

-f file 将日志直接记录到指定的file中，而不是转发到 syslogd 进程。 -i
-I 要求当前正在运行的 klogd 守护进程重新装载内核符号表。
-i 用于让守护进程重新装载内核模块符号。
-I 用于让守护进程重新装载静态内核符号和内核模块符号。 -n 禁止自动后台运行，在 klogd 由 init 启动并直接被 init 控制的情况下必须使用此开关。 -o klogd 在读取并记录所有内核消息缓冲区中的消息之后立即退出(不作为守护进程)。 -p 只要 klogd 检测到内核消息流中包含了一个 Oops 字符串，那么就重新加载内核符号表。 -s 可以通过两个途径获取内核消息: /proc 文件系统和 sys_syslog 系统调用接口。虽然两者本质上完全等价，但 klogd 会优先使用 /proc/kmsg 文件。这个开关则强制 klogd 使用系统调用获取内核消息。 -k file 将指定的 file 作为内核符号表文件，也就是System.map文件的位置。 -v 打印版本信息后退出。 -x 忽略 EIP 转换信息，这样就不需要读取 System.map 文件。 -2 当展开符号时打印两行，一行将地址转换为符号，一行是原始文本。这样就允许一些外部程序(比如ksymoops)在原始数据上做一些处理。 消息转发
如果 klogd 将内核消息转发给 syslogd 进程，那么它可以分拣出某些特定的消息。原始内核消息的格式如下：

<[0-7]>Something said by the kernel.
尖括号中的数字表示内核消息的优先级，这些数字的定义位于 kernel.h 文件中。当 klogd 收到内核消息之后，将会读取这个数字，并在将此消息转发给 syslogd 时按照这个数字分配适当的优先级。

如果使用 -f 将内核消息直接记录到特定的文件中，那么这条消息将保持原样。

内核地址解析
klogd 会尝试将内核地址解析为对应的符号，如果你想得到原始的地址信息，那么可以使用"-2"开关。如果没有使用"-k"选项，那么将会依次尝试下面的路径：

}
sysklogd(){
Sysklogd 日志记录器由两个守护进程(klogd syslogd)和一个配置文件(syslog.conf)组成。
}

klogctl(){
0 -- Close the log.  Currently a NOP.                          
1 -- Open the log. Currently a NOP.                            
2 -- Read from the log.                                        syslog(2,buf,len)     empty wait ether read &&  /proc/kmsg
3 -- Read all messages remaining in the ring buffer.           syslog(3,buf,len)     read 
4 -- Read and clear all messages remaining in the ring buffer  syslog(4,buf,len)     read and clear
5 -- Clear ring buffer.                                        syslog(5,dummy,dummy) clear
6 -- Disable printk to console                                 syslog(6,dummy,dummy) level to minimum
7 -- Enable printk to console                                  syslog(7,dummy,dummy) level to default
8 -- Set level of messages printed to console                  syslog(8,dummy,level) level to level [1-8]
9 -- Return number of unread characters in the log buffer      syslog(9,dummy,dummy) unread length
10 -- Return size of the log buffer                            syslog(10,dummy,dummy) buffer length

#define KERN_EMERG    "<0>"  /* system is unusable               */
#define KERN_ALERT    "<1>"  /* action must be taken immediately */
#define KERN_CRIT     "<2>"  /* critical conditions              */
#define KERN_ERR      "<3>"  /* error conditions                 */
#define KERN_WARNING  "<4>"  /* warning conditions               */
#define KERN_NOTICE   "<5>"  /* normal but significant condition */
#define KERN_INFO     "<6>"  /* informational                    */
#define KERN_DEBUG    "<7>"  /* debug-level messages             */
}