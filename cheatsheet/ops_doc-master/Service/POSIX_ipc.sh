https://github.com/JeffyLu/JeffyLu.github.io/issues/21
https://blog.csdn.net/pbymw8iwm/article/details/7971313
https://github.com/darlingYang/Job/issues/4

POSIX信号量是属于POSIX标准系统接口定义的实时扩展部分。
POSIX IPC函数时大势所趋，因为他们比System V中的相应部分更具有优势

man mq_overview
man sem_overview
man shm_overview

sem(概述){

# /dev/shm

信号量是一种提供不同进程间或者一个给定进程不同线程之间的同步
POSIX信号量又分为有名信号量和基于内存的信号量(匿名信号)。区别在于是否需要使用POSIX IPC名字来标识。
Linux操作系统中，POSIX有名信号量创建在虚拟文件系统中 一般挂载在/dev/shm，其名字以sem.somename的形式存在。

无名信号量也被称作基于内存的信号量。
有名信号量通过IPC名字进行进程间的同步，而无名信号量如果不是放在进程间的共享内存区中，是不能用来进行
进程间同步的，只能用来进行线程同步。
}
sem(有名信号 匿名信号 共享内存匿名信号){
1. 创建|打开一个有名信号量，成功返回新信号量的地址，失败返回SEM_FAILED设errno
sem_t *sem_open(const char *name, int oflag);
sem_t *sem_open(const char *name, int oflag, mode_t mode, unsigned int value);
name规则：一般是"/xxxx"的形式，创建成功后，消息队列将存在挂载在文件系统上的目录，例如/dev/shm ; NAME_MAX-4
oflag
  0 获取已经存在的信号量
  O_CREAT如果信号量不存在就创建信号量，这是mode和value就必须存在; 如果O_CREAT且信号量已经存在，则忽略mode和value
  O_EXCL和O_CREAT连用，确保可以创建新的信号量，如果已存在就报错
mode  :可以设置为0644 自己可读写，其他用户和组内用户可读
value :配合O_CREAT使用，设置信号量的初始值
SEM_FAILED errno: EACCES 访问name权限不够
                  EEXIST O_EXCL和O_CREAT
                  EINVAL name名字不对
                  EMFILE 进程文件描述符超限
                  ENAMETOOLONG name太长
                  ENFILE 系统文件描述符超限
                  ENOENT 没有O_CREAT且name不存在
                  O_CREAT 内存不足
                  
2. 初始化无名信号量，成功返回0,失败返回-1设errno
int sem_init(sem_t *sem, int pshared, unsigned int value);
sem 是指向一个已经分配的sem_t变量。
pthread指定信号量是在线程间使用还是进程间使用
  0表示信号量在一个进程内的线程间使用，此时信号量应该分配的在线程可见的内存区域
  非0表示信号量在进程间使用，此时信号量应该分配在共享内存里 # shm_open(3), mmap(2), and shmget(2)
value表示信号量的初始值
errno：EINVAL value>SEM_VALUE_MAX
       ENOSYS 给sem分配的内存不支持进程间共享
       
a. 无名信号量不使用任何类似O_CREAT的标志，这表示sem_init()总是会初始化信号量的值，所以对于特定的一个信号量，
   我们必须保证只调用sem_init()进行初始化一次，对于一个已初始化过的信号量调用sem_init()的行为是未定义的。
b. 摧毁一个有线程阻塞在其上的信号量的行为是未定义的。

3. 首先会测试指定信号量的值，如果大于0，就会将它减1并立即返回，如果等于0，那么调用线程会进入睡眠，指定信号量的值大于0.
int sem_wait(sem_t *sem); # 试图占用信号量，如果信号量值>0,就-1,如果已经=0,就block，直到>0

3.1 当信号量的值等于0的，调用线程不会阻塞，直接返回，并标识EAGAIN错误。
int sem_trywait(sem_t *sem); # 试图占用信号量，如果信号量已经=0，立即报错

3.2 当信号量的值等于0时，调用线程会限时等待。当等待时间到后，信号量的值还是0，那么就会返回错误。
int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout);
-1 && errno： EINTR  信号中断
              EINVAL sem错误
              EAGAIN sem_trywait
              EINVAL sem_timedwait的abs_timeout错误
              ETIMEDOUT 超时

4. 信号量的值加1，如果有等待的线程，那么会唤醒等待的一个线程。
int sem_post(sem_t *sem); # 成功返回0,失败返回-1设errno
-1 && errno：EACCES      访问name权限不够
             ENAMETOOLONG   超过最大值

5. 获得信号量sem的当前的值，放到sval中。如果有线程正在block这个信号量，sval可能返回两个值，0或“-正在block的线程的数目”，Linux返回0
成功返回0,失败返回-1设errno
int sem_getvalue(sem_t *sem, int *sval);
-1 && errno：EINVAL      sem错误

6. 关闭有名信号量，成功返回0,失败返回-1设errno
int sem_close(sem_t *sem);
-1 && errno：EINVAL      sem错误

7. 试图销毁信号量，一旦所有占用该信号量的进程都关闭了该信号量，那么就会销毁这个信号量
成功返回0,失败返回-1设errno
int sem_unlink(const char *name);
-1 && EACCES      sem错误
      ENAMETOOLONG name太长
      ENOENT       name不存在

8. sem_unlink用于将有名信号量立刻从系统中删除，但信号量的销毁是在所有进程都关闭信号量的时候。
int sem_destroy(sem_t *sem); # 成功返回0,失败返回-1设errno
}

sem(持续性){
1. 有名信号量是随内核持续的。当有名信号量创建后，即使当前没有进程打开某个信号量它的值依然保持。
   直到内核重新自举或调用sem_unlink()删除该信号量。
2. 无名信号量的持续性要根据信号量在内存中的位置：
2.1 如果无名信号量是在单个进程内部的数据空间中，即信号量只能在进程内部的各个线程间共享，那么
    信号量是随进程的持续性，当进程终止时它也就消失了。
2.2 如果无名信号量位于不同进程的共享内存区，因此只要该共享内存区仍然存在，该信号量就会一直存在。
    所以此时无名信号量是随内核的持续性。
}
sem(继承){
1. 对于有名信号量在父进程中打开的任何有名信号量在子进程中仍是打开的
2. 对于无名信号量的继承要根据信号量在内存中的位置：
2.1 如果无名信号量是在单个进程内部的数据空间中，那么信号量就是进程数据段或者是堆栈上，当fork产生子进程后，
    该信号量只是原来的一个拷贝，和之前的信号量是独立的。
2.2 如果无名信号量位于不同进程的共享内存区，那么fork产生的子进程中的信号量仍然会存在该共享内存区，
    所以该信号量仍然保持着之前的状态。
}
sem(销毁){
1. 对于有名信号量，当某个持有该信号量的进程没有解锁该信号量就终止了，内核并不会将该信号量解锁。
   这跟记录锁不一样。
2. 对于无名信号量，
如果信号量位于进程内部的内存空间中，当进程终止后，信号量也就不存在了，无所谓解锁了。
如果信号量位于进程间的共享内存区中，当进程终止后，内核也不会将该信号量解锁。
}
msg(概述){

# mkdir /dev/mqueue
# mount -t mqueue none /dev/mqueue
|-------------------|--------------------|
|Library interface  | System call        |
|-------------------|--------------------|
|mq_close(3)        | close(2)           |
|mq_getattr(3)      | mq_getsetattr(2)   |
|mq_notify(3)       | mq_notify(2)       |
|mq_open(3)         | mq_open(2)         |
|mq_receive(3)      | mq_timedreceive(2) |
|mq_send(3)         | mq_timedsend(2)    |
|mq_setattr(3)      | mq_getsetattr(2)   |
|mq_timedreceive(3) | mq_timedreceive(2) |
|mq_timedsend(3)    | mq_timedsend(2)    |
|mq_unlink(3)       | mq_unlink(2)       |
|-------------------|--------------------|
/proc/sys/fs/mqueue/msg_max      attr->mq_maxmsg  最小值1    默认值10   最大值HARD_MAX
/proc/sys/fs/mqueue/msgsize_max  attr->mq_msgsize 最小值128  默认值8192 最大值INT_MAX
/proc/sys/fs/mqueue/queues_max                    最小值0    默认值256  最大值INT_MAX
RLIMIT_MSGQUEUE
QSIZE:129     NOTIFY:2    SIGNO:0    NOTIFY_PID:8260 

QSIZE
NOTIFY_PID  mq_notify
SIGNO       SIGEV_SIGNAL
NOTIFY       0 is SIGEV_SIGNAL; 1 is SIGEV_NONE; and 2 is SIGEV_THREAD.

更简单的基于文件的应用接口
完全支持消息优先级（优先级最终决动队列中消息的位置）
完全支持消息到达的异步通知，这通过信号或是线程创建实现
用于阻塞发送与接收操作的超时机制

Posix消息队列与System V消息队列主要区别：
1.对Posix消息队列的读总是返回最高优先级的消息，对System V消息队列的读则可以返回任一指定优先级消息。
2.往空队列放置消息时，Posix消息队列允许产生一个信号或启动一个线程，System V则不提供类似机制
Posix消息队列与管道或FIFO的主要区别：
1.在某个进程往一个队列写入消息之前，并不需要另外某个进程在该队列上等待消息的到达。对管道和FIFO来说，除非读出者已存在，否则先有写入者是没有意义的。
2.管道和FIFO是字节流模型，没有消息边界；消息队列则指定了数据长度，有边界。
}

msg(基于文件系统的消息队列){
1. 创建一个POSIX消息队列或打开一个已经存在的消息队列,成功返回消息队列描述符mqdes供其他函数使用，失败返回(mqd_t)-1设errno
mqd_t mq_open(const char *name, int oflag);
mqd_t mq_open(const char *name, int oflag, mode_t mode, struct mq_attr *attr);
name:
  name规则：一般是"/xxxx"的形式，创建成功后，消息队列将存在挂载在文件系统上的目录，例如/dev/mqueue
oflag
  O_RDONLY表示以只接收消息的形式打开消息队列
  O_WRONLY表示以只发送消息的形式打开消息队列
  O_RDWR表示以可接收可发送的形式打开消息队列
mode
  O_NONBLOCK以nonblocking的模式打开消息队列
  O_CREAT如果一个消息队列不存在就创建它，消息队列的拥有者的UID被设为调用进程的effective UID，GID被设为调用进程的effective GID
  O_EXCL确保消息队列被创建，如果消息队列已经存在，则发生错误
mode如果oflag里有O_CREAT，则mode用来表示新创建的消息队列的权限
attr如果oflag里有O_CREAT，则attr表示消息队列的属性，
    如果attr是NULL，则会按照默认设置配置消息队列
    
attr 1. 在mq_open中oflag中设定O_CREAT创建消息队列的时候，设定attr是有必要的，特别是mq_maxmsg:消息数量和mq_msgsize：消息大小的设定
        而mq_flags的配置是无效的；mq_curmsgs值也会是0
     2. 在mq_open每次创建或打开的时候，就会关联attr结构，创建的时候会初始化该结构；打开的时候会获取创建初始化该结构的
        mq_maxmsg，mq_msgsize，mq_curmsgs而不会影响该结构中的mq_flags标识信息。
     3. 可以将mq_getattr获取的mq_maxmsg，mq_msgsize看做是协议约束的一部分，说明协议报文大小和协议报文个数要求
        在消息队列层面至少需要说怎么实现
  注意：mq_setattr()函数只能设置mq_flags属性，另外的域会被自动忽略，mq_maxmsg和mq_msgsize的设置需要在mq_open当中来完成， 
       参数oldattr会和函数mq_getattr函数中参数attr相同的值。
2. 设置/修改 / 获取消息队列属性,成功返回0,失败返回-1设errno
int mq_setattr(mqd_t mqdes, const struct mq_attr *newattr, struct mq_attr *oldattr);
int mq_getattr(mqd_t mqdes, struct mq_attr *attr);
mqattr(消息队列属性){
                                                     /proc/sys/fs/mqueue/queues_max   最大消息队列数 默认256
    long mq_flags;     # 阻塞标志， 0或O_NONBLOCK
    long mq_maxmsg;    # 最大消息数                  /proc/sys/fs/mqueue/msg_max      对应mq_maxmsg 默认10
    long mq_msgsize;   # 每个消息最大大小            /proc/sys/fs/mqueue/msgsize_max  对应mq_msgsize 默认8192
    long mq_curmsgs;   # 当前消息数                  
}
3. 发送消息到mqdes指向的消息队列。成功返回0，失败返回-1设errno # 阻塞
int mq_send(mqd_t mqdes, const char *msg_ptr, size_t msg_len, unsigned int msg_prio);
a. 如果优先级并不需要，那么将unsigned int msg_prio设置为0
   msg_prio: 值越大优先级越大；高优先级的消息首先被从队列中获取

3.1 如果消息队列满 # 阻塞
int mq_timedsend(mqd_t mqdes, const char *msg_ptr, size_t msg_len, unsigned int msg_prio,const struct timespec *abs_timeout);
msg_len     msg_ptr指向的消息队列的长度，这个长度必须<=消息队列中消息长度，可以是0
msg_prio    一个用于表示消息优先级的非0整数，消息按照优先级递减的顺序被放置在消息队列中，同样优先级的消息，
            新的消息在老的之后，如果消息队列满了，就进入blocked状态，新的消息必须等到消息队列有空间了进入，
            或者调用被signal中断了。如果flag里有O_NOBLOCK选项，则此时会直接报错
abs_timeout 如果消息队列满了，那么就根据abs_timeout指向的结构体表明的时间进行锁定，里面的时间是从1970-01-01 00:00:00 +0000 
             (UTC)开始按微秒计量的时间，如果时间到了，那么mq_timesend()立即返回
             
4. 从消息队列中取出优先级最高的里面的最老的消息，成功返回消息取出消息的大小，失败返回-1设errno
ssize_t mq_receive(mqd_t mqdes, char *msg_ptr, size_t msg_len, unsigned int *msg_prio); # 阻塞
如果优先级并不需要，那么将unsigned int *msg_prio设置为NULL
4.1 # 阻塞
ssize_t mq_timedreceive(mqd_t mqdes, char *msg_ptr, size_t msg_len, unsigned int *msg_prio, const struct timespec *abs_timeout);

5. 允许调用进程注册或去注册同步来消息的通知，成功返回0,失败返回-1设errno
int mq_notify(mqd_t mqdes, const struct sigevent *sevp); # 注册或注销一个消息通知；当一个消息达到一个空消息队列时或者队列变成空队列
# 如果其他进程或线程阻塞在mq_receive则，信号不会到达，注册事件保持等待
sevp指向sigevent的指针
  如果sevp不是NULL，那么这个函数就将调用进程注册到通知进程,只有一个进程可以被注册为通知进程
  如果sevp是NULL且当前进程已经被注册过了，则去注销，以便其他进程注册
sigval(mq_notify通知信号){
    int     sival_int;          /* Integer value */
    void*   sival_ptr;          /* Pointer value */
}
SI_MESGQ
sigevent(mq_notify信号配置) {
    int     sigev_notify;       /* Notification method */
    int     sigev_signo;        /* Notification signal */
    union sigval    sigev_value;    /* Data passed with notification */
    void(*sigev_notify_function) (union sigval); //Function used for thread notification (SIGEV_THREAD)
    void*   sigev_notify_attributes;    // Attributes for notification thread (SIGEV_THREAD)
    pid_t   sigev_notify_thread_id;     /* ID of thread to signal (SIGEV_THREAD_ID) */
    
sigev_notify使用下列的宏进行配置：
  SIGEV_NONE    调用进程仍旧被注册，但是有消息来的时候什么都不通知
  SIGEV_SIGNAL  通过给调用进程发送sigev_signo指定的信号来通知进程有消息来了
                信号：si_code=SI_MESGQ  si_pid=pid si_uid=uid
  SIGEV_THREAD  一旦有消息到了，就激活sigev_notify_function作为新的线程的启动函数
EBADF ：错误的mqdes
EBUSY ： 另个进程已经注册
EINVAL ： sevp->sigev_notify 错误 或 sevp->sigev_signo不是有效信号
ENOMEM : 内存不足
}

6. 关闭消息队列描述符mqdes，如果有进程存在针对这个队列的notification request，那么也会被移除
成功返回0,失败返回-1设errno
int mq_close(mqd_t mqdes);

7. 删除会马上发生，即使该队列的描述符引用计数仍然大于0。
成功返回0，失败返回-1设errno
int mq_unlink(const char *name);
}

shm_open()   # 创建/获取共享内存fd     
ftruncate()  # 创建者调整文件大小       
mmap()       # 映射fd到内存         
munmap()     # 去映射fd               
shm_unlink() # 删除共享内存  
shm(共享内存){
1. 创建|获取共享内存的文件描述符，成功返回文件描述符，失败返回-1
int shm_open(const char *name, int oflag, mode_t mode);
name:
  name规则：一般是"/xxxx"的形式，创建成功后，消息队列将存在挂载在文件系统上的目录，例如/dev/shm
oflag
  O_RDONLY以只读的方式打开共享内存对象
  O_RDWR以读写的方式打开共享内存对象
  O_CREAT 表示创建共享内存对象，刚被创建的对象会被初始化为0byte可以使用ftuncate()调整大小
  O_EXCL用来确保共享内存对象被成功创建，如果对象已经存在，那么返回错误
  O_TRUNC表示如果共享内存对象已经存在那么把它清空
mode: eg,0664 etc
返回文件描述符支持：FD_CLOEXEC&&fcntl
-1 && errno： EACCES shm_unlink 权限不够 或者 shm_open中mode或O_TRUNC 权限不够
              EEXIST shm_open的O_CREAT&O_EXCL
              EINVAL name错误
              EMFILE 进程能打开文件描述符超限
              ENAMETOOLONG name太长
              ENFILE 系统能打开文件描述符超限
              ENOENT O_CREAT未指定且name不存在
              ENOENT 指定name不存在
shm_open->[fcntl]->ftruncate->mmap: 当调用mmap之后，即使关闭文件描述符也不影响共享内存使用
shm_unlink模拟unlink删除，一旦unlink之后，shm_open不能再次打开

2. 调整fd指向文件的大小，成功返回0,失败返回-1设errno
int ftruncate(int fd, off_t length)；
如果原文件大小>指定大小，原文件中多余的部分会被截除

3. 获取文件状态，成功返回0,失败返回-1设errno
int lstat(const char *pathname,     struct stat *buf);
int fstat(int fd, struct stat *buf);

4. 映射文件或设备到进程的虚拟内存空间，映射成功后对相应的文件或设备操作就相当于对内存的操作
   映射以页为基本单位,文件大小, mmap的参数 len 都不能决定进程能访问的大小, 而是容纳文件被映射部分的最小页面数决定传统文件访问
   要求对文件进行可读可写的的打开!!!
   成功返回映射区的指针，失败返回-1设errno           
void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);   # prot:protection, 权限
addr:映射的起始地址, 如果为NULL则由kernel自行选择->最合适的方法
length:映射的区域长度
prot:映射内存的保护权限
  PROT_EXEC表示映射的内存页可执行
  PROT_READ表示映射的内存可被读
  PROT_WRITE表示映射的内存可被写
  PROT_NONE表示映射的内存不可访问
flags
  MAP_SHARED表示共享这块映射的内存，读写这块内存相当于直接读写文件，这些操作对其他进程可见，由于OS对文件的读写都有缓存机制，所以实际上不会立即将更改写入文件，除非带哦用msync()或mumap()
  MAP_PRIVATE表示创建一个私有的copy-on-write的映射， 更新映射区对其他映射到这个文件的进程是不可见的
  
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
    
5. 接触文件或设备对内存的映射，成功返回0,失败返回-1设errno
int munmap(void *addr, size_t length);

6. 关闭进程打开的共享内存对象，成功返回0,失败返回-1
int shm_unlink(const char *name);
}
mmap(open shm_open mmap){
mmap函数把一个文件或者一个Posix共享内存区对象映射到进程的地址空间，这样：
  1.使用普通文件提供内存映射;通常在需要对文件进行频繁读写时使用，这样用内存读写取代I/O读写，以获得较高的性能
  2.特殊文件提供匿名内存映射;可以为关联进程提供共享内存空间
  3.使用shm_open提供Posix共享内存区;
  4.为无关联的进程提供共享内存空间，一般也是将一个普通文件映射到内存中。
void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);
int munmap(void *addr, size_t length); # 取消映射
参数start：指向欲映射的内存起始地址，通常设为 NULL，代表让系统自动选定地址，映射成功后返回该地址。
参数length：代表将文件中多大的部分映射到内存。
参数prot：映射区域的保护方式。可以为以下几种方式的组合：
  PROT_EXEC 映射区域可被执行
  PROT_READ 映射区域可被读取
  PROT_WRITE 映射区域可被写入
  PROT_NONE 映射区域不能存取
参数flags：影响映射区域的各种特性。在调用mmap()时必须要指定MAP_SHARED 或MAP_PRIVATE。
  MAP_FIXED 如果参数start所指的地址无法成功建立映射时，则放弃映射，不对地址做修正。通常不鼓励用此旗标。
  MAP_SHARED对映射区域的写入数据会复制回文件内，而且允许其他映射该文件的进程共享。
  MAP_PRIVATE 对映射区域的写入操作会产生一个映射文件的复制，即私人的“写入时复制”（copy on write）对此区域作的任何修改都不会写回原来的文件内容。
  MAP_ANONYMOUS建立匿名映射。此时会忽略参数fd，不涉及文件，而且映射区域无法和其他进程共享。
  MAP_DENYWRITE只允许对映射区域的写入操作，其他对文件直接写入的操作将会被拒绝。
  MAP_LOCKED 将映射区域锁定住，这表示该区域不会被置换（swap）。
参数fd：要映射到内存中的文件描述符。如果使用匿名内存映射时，即flags中设置了MAP_ANONYMOUS，fd设为-1。有些系统不支持匿名内存映射，则可以使用fopen打开/dev/zero文件，然后对该文件进行映射，可以同样达到匿名内存映射的效果。
参数offset：文件映射的偏移量，通常设置为0，代表从文件最前方开始对应，offset必须是分页大小的整数倍。
返回值：
若映射成功则返回映射区的内存起始地址，否则返回MAP_FAILED(-1)，错误原因存于errno 中。

MAP_FAILED && errno 
  EBADF 参数fd 不是有效的文件描述词
  EACCES 存取权限有误。如果是MAP_PRIVATE 情况下文件必须可读，使用MAP_SHARED则要有PROT_WRITE以及该文件要能写入。
  EINVAL 参数start、length 或offset有一个不合法。
  EAGAIN 文件被锁住，或是有太多内存被锁住。
  ENOMEM 内存不足。

1. 必须以PAGE_SIZE为单位进行映射，而内存也只能以页为单位进行映射，若要映射非PAGE_SIZE整数倍的地址范围，
   要先进行内存对齐，强行以PAGE_SIZE的倍数大小进行映射。
2. mmap 的回写时机： 
   内存不足 
   进程退出 
   调用 msync 或者 munmap 
   不设置 MAP_NOSYNC 情况下 30s-60s(仅限FreeBSD)
3.  内存映射的步骤:
    用open系统调用打开文件, 并返回描述符fd.
    用mmap建立内存映射, 并返回映射首地址指针start.
    对映射(文件)进行各种操作, 显示(printf), 修改(sprintf).
    用munmap(void *start, size_t lenght)关闭内存映射.
    用close系统调用关闭文件fd.

}