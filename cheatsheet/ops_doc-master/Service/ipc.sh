https://www.ibm.com/developerworks/cn/linux/l-ipc/part1/index.html

toybox ipcs ipcrm

|---------|----------|---------|----------------|
|分类     | 创建函数 | 控制函数| 独立函数       |
|---------|----------|---------|----------------|
|消息队列 | msgget   | msgctl  | msgsnd，msgrcv |
|信号量   | semget   | semctl  | semop          |
|共享内存 | shmget   | shmctl  | shmat，shmdt   |
|---------|----------|---------|----------------|

| msgget|shmget|semget |
|-----------|-----------------------------------------------
|IPC_CREAT  | 如果key不存在，则创建(类似open函数的O_CREAT)
|IPC_EXCL   | 如果key存在，则返回失败(类似open函数的O_EXCL)
|IPC_NOWAIT | 如果需要等待，则直接返回错误
|-----------|-----------------------------------------------

| msgctl|shmctl|semctl |
|----------|------------------------------------------------
|IPC_RMID  | 删除消息队列。只能由其创建者或超级用户（root）来删除
|IPC_SET   | 设置消息队列的属性。按照buf指向的结构中的值，来设置此IPC对象
|IPC_STAT  | 读取消息队列的属性。取得此队列的msqid_ds结构，并存放在buf中
|IPC_INFO  | （只有Linux有）返回系统级的限制，结果放在buf中
|----------|------------------------------------------------

ipc(共同){
struct ipc_perm {
   uid_t          cuid;   /* creator user ID */
   gid_t          cgid;   /* creator group ID */
   uid_t          uid;    /* owner user ID */
   gid_t          gid;    /* owner group ID */
   unsigned short mode;   /* r/w permissions */
};
# mode
0400    Read by user.
0200    Write by user.
0040    Read by group.
0020    Write by group.
0004    Read by others.
0002    Write by others
# 管理
IPC_CREAT     Create entry if key doesn’t exist.
IPC_EXCL      Fail if key exists.
IPC_NOWAIT    Error if request must wait.
IPC_PRIVATE   Private key.
IPC_RMID      Remove resource.
IPC_SET       Set resource options.
IPC_STAT      Get resource options.

# msqid_ds
msg_perm   ipc_perm structure that specifies the access permissions on the message queue.
msg_qnum   Number of messages currently on the message queue.
msg_qbytes Maximum number of bytes of message text allowed on the message queue.
msg_lspid  ID of the process that performed the last msgsnd(2) system call.
msg_lrpid  ID of the process that performed the last msgrcv(2) system call.
msg_stime  Time of the last msgsnd(2) system call.
msg_rtime  Time of the last msgrcv(2) system call.
msg_ctime  Time of the last system call that changed a member of the msqid_ds structure. 
# semid_ds
sem_perm   ipc_perm structure that specifies the access permissions on the semaphore set.
sem_otime  Time of last semop(2) system call.
sem_ctime  Time of last semctl(2) system call that changed a member of the above structure or of one  semaphore
           belonging to the set.
sem_nsems  Number  of semaphores in the set.  Each semaphore of the set is referenced by a non-negative integer
           ranging from 0 to sem_nsems-1.
# shmid_ds
shm_perm   ipc_perm structure that specifies the access permissions on the shared memory segment.
shm_segsz  Size in bytes of the shared memory segment.
shm_cpid   ID of the process that created the shared memory segment.
shm_lpid   ID of the last process that executed a shmat(2) or shmdt(2) system call.
shm_nattch Number of current alive attaches for this shared memory segment.
shm_atime  Time of the last shmat(2) system call.
shm_dtime  Time of the last shmdt(2) system call.
shm_ctime  Time of the last shmctl(2) system call that changed shmid_ds.
       
}
msg(总体){
1. 对消息队列有写权限的进程可以向中按照一定的规则添加新消息；
2. 对消息队列有读权限的进程则可以从消息队列中读走消息。

1. POSIX消息队列以及系统V消息队列，系统V消息队列目前被大量使用。
2. 考虑到程序的可移植性，新开发的应用程序应尽量使用POSIX消息队列。

1. 系统V消息队列是随内核持续的，只有在内核重起或者显示删除一个消息队列时，该消息队列才会真正被删除。
   因此系统中记录消息队列的数据结构(struct ipc_ids msg_ids)位于内核中，系统中的所有消息队列都可以
   在结构msg_ids中找到访问入口。
2. 消息队列就是一个消息的链表。每个消息队列都有一个队列头，用结构struct msg_queue来描述。队列头中包含
   了该消息队列的大量信息，包括消息队列键值、用户ID、组ID、消息队列中消息数目等等，甚至记录了最近对
   消息队列读写进程的ID。读者可以访问这些信息，也可以设置其中的某些信息。
   
1. 打开或创建消息队列 
   消息队列的内核持续性要求每个消息队列都在系统范围内对应唯一的键值，所以，要获得一个消息队列的描述字，
   只需提供该消息队列的键值即可；
   # 注：消息队列描述字是由在系统范围内唯一的键值生成的，而键值可以看作对应系统内的一条路经。
2. 读写操作
   消息读写操作非常简单，对开发人员来说，每个消息都类似如下的数据结构：
   struct msgbuf{
    long mtype;
    char mtext[1]; # msgsz <-> msgsnd msgrcv 长度不能等于0
   };
   mtype成员代表消息类型，从消息队列中读取消息的一个重要依据就是消息的类型；mtext是消息内容，当然长度不一定为1。
   对于发送消息来说，首先预置一个msgbuf缓冲区并写入消息类型和内容，调用相应的发送函数即可；
   对读取消息来说，首先分配这样一个msgbuf缓冲区，然后把消息读入该缓冲区即可。
   
   #define MSGMAX 8192
   消息总的大小不能超过8192个字节，包括mtype成员(4个字节)。
   
3. 获得或设置消息队列属性：
   消息队列的信息基本上都保存在消息队列头中，因此，可以分配一个类似于消息队列头的结构(struct msqid_ds)，来返回
   消息队列的属性；同样可以设置该数据结构。
}
msg(kern_ipc_perm){
kern_ipc_perm   # 内核中记录消息队列的全局数据结构msg_ids能够访问到该结构；
key_t   key;    # 该键值则唯一对应一个消息队列
uid_t   uid;    # 有效用户ID
gid_t   gid;    # 有效组ID
uid_t   cuid;   # 创建用户ID
gid_t   cgid;   # 创建组ID
mode_t  mode;   # msgflg 9位mask
unsigned long seq; # 可忽略
msg_qnum，msg_lspid，msg_lrpid，msg_stime，msg_rtime被设置为0
msg_ctime # 当前时间
msg_qbytes # MSGMNB
}
# file to key
msg(ftok){  -> msgget(2), semget(2), or shmget(2)
key_t ftok(const char *pathname, int proj_id); # 返回与路径pathname相对应的一个键值。
pathname: 存在于文件系统可以访问的文件
proj_id : 最后8bit非全0的整数
错误码：stat函数的错误码

key的31~24位为ftok函数第二个参数proj_id的低8位。
key的23~16位为该文件stat结构中st_dev属性的低8位。
key的15~0位为该文件stat结构中st_ino属性的低16位。
}
msg(IPC_PRIVATE){
  使用IPC_PRIVATE创建的IPC对象, key值属性为0，和IPC对象的编号就没有了对应关系。这样毫无关系的进程，
就不能通过key值来得到IPC对象的编号（因为这种方式创建的IPC对象的key值都是0）。因此，这种方式产生的IPC对象，
和无名管道类似，不能用于毫无关系的进程间通信。但也不是一点用处都没有，仍然可以用于有亲缘关系的进程间通信。

使用IPC_PRIVATE方式注意
int shmID=shmget(IPC_PRIVATE,len,IPC_CREAT|0600);需要在父子进程都可见的地方调用(即在创建子进程之前)，否则不能实现内存的共享
    因为通过IPC_PRIVATE这个key获得的id不一样，其他通过ftok获得的key来shmget获得的id在程序每次运行中是一样的。
ftok参数一样的话每次程序运行中返回值都一样。
}
msg(ipc){
linux为操作系统V进程间通信的三种方式(消息队列、信号灯、共享内存区)提供了一个统一的用户界面：
int ipc(unsigned int call, int first, int second, int third, void * ptr, long fifth);
第一个参数指明对IPC对象的操作方式，对消息队列而言共有四种操作：
  MSGSND 向消息队列发送消息
  MSGRCV 从消息队列读取消息
  MSGGET 打开或创建消息队列
  MSGCTL 控制消息队列
    int ipc( MSGGET, intfirst, intsecond, intthird, void*ptr, longfifth); 
    与该操作对应的系统V调用为：int msgget( (key_t)first，second)。
    int ipc( MSGCTL, intfirst, intsecond, intthird, void*ptr, longfifth) 
    与该操作对应的系统V调用为：int msgctl( first，second, (struct msqid_ds*) ptr)。
    int ipc( MSGSND, intfirst, intsecond, intthird, void*ptr, longfifth); 
    与该操作对应的系统V调用为：int msgsnd( first, (struct msgbuf*)ptr, second, third)。
    int ipc( MSGRCV, intfirst, intsecond, intthird, void*ptr, longfifth); 
    与该操作对应的系统V调用为：int msgrcv( first，(struct msgbuf*)ptr, second, fifth,third)，
first参数代表唯一的IPC对象；
}
msg(msgget){
int msgget(key_t key, int msgflg) # 返回与健值key相对应的消息队列描述字
msgflg参数是一些标志位。该调用    # 创建消息队列
1. 如果没有消息队列与健值key相对应，并且msgflg中包含了IPC_CREAT标志位
2. key参数为IPC_PRIVATE
参数msgflg可以为以下：IPC_CREAT、IPC_EXCL、IPC_NOWAIT或三者的或结果。
# IPC_PRIVATE并不意味着其他进程不能访问该消息队列，只意味着即将创建新的消息队列。
调用返回：成功返回消息队列描述字，否则返回-1 && errno EACCES|EEXIST|ENOENT|ENOMEM|ENOSPC

msg_id = msgget(key, IPC_CREATE | IPC_EXCL | 0x0666);
0          获取已经存在的消息队列
IPC_CREAT  创建
IPC_EXCL   不存在则创建，存在则errno=EEXIST
0x0666     权限

消息队列的容量由msg_qbytes控制，在消息队列被创建的过程中，这个大小被初始化为MSGMNB，这个限制可以通过msgctl()修改
}
msg(msgrcv){ -> 取消息是不一定遵循先进先出的， 也可以按消息的类型字段取消息。  读权限
int msgrcv(int msqid, struct msgbuf *msgp, int msgsz, long msgtyp, int msgflg);
# 该系统调用从msgid代表的消息队列中读取一个消息，并把消息存储在msgp指向的msgbuf结构中。
msqid   为消息队列描述字；
msgp    消息返回后存储在msgp指向的地址，
msgsz   msgbuf的mtext成员的长度(即消息内容的长度)，不能等于0
    如果消息的长度>msgsz且msgflg里有MSG_NOERROR，则消息会被截断，被截断的部分会丢失
    如果消息的长度>msgsz且msgflg里没有MSG_NOERROR，那么会出错，报E2BIG。
msgtyp  为请求读取的消息类型
  type == 0，返回队列中的第一个消息；
  type > 0，返回队列中消息类型为 type 的第一个消息；
  msgflg | MSG_EXCEPT : 返回队列中消息类型不为 type 的第一个消息；
  type < 0，返回队列中消息类型值小于或等于 type 绝对值的消息，如果有多个，则取类型值最小的消息。
读消息标志msgflg可以为以下几个常值的或：
  IPC_NOWAIT  如果没有满足条件的消息，调用立即返回，此时， # errno=ENOMSG
  IPC_EXCEPT  与msgtyp>0配合使用，返回队列中第一个类型不为msgtyp的消息
  IPC_NOERROR 如果队列中满足条件的消息内容大于所请求的msgsz字节，则把该消息截断，截断部分将丢失。
msgrcv()解除阻塞的条件有三个：
  消息队列中有了满足条件的消息；
  msqid代表的消息队列被删除       # EIDRM
  调用msgrcv()的进程被信号中断    # EINTR
调用返回：成功返回读出消息的实际字节数，否则返回-1。
msg_lrpid   # 接收消息进程ID
msg_qnum    # 消息队列数据总数
msg_rtime   # 最近接收时间
}
msg(msgsnd){ 写权限 msgsz不能等于0 msgflg|IPC_NOWAIT:非阻塞-EAGAIN； MSGMAX-/proc/sys/kernel/msgmax；MSGMNB-/proc/sys/kernel/msgmnb
int msgsnd(int msqid, struct msgbuf *msgp, int msgsz, int msgflg);
1. msgsz消息的大小, 该参数用于指定消息内容的大小, 不包括消息的类型。只能sizeof(Msgbuf.mtext),不能sizeof(Msgbuf)
# 向msgid代表的消息队列发送一个消息，即将发送的消息存储在msgp指向的msgbuf结构中，消息的大小由msgze指定。
  对发送消息来说，有意义的msgflg标志为IPC_NOWAIT，指明在消息队列没有足够空间容纳要发送的消息时，msgsnd是否等待。
造成msgsnd()等待的条件有两种：
    当前消息的大小与当前消息队列中的字节数之和超过了消息队列的总容量；
    当前消息队列的消息数（单位"个"）不小于消息队列的总容量（单位"字节数"），此时，虽然消息队列中的消息数目很多，但基本上都只有一个字节。
msgsnd()解除阻塞的条件有三个：
    不满足上述两个条件，即消息队列中有容纳该消息的空间；
    msqid代表的消息队列被删除 # EIDRM
    调用msgsnd（）的进程被信号中断 # EINTR
调用返回：成功返回0，否则返回-1
msg_lspid  # 发送消息进程ID
msg_qnum   # 消息队列数据总数
msg_stime  # 最近发送时间

struct msgmbuf msg_mbuf;  
msg_mbuf.mtype = 10; # 消息大小10字节  
memcpy(msg_mbuf.mtext, "测试消息", sizeof("测试消息"));  
int ret = msgsnd(msg_id, &msg_mbuf, sizeof("测试消息"), IPC_NOWAIT); 
}
msg(msgctl - msqid_ds){ -> msqid_ds ipc_perm
int msgctl(int msqid, int cmd, struct msqid_ds *buf);
该系统调用对由msqid标识的消息队列执行cmd操作，共有三种cmd操作：IPC_STAT、IPC_SET 、IPC_RMID。
  IPC_STAT：该命令用来获取消息队列信息，返回的信息存贮在buf指向的msqid结构中；
  IPC_SET： 该命令用来设置消息队列的属性，要设置的属性存储在buf指向的msqid结构中；可设置属性包括
            msg_perm.uid、msg_perm.gid、msg_perm.mode以及msg_qbytes，同时，也影响msg_ctime成员。
  IPC_RMID：删除msqid标识的消息队列；
  IPC_INFO: Linux支持
调用返回：成功返回0，否则返回-1。
}

sem(总体){
信号灯有以下两种类型：
  二值信号灯：最简单的信号灯形式，信号灯的值只能取0或1，类似于互斥锁。
  计算信号灯：信号灯的值可以取任意非负值（当然受内核本身的约束）
1. 系统V信号灯是随内核持续的，只有在内核重起或者显示删除一个信号灯集时，该信号灯集才会真正被删除。
  因此系统中记录信号灯的数据结构（struct ipc_ids sem_ids）位于内核中，系统中的所有信号灯都可以在
  结构sem_ids中找到访问入口。
  
2. struct sem结构如下：
    struct sem{
    int semval;     // current value
    int sempid      // pid of last operation
    }
    
1、  打开或创建信号灯 
  与消息队列的创建及打开基本相同，不再详述。
2、  信号灯值操作 
  linux可以增加或减小信号灯的值，相应于对共享资源的释放和占有。具体参见后面的semop系统调用。
3、  获得或设置信号灯属性： 
  系统中的每一个信号灯集都对应一个struct sem_array结构，该结构记录了信号灯集的各种信息，存在于系统空间。
  为了设置、获得该信号灯集的各种信息及属性，在用户空间有一个重要的联合结构与之对应，即union semun。
}
sem(ipc){
int ipc(unsigned int call, int first, int second, int third, void *ptr, long fifth);
参数call取不同值时，对应信号灯的三个系统调用： 
当call为SEMOP时，对应int semop(int semid, struct sembuf *sops, unsigned nsops)调用； 
当call为SEMGET时，对应int semget(key_t key, int nsems, int semflg)调用； 
当call为SEMCTL时，对应int semctl(int semid，int semnum，int cmd，union semun arg)调用；
}
sem(semget){ nsems->(0,SEMMSL]
int semget(key_t key, int nsems, int semflg) 
参数nsems指定打开或者新创建的信号灯集中将包含信号灯的数目；
msgflg参数是一些标志位。该调用    # 创建信号量
1. 如果没有消息队列与健值key相对应，并且msgflg中包含了IPC_CREAT标志位
2. key参数为IPC_PRIVATE
参数msgflg可以为以下：IPC_CREAT、IPC_EXCL、IPC_NOWAIT或三者的或结果。
调用返回：成功返回信号灯集描述字，否则返回-1。 
int semid = semget(key,1,IPC_CREAT|IPC_EXCL|0664);
int semid = semget(key,0,IPC_CREATE|IPC_EXCL|0666);
nsems: 信号量集的大小/信号量的个数，0表示获取已经存在的信号量集
semflg:
  0          获取已经存在的信号量集
  IPC_CREAT  创建
  IPC_EXCL   不存在则创建，存在则errno=EEXIST
  0x0666     权限

SEMMNI  /proc/sys/kernel/sem(第4个值) 最大信号集个数
SEMMSL  /proc/sys/kernel/sem(第1个值) 每个信号集中包含信号量个数
SEMMNS  /proc/sys/kernel/sem(第2个值) SEMMSL * SEMMNI
注：如果key所代表的信号灯已经存在，且semget指定了IPC_CREAT|IPC_EXCL标志，那么即使参数nsems与原来信号灯的数目不等，返回的也是EEXIST错误；
    如果semget只指定了IPC_CREAT标志，那么参数nsems必须与原来的值一致，
}
sem(semop){
int semop(int semid, struct sembuf *sops, unsigned nsops); 
semid是信号灯集ID，sops指向数组的每一个sembuf结构都刻画一个在特定信号灯上的操作。nsops为sops指向数组的大小
# 每个信号集中的信号关联的变量
unsigned short  semval;   # semaphore value 
unsigned short  semzcnt;  # waiting for zero 
unsigned short  semncnt;  # waiting for increase 
pid_t           sempid;   # process that did last op 

sembuf结构如下：
struct sembuf { -> 信号量操作sembuf结构
    unsigned short      sem_num; # 信号量的编号
    short           sem_op;      # 信号量的操作。
    # 如果为正，则从信号量中加上一个值，
    # 如果为负，则从信号量中减掉一个值，
    # 如果为0，则将进程设置为睡眠状态，直到信号量的值为0为止。  
    short           sem_flg;      # 信号的操作标志，一般为IPC_NOWAIT 和 SEM_UNDO
};
struct sembuf sops = {0, +1, IPC_NOWAIT};   # 对索引值为0的信号量加一。  
semop(semid, &sops, 1);                     # 以上功能执行的次数为一次。 

调用返回：成功返回0，否则返回-1。
SEMOPM ->  /proc/sys/kernel/sem(第3个值) 进行最大操作
SEMVMX ->  /proc/sys/kernel/sem 65536
若sem_op > 0，表示进程释放相应的资源数，将 sem_op 的值加到信号量的值上。如果有进程正在休眠等待此信号量，则唤醒它们 
若sem_op < 0，请求 sem_op 的绝对值的资源。如果相应的资源数可以满足请求，则将该信号量的值减去sem_op的绝对值，函数成功返回。
    当相应的资源数不能满足请求时，这个操作与sem_flg有关。
        sem_flg 指定IPC_NOWAIT，则semop函数出错返回EAGAIN。
        sem_flg 没有指定IPC_NOWAIT，则将该信号量的semncnt值加1，然后进程挂起直到下述情况发生：
            当相应的资源数可以满足请求，此信号量的semncnt值减1，该信号量的值减去sem_op的绝对值。成功返回；
            此信号量被删除，函数smeop出错返回EIDRM；
            进程捕捉到信号，并从信号处理函数返回，此情况下将此信号量的semncnt值减1，函数semop出错返回EINTR
若sem_op == 0，进程阻塞直到信号量的相应值为0：  # wait-for-zero  EAGAIN
    当信号量已经为0，函数立即返回。
    如果信号量的值不为0，则依据sem_flg决定函数动作：
        sem_flg指定IPC_NOWAIT，则出错返回EAGAIN。
        sem_flg没有指定IPC_NOWAIT，则将该信号量的semzcnt值加1，然后进程挂起直到下述情况发生：
            信号量值为0，将信号量的semzcnt的值减1，函数semop成功返回；
            此信号量被删除，函数smeop出错返回EIDRM
            进程捕捉到信号，并从信号处理函数返回，在此情况将此信号量的semncnt值减1，函数semop出错返回EINTR
            timeout: EAGAIN
            
struct sembuf sops[2];
int semid;

/* Code to set semid omitted */

sops[0].sem_num = 0;        /* Operate on semaphore 0 */
sops[0].sem_op = 0;         /* Wait for value to equal 0 */
sops[0].sem_flg = 0;

sops[1].sem_num = 0;        /* Operate on semaphore 0 */
sops[1].sem_op = 1;         /* Increment value by one */
sops[1].sem_flg = 0;

if (semop(semid, sops, 2) == -1) {
   perror("semop");
   exit(EXIT_FAILURE);
}
}
sem(semctl - semid_ds){
int semctl(int semid, int semnum, int cmd, union semun arg) # 支持3个参数或4个参数，存在第4个参数，则参数为semun
实现对信号灯的各种控制操作，
   参数semid指定信号灯集，
   参数semnum指定信号量集的下标(这个信号量集里的哪个信号量)，
   参数cmd指定具体的操作类型；只对几个特殊的cmd操作有意义；
arg用于设置或返回信号灯信息
# union semun 联合体如下：
int              val;    /* Value for SETVAL */
struct semid_ds *buf;    /* Buffer for IPC_STAT, IPC_SET */
unsigned short  *array;  /* Array for GETALL, SETALL */
struct seminfo  *__buf;  /* Buffer for IPC_INFO (Linux-specific) */
# semid_ds结构体如下：
struct ipc_perm sem_perm;  /* Ownership and permissions */
time_t          sem_otime; /* Last semop time */
time_t          sem_ctime; /* Last change time */
unsigned short  sem_nsems; /* No. of semaphores in set */
# ipc_perm结构体如下：
key_t          __key; /* Key supplied to semget(2) */
uid_t          uid;   /* Effective UID of owner */
gid_t          gid;   /* Effective GID of owner */
uid_t          cuid;  /* Effective UID of creator */
gid_t          cgid;  /* Effective GID of creator */
unsigned short mode;  /* Permissions */
unsigned short __seq; /* Sequence number */
               
IPC_STAT    获取信号灯信息，信息由arg.buf返回；
IPC_SET     设置信号灯信息，待设置信息保存在arg.buf中
IPC_RMDI    忽略第4个参数
  GETALL      返回所有信号灯的值，结果保存在arg.array中，参数sennum被忽略；
  GETNCNT     返回等待semnum所代表信号灯的值增加的进程数，相当于目前有多少进程在等待semnum代表的信号灯所代表的共享资源；
  GETPID      返回最后一个对semnum所代表信号灯执行semop操作的进程ID；
  GETVAL      返回semnum所代表信号灯的值；
  GETZCNT     返回等待semnum所代表信号灯的值变成0的进程数；
  SETALL      通过arg.array更新所有信号灯的值；同时，更新与本信号集相关的semid_ds结构的sem_ctime成员；
  SETVAL      设置semnum所代表信号灯的值为arg.val；

Cmd         return value
GETNCNT     semncnt
GETPID      sempid
GETVAL      semval
GETZCNT     semzcnt
}
sem_queue(){
/* 系统中每个因为信号灯而睡眠的进程，都对应一个sem_queue结构*/
 struct sem_queue {
  struct sem_queue *  next;     /* next entry in the queue */
  struct sem_queue **  prev; 
  /* previous entry in the queue, *(q->prev) == q */
  struct task_struct*  sleeper;   /* this process */
  struct sem_undo *  undo;     /* undo structure */
  int   pid;             /* process id of requesting process */
  int   status;           /* completion status of operation */
  struct sem_array *  sma;       /* semaphore array for operations */
  int  id;               /* internal sem id */
  struct sembuf *  sops;       /* array of pending operations */
  int  nsops;             /* number of operations */
  int  alter;             /* operation will alter semaphore */
};
}
semun(信号量数据结构){
union semun {
    int val;                    /* value for SETVAL */
    struct semid_ds *buf;       /* buffer for IPC_STAT & IPC_SET */
    unsigned short *array;      /* array for GETALL & SETALL */
    struct seminfo *__buf;      /* buffer for IPC_INFO */   //test!!
    void *__pad;
};
struct  seminfo {
    int semmap;
    int semmni;
    int semmns;
    int semmnu;
    int semmsl;
    int semopm;
    int semume;
    int semusz;
    int semvmx;
    int semaem;
};
struct semid_ds { -> 每个信号量集合都维护一个semid_ds结构
   struct ipc_perm sem_perm;  /* Ownership and permissions */
   time_t          sem_otime; /* Last semop time */
   time_t          sem_ctime; /* Last change time */
   unsigned short  sem_nsems; /* No. of semaphores in set */
};
}
shm(总体){
系统调用mmap()通过映射一个普通文件实现共享内存。
系统V则是通过映射特殊文件系统shm中的文件实现进程间的共享内存通信。
也就是说，每个共享内存区域对应特殊文件系统shm中的一个文件

1. 系统V共享内存中的数据，从来不写入到实际磁盘文件中去；而通过mmap()映射普通文件实现的共享内存通信可以
   指定何时将数据写入磁盘文件中。 
   注：前面讲到，系统V共享内存机制实际是通过映射特殊文件系统shm中的文件实现的，文件系统shm的安装点在
   交换分区上，系统重新引导后，所有的内容都丢失。
2. 系统V共享内存是随内核持续的，即使所有访问共享内存的进程都已经正常终止，共享内存区仍然存在
   （除非显式删除共享内存），在内核重新引导之前，对该共享内存区域的任何改写操作都将一直保留。
3. 通过调用mmap()映射普通文件进行进程间通信时，一定要注意考虑进程何时终止对通信的影响。
   而通过系统V共享内存实现通信的进程则不然。 
}

shm(shmget){
int shmget(key_t key,size_t size,int shmflg);  
# shmget函数用来创建一个新的共享内存段，或者访问一个现有的共享内存段(不同进程只要key值相同即可访问同一共享内存段)。
第一个参数key是ftok生成的键值，
第二个参数size:共享内存的大小，实际会按照页的大小(PAGE_SIZE)来分配。0表示获取已经分配好的共享内存
第三个参数sem_flags是打开共享内存的方式。 
  IPC_CREAT:若不存在则创建, 需要在shmflg中＂|权限信息＂, eg: |0664; 若存在则打开
  IPC_EXCL:与IPC_CREAT搭配使用, 若存在则创建失败==>报错,set errno
  0 :获取已经存在的共享内存
sem_flags|mode_flags:SHM_HUGETLB|SHM_NORESERVE
# shmid_ds
shm_perm.cuid and shm_perm.uid
shm_perm.cgid and shm_perm.gid
shm_perm.mode
shm_segsz
shm_lpid, shm_nattch, shm_atime and shm_dtime are set to 0
shm_ctime 

int shmid = shmget(key, 1024, IPC_CREATE | IPC_EXCL | 0666);
# 第三个参数参考消息队列int msgget(key_t key,int msgflag);  
}
shm(shmat){
void *shmat(int shm_id,const void *shm_addr,int shmflg); 
shmat函数通过shm_id将共享内存连接到进程的地址空间中。
shm_addr可以由用户指定共享内存映射到进程空间的地址，shm_addr如果为NULL，表示由系统选择
  shmaddr != NULL 和 SHM_RND 则，按照SHMLBA最接近的一个虚拟页面
shmflg :操作的标志, 给0即可
  SHM_RDONLY表示挂接到该共享内存的进程必须有读权限
  SHM_REMAP (Linux-specific)表示如果要映射的共享内存已经有现存的内存，那么就将旧的替换

# 返回值为共享内存映射的地址。  
eg.char *shms = (char *)shmat(shmid, 0, 0); # shmid由shmget获得  

shm_atime is set to the current time.
shm_lpid is set to the process-ID of the calling process.
shm_nattch is incremented by one.
              
}
shm(shmdt){
int shmdt(const void *shm_addr); 
# shmdt函数将共享内存从当前进程中分离。 参数为共享内存映射的地址。  
shmdt(shms); 
shm_dtime is set to the current time.
shm_lpid is set to the process-ID of the calling process.
shm_nattch  is  decremented by one. 
              
}
shm(shmctl - shmid_ds){
int shmctl(int shm_id,int cmd,struct shmid_ds *buf);
# shmctl函数是控制函数，使用方法和消息队列msgctl()函数调用完全类似。
# 参数一shm_id是共享内存的句柄，
# cmd是向共享内存发送的命令，
# 最后一个参数buf是向共享内存发送命令的参数。 

# shmid_ds
struct ipc_perm shm_perm;    /* Ownership and permissions */
size_t          shm_segsz;   /* Size of segment (bytes) */
time_t          shm_atime;   /* Last attach time */
time_t          shm_dtime;   /* Last detach time */
time_t          shm_ctime;   /* Last change time */
pid_t           shm_cpid;    /* PID of creator */
pid_t           shm_lpid;    /* PID of last shmat(2)/shmdt(2) */
shmatt_t        shm_nattch;  /* No. of current attaches */

# ipc_perm
 key_t          __key;    /* Key supplied to shmget(2) */
uid_t          uid;      /* Effective UID of owner */
gid_t          gid;      /* Effective GID of owner */
uid_t          cuid;     /* Effective UID of creator */
gid_t          cgid;     /* Effective GID of creator */
unsigned short mode;     /* Permissions + SHM_DEST and
                           SHM_LOCKED flags */
unsigned short __seq;    /* Sequence number */

IPC_STAT
IPC_SET  # shm_ctime | shm_perm.uid | shm_perm.gid | shm_perm.mode | shm_perm.uid | shm_perm.gid
IPC_RMID    最后一个shmat挂载
SHM_LOCK    防止系统将共享内存放到swap区，IPC_STAT读到的信息中SHM_LOCKED标记就被设置了
SHM_UNLOCK  解除锁定，即允许共享内存被系统放到swap区
}

shm(sheepdog){
共享内存输出日志
}

shm(busybox:syslogd,logread){
共享内存输出日志
}

shm(arm){
共享内存实现进程间数据共享
}

msg(心跳){
维持心跳，进程保活
}
Vipc(总结){
在内核中有相似的IPC结构(消息队列的msgid_ds，信号量的semid_ds，共享内存的shmid_ds)
都用一个非负整数的标识符加以引用(消息队列的msg_id，信号量的sem_id，共享内存的shm_id，分别通过msgget、semget以及shmget获得)
标志符是IPC对象的内部名，每个IPC对象都有一个键(key_t key)相关联，将这个键作为该对象的外部名。

1、XSI IPC的IPC结构是在系统范围内起作用，没用使用引用计数。如果一个进程创建一个消息队列，并在消息队列中放入几个消息，
   进程终止后，即使现在已经没有程序使用该消息队列，消息队列及其内容依然保留。而PIPE在最后一个引用管道的进程终止时，
   管道就被完全删除了。对于FIFO最后一个引用FIFO的进程终止时，虽然FIFO还在系统，但是其中的内容会被删除。
2、和PIPE、FIFO不一样，XSI IPC不使用文件描述符，所以不能用ls查看IPC对象，不能用rm命令删除，不能用chmod命令删除它们
   的访问权限。只能使用ipcs和ipcrm来查看可以删除它们。
}
Vipc(内核限制){
kernel.msgmni=1000
kernel.msgmax=81920
kernel.msgmnb=163840

MSGMNB ：每个消息队列的最大字节限制。该文件指定一个消息队列的最大长度（bytes）。
MSGMNI ：整个系统的最大数量的消息队列。该文件指定消息队列标识的最大数目，即系统范围内最大多少个消息队列。
MSGGSZ ：消息片断的大小（字节）。大于该值的消息被分割成多个片断。
MSGSEG ：在单个队列里能存在的最大数量的消息片断。
MSGTQL ：整个系统的最大数量的消息。
MSGMAX ；单个消息的最大size。在某些操作系统例如BSD中，你不必设置这个。BSD自动设置它为MSGSSZ * MSGSEG。其他操作系统中，你也许需要改变这个参数的默认值，你可以设置它与MSGMNB相同。该文件指定了从一个进程发送到另一个进程的消息的最大长度（bytes）。进程间的消息传递是在内核的内存中进行的，不会交换到磁盘上，所以如果增加该值，则将增加操作系统所使用的内存数量。

SHMSEG ：每个进程的最大数量的共享内存片断。
SHMMNI ：共享内存片断数量的系统级的限制。
SHMMAX ：单个共享内存片断的最大size。
SHMALL ：可分配的共享内存数量的系统级限制。在某些系统上，SHMALL可能表示成页数量，而不是字节数量

# ipcs -l -> 显示消息队列的限制信息
------ Shared Memory Limits --------     # 共享内存限制
max number of segments = 4096                  # 
max seg size (kbytes) = 67108864               # 一次可提供最大共享内存大小
max total shared memory (kbytes) = 17179869184 # 系统可提供共享内存大小
min seg size (bytes) = 1                       # 一次可提供最小共享内存大小

------ Semaphore Limits --------          # 信号量限制
max number of arrays = 128                # 最大数组数量
max semaphores per array = 250            # 每个数组的最大信号量数目
max semaphores system wide = 32000        # 系统最大信号量数
max ops per semop call = 32               # 每次信号量调用最大操作数
semaphore max value = 32767               # 信号量最大值

------ Messages: Limits --------           # 同享内存限制 
max queues system wide = 15693             # MSGMNI //整个系统的最大数量的消息队列
max size of message (bytes) = 65536        # msgmax //单个消息的最大size。
default max size of queue (bytes) = 65536  # msgmnb //每个消息队列的最大字节限制。
}
ipc(命令){
pcs [-mqs] [-abcopt] [-C core] [-N namelist] 
-a : 显示当前系统中共享内存段、信号量集、消息队列的使用情况;  
-q：显示活动的消息队列信息  # -q -[u|l|t] -c | -p
-m：显示活动的共享内存信息  # -m -[u|l|t] -c | -p
-s：显示活动的信号量信息    # -s -[u|l|t] -c | -p

-a 使用时： 
-b 写入消息队列的队列上消息的最大字节数、共享内存段的大小、每个信号量集中信号量的数量。 
-c 写入构建该设施的用户的登录名和组名称。  creator
-o 写以下的使用信息：
    队列上的消息数 
    消息队列上消息的总字节数 
    连接在共享内存段上的进程数
-p 写进程编号的信息：pid
    最后接收消息队列上消息的进程号 
    最后在消息队列上发送消息的进程号 
    创建进程的进程号 
    最后一个连接或拆离共享内存段的进程编号
-t 写入时间信息：time
    最后一次更改所有设备访问许可权的控制操作的时间 
    消息队列上最后一次执行 msgsnd 和 msgrcv 的时间 
    共享内存上最后一次执行 shmat 和 shmdt 的时间 
    在信号量集上最后一次执行 semop 的时间
-l limits
-u summary 

-C CoreFile 用由 CoreFile 参数指定的文件来代替 /dev/mem 文件。CoreFile 参数是由 Ctrl-(left)Alt-Pad1 按键顺序创建的内存映象文件。 
-N Kernel 用指定的 Kernel（ /usr/lib/boot/unix 文件是缺省的）。

清除命令是ipcrm [-m|-s|-q] semid 
-m 删除共享内存 
-s 删除共享信号量 
-q 删除共享队列

ipcmk # 创建或修改
ipcmk -M 1024(size)
ipcmk -M 1024(size) -p 0666
}
mmap(){
void *mmap(void*start,size_t length,int prot,int flags,int fd,off_t offset); 
# mmap函数将一个文件或者其它对象映射进内存。 
第一个参数为映射区的开始地址，设置为0表示由系统决定映射区的起始地址，
第二个参数为映射的长度，
第三个参数为期望的内存保护标志，
第四个参数是指定映射对象的类型，
第五个参数为文件描述符（指明要映射的文件），
第六个参数是被映射对象内容的起点。
成功返回被映射区的指针，失败返回MAP_FAILED[其值为(void *)-1]。  
int munmap(void* start,size_t length); 
# munmap函数用来取消
参数start所指的映射内存起始地址，
参数length则是欲取消的内存大小。
如果解除映射成功则返回0，否则返回-1，错误原因存于errno中错误代码EINVAL。   
int msync(void *addr,size_t len,int flags); 
# msync函数实现磁盘文件内容和共享内存取内容一致，即同步。
第一个参数为文件映射到进程空间的地址，
第二个参数为映射空间的大小，
第三个参数为刷新的参数设置。  
}