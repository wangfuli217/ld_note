1. netlink 采用异步机制，更容易实现和可动态链接的优点。
2. 896MB以内的常规的可被寻址的内存区域称为低端内存。内存分配函数kmalloc就是从该区域分配内存的。高于896MB的
   内存区域称为高端内存，只有在采用特使的方式进行映射后才能被访问。
3. start_kernel函数首先会初始化CPU子系统，之后让内存和进程管理系统就位，接下来启动外部总线和IO设备，
   最后一步是激活init进程。
Centos：
      POST(加点自检) -> Boot Sequence(BIOS基本输入输出系统)->Boot Loader(MBR主引导记录) -> Kernel(ramdisk) ->
rootfs(根文件系统) ->switchchroot ->/sbin/init(/etc/inittab /etc/init/*.conf) ->设定运行级别 -> 系统初始化脚本
-> 关闭启动相应服务 -> 启动终端

   
   
   
4. 内核利用硬件提供的不同的定时器以支持忙等待或睡眠等待等时间相关的服务。
   内核定时器变量jiffies HZ xtinme
   Pentium时间戳计数器TSC
   实时钟RTC
5. 所有的逻辑地址都是内核虚拟地址，而所有的虚拟地址并非一定是逻辑地址。

param.h
jiffies.h

loops_per_jiffy(一个jiffy时间内运行一个内部的延迟循环的次数)
{
init/calibrate.c

BogoMIPS=loops_per_jiffy * 1秒内的jiffy数 * 延迟循环消耗的指令
        =2394935*HZ*2/(1000000)
        =2394935*250*2/(1000000)
        =119.46
############## loops_per_jiffy  #######################
在启动过程中，内核会计算处理器在一个jiffy时间内运行一个内部的延迟循环的次数。jiffy的含义是在系统定时器2个连续的节拍之间的间隔。
正如所料，该计算必须被校准到所用CPU的处理速度。校准的结果被存储在称为loops_per_jiffy的内核变量中。使用loops_per_jiffy的一种情
况是某设备驱动程序希望进行小的微妙级别的延迟的时候。

为了理解延迟—循环校准代码，让我们看一下定义于init/calibrate.c文件中的calibrate_delay()函数。该函数灵活地使用整型运算得到了
浮点的精度。如下的代码片段(有一些注释)显示了该函数的开始部分，这部分用于得到一个 loops_per_jiffy的粗略值：
loops_per_jiffy = (1 << 12); /* Initial approximation = 4096 */
printk(KERN_DEBUG "Calibrating delay loop...");
while ((loops_per_jiffy <<= 1) != 0) {
ticks = jiffies;  

  while (ticks == jiffies); /* Wait until the start of the next jiffy */
  ticks = jiffies;

  __delay(loops_per_jiffy);
 
  ticks = jiffies - ticks;
  if (ticks) break;
}

loops_per_jiffy >>= 1; /* This fixes the most significant bit and is
                          the lower-bound of loops_per_jiffy */
                          
上述代码首先假定loops_per_jiffy大于4096，这可以转化为处理器速度大约为每秒100万条指令，即1 MIPS。接下来，它等待jiffy被刷新(1个新的节拍的开始)，
并开始运行延迟循环__delay(loops_per_jiffy)。如果这个延迟 循环持续了1个jiffy以上，将使用以前的loops_per_jiffy值(将当前值右移1位)修复当前
loops_per_jiffy的最高位;否 则，该函数继续通过左移loops_per_jiffy值来探测出其最高位。在内核计算出最高位后，它开始计算低位并微调其精度：

                          
896 MB以内的常规的可被寻址的内存区域被称作低端内存。内存分配函数kmalloc()就是从该区域分配内存的。高于896 MB的内存区域被称为高端内存，
只有在采用特殊的方式进行映射后才能被访问。
在启动过程中，内核会计算并显示这些内存区内总的页数。
}

MIPS(每秒处理的百万级的机器语言指令数)
{
    MIPS(Million Instructions Per Second)：单字长定点指令平均执行速度 Million Instructions Per Second的缩写，每秒处理的百万级的
机器语言指令数。这是衡量CPU速度的一个指标。像是一个Intel 80386 电脑可以每秒处理3百万到5百万机器语言指令，即我们可以说80386
是3到5MIPS的CPU。MIPS只是衡量CPU性能的指标。
    因为时钟是CPU的脉搏，每一次跳动执行一条指令，既是1Mips/MHz一般的CPU的极限就是1Mips/MHz，就是一秒钟时钟振荡1百万次，指令执行
1百万条，这仅限于单指令周期指令，多指令周期指令会花掉更长的时间，早期的51单片机是12指令周期的，所以为1/12MIPS/MHz，但是新型
CPU采用了流水线结构和一起其他的手段之后，能够超过1Mips/MHz，很恐怖吧，PIC的一些单片机即可以办到。
}

HZ_Jiffies(系统定时器能以可编程的频率中断处理器：HZ)
{
time_after(jiffies, timeout)
time_before(jiffies, timeout)
time_after_eq(jiffies, timeout)
time_before_eq(jiffies, timeout)
jiffies jiffies_64
##################### HZ和Jiffies #########################
　　系统定时器能以可编程的频率中断处理器。此频率即为每秒的定时器节拍数，对应着内核变量HZ。选择合适的HZ值需要权衡。HZ值大，定时器间隔时间就小，
因此进程调度的准确性会更高。但是，HZ值越大也会导致开销和电源消耗更多，因为更多的处理器周期将被耗费在定时器中断上下文中。
    HZ的值取决于体系架构。在x86系统上，在2.4内核中，该值默认设置为100；在2.6内核中，该值变为1000；而在2.6.13中，它又被降低到了250。
在基于ARM的平台上，2.6内核将HZ设置为100。在目前的内核中，可以在编译内核时通过配置菜单选择一个HZ值。该选项的默认值取决于体系架构的版本。
jiffies变量记录了系统启动以来，系统定时器已经触发的次数。内核每秒钟将jiffies变量增加HZ次。因此，对于HZ值为100的系统，1个jiffy等于10ms，
而对于HZ为1000的系统，1个jiffy仅为1ms。
}

check_bugs(启动代码检查体系架构相关的Bug)
{
x86在/include/asm/x86/bugs.h      cpu_idle()
arm在/include/asm-generic/bugs.h  空函数
}

initrd(由引导程序加载的常驻内存的虚拟磁盘镜像)
{
命令行
initrd= 

make config
INITRAMFS_SOURCE 选项直接编入内核：需要提供cpio压缩包的文件名或者包含initramfs的目录树。

mkinitramfs 可以创建一个initramfs镜像。
documentation/filesystems/ramfsrootfs-initramfs.txt

}

用户模式的代码允许发生缺页，而内核模式的代码则不允许。
jiffies(系统启动以来定时器已触发的次数)
{
1. IDE drivers/ide/ide.c 中一直轮询磁盘驱动器的忙状态                               jiffies操作实例
2. jiffies向秒转换 (jiffies - stream->start)/HZ  drivers/usb/host/ehci-sched.c      jiffies转向秒
3. jiffies_64 drivers/cpufreq/cpufreq_stat.c 文件中定义的 cpufreq_stats_update()    jiffies_64操作实例

长延时+忙等待：  timeout = jiffies+HZ; while(time_before(jiffies, timeout)) continue; =>  长延时+睡眠等待
长延时+睡眠等待： schedule_timeout(timeout); [ wait_event_timeout() 条件满足或超时继续执行 和 msleep(睡眠指定毫秒时间) ]
      定时器API：init_timer() DEFINE_TIMER() add_timer() mod_timer() del_timer() timer_pending()
      用户态：   clock_settime() 和 clock_gettime() 调用了内核定时器服务
                 setitime() 和 getitime() 控制一个警告信号在特定的超时后发生      
短延时+忙等待：  mdelay(毫秒) udelay(微秒) ndelay(纳秒) 短延时API使用loops_per_jiffies值来决定需要进行循环的次数
短延时+睡眠等待：

##################### 长延时 jiffies 短延时 #########################
    这种长延时技术仅仅适用于进程上下文。睡眠等待不能用于中断上下文，因为中断上下文不允许执行schedule()或睡眠(4.2节给出了中断上下文可以做和
不能做的事情)。在中断中进行短时间的忙等待是可行的，但是进行长时间的忙等则被认为不可赦免的罪行。在中断禁止时，
进行长时间的忙等待也被看作禁忌。

    为了支持在将来的某时刻进行某项工作，内核也提供了定时器API。可以通过init_timer()动态定义一个定时器，也可以通过DEFINE_TIMER()静态创建定时器。
然后，将处理函数的地址和参数绑定给一个timer_list，并使用add_timer()注册它即可：

    在内核中，小于jiffy的延时被认为是短延时。这种延时在进程或中断上下文都可能发生。由于不可能使用基于jiffy的方法实现短延时，之前讨论的睡眠等待
将不再能用于短的超时。这种情况下，唯一的解决途径就是忙等待。
    忙等待的实现方法是测量处理器执行一条指令的时间，为了延时，执行一定数量的指令。从前文可知，内核会在启动过程中进行测量并将该值存储在
loops_per_jiffy变量中。短延时API就使用了loops_per_jiffy值来决定它们需要进行循环的数量。为了实现握手进程中1微秒的延时，USB主机控制器驱动程序
(drivers/usb/host/ehci-hcd.c)会调用udelay()，而udelay()会内部调用loops_per_jiffy：

}

TSC(Pentium)
{
TSC随着处理器周期速度的比例的变化而变化。剖析代码和检测代码
rdtsc(low_tsc_tick0, high_tsc_tick0);
printk("hello world");
rdtsc(low_tsc_tick1, high_tsc_tick1);
exec_time = low_tsc_tick1 - low_tsc_tick0;

#####################  Pentium时间戳计数器  #########################
　　时间戳计数器(TSC)是Pentium兼容处理器中的一个计数器，它记录自启动以来处理器消耗的时钟周期数。由于TSC随着处理器周期速率的比例的变化而变化，
因此提供了非常高的精确度。TSC通常被用于剖析和监测代码。使用rdtsc指令可测量某段代码的执行时间，其精度达到微秒级。TSC的节拍可以被转化为秒，
方法是将其除以CPU时钟速率(可从内核变量cpu_khz读取)。
}

rtc(实时钟)
{
1. 读取、设置绝对时间，在时钟更新时产生中断；
2. 产生频率为2~8192Hz之间的周期性中断
3. 设置告警信号

xtime用于保存墙上时钟。
do_gettimeofday(获取墙上时钟)

#####################  rtc  #########################
用户空间也包含一系列可以访问墙上时间的函数，包括：
　　(1) time()，该函数返回日历时间，或从新纪元(1970年1月1日00:00:00)以来经历的秒数;
　　(2) localtime()，以分散的形式返回日历时间;
　　(3) mktime()，进行localtime()函数的反向工作;
　　(4) gettimeofday()，如果你的平台支持，该函数将以微秒精度返回日历时间。
}

mutex_spinlock(睡眠等待和忙等待)
{
长等待：mutex 睡眠等待    进程上下文
短等待：spinlock 忙等待   中断上下文

#####################  自旋锁 和 互斥体  #########################
自旋锁可以确保在同时只有一个线程进入临界区。其他想进入临界区的线程必须不停地原地打转，直到第1个线程释放自旋锁。注意：这里所说的线程不是内核线程，
而是执行的线程。与自旋锁不同的是，互斥体在进入一个被占用的临界区之前不会原地打转，而是使当前线程进入睡眠状态。
如果要等待的时间较长，互斥体比自旋锁更合适，因为自旋锁会消耗CPU资源。在使用互斥体的场合，多于2次进程切换时间都可被认为是长时间，因此一个互斥体会
引起本线程睡眠，而当其被唤醒时，它需要被切换回来。
　　因此，在很多情况下，决定使用自旋锁还是互斥体相对来说很容易：
　　(1) 如果临界区需要睡眠，只能使用互斥体，因为在获得自旋锁后进行调度、抢占以及在等待队列上睡眠都是非法的;
　　(2) 由于互斥体会在面临竞争的情况下将当前线程置于睡眠状态，因此，在中断处理函数中，只能使用自旋锁。

互斥体接口代替了旧的信号量接口(semaphore)。互斥体接口是从-rt树演化而来的，在2.6.16内核中被融入主线内核。
　　尽管如此，但是旧的信号量仍然在内核和驱动程序中广泛使用。信号量接口的基本用法如下：
static DEFINE_MUTEX(mymutex);       spinlock_t mylock = SPIN_LOCK_UNLOCKED;     static DECLARE_MUTEX(mysem);
mutex_lock(&mymutex);               spin_lock(&mylock);                         down(&mysem);
mutex_unlock(&mymutex);             spin_unlock(&mylock);                       up(&mysem); 

中断屏蔽将使得中断和进程间的并发不再发生。

[进程上下文]->[进程上下文+中断上下文]->[进程上下文+中断上下文+抢占]->[进程上下文+中断上下文+抢占+SMP]
 不需要加锁    local_irq_save                spin_lock_irqsave            spin_lock_irqsave
               local_irq_restore             spin_unlock_irqrestore       spin_unlock_irqrestore

资源临界区管理

(1) 非抢占内核，单CPU情况下存在于进程上下文的临界区;
不需要加锁，

(2) 非抢占内核，单CPU情况下存在于进程和中断上下文的临界区;    [中断与临界区]
为了保护临界区，仅仅需要禁止中断。
          多个进行上下文与中断上下文具有临界区                              单个进行上下文与中断上下文具有临界区
local_irq_save(flags);     /* Disable Interrupts */                       local_irq_disable();     /* Disable Interrupts */
/* ... Critical Section ... */                                             /* ... Critical Section ... */
local_irq_restore(flags);  /* Restore state to what it was at Point A */  local_irq_enable();  /* Enable Interrupts */

(3) 可抢占内核，单CPU情况下存在于进程和中断上下文的临界区;    [中断+抢占与临界区]
  spin_lock_irqsave(&mylock, flags);
  /* ... Critical Section ... */
  /* Restore interrupt state to what it was at Point A */
  spin_unlock_irqrestore(&mylock, flags);
  
通过内核全局变量维护，只有在计数器值为0的时候，抢占才发挥作用。
  preempt_disable()
  preempt_enable()
  
(4) 可抢占内核，SMP情况下存在于进程和中断上下文的临界区。     [SMP+中断+抢占与临界区] 
  spin_lock_irqsave(&mylock, flags);
  /* ... Critical Section ... */
  /*
    - Restore interrupt state and preemption to what it
      was at Point A for the local CPU
    - Release the lock
   */
  spin_unlock_irqrestore(&mylock, flags);
  
    在SMP系统上，获取自旋锁时，仅仅本CPU上的中断被禁止。因此，一个进程上下文的执行单元(图2-4中的执行单元A)在一个CPU上运行的同时，一个中断处理函数
可能运行在另一个CPU上。非本CPU上的中断处理函数必须自旋等待本CPU上的进程上下文代码退出临界区。中断上下文需要调用spin_lock()/spin_unlock()
  
除了有irq变体以外，自旋锁也有底半部(BH)变体。在锁被获取的时候，
spin_lock_bh()会禁止底半部，而spin_unlock_bh()则会在锁被释放时重新使能底半部。  
  
}

atomic_op(原子操作)
{

#####################  原子操作  #########################
原子操作的使用将确保数据引用计数不会被这两个执行单元“蹂躏”。它也消除了使用锁去保护单一整型变量的争论。

　　内核也支持set_bit()、clear_bit()和test_and_set_bit()操作，它们可用于原子地位修改。查看include/asm-your-arch/atomic.h
文件可以看出你所在体系架构所支持的原子操作。
}

rwlock_t(自旋锁的读写锁变体)
{

#####################  读—写锁  #########################
另一个特定的并发保护机制是自旋锁的读—写锁变体。如果每个执行单元在访问临界区的时候要么是读要么是写共享的数据结构，但是它们都不会同时进行读和写操作，
那么这种锁是最好的选择。允许多个读线程同时进入临界区。读自旋锁可以这样定义：

rwlock_t myrwlock = RW_LOCK_UNLOCKED;   rwlock_t myrwlock = RW_LOCK_UNLOCKED;
read_lock(&myrwlock);                   write_lock(&myrwlock);    
read_unlock(&myrwlock);                 write_unlock(&myrwlock);  

net/ipx/ipx_route.c中的IPX路由代码是使用读—写锁的真实示例。一个称作ipx_routes_lock的读—写锁将保护IPX 路由表的并发访问。要通过查找路由表实现包转发
的执行单元需要请求读锁。需要添加和删除路由表中入口的执行单元必须获取写锁。由于通过读路由表的情况比更 新路由表的情况多得多，使用读—写锁提高了性能。

读写锁的irq变体
read_lock_irqsave()、       write_lock_irqsave()
read_unlock_ irqrestore()、 write_unlock_irqrestore()
}

seqlock(写多于读的自旋锁)
{

#####################  顺序锁(seqlock)  #########################
写多于读的读—写锁。在一个变量的写操作比读操作多得多的情况下，这种锁非常有用。前文讨论的jiffies_64变量就是使用顺序锁的一个例子。写线程不必等待
一个已经进入临界区的读，因此，读线程也许会发现它们进入临界区的操作失败，因此需要重试：
# u64 get_jiffies_64(void) /* Defined in kernel/time.c */
# {
#   unsigned long seq;
#   u64 ret;
#   do {
#     seq = read_seqbegin(&xtime_lock);
#     ret = jiffies_64;
#   } while (read_seqretry(&xtime_lock, seq));
#   return ret;
# }
写者会使用write_seqlock()和write_sequnlock()保护临界区。
}

RCU(读远远多于写的锁)
{

#####################  读—复制—更新(RCU)  #########################
该机制用于提高读操作远多于写操作时的性能。其基本理念是读线程不需要加锁，但是写线程 会变得更加复杂，它们会在数据结构的一份副本上执行更新操作，
并代替读者看到的指针。为了确保所有正在进行的读操作的完成，原子副本会一直被保持到所有 CPU上的下一次上下文切换。使用RCU的情况很复杂，因此，
只有在确保你确实需要使用它而不是前文的其他原语的时候，才适宜选择它。 include/linux/ rcupdate.h文件中定义了RCU的数据结构和接口函数，
Documentation/RCU/*提供了丰富的文档。

fs/dcache.c文件中包含一个RCU的使用示例。在Linux中，每个文件都与一个目录入口信息(dentry结构体)、元数据信息(存放在 inode中)和实际的数据(存放在
数据块中)关联。每次操作一个文件的时候，文件路径中的组件会被解析，相应的dentry会被获取。为了加速未来的操 作，dentry结构体被缓存在称为dcache的
数据结构中。任何时候，对dcache进行查找的数量都远多于dcache的更新操作，因此，对 dcache的访问适宜用RCU原语进行保护。


例如，通过向/proc/sys/kernel/printk文件回送一个新的值，可以改变内核printk日志的级别。许多实用程序(如 ps)和系统性能监视工具(如sysstat)就是通过
驻留于/proc中的文件来获取信息的。
}


ZONE()
{
ZONE_DMA        
ZONE_NORMAL     kmalloc(内核) 直接通过page分配       kzalloc(用户态)
ZONE_HIGH       kmap和kunmap  映射和取消映射         vmalloc分配较大空间[分配虚拟连续但物理不一定连续的内存]

1. 后备缓冲区 look aside buffer
2. slab
3. mempool
##################### 内存分配 #########################
　　一些设备驱动程序必须意识到内存区的存在，另外，许多驱动程序需要内存分配函数的服务。本节我们将简要地讨论这两点。

　　内核会以分页形式组织物理内存，而页大小则取决于具体的体系架构。在基于x86的机器上，其大小为4096B。物理内存中的每一页都有一个与之对应的
struct page(定义在include/linux/ mm_types.h文件中)：

　 　在32位x86系统上，默认的内核配置会将4 GB的地址空间分成给用户空间的3 GB的虚拟内存空间和给内核空间的1 GB的空间(如图2-5所示)。
这导致内核能处理的处理内存有1 GB的限制。现实情况是，限制为896 MB，因为地址空间的128 MB已经被内核数据结构占据。通过改变3GB/1GB的分割线，
可以放宽这个限制，但是由于减少了用户进程虚拟地址空间的大小，在内存密集型的应用程序中可能会出现一些问题。

内核中用于映射低于896 MB物理内存的地址与物理地址之间存在线性偏移;这种内核地址被称作逻辑地址。在支持"高端内存"的情况下，在通过特定的方式映射
这些区域产生对应的虚拟地址后，内核将能访问超过896 MB的内存。所有的逻辑地址都是内核虚拟地址，而所有的虚拟地址并非一定是逻辑地址。

　　因此，存在如下的内存区。
　　(1) ZONE_DMA(小于16 MB)，该区用于直接内存访问(DMA)。由于传统的ISA设备有24条地址线，只能访问开始的16 MB，因此，内核将该区献给了这些设备。
　　(2) ZONE_NORMAL(16～896 MB),常规地址区域，也被称作低端内存。用于低端内存页的struct page结构中的"虚拟"字段包含了对应的逻辑地址。
　  (3) ZONE_HIGH(大于896 MB)，仅仅在通过kmap()映射页为虚拟地址后才能访问。(通过kunmap()可去除映射。)相应的内核地址为虚拟地址而非逻辑地址。
如果相应的页未被映射，用于高端内存页的struct page结构体的"虚拟"字段将指向NULL。

　　kmalloc()是一个用于从ZONE_NORMAL区域返回连续内存的内存分配函数，其原型如下：
　　void *kmalloc(int count, int flags);
　　count是要分配的字节数，flags是一个模式说明符。支持的所有标志列在include/linux./gfp.h文件中(gfp是get free page的缩写)，如下为常用标志。
　　(1) GFP_KERNEL，被进程上下文用来分配内存。如果指定了该标志，kmalloc()将被允许睡眠，以等待其他页被释放。
　　(2) GFP_ATOMIC，被中断上下文用来获取内存。在这种模式下，kmalloc()不允许进行睡眠等待，以获得空闲页，因此GFP_ATOMIC分配成功的可能性比用GFP_KERNEL低。
　　由于kmalloc()返回的内存保留了以前的内容，将它暴露给用户空间可到会导致安全问题，因此我们可以使用kzalloc()获得被填充为0的内存
　　如果需要分配大的内存缓冲区，而且也不要求内存在物理上有联系，可以用vmalloc()代替kmalloc()：
　　void *vmalloc(unsigned long count);
　　count是要请求分配的内存大小。该函数返回内核虚拟地址。
　  vmalloc()需要比kmalloc()更大的分配空间，但是它更慢，而且不能从中断上下文调用。另外，不能用vmalloc()返回的物理上不连续的内存执行DMA。
在设备打开时，高性能的网络驱动程序通常会使用vmalloc()来分配较大的描述符环行缓冲区。

}

mempool()
{

}

slab()
{

}


look_aside_buffer(后备缓冲区)
{

}

HZ                  include/asm-your-arch/param.h         每秒钟的系统时钟节拍数
loops_per_jiffy     init/main.c                           处理器在1个jiffy时间内执行外部延迟循环的次数
timer_list          include/linux/timer.h                 用于存放未来将会执行的函数的入口地址
timeval             include/linux/time.h                  时间戳
spinlock_t          include/linux/spinlock_types.h        用于确保仅有单一线程进入某临界区的忙等待锁
semaphore           include/asm-your-arch/semaphore.h     一种允许指定数量的执行线索进入临界区的可睡眠的锁机制
mutex               include/linux/mutex.h                 替代信号量的新街口
rwlock_t            include/linux/spinlock_types.h        读-写自旋锁
page                include/linux/mm_types.h              物理内存页在内核的表示


time_after           include/linux/jiffies.h               将目前的juffies值与指定的将来的值进行对比 
time_after_eq                                               
time_before                                                 
time_before_eq                                              
schedule_timeout     kernel/timer.c                         到指定的超时发生后调度进程执行
wait_event_timeout   include/linux/wait.h                   当特定条件为真或超时发生后恢复执行
DEFINE_TIMER         include/linux/timer.h                  静态定义一个定时器
init_timer           kernel/timer.c                         动态定义一个定时器
add_timer            include/linux/timer.h                  当超时时间到后调度定时器执行
mod_timer            kernel/timer.c                         修改定时器的到期时间
timer_pending        include/linux/timer.h                  检查当前是否有定时器等待执行
udelay               include/asm-yourarch/delay.h           忙等待指定的微妙数
                     arch/your-arch/lib/delay.c             
rdtsc                include/asm-x86/msr.h                  获得pentium兼容处理器上的TSC的值
do_gettimeofday      kernel/time.c                          获得墙上时间
local_irq_disable    include/asm-your-arch/system.h         禁止本CPU上的中断
local_irq_enable     include/asm-your-arch/system.h         启用本CPU上的中断
local_irq_save       include/asm-your-arch/system.h         保存中断状态并禁止中断
local_irq_restore    include/asm-your-arch/system.h         将中断状态恢复至对应的local_irq_save()被调用时的状态
spin_lock            include/linux/spinlock.h[kernel/spinlock.c]  获取自旋锁
spin_unlock          include/linux/spinlock.h[kernel/spinlock.c]  释放自旋锁
spin_lock_irqsave    include/linux/spinlock.h[kernel/spinlock.c]  保存中断状态，禁止本CPU上的中断和抢占，锁住临界区以防止被其他CPU访问 
spin_lock_irqrestore include/linux/spinlock.h[kernel/spinlock.c]   恢复中断状态，允许抢占并释放锁
DEFINE_MUTEX         include/mutex.h                           静态定义一个互斥体
mutex_init           include/mutex.h                           动态定义一个互斥体
mutex_lock           kernel/mutex.c                            获取互斥体
mutex_unlock         kernel/mutex.c                            释放互斥体
DECLARE_MUTEX        include/asm-your-arch/semaphore.h         静态定义一个信号量
init_MUTEX           include/asm-your-arch/semaphore.h         动态定义一个信号量
up                   arch/your-arch/kernel/semaphore.c         获取信号量
down                 arch/your-arch/kernel/semaphore.c         释放信号量
atomic_inc           include/asm-your-arch/atomic.h            执行轻量级操作的原子操作  
atomic_inc_and_test    
atomic_dec             
atomic_dec_and_test    
clear_bit              
set_bit                
test_bit               
test_and_set_bit       
read_lock            include/linux/spinlock.h                 自旋锁的读写锁变体
read_unlock          kernel/spinlock.c  
write_lock             
write_unlock           
write_lock_irqsave     
write_unlock_irqrestore 
down_read             kernel/rwsem.c                           信号量的读写变体 
up_read                
down_write             
up_write               
read_seqbegin         include/linux/seqlock.h                  seqlock操作   
read_seqretry          
write_seqlock          
write_sequnlock        
kmalloc               include/linux/slab.h mm/slab.c          从ZONE_NORMAL申请物理连续的内存
kzalloc                include/linux/slab.h mm/util.c         经由kmalloc申请内存，并将其清零
kfree                  mm/slab.c                              释放kmalloc申请的内存
vmalloc                mm/vmalloc.c                           分配虚拟连续但物理不一定连续的内存








