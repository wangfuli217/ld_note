https://www.ibm.com/developerworks/cn/linux/l-synch/part2/

ibm()
{
大内核锁本质上也是自旋锁，但是它又不同于自旋锁，
1. 自旋锁是不可以递归获得锁的，因为那样会导致死锁。大内核锁可以递归获得锁。
2. 大内核锁用于保护整个内核，而自旋锁用于保护非常特定的某一共享资源。
3. 进程保持大内核锁时可以发生调度，进程自旋锁锁时不可以发生调度，


具体实现是：在执行schedule时，schedule将检查进程是否拥有大内核锁，如果有，它将被释放，以致于其它的进程能够获得该锁，而当轮到该进程运行时，
            再让它重新获得大内核锁。注意在保持自旋锁期间是不运行发生调度的。
还需要特别指出的是，大内核锁是历史遗留，内核中用的非常少，一般保持该锁的时间较长，因此不提倡使用它。从2.6.11内核起，大内核锁可以通过配置
                    内核使其变得可抢占（自旋锁是不可抢占的），这时它实质上是一个互斥锁，使用信号量实现。

大内核锁的API包括：
void lock_kernel(void);
该函数用于得到大内核锁。它可以递归调用而不会导致死锁。

void unlock_kernel(void);
该函数用于释放大内核锁。当然必须与lock_kernel配对使用，调用了多少次lock_kernel，就需要调用多少次unlock_kernel。

大内核锁的API使用非常简单，按照以下方式使用就可以了：
lock_kernel();
//对被保护的共享资源的访问
…
unlock_kernel()；
}


BLK(用于解决smp下进程在不同CPU下执行的困境)
{
但是它又有一些非常诡异的地方。从表面上看：

1、BKL是一个全局的锁（注意，是"一个"而不是"一种"），它保护所有使用它来同步的临界区。一旦一个进程获得BKL，进入被它保护的临界区，不但该临界区被上锁，所有被它保护的临界区都一起被锁住。
这看起来非常之武断：进程A在CPU_1上操作链表list_a，而进程B在CPU_2上操作全局变量var_b，这两者本身毫无瓜葛。但如果你使用了BKL，它们就要"被同步"。

2、BKL是递归锁。同一进程中可以对BKL嵌套的上锁和解锁，当解锁次数等于上锁次数时，锁才真正被释放。
这一点虽然跟内核中的其他锁不大一样，但倒也不算神奇，用户态的pthread_mutex也支持这样的递归锁。

3、BKL有自动释放的特性。在CPU_N上，如果当前进程A持有BKL，则当CPU_N上面发生调度时，进程A持有的BKL将被自动释放。而当进程A再次被调度执行时，它又自动获得BKL（如果BKL正在被其他进程持有，则进程A不会被调度执行）。
这个特性对于普通的用户态程序来说实在是不可思议：进程A进入了临界区，要准备修改某全局链表list_a，但是由于某种原因而进入睡眠（比如系统内存紧缺时，等待分配内存），结果锁就被自动释放了。而另一个进程B就可以堂而皇之的获得锁而进入临界区，并且把全局链表list_a给改了。等进程A从睡眠中被唤醒的时候，就发现这个世界全变了……而锁呢？竟然完全不起作用。

BKL的前两个特性还好理解，第三个特性实在是匪夷所思。这么诡异的锁是怎么来的呢？

BKL的前两个特性还好理解，第三个特性实在是匪夷所思。这么诡异的锁是怎么来的呢？
百度一下"大内核锁"可以了解到：据说在linux 2.0时代，内核是不支持SMP（对称多处理器）的。在迈入linux 2.2时代的时候，SMP逐渐流行起来，内核需要对其进行支持了。但是发现，内核中的很多代码在多个CPU上同时运行的时候会存在问题。怎么办呢？最完美的解决办法当然是把所有存在问题的地方都找出来，然后给它们分别安排一个锁。但是这样做的话工作量会很大，为了快速支持SMP，linux内核出了狠招，这就是BKL：CPU进入内核态时就上BKL、退出内核态时释放。于是，系统中同一时刻就只有一个CPU会处于内核态，内核代码就没有了"在多个CPU上同时运行"的问题。
这一招很有效，但是显然很拙劣，内核代码不能在多个CPU上同时运行，SMP的优势大打折扣。于是后来的内核版本又逐步逐步的在削减被BKL所保护的临界区，以期把它们都消灭干净。

一个进程上了一个锁，保护了一个临界区。那么在锁被释放之前，其他进程都应该遵守规则，而不进入这个临界区。这里的"其他进程"有两层含义：
1、由于调度，在同一CPU上交错运行的其他进程；
2、由于SMP，在不同CPU上同时运行的其他进程；
把"其他进程"划分成这两类，似乎有点畸形，但这也正是BKL畸形之所在。因为我们一般所说的同步、所用到的锁都是针对所有"其他进程"的，不管是"在同一CPU上交错运行的其他进程"，还是"在不同CPU上同时运行的其他进程"，都应该在被同步的范围之内。

那么BKL为什么不能设计成跟普通的锁一样健全呢？因为，正是由于BKL的不健全，一个持有BKL的进程在进入睡眠之后，其它进程还可以持有BKL，还可以进入临界区。如果它健全的话，其他进程都只有傻傻等待的份，SMP的优势将再打折扣。
}
