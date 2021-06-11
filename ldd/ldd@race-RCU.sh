
rcu(API)
{
对于被RCU保护的共享数据结构，读者不需要获得任何锁就可以访问它，但写者在访问它时首先备份一个副本，然后对副本进行修改，
然后对副本进行修改，最后使用一个回调(callback)机制在适当的时机把原来数据的指针重新指向新的被修改的数据。这个时机就是
所有引用该数据的CPU都退出对共享数据的操作时。
1）读锁定。                           2)读解锁。                     使用RCU进行读的模式如下：
rcu_read_lock();                      rcu_read_unlock();             rcu_read_lock()
rcu_read_lock_bh();                   rcu_read_unlock_bh();            …//读临界区
                                                                     rcu_read_unlock()

3)与RCU相关的写者函数包括：
struct rcu_head{
     struct rcu_head *next;//下一个RCU
     void (*func)(struct rcu_head *head);//获得竞争条件后的处理函数
}；

synchronize_rcu(void);//阻塞读者，直到所有的读者已经完成读端临界区，写者才可以继续下一步操作
synchronize_sched();//等待所有CPU都处在可抢占状态，保证所有中断(不包括软中断)处理完毕
void call_rcu(struct rcu_head *head, void (*func)(void *arg),void arg);//不阻塞写者，可以在中断上下文或软中断使用，
使用synchronize_rcu的写操作流程如下:
DEFINE_SPINLOCK(foo_spinlock);
Int a_new;
spin_lock(&foo_spinlock);
//a_new = a;
//write a_new;
synchronize_rcu();
//a=a_new;
spin_unlock(&foo_spinlock);
//使用call_rcu的写操作流程如下:
struct protectRcu
{
    int protect;
    struct rcu_head rcu;
};

struct protectRcu *global_pr;
//一般用来释放老的数据
void callback_function(struct rcu_head *r)
{
    struct protectRcu *t;
    t=container_of(r, struct protectRcu, rcu);
    kfree(t);
}

void write_process()
{
    struct protectRcu *t, *old;
    t = kmalloc (sizeof(*t),GFP_KERNEL);//创建副本
    spin_lock(&foo_spinlock);
    t->protect = xx;
    old= global_pr;
    global_pr=t;//用副本替换
    spin_unlock(&foo_spinlock);
    call_rcu(old->rcu, callback_function);
}

}


https://www.ibm.com/developerworks/cn/linux/l-synch/part2/

RCU(Read-Copy Update)，顾名思义就是读-拷贝修改，它是基于其原理命名的。对于被RCU保护的共享数据结构，读者不需要获得任何锁就可以访问它，
但写者在访问它时首先拷贝一个副本，然后对副本进行修改，最后使用一个回调（callback）机制在适当的时机把指向原来数据的指针重新指向新的被
修改的数据。这个时机就是所有引用该数据的CPU都退出对共享数据的操作。

RCU也是读写锁的高性能版本，但是它比大读者锁具有更好的扩展性和性能。 RCU既允许多个读者同时访问被保护的数据，又允许多个读者和多个写者
同时访问被保护的数据（注意：是否可以有多个写者并行访问取决于写者之间使用的同步机制），读者没有任何同步开销，而写者的同步开销则取决于
使用的写者间同步机制。但RCU不能替代读写锁，因为如果写比较多时，对读者的性能提高不能弥补写者导致的损失。

rcu_read_lock()			//读者在读取由RCU保护的共享数据时使用该函数标记它进入读端临界区。
rcu_read_unlock()		//该函数与rcu_read_lock配对使用，用以标记读者退出读端临界区。

synchronize_rcu()		//该函数由RCU写端调用，它将阻塞写者，直到经过grace period后，即所有的读者已经完成读端临界区，写者才可以继续
                        //下一步操作。如果有多个RCU写端调用该函数，他们将在一个grace period之后全部被唤醒。

synchronize_sched()		//该函数用于等待所有CPU都处在可抢占状态，它能保证正在运行的中断处理函数处理完毕，但不能保证正在运行的softirq处理完毕。
                        //注意，synchronize_rcu只保证所有CPU都处理完正在运行的读端临界区。

void fastcall call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu)) 
struct rcu_head { 
	struct rcu_head *next; 
	void (*func)(struct rcu_head *head); 
};							
函数call_rcu也由RCU写端调用，它不会使写者阻塞，因而可以在中断上下文或softirq使用。该函数将把函数func挂接到RCU回调函数链上，然后立即返回。
一旦所有的CPU都已经完成端临界区操作，该函数将被调用来释放删除的将绝不在被应用的数据。参数head用于记录回调函数func，一般该结构会作为被RCU
保护的数据结构的一个字段，以便省去单独为该结构分配内存的操作。需要指出的是，函数synchronize_rcu的实现实际上使用函数call_rcu。

void fastcall call_rcu_bh(struct rcu_head *head,
                                void (*func)(struct rcu_head *rcu))
函数call_ruc_bh功能几乎与call_rcu完全相同，唯一差别就是它把softirq的完成也当作经历一个quiescent state，因此如果写端使用了该函数，
在进程上下文的读端必须使用rcu_read_lock_bh。

#define rcu_dereference(p)     ({ \
                                typeof(p) _________p1 = p; \
                                smp_read_barrier_depends(); \
                                (_________p1); \
                                })
该宏用于在RCU读端临界区获得一个RCU保护的指针，该指针可以在以后安全地引用，内存栅只在alpha架构上才使用。
除了这些API，RCU还增加了链表操作的RCU版本，因为对于RCU，对共享数据的操作必须保证能够被没有使用同步机制的读者看到，所以内存栅是非常必要的。

static inline void list_add_rcu(struct list_head *new, struct list_head *head)
该函数把链表项new插入到RCU保护的链表head的开头。使用内存栅保证了在引用这个新插入的链表项之前，新链表项的链接指针的修改对所有读者是可见的。

static inline void list_add_tail_rcu(struct list_head *new,
                                        struct list_head *head)
该函数类似于list_add_rcu，它将把新的链表项new添加到被RCU保护的链表的末尾。

static inline void list_del_rcu(struct list_head *entry)
该函数从RCU保护的链表中移走指定的链表项entry，并且把entry的prev指针设置为LIST_POISON2，但是并没有把entry的next指针设置为LIST_POISON1，因为该指针可能仍然在被读者用于便利该链表。

static inline void list_replace_rcu(struct list_head *old, struct list_head *new)
该函数是RCU新添加的函数，并不存在非RCU版本。它使用新的链表项new取代旧的链表项old，内存栅保证在引用新的链表项之前，它的链接指针的修正对所有读者可见。

list_for_each_rcu(pos, head)
该宏用于遍历由RCU保护的链表head，只要在读端临界区使用该函数，它就可以安全地和其它_rcu链表操作函数（如list_add_rcu）并发运行。

list_for_each_safe_rcu(pos, n, head)
该宏类似于list_for_each_rcu，但不同之处在于它允许安全地删除当前链表项pos。

list_for_each_entry_rcu(pos, head, member)
该宏类似于list_for_each_rcu，不同之处在于它用于遍历指定类型的数据结构链表，当前链表项pos为一包含struct list_head结构的特定的数据结构。

list_for_each_continue_rcu(pos, head)
该宏用于在退出点之后继续遍历由RCU保护的链表head。

static inline void hlist_del_rcu(struct hlist_node *n)
它从由RCU保护的哈希链表中移走链表项n，并设置n的ppre指针为LIST_POISON2，但并没有设置next为LIST_POISON1,因为该指针可能被读者使用用于遍利链表。

static inline void hlist_add_head_rcu(struct hlist_node *n,
                                        struct hlist_head *h)
该函数用于把链表项n插入到被RCU保护的哈希链表的开头，但同时允许读者对该哈希链表的遍历。内存栅确保在引用新链表项之前，它的指针修正对所有读者可见。

hlist_for_each_rcu(pos, head)
该宏用于遍历由RCU保护的哈希链表head，只要在读端临界区使用该函数，它就可以安全地和其它_rcu哈希链表操作函数（如hlist_add_rcu）并发运行。

hlist_for_each_entry_rcu(tpos, pos, head, member)
类似于hlist_for_each_rcu，不同之处在于它用于遍历指定类型的数据结构哈希链表，当前链表项pos为一包含struct list_head结构的特定的数据结构。

对于RCU更详细的原理、实现机制以及应用请参看作者专门针对RCU发表的一篇文章,"Linux 2.6内核中新的锁机制--RCU(Read-Copy Update)"。




	