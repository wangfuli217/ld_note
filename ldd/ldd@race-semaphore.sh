semaphore(api)
{
1)定义信号量    struct semaphore sem;

2)初始化信号量   
void sema_init (struct semphore *sem, int val);    //设置sem为val
void init_MUTEX(struct semaphore *sem);    //初始化一个用户互斥的信号量sem设置为1
void init_MUTEX_LOCKED(struct semaphore *sem);    //初始化一个用户互斥的信号量sem设置为0

DECLARE_MUTEX(name);     //该宏定义信号量name并初始化1
DECLARE_MUTEX_LOCKED(name);    //该宏定义信号量name并初始化0

3)获得信号量                         //down已经不再推荐使用。
void down(struct semaphore *sem);    //该函数用于获取信号量sem，会导致睡眠，不能被信号打断,所以不能在中断上下文使用。
int down_interruptible(struct semaphore *sem);    //因其进入睡眠状态的进程能被信号打断，信号也会导致该函数返回，这是返回非0。
int down_trylock(struct semaphore *sem);//尝试获得信号量sem，如果能够获得，就获得并返回0，否则返回非0,不会导致调用者睡眠，可以在中断上下文使用
一般这样使用

if(down_interruptible(&sem))
{
    return  -ERESTARTSYS;
}

4)释放信号量
void up(struct semaphore *sem);    //释放信号量sem，唤醒等待者
信号量一般这样被使用，如下所示：
//定义信号量
DECLARE_MUTEX(mount_sem);
down(&mount_sem);//获取信号量，保护临界区
…
critical section //临界区
…
up(&mount_sem);


5. down_killable只能被fatal信号打断，这种信号通常用来终止进程，因此down_killable用了保证用户进程可以被杀死，
否则一旦有死锁进程，则只能重启系统。

}

rw_semphore(API)
{
使用方法：
1)定义和初始化读写信号量
struct rw_semphore my_rws;    //定义读写信号量
void init_rwsem(struct rw_semaphore *sem);    //初始化读写信号量
2)读信号量获取
void down_read(struct rw_semaphore *sem);
int down_read_try(struct rw_semaphore *sem);
3)读信号量释放
void up_read(struct rw_semaphore *sem);
4)写信号量获取
void down_write(struct rw_semaphore *sem);
int down_write_try(struct rw_semaphore *sem);
5)写信号量释放
void up_write(struct rw_semaphore *sem);
}

mutex(API)
{
使用方法：
1)定义并初始化互斥体
struct mutex my_mutex;
mutex_init(&my_mutex);
2)获取互斥体
void fastcall mutex_lock(struct mutex *lock);//引起的睡眠不能被打断
int fastcall mutex_lock_interruptible(struct mutex *lock);//可以被打断
int fastcall mutex_lock_trylock(struct mutex *lock);//尝试获得，获取不到也不会导致进程休眠
3)释放互斥体
void fastcall mutex_unlock(struct mutex *lock);
}

https://www.ibm.com/developerworks/cn/linux/l-synch/part1/

	信号量在创建时需要设置一个初始值，表示同时可以有几个任务可以访问该信号量保护的共享资源，初始值为1就变成互斥锁（Mutex），
即同时只能有一个任务可以访问信号量保护的共享资源。一个任务要想访问共享资源，首先必须得到信号量，获取信号量的操作将把信号量的
值减1，若当前信号量的值为负数，表明无法获得信号量，该任务必须挂起在该信号量的等待队列等待该信号量可用；若当前信号量的值为非
负数，表示可以获得信号量，因而可以立刻访问被该信号量保护的共享资源。当任务访问完被信号量保护的共享资源后，必须释放信号量，
释放信号量通过把信号量的值加1实现，如果信号量的值为非正数，表明有任务等待当前信号量，因此它也唤醒所有等待该信号量的任务。

1. 以上init_MUTEX和DECLARE_MUTEX_LOCKED是linux3.0以后版本被废除的函数，应使用void sema_init(struct semaphore *sem, int val);
2. 推荐使用down_interruptible需要格外小心，若操作被中断，该函数会返回非零值，而调用这不会拥有该信号量。对down_interruptible的
   正确使用需要始终检查返回值，并做出相应的响应。
3. 带有“_trylock”的永不休眠，若信号量在调用是不可获得，会返回非零值。
semaphore()
{

1. 竟态会导致对共享数据的非控制访问，产生出的访问模式时，会产生非预期的结果。

asm/semaphore.h
struct semaphore;
    //信号量
	void sema_init(struct semaphore *sem, int val); // 信号量  /*初始化函数*/
	设置初始化设置信号量的初值，它设置信号量sem的值为val。
	
	
	// 互斥体
	DECLARE_MUTEX(name);           # name的信号量初始值为1  /*方法一、声明+初始化宏*/
	DECLARE_MUTEX_LOCKED(name);    # name的信号量初始值为0  /*方法一、声明+初始化宏*/
	
    
	void init_MUTEX (struct semaphore *sem);        # 初始化一个互斥锁，即它把信号量sem的值设置为1。 /*方法二、初始化函数*/
	void init_MUTEX_LOCKED (struct semaphore *sem); # 初始化一个互斥锁，即它把信号量sem的值设置为0。 /*方法二、初始化函数*/
	
	// 操作函数  ->会建立不可杀进程
	void down(struct semaphore *sem);
	用于获得信号量sem，它会导致睡眠，因此不能在中断上下文（包括IRQ上下文和softirq上下文）使用该函数。该函数将把sem的值减1，
	如果信号量sem的值非负，就直接返回，否则调用者将被挂起，直到别的任务释放该信号量才能继续运行。
	
	int __must_check down_interruptible(struct semaphore *sem); #可中断操作
	down不会被信号（signal）打断，但down_interruptible能被信号打断，因此该函数有返回值来区分是正常返回还是被信号中断，如果返回0，
	表示获得信号量正常返回，如果被信号打断，返回-EINTR。
	
	使用down_interruptible需要额外小心，如果操作被中断，该函数会返回非零值，而调用者不会拥有该信号量。
	
	ERESTARTSYS: 必须首先撤销应经做出的任何用户可见的修改，这样，系统调用可正确重试
	EINTR:       无法撤销已经做出的任何用户可见的修改。
	
	int __must_check down_trylock(struct semaphore *sem);
	永远不会休眠；如果信号量在调用是不可获得，down_trylock会立刻返回一个非零值。
	试着获得信号量sem，如果能够立刻获得，它就获得该信号量并返回0，否则，表示不能获得信号量sem，返回值为非0值。因此，它不会导致调用者睡眠，
	可以在中断上下文使用。
	
	int __must_check down_timeout(struct semaphore *sem, long jiffies);
	
	void up(struct semaphore *sem);
    该函数释放信号量sem，即把sem的值加1，如果sem的值为非正数，表明有任务等待该信号量，因此唤醒这些等待者。

----  只包含在2.6内核中 ----	

	在内核源码树的kernel/printk.c中，使用宏DECLARE_MUTEX声明了一个互斥锁console_sem，它用于保护console驱动列表
console_drivers以及同步对整个console驱动系统的访问，其中定义了函数acquire_console_sem来获得互斥锁console_sem，
定义了release_console_sem来释放互斥锁console_sem，定义了函数try_acquire_console_sem来尽力得到互斥锁console_sem。
这三个函数实际上是分别对函数down，up和down_trylock的简单包装。需要访问console_drivers驱动列表时就需要使用
acquire_console_sem来保护console_drivers列表，当访问完该列表后，就调用release_console_sem释放信号量console_sem。
函数console_unblank，console_device，console_stop，console_start，register_console和unregister_console都需要访问
console_drivers，因此它们都使用函数对acquire_console_sem和release_console_sem来对console_drivers进行保护。
}


mutex()
{
方法                              描述
mutex_lock(struct mutex *)      为指定的mutex上锁，如果锁不可用则睡眠
mutex_unlock(struct mutex *)    为指定的mutex解锁
mutex_trylock(struct mutex *)   试图获取指定的mutex，如果成功则返回1；否则锁被获取，返回0
mutex_is_locked(struct mutex *) 如果锁已被争用，则返回1；否则返回0
}


	