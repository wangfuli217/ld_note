---
title: 锁和同步
comments: true
---

# 锁种类

## 强制锁

尝试性文件锁需要各个进程的无私合作，试想A进程获得一个 写 的文件锁，它开始往文件里写操作。 同时B进程，却没有去尝试获取写操作，它也同样可以进行写操作。但是很显然，B进程违反了游戏规则。我们称之为不合作进程。 尝试性文件锁，需要各个进程遵守统一规则，在文件访问时，都要礼貌的去尝试获得文件锁，然后进一步操作。

<!--more-->

## 建议性锁

强制性文件锁不需要进程的合作，强制性文件锁是通过内核强制检查文件的打开，读写操作是否符合文件锁的使用规则。为了是强制性文件锁工作，我们必须要在文件系统上激活它，必要的操作包括挂载mount文件系统，通过 “-o mand”参数选项，对于文件锁施加的文件，打开 set-group-id 位，并且关闭 group-execute 位。我们必须选择这种顺序，因为你一旦关闭 group-execute 位，set-group-id 就没有意义了

## 非递归锁

锁一旦被加锁就不能再施加加锁动作，如果再次加锁会被阻塞，放到该锁的等待队列上

## 递归锁

递归锁就是锁在被持有的条件下，能继续加锁，解锁需要和加锁同样的次数

    #include "apue.h"
    #include <pthread.h>
    #include <time.h>
    #include <sys/time.h>

    extern int makethread(void *(*)(void *), void *);

    struct to_info {
    	void	      (*to_fn)(void *);	/* function */
    	void           *to_arg;			/* argument */
    	struct timespec to_wait;		/* time to wait */
    };

    #define SECTONSEC  1000000000	/* seconds to nanoseconds */

    #if !defined(CLOCK_REALTIME) || defined(BSD)
    #define clock_nanosleep(ID, FL, REQ, REM)	nanosleep((REQ), (REM))
    #endif

    #ifndef CLOCK_REALTIME
    #define CLOCK_REALTIME 0
    #define USECTONSEC 1000		/* microseconds to nanoseconds */

    void
    clock_gettime(int id, struct timespec *tsp)
    {
    	struct timeval tv;

    	gettimeofday(&tv, NULL);
    	tsp->tv_sec = tv.tv_sec;
    	tsp->tv_nsec = tv.tv_usec * USECTONSEC;
    }
    #endif

    void *
    timeout_helper(void *arg)
    {
    	struct to_info	*tip;

    	tip = (struct to_info *)arg;
    	clock_nanosleep(CLOCK_REALTIME, 0, &tip->to_wait, NULL);
    	(*tip->to_fn)(tip->to_arg);
    	free(arg);
    	return(0);
    }

    void
    timeout(const struct timespec *when, void (*func)(void *), void *arg)
    {
    	struct timespec	now;
    	struct to_info	*tip;
    	int				err;

    	clock_gettime(CLOCK_REALTIME, &now);
    	if ((when->tv_sec > now.tv_sec) ||
    	  (when->tv_sec == now.tv_sec && when->tv_nsec > now.tv_nsec)) {
    		tip = malloc(sizeof(struct to_info));
    		if (tip != NULL) {
    			tip->to_fn = func;
    			tip->to_arg = arg;
    			tip->to_wait.tv_sec = when->tv_sec - now.tv_sec;
    			if (when->tv_nsec >= now.tv_nsec) {
    				tip->to_wait.tv_nsec = when->tv_nsec - now.tv_nsec;
    			} else {
    				tip->to_wait.tv_sec--;
    				tip->to_wait.tv_nsec = SECTONSEC - now.tv_nsec +
    				  when->tv_nsec;
    			}
    			err = makethread(timeout_helper, (void *)tip);
    			if (err == 0)
    				return;
    			else
    				free(tip);
    		}
    	}

    	/*
    	 * We get here if (a) when <= now, or (b) malloc fails, or
    	 * (c) we can't make a thread, so we just call the function now.
    	 */
    	(*func)(arg);
    }

    pthread_mutexattr_t attr;
    pthread_mutex_t mutex;

    void
    retry(void *arg)
    {
    	pthread_mutex_lock(&mutex);

    	/* perform retry steps ... */

    	pthread_mutex_unlock(&mutex);
    }

    int
    main(void)
    {
    	int				err, condition, arg;
    	struct timespec	when;

    	if ((err = pthread_mutexattr_init(&attr)) != 0)
    		err_exit(err, "pthread_mutexattr_init failed");
    	if ((err = pthread_mutexattr_settype(&attr,
    	  PTHREAD_MUTEX_RECURSIVE)) != 0)
    		err_exit(err, "can't set recursive type");
    	if ((err = pthread_mutex_init(&mutex, &attr)) != 0)
    		err_exit(err, "can't create recursive mutex");

    	/* continue processing ... */

    	pthread_mutex_lock(&mutex);

    	/*
    	 * Check the condition under the protection of a lock to
    	 * make the check and the call to timeout atomic.
    	 */
    	if (condition) {
    		/*
    		 * Calculate the absolute time when we want to retry.
    		 */
    		clock_gettime(CLOCK_REALTIME, &when);
    		when.tv_sec += 10;	/* 10 seconds from now */
    		timeout(&when, retry, (void *)((unsigned long)arg));
    	}
    	pthread_mutex_unlock(&mutex);

    	/* continue processing ... */

    	exit(0);
    }

## 悲观锁

在关系数据库管理系统里，悲观并发控制（又名“悲观锁”，Pessimistic Concurrency Control，缩写“PCC”）是一种并发控制的方法。它可以阻止一个事务以影响其他用户的方式来修改数据。如果一个事务执行的操作都某行数据应用了锁，那只有当这个事务把锁释放，其他事务才能够执行与该锁冲突的操作。

悲观并发控制主要用于数据争用激烈的环境，以及发生并发冲突时使用锁保护数据的成本要低于回滚事务的成本的环境中。

悲观锁，正如其名，它指的是对数据被外界（包括本系统当前的其他事务，以及来自外部系统的事务处理）修改持保守态度(悲观)，因此，在整个数据处理过程中，将数据处于锁定状态。 悲观锁的实现，往往依靠数据库提供的锁机制 （也只有数据库层提供的锁机制才能真正保证数据访问的排他性，否则，即使在本系统中实现了加锁机制，也无法保证外部系统不会修改数据）

在数据库中，悲观锁的流程如下：

1. 在对任意记录进行修改前，先尝试为该记录加上排他锁（exclusive locking）。

2. 如果加锁失败，说明该记录正在被修改，那么当前查询可能要等待或者抛出异常。 具体响应方式由开发者根据实际需要决定。

3. 如果成功加锁，那么就可以对记录做修改，事务完成后就会解锁了。

4. 其间如果有其他对该记录做修改或加排他锁的操作，都会等待我们解锁或直接抛出异常。

MySQL InnoDB中使用悲观锁

要使用悲观锁，我们必须关闭mysql数据库的自动提交属性，因为MySQL默认使用autocommit模式，也就是说，当你执行一个更新操作后，MySQL会立刻将结果进行提交。set autocommit=0;

    //0.开始事务
    begin;/begin work;/start transaction; (三者选一就可以)
    //1.查询出商品信息
    select status from t_goods where id=1 for update;
    //2.根据商品信息生成订单
    insert into t_orders (id,goods_id) values (null,1);
    //3.修改商品status为2
    update t_goods set status=2;
    //4.提交事务
    commit;/commit work;

上面的查询语句中，我们使用了select…for update的方式，这样就通过开启排他锁的方式实现了悲观锁。此时在t_goods表中，id为1的 那条数据就被我们锁定了，其它的事务必须等本次事务提交之后才能执行。这样我们可以保证当前的数据不会被其它事务修改。

上面我们提到，使用select…for update会把数据给锁住，不过我们需要注意一些锁的级别，MySQL InnoDB默认行级锁。行级锁都是基于索引的，如果一条SQL语句用不到索引是不会使用行级锁的，会使用表级锁把整张表锁住，这点需要注意。

### 优点与不足

悲观并发控制实际上是“先取锁再访问”的保守策略，为数据处理的安全提供了保证。但是在效率方面，处理加锁的机制会让数据库产生额外的开销，还有增加产生死锁的机会；另外，在只读型事务处理中由于不会产生冲突，也没必要使用锁，这样做只能增加系统负载；还有会降低了并行性，一个事务如果锁定了某行数据，其他事务就必须等待该事务处理完才可以处理那行数

## 乐观锁

在关系数据库管理系统里，乐观并发控制（又名“乐观锁”，Optimistic Concurrency Control，缩写“OCC”）是一种并发控制的方法。它假设多用户并发的事务在处理时不会彼此互相影响，各事务能够在不产生锁的情况下处理各自影响的那部分数据。在提交数据更新之前，每个事务会先检查在该事务读取数据后，有没有其他事务又修改了该数据。如果其他事务有更新的话，正在提交的事务会进行回滚。乐观事务控制最早是由孔祥重（H.T.Kung）教授提出。

乐观锁（ Optimistic Locking ） 相对悲观锁而言，乐观锁假设认为数据一般情况下不会造成冲突，所以在数据进行提交更新的时候，才会正式对数据的冲突与否进行检测，如果发现冲突了，则让返回用户错误的信息，让用户决定如何去做。

相对于悲观锁，在对数据库进行处理的时候，乐观锁并不会使用数据库提供的锁机制。一般的实现乐观锁的方式就是记录数据版本。

数据版本,为数据增加的一个版本标识。当读取数据时，将版本标识的值一同读出，数据每更新一次，同时对版本标识进行更新。当我们提交更新的时候，判断数据库表对应记录的当前版本信息与第一次取出来的版本标识进行比对，如果数据库表当前版本号与第一次取出来的版本标识值相等，则予以更新，否则认为是过期数据。

实现数据版本有两种方式，第一种是使用版本号，第二种是使用时间戳。

使用版本号实现乐观锁

使用版本号时，可以在数据初始化时指定一个版本号，每次对数据的更新操作都对版本号执行+1操作。并判断当前版本号是不是该数据的最新的版本号。

    1.查询出商品信息
    select (status,status,version) from t_goods where id=#{id}
    2.根据商品信息生成订单
    3.修改商品status为2
    update t_goods
    set status=2,version=version+1
    where id=#{id} and version=#{version};

### 优点与不足

乐观并发控制相信事务之间的数据竞争(data race)的概率是比较小的，因此尽可能直接做下去，直到提交的时候才去锁定，所以不会产生任何锁和死锁。但如果直接简单这么做，还是有可能会遇到不可预期的结果，例如两个事务都读取了数据库的某一行，经过修改以后写回数据库，这时就遇到了问题。

# 进程间同步--锁

## 自旋锁

如果内核控制路径发现自旋锁“开着”（可以获取），就获取锁并继续自己的执行。相反，如果内核控制路径发现锁由运行在另一个CPU上的内核控制路径“锁着”，就在原地“旋转”，反复执行一条紧凑的循环检测指令，直到锁被释放。 自旋锁是循环检测“忙等”，即等待时内核无事可做（除了浪费时间），进程在CPU上保持运行，所以它保护的临界区必须小，且操作过程必须短。不过，自旋锁通常非常方便，因为很多内核资源只锁1毫秒的时间片段，所以等待自旋锁的释放不会消耗太多CPU的时间。自旋锁主要用在SMP（对称多核处理机）SpinLock的出现是因为Symmetric Multi-Processor的出现，如果是UniProcessor，用简单的DisableIRQ就可以满足其要求。

> 1. 中断，包括硬件中断和软件中断 （仅在中断代码可能访问临界区时需要）
>
>     这种干扰存在于任何系统中，一个中断的到来导致了中断例程的执行，如果在中断例程中访问了临界区，原子性就被打破了。所以如果在某种中断例程中存在访问某个临界区的代码，那么就必须用spinlock保护。对于不同的中断类型（硬件中断和软件中断）对应于不同版本的自旋锁实现，其中包含了中断禁用和开启的代码。但是如果你保证没有中断代码会访问临界区，那么使用不带中断禁用的自旋锁API即可。
>
> 2. 内核抢占（仅存在于可抢占内核中）
>
>     在2.6以后的内核中，支持内核抢占，并且是可配置的。这使UP系统和SMP类似，会出现内核态下的并发。这种情况下进入临界区就需要避免因抢占造成的并发，所以解决的方法就是在加锁时禁用抢占（preempt_disable(); ），在开锁时开启抢占（preempt_enable();注意此时会执行一次抢占调度） 。
>
> 3. 其他处理器对同一临界区的访问 （仅SMP系统）
>
>     在SMP系统中，多个物理处理器同时工作，导致可能有多个进程物理上的并发。这样就需要在内存加一个标志，每个需要进入临界区的代码都必须检查这个标志，看是否有进程已经在这个临界区中。这种情况下检查标志的代码也必须保证原子和快速，这就要求必须精细地实现，正常情况下每个构架都有自己的汇编实现方案，保证检查的原子性。

自旋锁变体的使用规则

>不论是抢占式UP、非抢占式UP还是SMP系统，只要在某类中断代码可能访问临界区，就需要控制中断，保证操作的原子性。所以这个和模块代码中临界区的访问还有关系，是否可能在中断中操作临界区，只有程序员才知道。所以自旋锁API中有针对不同中断类型的自旋锁变体：

不会在任何中断例程中操作临界区：

    static inline void spin_lock(spinlock_t *lock)
    static inline void spin_unlock(spinlock_t *lock)

如果在软件中断中操作临界区：

    static inline void spin_lock_bh(spinlock_t *lock)
    static inline void spin_unlock_bh(spinlock_t *lock)

bh代表bottom half，也就是中断中的底半部，因内核中断的底半部一般通过软件中断（tasklet等）来处理而得名。

如果在硬件中断中操作临界区：

    static inline void spin_lock_irq(spinlock_t *lock)
    static inline void spin_unlock_irq(spinlock_t *lock)

如果在控制硬件中断的时候需要同时保存中断状态：

    spin_lock_irqsave(lock, flags)
    static inline void spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)

1. 如果被保护的共享资源只在进程上下文访问和软中断（包括tasklet、timer）上下文访问，那么当在进程上下文访问共享资源时，可能被软中断打断，从而可能进入软中断上下文来对被保护的共享资源访问，因此对于这种情况，对共享资源的访问必须使用spin_lock_bh和spin_unlock_bh来保护。当然使用spin_lock_irq和spin_unlock_irq以及spin_lock_irqsave和spin_unlock_irqrestore也可以，它们失效了本地硬中断，失效硬中断隐式地也失效了软中断。但是使用spin_lock_bh和spin_unlock_bh是最恰当的，它比其他两个快。

2. 如果被保护的共享资源只在两个或多个tasklet或timer上下文访问，那么对共享资源的访问仅需要用spin_lock和spin_unlock来保护，不必使用_bh版本，因为当tasklet或timer运行时，不可能有其他tasklet或timer在当前CPU上运行。

3. 如果被保护的共享资源只在一个tasklet或timer上下文访问，那么不需要任何自旋锁保护，因为同一个tasklet或timer只能在一个CPU上运行，即使是在SMP环境下也是如此。实际上tasklet在调用tasklet_schedule标记其需要被调度时已经把该tasklet绑定到当前CPU，因此同一个tasklet决不可能同时在其他CPU上运行。timer也是在其被使用add_timer添加到timer队列中时已经被帮定到当前CPU，所以同一个timer绝不可能运行在其他CPU上。当然同一个tasklet有两个实例同时运行在同一个CPU就更不可能了。

4. 如果被保护的共享资源只在一个软中断（tasklet和timer除外）上下文访问，那么这个共享资源需要用spin_lock和spin_unlock来保护，因为同样的软中断可以同时在不同的CPU上运行。

5. 如果被保护的共享资源在两个或多个软中断上下文访问，那么这个共享资源当然更需要用spin_lock和spin_unlock来保护，不同的软中断能够同时在不同的CPU上运行。

6. 如果被保护的共享资源在软中断（包括tasklet和timer）或进程上下文和硬中断上下文访问，那么在软中断或进程上下文访问期间，可能被硬中断打断，从而进入硬中断上下文对共享资源进行访问，因此，在进程或软中断上下文需要使用spin_lock_irq和spin_unlock_irq来保护对共享资源的访问。

而在中断处理句柄中使用什么版本，需依情况而定，如果只有一个中断处理句柄访问该共享资源，那么在中断处理句柄中仅需要spin_lock和spin_unlock来保护对共享资源的访问就可以了。因为在执行中断处理句柄期间，不可能被同一CPU上的软中断或进程打断。

1. 但是如果有不同的中断处理句柄访问该共享资源，那么需要在中断处理句柄中使用spin_lock_irq和spin_unlock_irq来保护对共享资源的访问。

2. 在使用spin_lock_irq和spin_unlock_irq的情况下，完全可以用spin_lock_irqsave和spin_unlock_irqrestore取代，那具体应该使用哪一个也需要依情况而定，如果可以确信在对共享资源访问前中断是使能的，那么使用spin_lock_irq更好一些。因为它比spin_lock_irqsave要快一些，但是如果你不能确定是否中断使能，那么使用spin_lock_irqsave和spin_unlock_irqrestore更好，因为它将恢复访问共享资源前的中断标志而不是直接使能中断。

3. 当然，有些情况下需要在访问共享资源时必须中断失效，而访问完后必须中断使能，这样的情形使用spin_lock_irq和spin_unlock_irq最好。

4. spin_lock用于阻止在不同CPU上的执行单元对共享资源的同时访问以及不同进程上下文互相抢占导致的对共享资源的非同步访问，而中断失效和软中断失效却是为了阻止在同一CPU上软中断或中断对共享资源的非同步访问。

spinlock特性：

防止多处理器并发访问临界区，

1、非睡眠（该进程/LWP(Light Weight Process)始终处于Running的状态）

2、忙等 （cpu一直检测锁是否已经被其他cpu释放）

3、短期（低开销）加锁

4、适合中断上下文锁定

5、多cpu的机器才有意义（需要等待其他cpu释放锁）


自旋锁在获取锁之前会处于忙等，而不是通过休眠使进程阻塞。自旋锁可以阻塞中断，因为自旋锁底层由原子级汇编指令swap和test_and_set实现，因为中断只能发生在指令之间，所以自旋锁会屏蔽中断。在抢占式系统中，如果线程时间片到了，如果线程持有自旋锁，会导致其它需要这把锁的线程自旋时间更久。自旋锁可以设置自旋计数，达到一定计数后出错返回。

    int pthread_spin_init(pthread_spinlock_t *lock, int pshared);

pshared

>PTHREAD_PROCESS_SHARED，则可以由有访问自旋锁底层内存的线程所获取，即使该线程属于不同进程
>
>PTHREAD_PROCESS_PRIVATE，自旋锁只能被初始化该锁的进程内部线程所访问

    int pthread_spin_destroy(pthread_spinlock_t *lock);
    int pthread_spin_lock(pthread_spinlock_t *lock);
    int pthread_spin_trylock(pthread_spinlock_t *lock);
    不能获取锁立即返回EBUSY错误，不能自旋
    int pthread_spin_unlock(pthread_spinlock_t *lock);

## Ticket 自旋锁

由于传统自旋锁无序竞争的本质特点，内核执行线程无法保证何时可以取到锁，某些执行线程可能需要等待很长时间，导致“不公平”问题的产生。这有两方面的原因：
随着处理器个数的不断增加，自旋锁的竞争也在加剧，自然导致更长的等待时间。
释放自旋锁时的重置操作将无效化所有其它正在忙等待的处理器的缓存，那么在处理器拓扑结构中临近自旋锁拥有者的处理器可能会更快地刷新缓存，因而增大获得自旋锁的机率。
由于每个申请自旋锁的处理器均在全局变量 slock 上忙等待，系统总线将因为处理器间的缓存同步而导致繁重的流量，从而降低了系统整体的性能。

在 NUMA 系统中，不是所有进程都对所有对等的访问。与该锁处于同一 NUMA 节点中的进程明显可以优先获得该锁。远程 NUMA 节点中的进程可能会有锁不足和性能下降的问题。Ticket Lock 是为了解决上面的公平性问题，类似于现实中银行柜台的排队叫号：锁拥有一个服务号，表示正在服务的线程，还有一个排队号；每个线程尝试获取锁之前先拿一个排队号，然后不断轮询锁的当前服务号是否是自己的排队号，如果是，则表示自己拥有了锁，不是则继续轮询。 ticket 自旋锁负担比普通自旋锁要高，但它缩放比例更大，并可在 NUMA 系统中提供更好的性能。

Ticket Lock 虽然解决了公平性的问题，但是多处理器系统上，每个进程/线程占用的处理器都在读写同一个变量serviceNum ，每次读写操作都必须在多个处理器缓存之间进行缓存同步，这会导致繁重的系统总线和内存的流量，大大降低系统整体的性能。

Queued Spinlock（只工作在Windwos上） 的工作方式如下：每个处理器上的执行线程都有一个本地的标志，通过该标志，所有使用该锁的处理器（锁拥有者和等待者）被组织成一个单向队列。当一个处理器想要获得一个已被其它处理器持有的 Queued Spinlock 时，它把自己的标志放在该 Queued Spinlock 的单向队列的末尾。如果当前锁持有者释放了自旋锁，则它将该锁移交到队列中位于自己之后的第一个处理器。同时，如果一个处理器正在忙等待 Queued Spinlock，它并不是检查该锁自身的状态，而是检查针对自己的标志；在队列中位于该处理器之前的处理器释放自旋锁时会设置这一标志，以表明轮到这个正在等待的处理器了。

忙等待 Queued Spinlock 的每个处理器在针对该处理器的标志上旋转，而不是在全局的自旋锁上测试旋转，因此处理器之间的同步比 Linux 的排队自旋锁少得多。
Queued Spinlock 拥有真实的队列结构，因此便于扩充更高级的功能。

## MCS锁

MCS Spinlock 是一种基于链表的可扩展、高性能、公平的自旋锁，申请线程只在本地变量上自旋，直接前驱负责通知其结束自旋，从而极大地减少了不必要的处理器缓存同步的次数，降低了总线和内存的开销。

## CLH锁

CLH锁也是一种基于链表的可扩展、高性能、公平的自旋锁，申请线程只在本地变量上自旋，它不断轮询前驱的状态，如果发现前驱释放了锁就结束自旋。

- 从代码实现来看，CLH比MCS要简单得多。
- 从自旋的条件来看，CLH是在前驱节点的属性上自旋，而MCS是在本地属性变量上自旋。
- 从链表队列来看，CLH的队列是隐式的，CLHNode并不实际持有下一个节点；MCS的队列是物理存在的。
- CLH锁释放时只需要改变自己的属性，MCS锁释放则需要改变后继节点的属性。

## BKL（大内核锁）

大内核锁本质上也是自旋锁，但是它又不同于自旋锁，自旋锁是不可以递归获得锁的，因为那样会导致死锁。但大内核锁可以递归获得锁。大内核锁用于保护整个内核，而自旋锁用于保护非常特定的某一共享资源。进程保持大内核锁时可以发生调度，具体实现是：在执行schedule时，schedule将检查进程是否拥有大内核锁，如果有，它将被释放，以致于其它的进程能够获得该锁，而当轮到该进程运行时，再让它重新获得大内核锁。注意在保持自旋锁期间是不运行发生调度的。

## 读写自旋锁

读写锁实际是一种特殊的自旋锁，它把对共享资源的访问者划分成读者和写者，读者只对共享资源进行读访问，写者则需要对共享资源进行写操作。这种锁相对于自旋锁而言，能提高并发性，因为在多处理器系统中，它允许同时有多个读者来访问共享资源，最大可能的读者数为实际的逻辑CPU数。写者是排他性的，一个读写锁同时只能有一个写者或多个读者（与CPU数相关），但不能同时既有读者又有写者。
在读写锁保持期间也是抢占失效的。

## 互斥锁（互斥量）

是指某一资源同时只允许一个访问者对其进行访问，具有唯一性和排它性。但互斥无法限制访问者对资源的访问顺序，即访问是无序的。

### 互斥量操作

    int pthread_mutex_init(pthread_mutex_t *restrict mutex, const pthread_mutexattr_t *restrict attr);
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    int pthread_mutex_destroy(pthread_mutexattr_t *attr);

    int pthread_mutex_lock(pthread_mutex_t *mutex);
    int pthread_mutex_trylock(pthread_mutex_t *mutex);
    int pthread_mutex_unlock(pthread_mutex_t *mutex);
    int pthread_mutex_timedlock(pthread_mutex_t *restrict mutex, const struct timespec *restrict abstime);


### 设置互斥量优先级上限

    int pthread_mutex_getprioceiling(const pthread_mutex_t *restrict mutex, int *restrict prioceiling);
    int pthread_mutex_setprioceiling(pthread_mutex_t *restrict mutex, int prioceiling, int *restrict old_ceiling);

### 互斥量锁属性

    int pthread_mutexattr_destroy(pthread_mutexattr_t *attr);
    int pthread_mutexattr_init(pthread_mutexattr_t *attr);

    int pthread_mutexattr_getpshared(const pthread_mutexattr_t *restrict attr, int *restrict pshared);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t *attr, int pshared);

    int pthread_mutexattr_getprotocol(const pthread_mutexattr_t *restrict attr, int *restrict protocol);
    int pthread_mutexattr_setprotocol(pthread_mutexattr_t *attr, int protocol);

    int pthread_mutexattr_getprioceiling(const pthread_mutexattr_t *restrict attr, int *restrict prioceiling);
    int pthread_mutexattr_setprioceiling(pthread_mutexattr_t *attr, int prioceiling);

pshared可以设置为

>PTHREAD_PROCESS_SHARED 允许互斥量在进程间共享
>
>PTHREAD_PROCESS_PRIVATE

    int pthread_mutexattr_getrobust(const pthread_mutexattr_t *attr, int *robustness);
    int pthread_mutexattr_setrobust(const pthread_mutexattr_t *attr, int robustness);

多进程间共享互斥量时，当持有互斥量的进程终止时，并且互斥量处于锁住状态，需要恢复为未锁定，否则其它进程会一直阻塞下去。
robustness：

>PTHREAD_MUTEX_STALLED 持有互斥量的进程终止时不需要采取特别动作
>
>PTHREAD_MUTEX_ROBUST  当持有锁的线程终止时并且没有释放锁，其它线程在pthread_mutex_lock时返回EOWNERDEAD而不是0。

    int pthread_mutex_consistent(pthread_mutex_t * mutex);

如果应用状态无法恢复，线程对互斥量解锁后，互斥量将处于永久不可用状态。此时调用pthread_mutex_consistent。
如果线程没有先调用pthread_mutex_consistent就对互斥量进行解锁，其它试图获取该互斥量的阻塞线程就会得到错误码ENOTRECOVERABLE。此时互斥量不可再用。


int pthread_mutexattr_gettype(const pthread_mutexattr_t *restrict attr, int *restrict type);
int pthread_mutexattr_settype(pthread_mutexattr_t *attr, int type);

互斥量锁定类型：

* PTHREAD_MUTEX_NORMAL 不做特殊错误检查和死锁检测，没有解锁时加锁会死锁，不占用时解锁或已解锁时解锁未定义
* PTHREAD_MUTEX_ERRORCHECK 提供错误检查，没有解锁时重新加锁返回错误，不占用或已解锁时解锁返回错误
* PTHREAD_MUTEX_RECURSIVE 此互斥量允许同一线程在互斥量解锁前对该互斥量多次加锁。需要同样的解锁次数才能解锁。不占用或已解锁时解锁返回错误
* PTHREAD_MUTEX_DEFAULT 没有解锁时重新加锁，不占用时解锁，已解锁时解锁都是未定义行为

### 互斥量例子

使用两个互斥量来避免死锁

    #include <stdlib.h>
    #include <pthread.h>

    #define NHASH 29
    #define HASH(id) (((unsigned long)id)%NHASH)

    struct foo *fh[NHASH];

    pthread_mutex_t hashlock = PTHREAD_MUTEX_INITIALIZER;

    struct foo {
    	int             f_count;
    	pthread_mutex_t f_lock;
    	int             f_id;
    	struct foo     *f_next; /* protected by hashlock */
    	/* ... more stuff here ... */
    };

    struct foo *
    foo_alloc(int id) /* allocate the object */
    {
    	struct foo	*fp;
    	int			idx;

    	if ((fp = malloc(sizeof(struct foo))) != NULL) {
    		fp->f_count = 1;
    		fp->f_id = id;
    		if (pthread_mutex_init(&fp->f_lock, NULL) != 0) {
    			free(fp);
    			return(NULL);
    		}
    		idx = HASH(id);
    		pthread_mutex_lock(&hashlock);
    		fp->f_next = fh[idx];
    		fh[idx] = fp;
    		pthread_mutex_lock(&fp->f_lock);
    		pthread_mutex_unlock(&hashlock);
    		/* ... continue initialization ... */
    		pthread_mutex_unlock(&fp->f_lock);
    	}
    	return(fp);
    }

    void
    foo_hold(struct foo *fp) /* add a reference to the object */
    {
    	pthread_mutex_lock(&fp->f_lock);
    	fp->f_count++;
    	pthread_mutex_unlock(&fp->f_lock);
    }

    struct foo *
    foo_find(int id) /* find an existing object */
    {
    	struct foo	*fp;

    	pthread_mutex_lock(&hashlock);
    	for (fp = fh[HASH(id)]; fp != NULL; fp = fp->f_next) {
    		if (fp->f_id == id) {
    			foo_hold(fp);
    			break;
    		}
    	}
    	pthread_mutex_unlock(&hashlock);
    	return(fp);
    }

    void
    foo_rele(struct foo *fp) /* release a reference to the object */
    {
    	struct foo	*tfp;
    	int			idx;

    	pthread_mutex_lock(&fp->f_lock);
    	if (fp->f_count == 1) { /* last reference */
    		pthread_mutex_unlock(&fp->f_lock);
    		pthread_mutex_lock(&hashlock);
    		pthread_mutex_lock(&fp->f_lock);
    		/* need to recheck the condition */
    		if (fp->f_count != 1) {
    			fp->f_count--;
    			pthread_mutex_unlock(&fp->f_lock);
    			pthread_mutex_unlock(&hashlock);
    			return;
    		}
    		/* remove from list */
    		idx = HASH(fp->f_id);
    		tfp = fh[idx];
    		if (tfp == fp) {
    			fh[idx] = fp->f_next;
    		} else {
    			while (tfp->f_next != fp)
    				tfp = tfp->f_next;
    			tfp->f_next = fp->f_next;
    		}
    		pthread_mutex_unlock(&hashlock);
    		pthread_mutex_unlock(&fp->f_lock);
    		pthread_mutex_destroy(&fp->f_lock);
    		free(fp);
    	} else {
    		fp->f_count--;
    		pthread_mutex_unlock(&fp->f_lock);
    	}
    }

    #include <stdlib.h>
    #include <pthread.h>

    #define NHASH 29
    #define HASH(id) (((unsigned long)id)%NHASH)

    struct foo *fh[NHASH];
    pthread_mutex_t hashlock = PTHREAD_MUTEX_INITIALIZER;

    struct foo {
    	int             f_count; /* protected by hashlock */
    	pthread_mutex_t f_lock;
    	int             f_id;
    	struct foo     *f_next; /* protected by hashlock */
    	/* ... more stuff here ... */
    };

    struct foo *
    foo_alloc(int id) /* allocate the object */
    {
    	struct foo	*fp;
    	int			idx;

    	if ((fp = malloc(sizeof(struct foo))) != NULL) {
    		fp->f_count = 1;
    		fp->f_id = id;
    		if (pthread_mutex_init(&fp->f_lock, NULL) != 0) {
    			free(fp);
    			return(NULL);
    		}
    		idx = HASH(id);
    		pthread_mutex_lock(&hashlock);
    		fp->f_next = fh[idx];
    		fh[idx] = fp;
    		pthread_mutex_lock(&fp->f_lock);
    		pthread_mutex_unlock(&hashlock);
    		/* ... continue initialization ... */
    		pthread_mutex_unlock(&fp->f_lock);
    	}
    	return(fp);
    }

    void
    foo_hold(struct foo *fp) /* add a reference to the object */
    {
    	pthread_mutex_lock(&hashlock);
    	fp->f_count++;
    	pthread_mutex_unlock(&hashlock);
    }

    struct foo *
    foo_find(int id) /* find an existing object */
    {
    	struct foo	*fp;

    	pthread_mutex_lock(&hashlock);
    	for (fp = fh[HASH(id)]; fp != NULL; fp = fp->f_next) {
    		if (fp->f_id == id) {
    			fp->f_count++;
    			break;
    		}
    	}
    	pthread_mutex_unlock(&hashlock);
    	return(fp);
    }

    void
    foo_rele(struct foo *fp) /* release a reference to the object */
    {
    	struct foo	*tfp;
    	int			idx;

    	pthread_mutex_lock(&hashlock);
    	if (--fp->f_count == 0) { /* last reference, remove from list */
    		idx = HASH(fp->f_id);
    		tfp = fh[idx];
    		if (tfp == fp) {
    			fh[idx] = fp->f_next;
    		} else {
    			while (tfp->f_next != fp)
    				tfp = tfp->f_next;
    			tfp->f_next = fp->f_next;
    		}
    		pthread_mutex_unlock(&hashlock);
    		pthread_mutex_destroy(&fp->f_lock);
    		free(fp);
    	} else {
    		pthread_mutex_unlock(&hashlock);
    	}
    }


## 读写锁

1.当读写锁是写加锁状态时，在这个锁被解锁之前，所有试图对这个锁加锁的线程都会被阻塞
2.当读写锁在读加锁状态时，所有试图以读模式对它进行加锁的线程都可以得到访问权，但是以写模式对它进行加锁的线程将会被阻塞
3.当读写锁在读模式的锁状态时，如果有另外的线程试图以写模式加锁，读写锁通常会阻塞随后的读模式锁的请求，这样可以避免读模式锁长期占用，而等待的写模式锁请求则长期阻塞。

### 读写锁属性

    #include <pthread.h>
    int pthread_rwlockattr_init(pthread_rwlockattr_t *attr);
    int pthread_rwlockattr_destroy(pthread_rwlockattr_t *attr);

    int pthread_rwlockattr_setkind_np(pthread_rwlockattr_t *attr, int pref);
    int pthread_rwlockattr_getkind_np(const pthread_rwlockattr_t *attr, int *pref);

    int pthread_rwlockattr_getpshared(const pthread_rwlockattr_t *restrict attr, int *restrict pshared);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t *attr, int pshared);

### 读写锁操作

    int pthread_rwlock_init(pthread_rwlock_t *restrict rwlock, const pthread_rwlockattr_t *restrict attr);
    pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
    int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
    int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_timedrdlock(pthread_rwlock_t *restrict rwlock, const struct timespec *restrict tsptr);
    int pthread_rwlock_timedwrlock(pthread_rwlock_t *restrict rwlock, const struct timespec *restrict tsptr);

正常返回0， 否则返回错误编号

### 读写锁例子

    #include <stdlib.h>
    #include <pthread.h>

    struct job {
    	struct job *j_next;
    	struct job *j_prev;
    	pthread_t   j_id;   /* tells which thread handles this job */
    	/* ... more stuff here ... */
    };

    struct queue {
    	struct job      *q_head;
    	struct job      *q_tail;
    	pthread_rwlock_t q_lock;
    };

    /*
     * Initialize a queue.
     */
    int
    queue_init(struct queue *qp)
    {
    	int err;

    	qp->q_head = NULL;
    	qp->q_tail = NULL;
    	err = pthread_rwlock_init(&qp->q_lock, NULL);
    	if (err != 0)
    		return(err);
    	/* ... continue initialization ... */
    	return(0);
    }

    /*
     * Insert a job at the head of the queue.
     */
    void
    job_insert(struct queue *qp, struct job *jp)
    {
    	pthread_rwlock_wrlock(&qp->q_lock);
    	jp->j_next = qp->q_head;
    	jp->j_prev = NULL;
    	if (qp->q_head != NULL)
    		qp->q_head->j_prev = jp;
    	else
    		qp->q_tail = jp;	/* list was empty */
    	qp->q_head = jp;
    	pthread_rwlock_unlock(&qp->q_lock);
    }

    /*
     * Append a job on the tail of the queue.
     */
    void
    job_append(struct queue *qp, struct job *jp)
    {
    	pthread_rwlock_wrlock(&qp->q_lock);
    	jp->j_next = NULL;
    	jp->j_prev = qp->q_tail;
    	if (qp->q_tail != NULL)
    		qp->q_tail->j_next = jp;
    	else
    		qp->q_head = jp;	/* list was empty */
    	qp->q_tail = jp;
    	pthread_rwlock_unlock(&qp->q_lock);
    }

    /*
     * Remove the given job from a queue.
     */
    void
    job_remove(struct queue *qp, struct job *jp)
    {
    	pthread_rwlock_wrlock(&qp->q_lock);
    	if (jp == qp->q_head) {
    		qp->q_head = jp->j_next;
    		if (qp->q_tail == jp)
    			qp->q_tail = NULL;
    		else
    			jp->j_next->j_prev = jp->j_prev;
    	} else if (jp == qp->q_tail) {
    		qp->q_tail = jp->j_prev;
    		jp->j_prev->j_next = jp->j_next;
    	} else {
    		jp->j_prev->j_next = jp->j_next;
    		jp->j_next->j_prev = jp->j_prev;
    	}
    	pthread_rwlock_unlock(&qp->q_lock);
    }

    /*
     * Find a job for the given thread ID.
     */
    struct job *
    job_find(struct queue *qp, pthread_t id)
    {
    	struct job *jp;

    	if (pthread_rwlock_rdlock(&qp->q_lock) != 0)
    		return(NULL);

    	for (jp = qp->q_head; jp != NULL; jp = jp->j_next)
    		if (pthread_equal(jp->j_id, id))
    			break;

    	pthread_rwlock_unlock(&qp->q_lock);
    	return(jp);
    }

## 大读者锁

大读者锁的实现机制是：每一个大读者锁在所有CPU上都有一个本地读者写者锁，一个读者仅需要获得本地CPU的读者锁，而写者必须获得所有CPU上的锁。

大读者锁是读写锁的高性能版，读者可以非常快地获得锁，但写者获得锁的开销比较大。大读者锁只存在于2.4内核中，在2.6中已经没有这种锁（提醒读者特别注意）。它们的使用与读写锁的使用类似，只是所有的大读者锁都是事先已经定义好的。这种锁适合于读多写少的情况，它在这种情况下远好于读写锁。

## RCU（read-copy-update）

RCU(Read-Copy Update)，顾名思义就是读-拷贝修改，它是基于其原理命名的。对于被RCU保护的共享数据结构，读者不需要获得任何锁就可以访问它，但写者在访问它时首先拷贝一个副本，然后对副本进行修改，最后使用一个回调（callback）机制在适当的时机把指向原来数据的指针重新指向新的被修改的数据。这个时机就是所有引用该数据的CPU都退出对共享数据的操作。
RCU也是读写锁的高性能版本，但是它比大读者锁具有更好的扩展性和性能。 RCU既允许多个读者同时访问被保护的数据，又允许多个读者和多个写者同时访问被保护的数据（注意：是否可以有多个写者并行访问取决于写者之间使用的同步机制），读者没有任何同步开销，而写者的同步开销则取决于使用的写者间同步机制。但RCU不能替代读写锁，因为如果写比较多时，对读者的性能提高不能弥补写者导致的损失。

## 顺序锁

顺序锁也是对读写锁的一种优化，对于顺序锁，读者绝不会被写者阻塞，也就说，读者可以在写者对被顺序锁保护的共享资源进行写操作时仍然可以继续读，而不必等待写者完成写操作，写者也不需要等待所有读者完成读操作才去进行写操作。但是，写者与写者之间仍然是互斥的，即如果有写者在进行写操作，其他写者必须自旋在那里，直到写者释放了顺序锁。
这种锁有一个限制，它必须要求被保护的共享资源不含有指针，因为写者可能使得指针失效，但读者如果正要访问该指针，将导致OOPs。
如果读者在读操作期间，写者已经发生了写操作，那么，读者必须重新读取数据，以便确保得到的数据是完整的。
这种锁对于读写同时进行的概率比较小的情况，性能是非常好的，而且它允许读写同时进行，因而更大地提高了并发性。

在读取者和写入者之间引入了一个整形变量sequence，读取者在读取之前读取sequence, 读取之后再次读取此值，如果不相同，则说明本次读取操作过程中数据发生了更新，需要重新读取。而对于写进程在写入数据的时候就需要更新sequence的值

## 信号量

信号量的睡眠特性，使得信号量适用于锁会被长时间持有的情况；只能在进程上下文中使用，因为中断上下文中是不能被调度的；中断上下文就是中断处理函数。另外当代码持有信号量时，不可以再持有自旋锁。

信号量在创建时需要设置一个初始值，表示同时可以有几个任务可以访问该信号量保护的共享资源，初始值为1就变成互斥锁（Mutex），即同时只能有一个任务可以访问信号量保护的共享资源。一个任务要想访问共享资源，首先必须得到信号量，获取信号量的操作将把信号量的值减1，若当前信号量的值为负数，表明无法获得信号量，该任务必须挂起在该信号量的等待队列等待该信号量可用；若当前信号量的值为非负数，表示可以获得信号量，因而可以立刻访问被该信号量保护的共享资源。当任务访问完被信号量保护的共享资源后，必须释放信号量，释放信号量通过把信号量的值加1实现，如果信号量的值为非正数，表明有任务等待当前信号量，因此它也唤醒所有等待该信号量的任务。

## 读写信号量

读写信号量对访问者进行了细分，或者为读者，或者为写者，读者在保持读写信号量期间只能对该读写信号量保护的共享资源进行读访问，如果一个任务除了需要读，可能还需要写，那么它必须被归类为写者，它在对共享资源访问之前必须先获得写者身份，写者在发现自己不需要写访问的情况下可以降级为读者。读写信号量同时拥有的读者数不受限制，也就说可以有任意多个读者同时拥有一个读写信号量。如果一个读写信号量当前没有被写者拥有并且也没有写者等待读者释放信号量，那么任何读者都可以成功获得该读写信号量；否则，读者必须被挂起直到写者释放该信号量。如果一个读写信号量当前没有被读者或写者拥有并且也没有写者等待该信号量，那么一个写者可以成功获得该读写信号量，否则写者将被挂起，直到没有任何访问者。因此，写者是排他性的，独占性的。

## 条件变量

    int pthread_condattr_init(pthread_condattr_t *attr);
    int pthread_condattr_destroy(pthread_condattr_t *attr);

    int pthread_condattr_getpshared(const pthread_condattr_t *restrict attr, int *restrict pshared);
    int pthread_condattr_setpshared(pthread_condattr_t *attr, int pshared);

    int pthread_condattr_getclock(const pthread_condattr_t *restrict attr, clockid_t *restrict clock_id);
    int pthread_condattr_setclock(pthread_condattr_t *attr, clockid_t clock_id);
    只适用pthread_cond_timedwait,clock_id可以是CLOCK_REALTIME, CLOCK_MONOTONIC, CLOCK_PROCESS_CPUTIME_ID, CLOCK_THREAD_CPUTIME_ID

    int pthread_cond_init(pthread_cond_t *restrict cond, const pthread_condattr_t *restrict attr);
    int pthread_cond_destroy(pthread_cond_t *cond);

    int pthread_cond_wait(pthread_cond_t *restrict cond, pthread_mutex_t *restrict mutex);
    先锁住mutex，然后将线程放到等待列表，然后解锁mutex，直到被pthread_cond_signal或pthread_cond_broadcast唤醒
    int pthread_cond_timedwait(pthread_cond_t *restrict cond, pthread_mutex_t *restrict mutex, const struct timespec *restrict tsptr);

    int pthread_cond_signal(pthread_cond_t *cond);
    int pthread_cond_broadcast(pthread_cond_t *cond);

条件变量不应该使用递归锁，如果递归互斥量多次加锁，然后用在调用pthread_cond_wait函数中，条件永远不会被满足，pthread_cond_wait所做的解锁操作不能释放互斥量。

### 条件变量例子

    #include "apue.h"
    #include <pthread.h>

    void
    cleanup(void *arg)
    {
    	printf("cleanup: %s\n", (char *)arg);
    }

    void *
    thr_fn1(void *arg)
    {
    	printf("thread 1 start\n");
    	pthread_cleanup_push(cleanup, "thread 1 first handler");
    	pthread_cleanup_push(cleanup, "thread 1 second handler");
    	printf("thread 1 push complete\n");
    	if (arg)
    		return((void *)1);
    	pthread_cleanup_pop(0);
    	pthread_cleanup_pop(0);
    	return((void *)1);
    }

    void *
    thr_fn2(void *arg)
    {
    	printf("thread 2 start\n");
    	pthread_cleanup_push(cleanup, "thread 2 first handler");
    	pthread_cleanup_push(cleanup, "thread 2 second handler");
    	printf("thread 2 push complete\n");
    	if (arg)
    		pthread_exit((void *)2);
    	pthread_cleanup_pop(0);
    	pthread_cleanup_pop(0);
    	pthread_exit((void *)2);
    }

    int
    main(void)
    {
    	int			err;
    	pthread_t	tid1, tid2;
    	void		*tret;

    	err = pthread_create(&tid1, NULL, thr_fn1, (void *)1);
    	if (err != 0)
    		err_exit(err, "can't create thread 1");
    	err = pthread_create(&tid2, NULL, thr_fn2, (void *)1);
    	if (err != 0)
    		err_exit(err, "can't create thread 2");
    	err = pthread_join(tid1, &tret);
    	if (err != 0)
    		err_exit(err, "can't join with thread 1");
    	printf("thread 1 exit code %ld\n", (long)tret);
    	err = pthread_join(tid2, &tret);
    	if (err != 0)
    		err_exit(err, "can't join with thread 2");
    	printf("thread 2 exit code %ld\n", (long)tret);
    	exit(0);
    }

## 屏障

    int pthread_barrierattr_init(pthread_barrierattr_t *attr);
    int pthread_barrierattr_destroy(pthread_barrierattr_t *attr);
    int pthread_barrierattr_getpshared(const pthread_barrierattr_t *restrict attr, int *restrict pshared);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t *attr,int pshared);

    int pthread_barrier_init(pthread_barrier_t *restrict barrier, const pthread_barrierattr_t *restrict attr, unsigned int count);
    int pthread_barrier_destroy(pthread_barrier_t *barrier);
    int pthread_barrier_wait(pthread_barrier_t *barrier);

一旦达到屏障计数值，线程处于非阻塞状态，屏障就可以重用，但是除非调用pthread_barrier_destroy后又pthread_barrier_init，否则屏障计数不会改变。

pthread_barrier_wait返回值PTHREAD_BARRIER_SERIAL_THREAD

    #include "apue.h"
    #include <pthread.h>
    #include <limits.h>
    #include <sys/time.h>

    #define NTHR   8				/* number of threads */
    #define NUMNUM 8000000L			/* number of numbers to sort */
    #define TNUM   (NUMNUM/NTHR)	/* number to sort per thread */

    long nums[NUMNUM];
    long snums[NUMNUM];

    pthread_barrier_t b;

    #ifdef SOLARIS
    #define heapsort qsort
    #else
    extern int heapsort(void *, size_t, size_t,
                        int (*)(const void *, const void *));
    #endif

    /*
     * Compare two long integers (helper function for heapsort)
     */
    int
    complong(const void *arg1, const void *arg2)
    {
    	long l1 = *(long *)arg1;
    	long l2 = *(long *)arg2;

    	if (l1 == l2)
    		return 0;
    	else if (l1 < l2)
    		return -1;
    	else
    		return 1;
    }

    /*
     * Worker thread to sort a portion of the set of numbers.
     */
    void *
    thr_fn(void *arg)
    {
    	long	idx = (long)arg;

    	heapsort(&nums[idx], TNUM, sizeof(long), complong);
    	pthread_barrier_wait(&b);

    	/*
    	 * Go off and perform more work ...
    	 */
    	return((void *)0);
    }

    /*
     * Merge the results of the individual sorted ranges.
     */
    void
    merge()
    {
    	long	idx[NTHR];
    	long	i, minidx, sidx, num;

    	for (i = 0; i < NTHR; i++)
    		idx[i] = i * TNUM;
    	for (sidx = 0; sidx < NUMNUM; sidx++) {
    		num = LONG_MAX;
    		for (i = 0; i < NTHR; i++) {
    			if ((idx[i] < (i+1)*TNUM) && (nums[idx[i]] < num)) {
    				num = nums[idx[i]];
    				minidx = i;
    			}
    		}
    		snums[sidx] = nums[idx[minidx]];
    		idx[minidx]++;
    	}
    }

    int
    main()
    {
    	unsigned long	i;
    	struct timeval	start, end;
    	long long		startusec, endusec;
    	double			elapsed;
    	int				err;
    	pthread_t		tid;

    	/*
    	 * Create the initial set of numbers to sort.
    	 */
    	srandom(1);
    	for (i = 0; i < NUMNUM; i++)
    		nums[i] = random();

    	/*
    	 * Create 8 threads to sort the numbers.
    	 */
    	gettimeofday(&start, NULL);
    	pthread_barrier_init(&b, NULL, NTHR+1);
    	for (i = 0; i < NTHR; i++) {
    		err = pthread_create(&tid, NULL, thr_fn, (void *)(i * TNUM));
    		if (err != 0)
    			err_exit(err, "can't create thread");
    	}
    	pthread_barrier_wait(&b);
    	merge();
    	gettimeofday(&end, NULL);

    	/*
    	 * Print the sorted list.
    	 */
    	startusec = start.tv_sec * 1000000 + start.tv_usec;
    	endusec = end.tv_sec * 1000000 + end.tv_usec;
    	elapsed = (double)(endusec - startusec) / 1000000.0;
    	printf("sort took %.4f seconds\n", elapsed);
    	for (i = 0; i < NUMNUM; i++)
    		printf("%ld\n", snums[i]);
    	exit(0);
    }

## futex

    int futex(int *uaddr, int futex_op, int val, const struct timespec *timeout,   /* or: uint32_t val2 */ int *uaddr2, int val3);
    long get_robust_list(int pid, struct robust_list_head **head_ptr,size_t *len_ptr);
    long set_robust_list(struct robust_list_head *head, size_t len);

futex可以使程序等待某个地址的值发生变化，当值发生变化后唤醒等待程序，可以通过shared-mem利用futex完成进程间同步

其中uaddr为地址，val为对应期望值，timeout等待时间

其中op值指定了要进行的futex操作:

  - FUTEX_WAIT，如果uaddr不为val，等待timeout
  - FUTEX_WAKE，唤醒在uaddr上等待的进程，最多唤醒val个进程
  - FUTEX_FD，已不支持
  - FUTEX_REQUEUE，无用
  - FUTEX_CMP_REQUEUE，首先判定uaddr的值是否为val3，如果不是返回EAGAIN，则唤醒val个在uaddr上等待的进程，再将val2个等待进程转移到对uaddr2的等待上val2 = *((int *)timeout)

所有FUTEX_WAKE都可以通过FUTEX_CMP_REQUEUE来实现。在内核中实现了一个针对于uaddr的hash表，FUTEX_WAIT将task enqueue到hash表中，FUTEX_CMP_REQUEUE按照uaddr完成对task的dequeue。

## 各种锁区别

### 互斥量和信号量的区别

1. 互斥量用于线程的互斥，信号量用于线程的同步

这是互斥量和信号量的根本区别，也就是互斥和同步之间的区别

互斥：

是指某一资源同时只允许一个访问者对其进行访问，具有唯一性和排它性。但互斥无法限制访问者对资源的访问顺序，即访问是无序的

同步：

是指在互斥的基础上（大多数情况），通过其它机制实现访问者对资源的有序访问。在大多数情况下，同步已经实现了互斥，特别是所有写入资源的情况必定是互斥的。少数情况是指可以允许多个访问者同时访问资源

2. 互斥量值只能为0/1，信号量值可以为非负整数

也就是说，一个互斥量只能用于一个资源的互斥访问，它不能实现多个资源的多线程互斥问题。信号量可以实现多个同类资源的多线程互斥和同步。当信号量为单值信号量是，也可以完成一个资源的互斥访问

3. 互斥量的加锁和解锁必须由同一线程分别对应使用，信号量可以由一个线程释放，另一个线程得到

特性：

1、睡眠 （系统会将CPU切换给其他的进程/LWP运行。）

2、必须进程上下文(可调度)

3、长期加锁


# 文件锁

## 记录锁

记录锁的功能是：当一个进程正在读或修改文件的某个部分时，它可以阻止其他进程修改同一文件区。函数fcntl支持记录锁功能，不过fcntl默认支持的是建议性记录锁。如果想让它支持强制性记录锁，

1. 使用“-o mand”选项来挂载文件系统

2. 修改要加强制锁的文件的权限：设置 SGID 位，并清除组可执行位。这种组合通常来说是毫无意义的，系统用来表示该文件被加了强制锁

## 文件描述符锁

* 文件描述符锁和文件描述符相关联，而不是和进程。

* fork和clone后会继承文件描述符锁，需要设置CLONE_FILES

* 关闭最后一个关联文件描述符时自动释放

* 在同一个文件上，一个读锁一个写锁，或者两个写锁，这两个组合中一个是传统记录锁，一个文件描述符锁时，会冲突

* 使用文件描述符锁替换文件描述符上的另一个文件描述符锁是兼容的，但是文件描述符必须是同一个或者是dup，fork，fcntl(F_DUPFD)
用不同的open文件描述符来设置文件描述符锁会冲突，因此线程之间可以各自使用open打开文件，用文件描述符锁来同步访问。

在使用下面的命令时，flock结构体中l_pid需设置为0，

> F_OFD_SETLK  l_type是F_RDLCK或F_WRLCK，F_UNLCK，如果和其它进程冲突，返回-1，errno置为EAGAIN
>
> F_OFD_SETLKW F_OFD_SETLK等待版，如果在等待过程被信号中断，在信号处理函数返回后，返回-1，errno置为EINTR
>
>F_OFD_GETLK  测试能否在放置一个文件描述符锁，如果能，flock结构体l_type置为F_UNLCK，其它不变，但是并不会真正设置锁，如果其它锁阻止，不能放置锁，则返回已经设置锁的信息


## flock设置锁

    int flock(int fd, int operation);

flock() 操作的 handle 必须是一个已经打开的文件指针。operation 可以是以下值之一：

1. 要取得共享锁定（读取程序），将 operation 设为 LOCK_SH（PHP 4.0.1 以前的版本设置为 1）。
2. 要取得独占锁定（写入程序），将 operation 设为 LOCK_EX（PHP 4.0.1 以前的版本中设置为 2）。
3. 要释放锁定（无论共享或独占），将 operation 设为 LOCK_UN（PHP 4.0.1 以前的版本中设置为 3）。
4. 如果你不希望 flock() 在锁定时堵塞，则给 operation 加上 LOCK_NB（PHP 4.0.1 以前的版本中设置为 4）。

flock只是建议性锁，不能在 NFS 以及其他的一些网络文件系统中正常工作。


flock创建的锁是和文件打开表项（struct file）相关联的，而不是fd。这就意味着复制文件fd（通过fork或者dup）后，那么通过这两个fd都可以操作这把锁（例如通过一个fd加锁，通过另一个fd可以释放锁），也就是说子进程继承父进程的锁。但是上锁过程中关闭其中一个fd，锁并不会释放（因为file结构并没有释放），只有关闭所有复制出的fd，锁才会释放。

使用open两次打开同一个文件，得到的两个fd是独立的（因为底层对应两个file对象），通过其中一个加锁，通过另一个无法解锁，并且在前一个解锁前也无法上锁

使用exec后，文件锁的状态不变。

flock锁可递归，即通过dup或者或者fork产生的两个fd，都可以加锁而不会产生死锁。

 ## lockf设置锁

    int lockf(int fd, int cmd, off_t len);

 fd为通过open返回的打开文件描述符。

  cmd的取值为：

  * F_LOCK：给文件互斥加锁，若文件以被加锁，则会一直阻塞到锁被释放。
  * F_TLOCK：同F_LOCK，但若文件已被加锁，不会阻塞，而回返回错误。
  * F_ULOCK：解锁。
  * F_TEST：测试文件是否被上锁，若文件没被上锁则返回0，否则返回-1。

  len：为从文件当前位置的起始要锁住的长度。

  通过函数参数的功能，可以看出lockf只支持排他锁，不支持共享锁。


## fcntl设置文件锁

    struct f_owner_ex {
    	int   type;
    	pid_t pid;
    };

    struct flock
    {
    	short l_type;/*F_RDLCK，读共享锁, F_WRLCK，写互斥锁, or F_UNLCK对一个区域解锁*/
    	off_t l_start;/*相对于l_whence的偏移值，字节为单位*/
    	short l_whence;/*从哪里开始：SEEK_SET, SEEK_CUR, or SEEK_END*/
    	off_t l_len;/*长度, 字节为单位; 0 意味着缩到文件结尾*/
    	pid_t l_pid;/*returned with F_GETLK*/
    };

    #include <unistd.h>
    #include <fcntl.h>
    int fcntl(int fd, int cmd, ...);

### 建议性记录锁

第三个指针参数指向flock参数

* F_GETLK

* F_SETLK  设置锁或者释放锁，设置锁系统会检测死锁，如果发现死锁，出错返回errno位置EDEADLK

* F_SETLKW 对应着F_SETLK的可以阻塞的版本。w意味着wait，等待过程被信号中断，从信号处理函数返回后再返回-1，errno置为EINTR

> 锁可以开始或者超过文件当前结束位置，但是不可以开始或者超过文件的开始位置
>
> 如果l_len为0，意味着锁的区域为可以到达的最大文件偏移位置。这个类型，可以让我们锁住一个文件的任意开始位置，结束的区域可以到达任意的文件结尾，并且以append方式追加文件时，也会同样上锁
>
>如果要锁住整个文件，设置l_start 和 l_whence为文件的开始位置（l_start为0 l_whence 为 SEEK_SET ），并且l_len为0。
>
>如果有多个读共享锁(l_type of F_RDLCK),其他的读共享锁可以接受，但是写互斥锁(type ofF_WRLCK)拒绝
>
>如果有一个写互斥锁(type ofF_WRLCK),其他的读共享锁(l_type of F_RDLCK)拒绝，其他的写互斥锁拒绝。
>
>如果要取得读锁，这个文件描述符必须被打开可以去读；如果要或者写锁，这个文件的描述符必须可以被打开可以去写。
>
>进程终止后会释放所有锁
>
>由fork产生的子进程不继承父进程所设置的锁，这点与flock也不同。
>
>标准IO因为使用了缓存，应该避免使用锁。使用不带缓存的IO
>
>关闭任何文件描述符会导致关联文件上的锁被释放，所以A进程会影响B进程，与flock不同
>
>线程之间共享记录锁
 >
 >上锁可递归，如果一个进程对一个文件区间已经有一把锁，后来进程又企图在同一区间再加一把锁，则新锁将替换老锁。
 >
 >进程不能使用F_GETLK命令来测试它自己是否再文件的某一部分持有一把锁。F_GETLK命令定义说明，返回信息指示是否现存的锁阻止调用进程设置它自己的锁。因为，F_SETLK和F_SETLKW命令总是替换进程的现有锁，所以调用进程绝不会阻塞再自己持有的锁上，于是F_GETLK命令绝不会报告调用进程自己持有的锁。

### 文件描述符锁

* 文件描述符锁和文件描述符相关联，而不是和进程。

* fork和clone后会继承文件描述符锁，需要设置CLONE_FILES

* 关闭最后一个关联文件描述符时自动释放

* 在同一个文件上，一个读锁一个写锁，或者两个写锁，这两个组合中一个是传统记录锁，一个文件描述符锁时，会冲突

* 使用文件描述符锁替换文件描述符上的另一个文件描述符锁是兼容的，但是文件描述符必须是同一个或者是dup，fork，fcntl(F_DUPFD)
用不同的open文件描述符来设置文件描述符锁会冲突，因此线程之间可以各自使用open打开文件，用文件描述符锁来同步访问。

在使用下面的命令时，flock结构体中l_pid需设置为0，

> F_OFD_SETLK  l_type是F_RDLCK或F_WRLCK，F_UNLCK，如果和其它进程冲突，返回-1，errno置为EAGAIN
>
> F_OFD_SETLKW F_OFD_SETLK等待版，如果在等待过程被信号中断，在信号处理函数返回后，返回-1，errno置为EINTR
>
>F_OFD_GETLK  测试能否在放置一个文件描述符锁，如果能，flock结构体l_type置为F_UNLCK，其它不变，但是并不会真正设置锁，如果其它锁阻止，不能放置锁，则返回已经设置锁的信息

### Mandatory locking 强制锁

如果进程去操作一个上锁的文件区域，如果设置了O_NONBLOCK，则出错返回，errno置为EAGAIN，否则一直等待可用或者被信号中断。

## flock、lockf、fcntl之间关系

flock和lockf/fcntl所上的锁互不影响。

POSIX FLOCK 这个比较明确，就是哪个类型的锁。flock系统调用产生的是FLOCK，fcntl调用F_SETLK，F_SETLKW或者lockf产生的是POSIX类型，

## 标准IO文件锁

    #include <stdio.h>
    int ftrylockfile(FILE *fp);
    OK返回0，不能获取锁返回非0值
    void flockfile(FILE *fp);
    void funlockfile(FILE *fp);

获取FILE关联对象锁，递归锁

    int getchar_unlocked(void);
    int getc_unlocked(FILE *fp);
    Both return: the next character if OK, EOF on end of file or error
    int putchar_unlocked(int c);
    int putc_unlocked(int c, FILE *fp);
    Both return: c if OK, EOF on error

除非被flockfile，ftrylockfile或funlockfile调用包围，否则不能调用以上函数。这些函数用来避免每次都对FILE对象加锁，提高性能。

# 内存锁

    #include <sys/mman.h>
    int mlock(const void *addr, size_t len);
    int mlock2(const void *addr, size_t len, int flags);
    int munlock(const void *addr, size_t len);
    int mlockall(int flags);
    int munlockall(void);

# 锁与fork、exec

1、锁与进程和文件两方面有关:

           a、当一个进程终止时，它所建立的锁全部释放；(即  进程退出，文件锁自动释放)

           b、任何时候关闭一个描述符时，则该进程通过这一描述符可以引用的文件上的任何一把锁都释放。(即  关闭文件,文件锁自动释放)

2、由fork产生的子进程不继承父进程所设置的锁。（文件锁不能被继承）

这意味着，若一个进程得到一把锁，然后调用fork,那么对于父进程获得的锁而言，子进程被视为另外一个进程，对于从父进程处继承过来的任一描述符，子进程需要调用fcntl才能获得它自己的锁。

3、在执行exec后，新程序可以继承原执行程序的锁。（EXEC文件锁被继承）


# 同步例子

## 同步

    #include "apue.h"
    #include <errno.h>
    #include <fcntl.h>
    #include <sys/wait.h>

    int
    main(int argc, char *argv[])
    {
    	int				fd;
    	pid_t			pid;
    	char			buf[5];
    	struct stat		statbuf;

    	if (argc != 2) {
    		fprintf(stderr, "usage: %s filename\n", argv[0]);
    		exit(1);
    	}
    	if ((fd = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, FILE_MODE)) < 0)
    		err_sys("open error");
    	if (write(fd, "abcdef", 6) != 6)
    		err_sys("write error");

    	/* turn on set-group-ID and turn off group-execute */
    	if (fstat(fd, &statbuf) < 0)
    		err_sys("fstat error");
    	if (fchmod(fd, (statbuf.st_mode & ~S_IXGRP) | S_ISGID) < 0)
    		err_sys("fchmod error");

    	TELL_WAIT();

    	if ((pid = fork()) < 0) {
    		err_sys("fork error");
    	}
    	else if (pid > 0) {	/* parent */
    						/* write lock entire file */
    		if (write_lock(fd, 0, SEEK_SET, 0) < 0)
    			err_sys("write_lock error");

    		TELL_CHILD(pid);

    		if (waitpid(pid, NULL, 0) < 0)
    			err_sys("waitpid error");
    	}
    	else {				/* child */
    		WAIT_PARENT();		/* wait for parent to set lock */

    		set_fl(fd, O_NONBLOCK);

    		/* first let's see what error we get if region is locked */
    		if (read_lock(fd, 0, SEEK_SET, 0) != -1)	/* no wait */
    			err_sys("child: read_lock succeeded");
    		printf("read_lock of already-locked region returns %d\n",
    			errno);

    		/* now try to read the mandatory locked file */
    		if (lseek(fd, 0, SEEK_SET) == -1)
    			err_sys("lseek error");
    		if (read(fd, buf, 2) < 0)
    			err_ret("read failed (mandatory locking works)");
    		else
    			printf("read OK (no mandatory locking), buf = %2.2s\n",
    				buf);
    	}
    	exit(0);
    }

假如一对父子进程需要同步：


    #include <stdio.h>

    int main()
    {
    	TELL_WAIT();
    	if (pid = fork() < 0) {
    		printf("fork error");
    	}
    	else if (pid == 0) {
    		//do things
    		TELL_PARENT(gitppid());
    		WAIT_PARENT();
    		exit(0);
    	}
    	else {
    		//do things
    		TELL_CHILD(pid);
    		WAIT_CHILD();
    		exit(0);
    	}
    }

## 基于信号的实现

    static volatile sig_atomic_t sigflag;
    static  sigset_t newmask, oldmask, zeromask;

    static void sig_usr(int signo)
    {
    	sigflag = 1;
    }

    void TELL_WAIT(void)
    {
    	if（signal(SIGUSR1, sig_usr) == SIG_ERR)
    	printf("signal(SIGUSR1) error");

    	if (signal(SIGUSR2, sig_usr) == SIG_ERR)
    		printf("signal(SIGUSR2) error");

    	sigemptyset(&zeromask);
    	sigemptyset(&newmask);
    	sigaddset(&newmask, SIGUSR1);
    	sigaddset(&newmask, SIGUSR2);

    	if (sigprocmask(SIG_BLOCK， &newmask, &oldmask) < 0)
    		printf("SIG_BLOCK error");
    }

    void TELL_PARENT(pid_t pid)
    {
    	kill(pid, SIGUSR2);
    }

    void WAIT_PARENT(void)
    {
    	while (sigflag == 0)
    		sigsuspend(&zeromask);
    	sigflag = 0;

    	if (sigprocmask(SIG_SETMASK, &oldmask, NULL) < 0)//会用zeromask替换当前信号屏蔽字，在返回之前又替换回去
    		printf("SIG_SETMASK error");
    }

    void TELL_CHILD(pid_t pid)
    {
    	kill(pid, SIGUSR1);
    }

    void WAIT_CHILD(void)
    {
    	while (sigflag == 0)
    		sigsuspend(&zeromask);//会用zeromask替换当前信号屏蔽字，在返回之前又替换回去
    	sigflag = 0;

    	if (sigprocmask(SIG_SETMASK, &oldmask, NULL) < 0)
    		printf("SIG_SETMASK error");
    }

这个实现不能处理多线程环境，可以专门安排一个线程来处理信号。

## 管道实现

    #include "apue.h"

    static int	pfd1[2], pfd2[2];

    void
    TELL_WAIT(void)
    {
    	if (pipe(pfd1) < 0 || pipe(pfd2) < 0)
    		err_sys("pipe error");
    }

    void
    TELL_PARENT(pid_t pid)
    {
    	if (write(pfd2[1], "c", 1) != 1)
    		err_sys("write error");
    }

    void
    WAIT_PARENT(void)
    {
    	char	c;

    	if (read(pfd1[0], &c, 1) != 1)
    		err_sys("read error");

    	if (c != 'p')
    		err_quit("WAIT_PARENT: incorrect data");
    }

    void
    TELL_CHILD(pid_t pid)
    {
    	if (write(pfd1[1], "p", 1) != 1)
    		err_sys("write error");
    }

    void
    WAIT_CHILD(void)
    {
    	char	c;

    	if (read(pfd2[0], &c, 1) != 1)
    		err_sys("read error");

    	if (c != 'c')
    		err_quit("WAIT_CHILD: incorrect data");
    }

## 存储映射进程间同步

    #include "apue.h"
    #include <fcntl.h>
    #include <sys/mman.h>

    #define	NLOOPS		1000
    #define	SIZE		sizeof(long)	/* size of shared memory area */

    static int
    update(long *ptr)
    {
    	return((*ptr)++);	/* return value before increment */
    }

    int
    main(void)
    {
    	int		fd, i, counter;
    	pid_t	pid;
    	void	*area;

    	if ((fd = open("/dev/zero", O_RDWR)) < 0)
    		err_sys("open error");
    	if ((area = mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
    		fd, 0)) == MAP_FAILED)
    		err_sys("mmap error");
    	close(fd);		/* can close /dev/zero now that it's mapped */

    	TELL_WAIT();

    	if ((pid = fork()) < 0) {
    		err_sys("fork error");
    	}
    	else if (pid > 0) {			/* parent */
    		for (i = 0; i < NLOOPS; i += 2) {
    			if ((counter = update((long *)area)) != i)
    				err_quit("parent: expected %d, got %d", i, counter);

    			TELL_CHILD(pid);
    			WAIT_CHILD();
    		}
    	}
    	else {						/* child */
    		for (i = 1; i < NLOOPS + 1; i += 2) {
    			WAIT_PARENT();

    			if ((counter = update((long *)area)) != i)
    				err_quit("child: expected %d, got %d", i, counter);

    			TELL_PARENT(getppid());
    		}
    	}

    	exit(0);
    }



 #include <sys/file.h>

       int flock(int fd, int operation);



       #include <sys/mman.h>

       int mlock(const void *addr, size_t len);
       int mlock2(const void *addr, size_t len, int flags);
       int munlock(const void *addr, size_t len);

       int mlockall(int flags);
       int munlockall(void);


https://www.ibm.com/developerworks/cn/linux/l-cn-spinlock/index.html
https://lwn.net/Articles/267968/
https://access.redhat.com/documentation/zh-CN/Red_Hat_Enterprise_Linux/6/html/Performance_Tuning_Guide/s-ticket-spinlocks.html
https://coderbee.net/index.php/concurrent/20131115/577
http://guojing.me/linux-kernel-architecture/posts/spin-lock/
https://www.kancloud.cn/kancloud/ldd3/60972
