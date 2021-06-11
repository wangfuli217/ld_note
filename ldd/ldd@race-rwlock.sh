rwlock(API)
{
使用方法：1)初始化读写锁的方法。
               rwlock_t x;//动态初始化                                            rwlock_t x=RW_LOCK_UNLOCKED;//动态初始化
               rwlock_init(&x);
             2)最基本的读写函数。
              void read_lock(rwlock_t *lock);//使用该宏获得读写锁，如果不能获得，它将自旋，直到获得该读写锁
              void read_unlock(rwlock_t *lock);//使用该宏来释放读写锁lock
              void write_lock(rwlock_t *lock);//使用该宏获得获得读写锁，如果不能获得，它将自旋，直到获得该读写锁
              void write_unlock(rwlock_t *lock);//使用该宏来释放读写锁lock
             3)和自旋锁中的spin_trylock(lock),读写锁中分别为读写提供了尝试获取锁，并立即返回的函数，如果获得，就立即返回真，否则返回假：
              read_trylock(lock)和write_lock(lock);
             4)硬中断安全的读写锁函数：
             read_lock_irq(lock);//读者获取读写锁，并禁止本地中断
             read_unlock_irq(lock);//读者释放读写锁，并使能本地中断
             write_lock_irq(lock);//写者获取读写锁，并禁止本地中断
             write_unlock_irq(lock);//写者释放读写锁，并使能本地中断
             read_lock_irqsave(lock, flags);//读者获取读写锁，同时保存中断标志，并禁止本地中断
             read_unlock_irqrestores(lock,flags);//读者释放读写锁，同时恢复中断标志，并使能本地中断
             write_lock_irqsave(lock,flags);//写者获取读写锁，同时保存中断标志，并禁止本地中断
             write_unlock_irqstore(lock,flags);写者释放读写锁，同时恢复中断标志，并使能本地中断
             5)软中断安全的读写函数：
             read_lock_bh(lock);//读者获取读写锁，并禁止本地软中断
             read_unlock_bh(lock);//读者释放读写锁，并使能本地软中断
             write_lock_bh(lock);//写者获取读写锁，并禁止本地软中断
             write_unlock_bh(lock);//写者释放读写锁，并使能本地软中断
}


https://www.ibm.com/developerworks/cn/linux/l-synch/part2/

rwlock(ibm)
{
读写锁实际是一种特殊的自旋锁，它把对共享资源的访问者划分成读者和写者，读者只对共享资源进行读访问，写者则需要对共享资源进行写操作。
这种锁相对于自旋锁而言，能提高并发性，因为在多处理器系统中，它允许同时有多个读者来访问共享资源，最大可能的读者数为实际的逻辑CPU数。
写者是排他性的，一个读写锁同时只能有一个写者或多个读者（与CPU数相关），但不能同时既有读者又有写者。

在读写锁保持期间也是抢占失效的。

如果读写锁当前没有读者，也没有写者，那么写者可以立刻获得读写锁，否则它必须自旋在那里，直到没有任何写者或读者。如果读写锁没有写者，
那么读者可以立即获得该读写锁，否则读者必须自旋在那里，直到写者释放该读写锁。

DEFINE_RWLOCK(x)		//静态初始化
RW_LOCK_UNLOCKED		//静态初始化一个读写锁。
DEFINE_RWLOCK(x)等同于rwlock_t x = RW_LOCK_UNLOCKED


rwlock_init(x)			//动态初始化


read_trylock(lock)  读者用它来尽力获得读写锁lock，如果能够立即获得读写锁，它就获得锁并返回真，否则不能获得锁，返回假。无论是否能够获得锁，
                    它都将立即返回，绝不自旋在那里。
write_trylock(lock) 写者用它来尽力获得读写锁lock，如果能够立即获得读写锁，它就获得锁并返回真，否则不能获得锁，返回假。无论是否能够获得锁，
                    它都将立即返回，绝不自旋在那里。

					
read_lock(lock)     读者要访问被读写锁lock保护的共享资源，需要使用该宏来得到读写锁lock。如果能够立即获得，它将立即获得读写锁并返回，否则，
                    将自旋在那里，直到获得该读写锁。
read_unlock(lock)	读者使用该宏来释放读写锁lock。它必须与read_lock配对使用。
write_lock(lock)    写者要想访问被读写锁lock保护的共享资源，需要使用该宏来得到读写锁lock。如果能够立即获得，它将立即获得读写锁并返回，否则，
                    将自旋在那里，直到获得该读写锁。					
write_unlock(lock)  写者使用该宏来释放读写锁lock。它必须与write_lock配对使用。					
					
read_lock_irqsave(lock, flags)  读者也可以使用该宏来获得读写锁，与read_lock不同的是，该宏还同时把标志寄存器的值保存到了变量flags中，
                                并失效了本地中断。
read_unlock_irqrestore(lock, flags) 读者也可以使用该宏来释放读写锁，与read_unlock不同的是，该宏还同时把标志寄存器的值恢复为变量flags的值。
                                    它必须与read_lock_irqsave配对使用。								
write_lock_irqsave(lock, flags) 写者可以用它来获得读写锁，与write_lock不同的是，该宏还同时把标志寄存器的值保存到了变量flags中，
                                并失效了本地中断。
write_unlock_irqrestore(lock, flags) 写者也可以使用该宏来释放读写锁，与write_unlock不同的是，该宏还同时把标志寄存器的值恢复为变量flags的值，
                                     并使能本地中断。它必须与write_lock_irqsave配对使用。


read_lock_irq(lock)  读者也可以用它来获得读写锁，与read_lock不同的是，该宏还同时失效了本地中断。该宏与read_lock_irqsave的不同之处是，
                     它没有保存标志寄存器。
read_unlock_irq(lock) 读者也可以使用该宏来释放读写锁，与read_unlock不同的是，该宏还同时使能本地中断。它必须与read_lock_irq配对使用。
					 
write_lock_irq(lock) 写者也可以用它来获得锁，与write_lock不同的是，该宏还同时失效了本地中断。该宏与write_lock_irqsave的不同之处是，
                     它没有保存标志寄存器。		
write_unlock_irq(lock) 写者也可以使用该宏来释放读写锁，与write_unlock不同的是，该宏还同时使能本地中断。它必须与write_lock_irq配对使用。

read_lock_bh(lock)   读者也可以用它来获得读写锁，与与read_lock不同的是，该宏还同时失效了本地的软中断。
read_unlock_bh(lock) 读者也可以使用该宏来释放读写锁，与read_unlock不同的是，该宏还同时使能本地软中断。它必须与read_lock_bh配对使用。
write_lock_bh(lock)  写者也可以用它来获得读写锁，与write_lock不同的是，该宏还同时失效了本地的软中断。
write_unlock_bh(lock) 写者也可以使用该宏来释放读写锁，与write_unlock不同的是，该宏还同时使能本地软中断。它必须与write_lock_bh配对使用。

}


大读者锁的实现机制是：每一个大读者锁在所有CPU上都有一个本地读者写者锁，一个读者仅需要获得本地CPU的读者锁，而写者必须获得所有CPU上的锁。


void br_read_lock (enum brlock_indices idx);
读者使用该函数来获得大读者锁idx，在2.4内核中，预定义的idx允许的值有两个：BR_GLOBALIRQ_LOCK和BR_NETPROTO_LOCK，当然，用户可以添加自己定义的大读者锁ID 。
void br_read_unlock (enum brlock_indices idx);
读者使用该函数释放大读者锁idx。

void br_write_lock (enum brlock_indices idx);
写者使用它来获得大读者锁idx。
void br_write_unlock (enum brlock_indices idx);
写者使用它来释放大读者锁idx。

br_read_lock_irqsave(idx, flags)
读者也可以使用该宏来获得大读者锁idx，与br_read_lock不同的是，该宏还同时把寄存器的值保存到变量flags中，并且失效本地中断。
br_read_lock_irq(idx)
读者也可以使用该宏来获得大读者锁idx，与br_read_lock不同的是，该宏还同时失效本地中断。与br_read_lock_irqsave不同的是，该宏不保存标志寄存器。
br_read_lock_bh(idx)
读者也可以使用该宏来获得大读者锁idx，与br_read_lock不同的是，该宏还同时失效本地软中断。

br_write_lock_irqsave(idx, flags)
写者也可以使用该宏来获得大读者锁idx，与br_write_lock不同的是，该宏还同时把寄存器的值保存到变量flags中，并且失效本地中断。
br_write_lock_irq(idx)
写者也可以使用该宏来获得大读者锁idx，与br_write_lock不同的是，该宏还同时失效本地中断。与br_write_lock_irqsave不同的是，该宏不保存标志寄存器。
br_write_lock_bh(idx)
写者也可以使用该宏来获得大读者锁idx，与br_write_lock不同的是，该宏还同时失效本地软中断。

br_read_unlock_irqrestore(idx, flags)
读者也使用该宏来释放大读者锁idx，它与br_read_unlock不同之处是，该宏还同时把变量flags的值恢复到标志寄存器。
br_read_unlock_irq(idx)
读者也使用该宏来释放大读者锁idx，它与br_read_unlock不同之处是，该宏还同时使能本地中断。
br_read_unlock_bh(idx)
读者也使用该宏来释放大读者锁idx，它与br_read_unlock不同之处是，该宏还同时使能本地软中断。

br_write_unlock_irqrestore(idx, flags)
写者也使用该宏来释放大读者锁idx，它与br_write_unlock不同之处是，该宏还同时把变量flags的值恢复到标志寄存器。
br_write_unlock_irq(idx)
写者也使用该宏来释放大读者锁idx，它与br_write_unlock不同之处是，该宏还同时使能本地中断。
br_write_unlock_bh(idx)
写者也使用该宏来释放大读者锁idx，它与br_write_unlock不同之处是，该宏还同时使能本地软中断。

这些API的使用与读写锁完全一致。

























					 