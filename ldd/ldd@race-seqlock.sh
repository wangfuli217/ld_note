seqlock(API)
{
    使用顺序锁，读执行单元绝不会被写执行单元阻塞，同时写执行单元也不需要等待所有读执行单元完成读操作后才进行写操作。
但是写执行单元之间仍然是互斥的。如果读执行单元在读操作期间，写执行单元已经发生了操作，那么，读执行单元必须重新读取数据，
以便确保得到的数据是完整的。

致命弱点：顺序锁有一个限制，就是它必须要求被保护的共享资源不含有指针。因为写执行单元可能使得指针失效，但读执行单元如果正要访问该指针，将导致Oops。

在Linux内核中。读执行单元设计如下顺序读操作。
1)读开始
unsigned read_seqbegin(const seqlock_t *s1);
read_seqbegin_irqsave(lock, flag);[ read_seqbegin_irqsave(lock, flag)=local_irq_save() + read_seqbegin();]

2)重读
int read_seqretry(const seqlock_t *s1, unsigned iv);
read_seqretry_irqrestore(lock, iv, flag);[read_seqretry_irqrestore(lock, iv, flag）= read_seqretry()+ local_irq_restore();]

读执行单元使用顺序锁的模式如下：
do{
    seqnum = read_seqbegin(&seqlock_a);
    //读操作代码块
    。。。
}while(read_seqretry(&seqlock_a, seqnum));

在Linux内核中。写执行单元设计如下顺序读操作。
1)获得顺序锁
void write_seqlock(seqlock_t *s1);
int write_ tryseqlock(seqlock_t *s1);
write_seqlock_irqsave(lock, flags);[=local_irq_save() + write_seqlock()]
write_seqlock_irq(lock);[=local_irq_disable() + write_seqlock()]
write_seqlock_bh(lock);[=local_bh_disable() + write_seqlock()]

2)释放顺序锁
void write_sequnlock(seqlock_t *s1);
write_sequnlock_irqrestore(lock, flag);[=write_sequnlock() + local_irq_restore()]
write_sequnlock_irq(lock);[=write_sequnlock() + local_irq_enable()]
write_sequnlock_bh(lock);[write_sequnlock()+local_bh_enable()]
写执行单元使用顺序锁的模式如下：
write_seqlock(&seqlock_a);
…//写操作代码
write_sequnlock(&seqlock_a);

}

https://www.ibm.com/developerworks/cn/linux/l-synch/part2/

    顺序锁也是对读写锁的一种优化，对于顺序锁，读者绝不会被写者阻塞，也就说，读者可以在写者对被顺序锁保护的共享资源进行写操作时仍然可以继续读，
而不必等待写者完成写操作，写者也不需要等待所有读者完成读操作才去进行写操作。但是，写者与写者之间仍然是互斥的，即如果有写者在进行写操作，
其他写者必须自旋在那里，直到写者释放了顺序锁。

这种锁有一个限制，它必须要求被保护的共享资源不含有指针，因为写者可能使得指针失效，但读者如果正要访问该指针，将导致OOPs。
如果读者在读操作期间，写者已经发生了写操作，那么，读者必须重新读取数据，以便确保得到的数据是完整的。
这种锁对于读写同时进行的概率比较小的情况，性能是非常好的，而且它允许读写同时进行，因而更大地提高了并发性。

void write_seqlock(seqlock_t *sl);
写者在访问被顺序锁s1保护的共享资源前需要调用该函数来获得顺序锁s1。
它实际功能上等同于spin_lock，只是增加了一个对顺序锁顺序号的加1操作，以便读者能够检查出是否在读期间有写者访问过。

void write_sequnlock(seqlock_t *sl);
写者在访问完被顺序锁s1保护的共享资源后需要调用该函数来释放顺序锁s1。
它实际功能上等同于spin_unlock，只是增加了一个对顺序锁顺序号的减1操作，以便读者能够检查出是否在读期间有写者访问过。

写者使用顺序锁的模式如下：
write_seqlock(&seqlock_a);
//写操作代码块
…
write_sequnlock(&seqlock_a);
因此，对写者而言，它的使用与spinlock相同。

int write_tryseqlock(seqlock_t *sl);
写者在访问被顺序锁s1保护的共享资源前也可以调用该函数来获得顺序锁s1。它实际功能上等同于spin_trylock，只是如果成功获得锁后，
该函数增加了一个对顺序锁顺序号的加1操作，以便读者能够检查出是否在读期间有写者访问过。

unsigned read_seqbegin(const seqlock_t *sl);
读者在对被顺序锁s1保护的共享资源进行访问前需要调用该函数。读者实际没有任何得到锁和释放锁的开销，该函数只是返回顺序锁s1的当前顺序号。

int read_seqretry(const seqlock_t *sl, unsigned iv);
读者在访问完被顺序锁s1保护的共享资源后需要调用该函数来检查，在读访问期间是否有写者访问了该共享资源，
如果是，读者就需要重新进行读操作，否则，读者成功完成了读操作。

因此，读者使用顺序锁的模式如下：

do {
   seqnum = read_seqbegin(&seqlock_a);
//读操作代码块
...
} while (read_seqretry(&seqlock_a, seqnum));
write_seqlock_irqsave(lock, flags)

写者也可以用该宏来获得顺序锁lock，与write_seqlock不同的是，该宏同时还把标志寄存器的值保存到变量flags中，并且失效了本地中断。
write_seqlock_irq(lock)

写者也可以用该宏来获得顺序锁lock，与write_seqlock不同的是，该宏同时还失效了本地中断。与write_seqlock_irqsave不同的是，该宏不保存标志寄存器。
write_seqlock_bh(lock)

写者也可以用该宏来获得顺序锁lock，与write_seqlock不同的是，该宏同时还失效了本地软中断。

write_sequnlock_irqrestore(lock, flags)
写者也可以用该宏来释放顺序锁lock，与write_sequnlock不同的是，该宏同时还把标志寄存器的值恢复为变量flags的值。它必须与write_seqlock_irqsave配对使用。

write_sequnlock_irq(lock)
写者也可以用该宏来释放顺序锁lock，与write_sequnlock不同的是，该宏同时还使能本地中断。它必须与write_seqlock_irq配对使用。

write_sequnlock_bh(lock)
写者也可以用该宏来释放顺序锁lock，与write_sequnlock不同的是，该宏同时还使能本地软中断。它必须与write_seqlock_bh配对使用。

read_seqbegin_irqsave(lock, flags)
读者在对被顺序锁lock保护的共享资源进行访问前也可以使用该宏来获得顺序锁lock的当前顺序号，与read_seqbegin不同的是，它同时还把标志寄存器的值保存到变量flags中，并且失效了本地中断。注意，它必须与read_seqretry_irqrestore配对使用。

read_seqretry_irqrestore(lock, iv, flags)
读者在访问完被顺序锁lock保护的共享资源进行访问后也可以使用该宏来检查，在读访问期间是否有写者访问了该共享资源，如果是，读者就需要重新进行读操作，否则，读者成功完成了读操作。它与read_seqretry不同的是，该宏同时还把标志寄存器的值恢复为变量flags的值。注意，它必须与read_seqbegin_irqsave配对使用。

因此，读者使用顺序锁的模式也可以为：

do {
   seqnum = read_seqbegin_irqsave(&seqlock_a, flags);
//读操作代码块
...
} while (read_seqretry_irqrestore(&seqlock_a, seqnum, flags));

读者和写者所使用的API的几个版本应该如何使用与自旋锁的类似。

如果写者在操作被顺序锁保护的共享资源时已经保持了互斥锁保护对共享数据的写操作，即写者与写者之间已经是互斥的，但读者仍然可以与写者同时访问，那么这种情况仅需要使用顺序计数（seqcount），而不必要spinlock。

顺序计数的API如下：

unsigned read_seqcount_begin(const seqcount_t *s);
读者在对被顺序计数保护的共享资源进行读访问前需要使用该函数来获得当前的顺序号。

int read_seqcount_retry(const seqcount_t *s, unsigned iv);
读者在访问完被顺序计数s保护的共享资源后需要调用该函数来检查，在读访问期间是否有写者访问了该共享资源，如果是，读者就需要重新进行读操作，否则，读者成功完成了读操作。

因此，读者使用顺序计数的模式如下：

do {
   seqnum = read_seqbegin_count(&seqcount_a);
//读操作代码块
...
} while (read_seqretry(&seqcount_a, seqnum));
void write_seqcount_begin(seqcount_t *s);
写者在访问被顺序计数保护的共享资源前需要调用该函数来对顺序计数的顺序号加1，以便读者能够检查出是否在读期间有写者访问过。

void write_seqcount_end(seqcount_t *s);
写者在访问完被顺序计数保护的共享资源后需要调用该函数来对顺序计数的顺序号加1，以便读者能够检查出是否在读期间有写者访问过。
写者使用顺序计数的模式为：
write_seqcount_begin(&seqcount_a);
//写操作代码块
…
write_seqcount_end(&seqcount_a);

需要特别提醒，顺序计数的使用必须非常谨慎，只有确定在访问共享数据时已经保持了互斥锁才可以使用。










