CPU上将要执行的代码将会执行一个测试并设置某个内存变量的原子操作,若测试结果表明锁已经空闲,则程序获得这个自旋
锁继续运行;若仍被占用,则程序将在一个小的循环内重复测试这个"测试并设置"的操作.这就是自旋。

利用spin_lock()/spin_unlock()作为自旋锁的基础，将它们和
关中断local_irq_disable()/开中断local_irq_enable(),
关底半部local_bh_disable()/开底半部local_bh_enable(),
关中断并保存状态字local_irq_save()/开中断并恢复状态local_irq_restore()
结合就完成了整套自旋锁机制。


1)什么叫自旋锁，就是忙等待，当锁不可用时，CPU除了在那儿拼命的执行"测试并设置"的傻瓜操作外什么都不做，可见，这是多么的影响系统的性能。

spinlock(API)
{
方法                      描述
spin_lock()             获取指定的自旋锁                                       
spin_lock_irq()         禁止本地中断并获取指定的锁                              = spin_lock() + local_irq_disable()
spin_lock_irqsave()     保存本地中断的当前状态，禁止本地中断，并获取指定的锁    = spin_unlock() + local_irq_save()
spin_unlock()           释放指定的锁                                           
spin_unlock_irq()       释放指定的锁，并激活本地中断                            = spin_unlock() + local_irq_enable()
spin_unlock_irqstore()  释放指定的锁，并让本地中断恢复到以前状态                = spin_unlock() + local_irq_restore()
spin_lock_init()        动态初始化指定的spinlock_t                             
spin_trylock()          试图获取指定的锁，如果未获取，则返回0                  
spin_is_locked()        如果指定的锁当前正在被获取，则返回非0，否则返回0       

spin_lock_bh() = spin_lock() + local_bh_disable()
spin_unlock_bh() = spin_unlock() +local_bh_enable()
}

https://www.ibm.com/developerworks/cn/linux/l-synch/part1/
spinlock(ibm)
{
自旋锁与互斥锁有点类似，只是自旋锁不会引起调用者睡眠，如果自旋锁已经被别的执行单元保持，调用者就一直循环在那里看是否该自旋锁的保持者已经释放了锁，
"自旋"一词就是因此而得名。由于自旋锁使用者一般保持锁时间非常短，因此选择自旋而不是睡眠是非常必要的，自旋锁的效率远高于互斥锁。


信号量和读写信号量 (只能在进程上下文使用（_trylock的变种能够在中断上下文使用）)
1. 合于保持时间较长的情况，
2. 致调用者睡眠，
3. 信号量和读写信号量保持期间是可以被抢占的

如果被保护的共享资源只在进程上下文访问，使用信号量保护该共享资源非常合适，如果对共巷资源的访问时间非常短，自旋锁也可以。

自旋锁适(在任何上下文使用)
1. 合于保持时间非常短的情况，
2. 自旋锁保持期间是抢占失效的，
3. 自旋锁只有在内核可抢占或SMP的情况下才真正需要，在单CPU且不可抢占的内核下，自旋锁的所有操作都是空操作。

但是如果被保护的共享资源需要在中断上下文访问（包括底半部即中断处理句柄和顶半部即软中断），就必须使用自旋锁。
无论是互斥锁，还是自旋锁，在任何时刻，最多只能有一个保持者，也就说，在任何时刻最多只能有一个执行单元获得锁。


DEFINE_SPINLOCK(x)  //静态初始化
SPIN_LOCK_UNLOCKED
DEFINE_SPINLOCK(x)等同于spinlock_t x = SPIN_LOCK_UNLOCKED

spin_lock_init(x) 	//动态初始化。

spin_is_locked(x)   //判断自旋锁x是否已经被某执行单元保持（即被锁），如果是，返回真，否则返回假。
spin_unlock_wait(x) //等待自旋锁x变得没有被任何执行单元保持，如果没有任何执行单元保持该自旋锁，
                      该宏立即返回，否则将循环在那里，直到该自旋锁被保持者释放。

spin_trylock(lock)  //尽力获得自旋锁lock，如果能立即获得锁，它获得锁并返回真，否则不能立即获得锁，立即返回假。它不会自旋等待lock被释放。
spin_lock(lock)     //用于获得自旋锁lock，如果能够立即获得锁，它就马上返回，否则，它将自旋在那里，直到该自旋锁的保持者释放，
                      这时，它获得锁并返回。总之，只有它获得锁才返回。					  
spin_unlock(lock)   //释放自旋锁lock，它与spin_trylock或spin_lock配对使用。如果spin_trylock返回假，表明没有获得自旋锁，
                      因此不必使用spin_unlock释放。					  

spin_lock_irqsave(lock, flags) 		//获得自旋锁的同时把标志寄存器的值保存到变量flags中并失效本地中断。
spin_trylock_irqsave(lock, flags)  //如果获得自旋锁lock，它也将保存标志寄存器的值到变量flags中，并且失效本地中断，如果没有获得锁，它什么也不做。
                                     因此如果能够立即获得锁，它等同于spin_lock_irqsave，如果不能获得锁，它等同于spin_trylock。
                                    如果该宏获得自旋锁lock，那需要使用spin_unlock_irqrestore来释放。
spin_unlock_irqrestore(lock, flags) //释放自旋锁lock的同时，也恢复标志寄存器的值为变量flags保存的值。它与spin_lock_irqsave配对使用。

spin_lock_irq(lock)			   //类似于spin_lock_irqsave，只是该宏不保存标志寄存器的值。
spin_trylock_irq(lock)         //类似于spin_trylock_irqsave，只是该宏不保存标志寄存器。如果该宏获得自旋锁lock，需要使用spin_unlock_irq来释放。
spin_unlock_irq(lock)          //释放自旋锁lock的同时，也使能本地中断。它与spin_lock_irq配对应用。

spin_lock_bh(lock)			   //在得到自旋锁的同时失效本地软中断。
spin_trylock_bh(lock)          //如果获得了自旋锁，它也将失效本地软中断。如果得不到锁，它什么也不做。因此，如果得到了锁，它等同于spin_lock_bh，
                                 如果得不到锁，它等同于spin_trylock。如果该宏得到了自旋锁，需要使用spin_unlock_bh来释放。
spin_unlock_bh(lock)	       //释放自旋锁lock的同时，也使能本地的软中断。它与spin_lock_bh配对使用。

spin_can_lock(lock)
该宏用于判断自旋锁lock是否能够被锁，它实际是spin_is_locked取反。如果lock没有被锁，它返回真，否则，返回假。
该宏在2.6.11中第一次被定义，在先前的内核中并没有该宏。
}

spinlock(tasklet和timer->tasklet-timer 与 进程上下文)
{
------ tasklet和timer是用软中断实现的  <tasklet-timer 与 进程上下文>  ---- 进行保护 spin_lock_bh
如果被保护的共享资源只在进程上下文访问和软中断上下文访问，那么当在进程上下文访问共享资源时，可能被软中断打断，从而可能
进入软中断上下文来对被保护的共享资源访问，因此对于这种情况，对共享资源的访问必须使用spin_lock_bh和spin_unlock_bh来保护。

}

spinlock(tasklet和timer->只在一个tasklet-timer上下文)
{
------ tasklet和timer是用软中断实现的  <只在一个tasklet-timer上下文>   ---- 无需保护
如果被保护的共享资源只在一个tasklet或timer上下文访问，那么不需要任何自旋锁保护，因为同一个tasklet或timer只能在一个CPU上运行，
即使是在SMP环境下也是如此。实际上tasklet在调用tasklet_schedule标记其需要被调度时已经把该tasklet绑定到当前CPU，因此同一个tasklet
决不可能同时在其他CPU上运行。timer也是在其被使用add_timer添加到timer队列中时已经被帮定到当前CPU，所以同一个timer绝不可能运行
在其他CPU上。当然同一个tasklet有两个实例同时运行在同一个CPU就更不可能了。
}

spinlock(tasklet和timer->只在多个tasklet-timer上下文)
{
------ tasklet和timer是用软中断实现的  <只在多个tasklet-timer上下文>   ---- 进行保护 spin_lock
	如果被保护的共享资源只在两个或多个tasklet或timer上下文访问，那么对共享资源的访问仅需要用spin_lock和spin_unlock来保护，不必使用_bh版本，
因为当tasklet或timer运行时，不可能有其他tasklet或timer在当前CPU上运行。 
	如果被保护的共享资源只在一个软中断（tasklet和timer除外）上下文访问，那么这个共享资源需要用spin_lock和spin_unlock来保护，
因为同样的软中断可以同时在不同的CPU上运行。
	如果被保护的共享资源在两个或多个软中断上下文访问，那么这个共享资源当然更需要用spin_lock和spin_unlock来保护，不同的软中断能够同时在
不同的CPU上运行。
}

spinlock(tasklet和timer->软中断或进程上下文 & 硬件中断)
{
------ tasklet和timer是用软中断或进程上下文 & 硬件中断  <多种中断和进程上下文>   ---- 进行保护 spin_lock_irq
	如果被保护的共享资源在软中断（包括tasklet和timer）或进程上下文和硬中断上下文访问，那么在软中断或进程上下文访问期间，可能被硬中断打断，
从而进入硬中断上下文对共享资源进行访问，因此，在进程或软中断上下文需要使用spin_lock_irq和spin_unlock_irq来保护对共享资源的访问。
而在中断处理句柄中使用什么版本，需依情况而定，
	如果只有一个中断处理句柄访问该共享资源，那么在中断处理句柄中仅需要spin_lock和spin_unlock来保护对共享资源的访问就可以了。因为在执行
中断处理句柄期间，不可能被同一CPU上的软中断或进程打断。但是
	如果有不同的中断处理句柄访问该共享资源，那么需要在中断处理句柄中使用spin_lock_irq和spin_unlock_irq来保护对共享资源的访问。

}

spinlock(tasklet和timer->软中断或进程上下文 & 硬件中断)
{
------ tasklet和timer是用软中断或进程上下文 & 硬件中断  <多种中断和进程上下文>   ---- 进行保护 spin_lock_irqsave (访问前中断未使能)
在使用spin_lock_irq和spin_unlock_irq的情况下，完全可以用spin_lock_irqsave和spin_unlock_irqrestore取代，那具体应该使用哪一个也需要依情况而定，
	如果可以确信在对共享资源访问前中断是使能的，那么使用spin_lock_irq更好一些，因为它比spin_lock_irqsave要快一些，但是
	如果你不能确定是否中断使能，那么使用spin_lock_irqsave和spin_unlock_irqrestore更好，因为它将恢复访问共享资源前的中断标志而不是直接使能中断。
	当然，有些情况下需要在访问共享资源时必须中断失效，而访问完后必须中断使能，这样的情形使用spin_lock_irq和spin_unlock_irq最好。

需要特别提醒读者，spin_lock用于阻止在不同CPU上的执行单元对共享资源的同时访问以及不同进程上下文互相抢占导致的对共享资源的非同步访问，
而中断失效和软中断失效却是为了阻止在同一CPU上软中断或中断对共享资源的非同步访问。

}




