---
title: Linux学习总结（八）——线程
date: 2016-12-18 11:52:36
categories: Linux学习记录
tags: [线程, 条件变量, 线程属性, 互斥锁]
---

进程，它是资源分配的最小单位，进程中的事情需要按照一定的顺序逐个进行，那么：**如何让一个进程中的一些事情同时执行？**
<!--more-->

这时候就需要使用线程。**线程**，有时又称轻量级进程，它是 **程序执行的最小单位**，**系统独立调度和分派 cpu 的基本单位**，它是**进程中的一个实体**。一个进程中可以有多个线程，这些线程共享进程的所有资源，线程本身只包含一点必不可少的资源。

在了解线程之前需要清楚几个概念：
1. **并发**
并发是指在同一时刻，只能有一条指令执行，但多个进程指令被快速轮换执行，使得在宏观上具有多个进程同时执行的效果。 **看起来同时发生**
1. **并行**
并行是指在同一时刻，有多条指令在多个处理器上同时执行。**真正的同时发生**
1. **同步**
彼此有依赖关系的调用不应该“同时发生”，而同步就是要阻止那些“同时发生”的事情。
1. **异步**
异步的概念和同步相对，任何两个彼此独立的操作是异步的，它表明事情独立的发生。


线程解决了进程的很多弊端：一是由于进程是资源拥有者，创建、撤消与切换存在较大的时空开销，；二是由于对称多处理机（SMP）出现，可以满足多个运行单位，而多个进程并行开销过大。因此，线程具有以下优势：
> 1、在多处理器中开发程序的并行性
    2、在等待慢速IO操作时，程序可以执行其他操作，提高并发性
    3、模块化的编程，能更清晰的表达程序中独立事件的关系，结构清晰
    4、占用较少的系统资源


## 一、线程的创建：
每个 Linux 都会运行在下面四种状态下：
* 就绪
 当线程刚被创建时就处于就绪状态，或者当线程被解除阻塞以后也会处于就绪状态。就绪的线程在等待一个可用的处理器，当一个运行的线程被抢占时，它立刻又回到就绪状态
* 运行
 当处理器选中一个就绪的线程执行时，它立刻变成运行状态
* 阻塞
 线程会在以下情况下发生阻塞：试图加锁一个已经被锁住的互斥量，等待某个条件变量，调用singwait等待尚未发生的信号，执行无法完成的I/O信号，由于内存页错误。
* 终止
 线程可以在启动函数中返回来终止自己，或者调用 `pthread_exit` 退出，或者取消线程。

### 1. 线程ID
我们首先来看下线程的创建，线程的创建使用的是 `pthread_create` 函数:
````C++
#include <pthread.h>
int pthread_create (pthread_t *thread,
                    pthread_attr_t *attr,
                    void *(*start_routine)(void *),
                    void *arg);````
功能：创建一个线程。
第一个参数 `thread`：新线程的id，如果成功则新线程的id回填充到tidp指向的内存
第二个参数 `attr`：线程属性（调度策略，继承性，分离性...）
第三个参数 `start_routine`：回调函数（新线程要执行的函数）
第四个参数 `arg`：回调函数的参数
返回值：成功返回0，失败则返回错误码

当线程被创建时，`thread` 被写入一个标识符，我们使用这个标识符来引用被创建的线程。`attr` 可以用来详细设定线程的属性，一般为 `NULL`，我们会在本篇博客的最后详细介绍线程的属性，`start_routine` 指向了一个函数地址，我们可以定义任意一个具有一个任意类型的参数并返回任意一个返回值的函数作为线程的执行函数，最后一个 `arg` 传入了该函数的参数。需要注意的是：
> 编译时需要连接库 `libpthread`。
新线程可能在当前线程从函数 `pthread_create` 返回之前就已经运行了，甚至新线程可能在当前线程从函数 `pthread_create` 返回之前就已经运行完毕了。

对于一个线程，可以使用 `pthread_self()` 函数来获取自己的线程号。
````C++
#include <pthread.h>
int pthread_self (void);````
功能：返回当前线程的线程 id。
返回值：调用线程的线程ID。

还有一个函数是 `pthread_equal()` 可以用来判断两个线程ID 是否一致。
````C++
#include <pthread.h>
int pthread_equal (pthread_t tid1, pthread_t tid2);````
功能：功能判断两个线程ID是否一致。
参数：`tid1` `tid2` 需要判断的ID
返回值：相等返回非0值，不相等返回0.

这样，主线程可以将工作任务放在一个队列中，并将每个任务添加一个进程ID标识，这样相应的线程使用上面两个函数就可以取出和自己相关的任务。


### 2. 初始线程/主线程
当c程序运行时，首先运行 `main` 函数。在线程代码中，这个特殊的执行流被称作初始线程或者主线程。你可以在初始线程中做任何普通线程可以做的事情。主线程的特殊性在于:
* 它在 `main` 函数返回的时候，会导致进程结束，进程内所有的线程也将会结束。这可不是一个好的现象，你可以在主线程中调用 `pthread_exit` 函数，这样进程就会等待所有线程结束时才终止。
* 主线程接受参数的方式是通过 `argc` 和 `argv`，而普通的线程只有一个参数 `void*`。
* 在绝大多数情况下，主线程在默认堆栈上运行，这个堆栈可以增长到足够的长度。而普通线程的堆栈是受限制的，一旦溢出就会产生错误。
 
## 二、线程的运行
### 1. 线程的退出
退出线程使用的是 `pthread_exit`，需要注意的是：线程函数不能使用 `exit()` 退出，`exit`是危险的：如果进程中的任意一个线程调用了 `exit`，`_Exit`，`_exit`，那么整个进程就会终止，普通的单个线程以以下三种方式退出，不会终止进程：
 1. 从启动函数中返回，返回值是线程的退出码。
 2. 线程可以被同一进程中的其他线程取消。
 3. 线程调用 `pthread_exit()` 函数。
 
````C
#include <pthread.h>
 void pthread_exit(void *rval);````
 功能：退出一个线程。
 参数：`rval` 是个无类型的指针，保存线程的退出码，其他线程可以通过 `pthread_join()` 函数来接收这个值。
 
### 2. 线程的回收
类似于进程的 `wait()` 函数，线程也有相应的机制，称为线程的回收，和这个机制紧密相关的一个概念是线程的**分离属性**。

**线程的分离属性：** 
 > 分离一个正在运行的线程并不影响它，仅仅是通知当前系统该线程结束时，其所属的资源可以回收。
 一个没有被分离的线程在终止时会保留它的虚拟内存，包括他们的堆栈和其他系统资源，有时这种线程被称为**僵尸线程**。
 创建线程时**默认是非分离的**。

如果线程具有分离属性，线程终止时会被立刻回收，回收将释放掉所有在线程终止时未释放的系统资源和进程资源，包括保存线程返回值的内存空间、堆栈、保存寄存器的内存空间等。
终止被分离的线程会释放所有的系统资源，但是你必须释放由该线程占有的程序资源。由 `malloc()` 或者 `mmap()` 分配的内存可以在任何时候由任何线程释放，条件变量、互斥量、信号灯可以由任何线程销毁，只要他们被解锁了或者没有线程等待。但是只有互斥量的主人才能解锁它，所以**在线程终止前，你需要解锁互斥量**。

将已创建的线程设置为分离的有两种方式：
* 调用 `pthread_detach()` 这个函数，那么当这个线程终止的时候，和它相关的系统资源将被自动释放。
  ````C
  #include <pthread.h>
  int pthread_detach(pthread_t thread);````
  功能：分离一个线程，线程可以自己分离自己。
  参数：`thread` 指定线程的 id。
  返回值：成功返回0，失败返回错误码
 
* 调用 `pthread_join` 会使指定的线程处于分离状态()，如果指定线程已经处于分离状态，那么调用就会失败。
  ````C
  #include <pthread.h>
  int pthread_join(pthead_t tid, void **rval);````
  功能：调用该函数的线程会一直阻塞，直到指定的线程 `tid` 调用 `pthread_exit`、从启动函数返回或者被取消。
  参数：参数 `tid` 就是指定线程的 `id`，参数 `rval` 是指定线程的返回码，如果线程被取消，那么 `rval` 被置为 `PTHREAD_CANCELED`
  返回值：该函数调用成功会返回0，失败返回错误码


### 3. 线程的取消
线程的取消类似于一个线程向另一个线程发送了一个信号，要求它终止，相应的取消函数很简单：
````C
#include <pthread.h>
int pthread_cancle(pthread_t tid);````
功能：请求一个线程终止
参数：`tid` 指定的线程
返回值：成功返回0，失败返回错误码。

取消只是发送一个请求，并不意味着等待线程终止，而且发送成功也不意味着 `tid` 一定会终止，它通常需要被取消线程的配合。线程在很多时候会查看自己取消状态，如果有就主动退出， 这些查看是否有取消的地方称为取消点
 
这时候，我们又有了两个概念：**取消状态**，**取消点**。
 
 * 取消状态
   取消状态，就是线程对取消信号的处理方式，忽略或者响应。线程创建时默认响应取消信号，相应的设置函数为：
   ````C
   #include <pthread.h> 
   int pthread_setcancelstate(int state, int *oldstate);````
   功能：设置本线程对取消请求(CANCEL 信号)的反应
   参数：`state` 有两种值：`PTHREAD_CANCEL_ENABLE`（缺省，接收取消请求）和 `PTHREAD_CANCEL_DISABLE`(忽略取消请求)；`old_state` 如果不为NULL则存入原来的Cancel状态以便恢复
   返回值：成功返回0，失败返回错误码。

   如果函数设置为接收取消请求，还可以设置他的**取消类型**:
   取消类型，是线程对取消信号的响应方式，立即取消或者延时取消。线程创建时默认延时取消
   ````C
   #include <pthread.h> 
   int pthread_setcanceltype(int type, int *oldtype) ;````
   功能：设置本线程取消动作的执行时机
   参数：`type` 由两种取值：`PTHREAD_CANCEL_DEFFERED` 表示收到信号后继续运行至下一个取消点再退出， `PTHREAD_CANCEL_ASYCHRONOUS` 标识立即执行取消动作（退出）；两者仅当 Cancel 状态为 Enable 时有效；`oldtype` 如果不为NULL则存入运来的取消动作类型值。
   返回值：成功返回0，失败则返回错误码
 
 * 取消点
   取消点：取消一个线程，默认需要被取消线程的配合。线程在很多时候会查看自己是否有取消请求，如果有就主动退出， 这些查看是否有取消的地方称为取消点。很多地方都是包含取消点，包括 `pthread_join()`、 `pthread_testcancel()`、`pthread_cond_wait()`、 `pthread_cond_timedwait()`、`sem_wait()`、`sigwait()` 以及 `write`、`read` 等大多数会阻塞的系统调用。

 
### 4. 线程的清除
线程可以安排它退出时的清理操作，这与进程的可以用atexit函数安排进程退出时需要调用的函数类似。这样的函数称为线程清理处理程序。线程可以建立多个清理处理程序，处理程序记录在栈中，所以这些处理程序执行的顺序与他们注册的顺序相反
````C
#include <pthread.h> 
void pthread_cleanup_push（void （*rtn）（void*）， void *args）//注册处理程序
void pthread_cleanup_pop（int excute）//清除处理程序````
 
当执行以下操作时调用清理函数，清理函数的参数由 `args` 传入
1. 调用 `pthread_exit`
2. 响应取消请求
3. 用非零参数调用 `pthread_cleanup_pop`

**`return` 不调用清理操作**。


## 五、线程的同步
有几种方法可以很好的控制线程执行和访问临界区域，主要是互斥量和信号量。

### 1. 互斥量
 * 为什么要使用互斥量？
当多个线程共享相同的内存时，需要每一个线程看到相同的视图。当一个线程修改变量时，而其他线程也可以读取或者修改这个变量，就需要对这些线程同步，确保他们不会访问到无效的变量。
为了让线程访问数据不产生冲突，这要就需要对变量加锁，使得同一时刻只有一个线程可以访问变量。互斥量本质就是锁，访问共享资源前对互斥量加锁，访问完成后解锁。
当互斥量加锁以后，其他所有需要访问该互斥量的线程都将阻塞，当互斥量解锁以后，所有因为这个互斥量阻塞的线程都将变为就绪态，第一个获得cpu的线程会获得互斥量，变为运行态，而其他线程会继续变为阻塞，在这种方式下访问互斥量每次只有一个线程能向前执行. 


1. 互斥量的初始化和销毁

   互斥量用 `pthread_mutex_t` 类型的数据表示，在使用之前需要对互斥量初始化
   * 如果是动态分配的互斥量，可以调用 `pthread_mutex_init()`函数初始化
   * 如果是静态分配的互斥量，还可以把它置为常量 `PTHREAD_MUTEX_INITIALIZER`
   * 动态分配的互斥量在释放内存之前需要调用 `pthread_mutex_destroy()`

  相应的处理函数为
   ````C
   #include <pthread.h>
   int pthread_mutex_init(pthread_mutex_t *restrict mutex,
          const pthread_mutexattr_t *restrict attr);  //动态初始化互斥量
 
   int pthread_mutex_destroy(pthread_mutex_t *mutex); //动态互斥量销毁
   pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; //静态初始化互斥量
   ````
   `mutex` 为需要创建或销毁的互斥量；`attr` 为新建互斥量的属性，默认为 `PTHREAD_MUTEX_TIMED_NP`， 即普通锁。

3. 加锁和解锁
    ````C
    int pthread_mutex_lock(pthread_mutex_t *mutex); ````
    成功返回0，失败返回错误码。如果互斥量已经被锁住，那么会导致该线程阻塞。

    ````C
    int pthread_mutex_trylock(pthread_mutex_t *mutex);`````
    成功返回0，失败返回错误码。如果互斥量已经被锁住，不会导致线程阻塞。

   ````C
   int pthread_mutex_unlock(pthread_mutex_t *mutex);````
    成功返回0，失败返回错误码。如果一个互斥量没有被锁住，那么解锁就会出错。
 
4. 死锁
   死锁：线程一直在等待锁，而锁却无法解开。如果一个线程对已经占有的互斥量继续加锁，那么他就会陷入死锁状态。

   **如何去避免死锁？**
   你可以小心的控制互斥量加锁的顺序来避免死锁，例如所有的线程都在加锁B之前先加锁A，那么这两个互斥量就不会产生死锁了。有的时候程序写的多了互斥量就难以把控，你可以先释放已经占有的锁，然后再加锁其他互斥量。
 
互斥量使用要注意：
> 
1. 访问共享资源时需要加锁
2. 互斥量使用完之后需要销毁
3. 加锁之后一定要解锁
4. 互斥量加锁的范围要小
5. 互斥量的数量应该少

### 2. 信号量
这里说的信号量和前一篇说的信号量不同，这里的信号量来自 POSIX 的实时扩展，而之前的信号量来自于 System V。两者的函数接口相似，但是不用通用。这里的相关信号量函数都以 `sem_` 开头。相关的函数有四个：

1. `sem_init` 函数
   该函数用于创建信号量，其原型如下：
   ````C
   int sem_init(sem_t *sem, int pshared， unsigned int value);  ````
   该函数初始化由 `sem` 指向的信号对象，设置它的共享选项，并给它一个初始的整数值。`pshared` 控制信号量的类型，如果其值为0，就表示这个信号量是当前进程的局部信号量，否则信号量就可以在多个进程之间共享，`value` 为 `sem` 的初始值。
   调用成功时返回0，失败返回-1.

2. `sem_wait` 函数
   该函数用于以原子操作的方式将信号量的值减1。原子操作就是，如果两个线程企图同时给一个信号量加1或减1，它们之间不会互相干扰。它的原型如下：
   ````C
   int sem_wait(sem_t *sem);  ````
   `sem` 指向的对象是由 `sem_init` 调用初始化的信号量。
   调用成功时返回0，失败返回-1.

3. `sem_post` 函数
   该函数用于以原子操作的方式将信号量的值加1。它的原型如下：
   ````C
   int sem_post(sem_t *sem);  ````
   与 `sem_wait` 一样，`sem` 指向的对象是由 `sem_init` 调用初始化的信号量。
   调用成功时返回0，失败返回-1.

4. `sem_destroy` 函数
   该函数用于对用完的信号量的清理。它的原型如下：
   ````C
   int sem_destroy(sem_t *sem);  
   成功时返回0，失败时返回-1.````

### 3. 读写锁
**什么是读写锁，它与互斥量的区别：**
读写锁与互斥量类似，不过读写锁有更高的并行性。互斥量要么加锁要么不加锁，而且同一时刻只允许一个线程对其加锁。但是对于一个变量的读取，完全可以让多个线程同时进行操作。这时候读写锁更为实用。

* 读写锁有三种状态，读模式下加锁，写模式下加锁，不加锁。相应的使用方法为：
 * 一次只有一个线程可以占有写模式下的读写锁，但是多个线程可以同时占有读模式的读写锁。 
 * 读写锁在写加锁状态时，在它被解锁之前，所有试图对这个锁加锁的线程都会阻塞。
 * 读写锁在读加锁状态时，所有试图以读模式对其加锁的线程都会获得访问权，但是如果线程希望以写模式对其加锁，它必须阻塞直到所有的线程释放锁。 
 * 读写锁在读加锁状态时，如果有线程试图以写模式对其加锁，那么读写锁会阻塞随后的读模式锁请求。这样可以避免读锁长期占用，而写锁达不到请求。

读写锁非常适合对数据结构读次数大于写次数的程序，当它以读模式锁住时，是以共享的方式锁住的；当它以写模式锁住时，是以独占的模式锁住的。

1. 读写锁的初始化和销毁
   读写锁在使用之前必须初始化,使用完需要销毁。
   ````C
   int pthread_rwlock_init(pthread_rwlock_t *restrict rwlock,
             const pthread_rwlockattr_t *restrict attr);
   int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);````
   成功返回0 ，失败返回错误码

2. 加锁和解锁
   读模式加锁    
   ````C   
   int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
   int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);````
   写模式加锁
   ````C
   int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
   int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);````
   解锁
   ````C
   int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);````
   成功返回0
 
### 3.  条件变量
条件变量的引入：我们需要一种机制，当互斥量被锁住以后发现当前线程还是无法完成自己的操作，那么它应该释放互斥量，让其他线程工作。条件变量的作用就是可以采用轮询的方式，不停的让系统来帮你查询条件。

1. 条件变量的初始化和销毁
  条件变量使用之前需要初始化，条件变量使用完成之后需要销毁。
  ````C
  pthread_cond_t cond = PTHREAD_COND_INITIALIZER;    //静态初始化条件变量
  int pthread_cond_init(pthread_cond_t *restrict cond,
                        const pthread_condattr_t *restrict attr); //动态初始化条件变量
  int pthread_cond_destroy(pthread_cond_t *cond);//销毁条件变量 ````
  动态条件变量的初始化和销毁函数返回值都是成功返回0，失败返回错误代码。`attr` 的值一般为 `NULL`。详细的设置在下个章节。
 
2. 条件变量的等待和唤醒
  条件变量使用需要配合互斥量
    1. 使用 `pthread_cond_wait` 等待条件变为真。传递给 `pthread_cond_wait` 的互斥量对条件进行保护，调用者把锁住的互斥量传递给函数。
      这个函数将线程放到等待条件的线程列表上，然后对互斥量进行解锁，这是个原子操作。当条件满足时这个函数返回，返回以后继续对互斥量加锁。
      ````C
      int pthread_cond_wait(pthread_cond_t *restrict cond,
                            pthread_mutex_t *restrict mutex);
       int pthread_cond_timedwait(pthread_cond_t *restrict cond,
                                  pthread_mutex_t *restrict mutex,
                                  const struct timespec *restrict abstime);````
       这个函数与 `pthread_cond_wait` 类似，只是多一个 `timeout`，如果到了指定的时间条件还不满足，那么就返回。
       注意，这个时间是绝对时间。例如你要等待3分钟，就要把当前时间加上3分钟然后转换到 `timespec`，而不是直接将3分钟转换到 `timespec`。
    4. 当条件满足的时候，需要唤醒等待条件的线程
    ````C
    int pthread_cond_broadcast(pthread_cond_t *cond); //唤醒等待条件的所有线程
    int pthread_cond_signal(pthread_cond_t *cond);    //至少唤醒等待条件的某一个线程````
    注意，**一定要在条件改变以后在唤醒线程。**

3. 条件变量的使用
   条件变量主要使用在那些需要条件触发的场景。譬如，一个经典的生产者消费者的问题。消费者等待生产者生产，如果单纯的使用互斥量，当然也可以解决问题，但是在生产者没有生产的时候，消费者就需要不停的轮询，大大浪费了CPU资源。我们更期待的是等生产者生产后"通知"我们的消费者，所以我们使用条件变量：
   生产者线程的执行顺序是：加锁 -> 生产 -> `pthread_cond_signal` -> 释放锁
   消费者线程的执行顺寻是：加锁 -> while(没有生产) `pthread_cond_wait`; 当没有商品存在的时候，进入条件变量，此时条件变量首先释放了锁，然后阻塞等待 `pthread_cond_signal` 信号的发送，接收到信号之后，申请锁，`pthread_cond_wait`结束， -> 执行相应的程序 -> 释放锁。
    
## 六、线程的控制
### 1. 线程属性

线程的属性用 `pthread_attr_t` 类型的结构表示，在创建线程的时候可以不用传入NULL，而是传入一个 `pthread_attr_t` 结构，由用户自己来配置线程的属性。`pthread_attr_t` 结构中定义的线程属性有很多：

|名称|描述|
|---|----|
|detachstate|	线程的分离状态|
|guardsize|	线程栈末尾的警戒区域大小（字节数）|
|stacksize|	线程栈的最低地址|
|stacksize|	线程栈的大小（字节数）|

1. 线程属性的初始化和销毁
   线程的初始化和销毁使用下面两个函数：
   ````C
   int pthread_attr_init(pthread_attr_t *attr);     //线程属性初始化
   int pthread_attr_destroy(pthread_attr_t *attr);  //线程属性销毁````
   如果在调用 `pthread_attr_init` 初始化属性的时候分配了内存空间，那么 `pthread_attr_destroy` 将释放内存空间。除此之外，`pthread_atty_destroy` 还会用无效的值初始化 `pthread_attr_t` 对象，因此如果该属性对象被误用，会导致创建线程失败。`pthread_attr_t` 类型对应用程序是不透明的，也就是说应用程序不需要了解有关属性对象内部结构的任何细节，因而可以增加程序的可移植性。


2. 线程的分离属性
   线程的分离属性已经在前面的章节介绍过了，如果在创建线程的时候就知道不需要了解线程的终止状态，那么可以修改 `pthread_attr_t` 结构体的 `detachstate` 属性，让线程以分离状态启动。线程的分离属性有两种合法值:
   `PTHREAD_CREATE_DETACHED` 分离的；
   `PTHREAD_CREATE_JOINABLE` 非分离的，可连接的；
   设置线程分离属性的步骤
    1. 定义线程属性变量 `pthread_attr_t attr`
    2. 初始化 `attr` ，`pthread_attr_init(&attr)`
    3. 设置线程为分离或非分离 `pthread_attr_setdetachstate(&attr, detachstate)`
    4. 创建线程 `pthread_create（&tid， &attr， thread_fun,  NULL）`

3. 线程的栈属性
   对一个进程，他的虚拟空间的大小是固定的，如果程序启动了大量的线程，因为所有的线程共享进程的的虚拟地址空间，所以按照默认的栈大小，虚拟空间就会不足，需要调小栈空间。或者某个线程使用了大量的自动变量，这时候需要调大栈空间，具体的分配使用不再详说，介绍下相关的函数：
   ````C
   int pthread_attr_setstack(pthread_attr_t *attr, void *stackaddr, size_t stacksize);   //修改栈属性
   int pthread_attr_getstack(pthread_attr_t *attr, void **stackaddr, size_t *stacksize); //获取栈属性
   int pthread_attr_setstacksize(pthread_attr_t *attr, size_t stacksize);                //单独设置栈属性
   int pthread_attr_getstacksize(pthread_attr_t *attr, size_t *stacksize);               //单独获取栈属性
   int pthread_attr_setguardsize(pthread_attr_t *attr, size_t guardsize);                //单独设置栈属性
   int pthread_attr_getguardsize(pthread_attr_t *attr, size_t *guardsize);               //单独获取栈属性
   ````
   上述函数的返回值都是成功返回0，失败返回相应的错误编码。
   对于遵循POSIX标准的系统来说，不一定要支持线程的栈属性，因此你需要检查
     1. 在编译阶段使用       
        `_POSIX_THREAD_ATTR_STACKADDR` 和 `_POSIX_THREAD_ATTR_STACKSIZE` 符号来检查系统是否支持线程栈属性。
     2. 在运行阶段把
        `_SC_THREAD_ATTR_STACKADD` 和 `_SC_THREAD_THREAD_ATTR_STACKSIZE` 传递给 `sysconf` 函数检查系统对线程栈属性的支持。

4. 线程的其他属性：
   线程还有一些属性没有在 `pthread_attr_t` 结构体中定义，如已经在上面介绍过的线程的取消状态和线程的取消类型，还有没有介绍的线程的并发度，这些就不再详细描述。
   
### 2. 同步属性

1. **互斥量的属性**
   就像线程有属性一样，线程的同步互斥量也有属性，比较重要的是进程共享属性和类型属性。互斥量的属性用 `pthread_mutexattr_t` 类型的数据表示，当然在使用之前必须进行初始化，使用完成之后需要进行销毁：
   ````C
   int pthread_mutexattr_init(pthread_mutexattr_t *attr);    //互斥量属性初始化
   int pthread_mutexattr_destroy(pthread_mutexattr_t *attr); //互斥量属性销毁
   int pthread_mutexattr_getpshared(const pthread_mutexattr_t *restrict attr, 
                                     int *restrict pshared); //获取互斥量属性
   int pthread_mutexattr_setpshared(pthread_mutexattr_t *attr, 
                                    int pshared);            //设置互斥量属性````
   上述函数的返回值都是成功返回0，失败返回相应的错误编码。
   互斥量属性的相关的值有：
   * `PTHREAD_MUTEX_TIMED_NP`，缺省值，当一个线程加锁以后，其余请求锁的线程将形成一个等待队列，并在解锁后按优先级获得锁。
   * `PTHREAD_MUTEX_RECURSIVE_NP`，嵌套锁，允许同一个线程对同一个锁成功获得多次，并通过多次unlock解锁。如果是不同线程请求，则在加锁线程解锁时重新竞争。
   * `PTHREAD_MUTEX_ERRORCHECK_NP`，检错锁，如果同一个线程请求同一个锁，则返回EDEADLK，否则与PTHREAD_MUTEX_TIMED_NP类型动作相同。这样就保证当不允许多次加锁时不会出现最简单情况下的死锁。
   * `PTHREAD_MUTEX_ADAPTIVE_NP`，适应锁，动作最简单的锁类型，仅等待解锁后重新竞争。
 
4. **读写锁的属性**
   读写锁也有属性，它只有一个进程共享属性:
   ````C
   int pthread_rwlockattr_destroy(pthread_rwlockattr_t *attr);
   int pthread_rwlockattr_init(pthread_rwlockattr_t *attr);
   int pthread_rwlockattr_getpshared(const pthread_rwlockattr_t *restrict attr, int *restrict pshared);
   int pthread_rwlockattr_setpshared(pthread_rwlockattr_t *attr, int pshared); ````
   上述函数的返回值都是成功返回0，失败返回相应的错误编码。

5. **条件变量的属性**
   条件变量也有进程共享属性:
   ````C
   int pthread_condattr_destroy(pthread_condattr_t *attr);
   int pthread_condattr_init(pthread_condattr_t *attr);
   int pthread_condattr_getpshared(const pthread_condattr_t *restrict attr, int *restrict pshared);
   int pthread_condattr_setpshared(pthread_condattr_t *attr, int pshared);````
   上述函数的返回值都是成功返回0，失败返回相应的错误编码。

### 3. 私有数据
应用程序设计中有必要提供一种变量，使得多个函数多个线程都可以访问这个变量（看起来是个全局变量），但是线程对这个变量的访问都不会彼此产生影响（貌似不是全局变量哦），但是你需要这样的数据，比如 `errno`。那么这种数据就是线程的私有数据，尽管名字相同，但是每个线程访问的都是数据的副本。
 
在使用私有数据之前，你首先要创建一个与私有数据相关的键，要来获取对私有数据的访问权限 。这个键的类型是 `pthread_key_t`:
````C
int pthread_key_create(pthread_key_t *key, void (*destructor)(voi8d*));````

创建的键放在key指向的内存单元，`destructor` 是与键相关的析构函数。当线程调用 `pthread_exit` 或者使用 `return` 返回，析构函数就会被调用。当析构函数调用的时候，它只有一个参数，这个参数是与key关联的那个数据的地址，因此你可以在析构函数中将这个数据销毁。

键使用完之后也可以删除，当键删除之后，与它关联的数据并没有销毁:
````C
int pthread_key_delete(pthread_key_t key);````
 
有了键之后，你就可以将私有数据和键关联起来，这样就就可以通过键来找到数据。所有的线程都可以访问这个键，但他们可以为键关联不同的数据。
````C
int pthread_setspecific(pthread_key_t key, const void *value);````
将私有数据与key关联

````C
void *pthread_getspecific(pthread_key_t key);````
获取私有数据的地址，如果没有数据与key关联，那么返回空。

有些事需要且只能执行一次（比如互斥量初始化）。通常当初始化应用程序时，可以比较容易地将其放在main函数中。但当你写一个库函数时，就不能在main里面初始化了，你可以用静态初始化，但使用一次初始（`pthread_once_t`）会比较容易些。
 
* 首先要定义一个 `pthread_once_t`变量，这个变量要用宏 `PTHREAD_ONCE_INIT` 初始化。然后创建一个与控制变量相关的初始化函数
  ````C
  pthread_once_t once_control = PTHREAD_ONCE_INIT;
  void init_routine（）
  {
   //初始化互斥量
   //初始化读写锁
   ......
  }````
 
* 接下来就可以在任何时刻调用pthread_once函数
  ````C
  int pthread_once(pthread_once_t* once_control, void (*init_routine)(void));````
  功能：本函数使用初值为 `PTHREAD_ONCE_INIT` 的 `once_control` 变量保证 `init_routine()` 函数在本进程执行序列中仅执行一次。在多线程编程环境下，尽管`pthread_once()` 调用会出现在多个线程中，`init_routine()` 函数仅执行一次，究竟在哪个线程中执行是不定的，是由内核调度来决定。"一次性函数"的执行状态有三种：`NEVER（0）`. `IN_PROGRESS（1）`. `DONE （2）`，用 `once_control` 来表示 `pthread_once()` 的执行状态：
  1. 如果 `once_control` 初值为0，那么 `pthread_once` 从未执行过，`init_routine()` 函数会执行。
  2. 如果 `once_control` 初值设为1，则由于所有 `pthread_once()` 都必须等待其中一个激发"已执行一次"信号， 因此所有 `pthread_once ()` 都会陷入永久的等待中，`init_routine()` 就无法执行
  3. 如果 `once_control` 设为2，则表示 `pthread_once()` 函数已执行过一次，从而所有 `pthread_once()`都会立即返回，`init_routine()`就没有机会执行。当pthread_once函数成功返回，once_control就会被设置为2

###  4. 线程的信号
在线程中使用信号，与在进程中使用信号机制有着根本的区别。在进程环境中，对信号的处理是异步的（我们完全不知到信号会在进程的那个执行点到来！）。但是在多线程中处理信号的原则完全不同，它的基本原则是：将对信号的异步处理，转换成同步处理，也就是说用一个线程专门的来“同步等待”信号的到来，而其它的线程可以完全不被该信号中断/打断(interrupt)。

* 信号的发送
  线程中信号的发送并不使用 `kill()` 函数，而是有专门的进程信号函数：
  ````C
  #include <pthread.h> 
  int pthread_kill(pthread_t thread, int sig);````
  功能：向指定ID的线程发送信号。
  参数：`thread` 进程标识符，`sig` 发送的信号。

  如果线程代码内不做处理，则按照信号默认的行为影响整个进程，也就是说，如果你给一个线程发送了 `SIGQUIT` ，但线程却没有实现 `signal` 处理函数，则整个进程退出。如果要获得正确的行为，就需要在线程内实现 `signal(SIGKILL,sig_handler)` 了。所以，如果 `sig` 不是0，那一定要清楚到底要干什么，而且一定要实现线程的信号处理函数，否则，就会影响整个进程。如果 `sig` 是0，这是一个保留信号，其实并没有发送信号，作用是用来判断线程是不是还活着。

* 信号的接收
  在多线程代码中，总是使用 `sigwait` 或者 `sigwaitinfo` 或者 `sigtimedwait` 等函数来处理信号。而不是 `signal` 或者 `sigaction` 等函数。因为在一个线程中调用 `signal` 或者 `sigaction` 等函数会改变所以线程中的信号处理函数。而不是仅仅改变调用 `signal`/`sigaction` 的那个线程的信号处理函数。

### 5. 线程与fork
当线程调用 `fork()` 函数时，就为子进程创建了整个进程地址空间的副本，子进程通过继承整个地址空间的副本，也会将父进程的互斥量、读写锁、条件变量的状态继承过来。也就是说，如果父进程调用 `fork()` 的线程中占有锁，那么在子进程中也占有锁，这是非常不安全的，因为不是子进程自己锁住的，它无法解锁。
 
子进程内部只有一个线程，由父进程中调用 `fork()` 函数的线程副本构成。如果调用 `fork()` 的线程将互斥量锁住，那么子进程会拷贝一个 `pthread_mutex_lock` 副本，这样子进程就有机会去解锁了。或者互斥量根本就没被加锁，这样也是可以的，但是你不能确保永远是这样的情况。
 
`pthread_atfork` 函数给你创造了这样的条件，它会注册三个函数
````C
int pthread_atfork(void (*prepare)(void);
                   void (*parent)(void); 
                   void (*child)(void));````
`prepare` 是在 `fork()` 调用之前会被调用的，他的任务是获取所有父进程中定义的锁。
`parent` 在 `fork()` 创建了子进程但返回之前在父进程中调用，他的任务是对所有 `prepare` 中获取的锁解锁。
`child` 在 `fork()` 创建了子进程但返回之前在子进程中调用，他的任务是对所有 `prepare` 中获取的锁解锁。

 

