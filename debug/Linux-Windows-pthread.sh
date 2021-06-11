1. 临界区只能用来同步本进程内的线程，而不可用来同步多个进程中的线程。
2. 互斥不仅仅能够在同一应 用程序不同线程中实现资源的安全共享，而且
   可以在不同应用程序的线程之间实现对资源的安全共享。
3. InterLockedIncrement是一个函数，他的功能是实现数的原子性加减。
   InterlockedDecrement是一个函数，他的功能是实现数的原子性加减。
4. 线程可以通过以下四种方式终止运行：
    1：线程函数返回。
    2：线程调用ExitThread杀死自己。
    3：其他线程调用TerminateThread。虽然TerminateThread不会释放线程栈，但是进程结束时栈空间会被清理。
    4：进程终止导致线程终止。如果该线程是进程的最后一个活动线程，也会导致进程终止。
5. 线程终止后，其内核对象不一定被释放。其他线程可以调用GetExitCodeThread来检查hThread所标示的线程是否已终止运行。
   如果pdwExitCode返回STILL_ACTIVE表明线程尚未终止。否则返回其退出代码。也可以使用WaitForSingleObject来判断线程
   内核对象句柄是否是已触发状态。

Thread(_beginthreadex和_endthreadex)
{
    beginThreadex函数的参数列表跟CreateThread一样，但是参数名称和类型并不完全一样。这是因为Microsoft的C/C++运行库
开发组认为C/C++运行库不应该对Windows数据类型有任何的依赖。

    在_beginthreadex内部，申请了_tiddata内存块，它是在C/C++运行库的堆中分配的。传给_beginthreadex的线程函数的
地址保存在_tiddata内存块中。在内部CreateThread会被调用，但是此时传给它的地址是_threadstartex而非pfnStartAddr。
参数的地址是_tiddata结构的地址，而非pvParam。虽然传给CreateThread的线程函数是_threadstartex，但是跟前面介绍的一样，
实际上仍然是RtlUserThreadStart先执行，然后再执行_threadstartex。所有的CreateThread都是这样处理。这一点要注意。

    在_threadstartex函数中，参数是_tiddata结构的地址，TlsSetValue是系统API。它用来将_tiddata块与新建线程关联起来。
然后_callthreadstartex函数被调用。此函数处理结构化异常。由于真正的线程函数保存在_tiddata内存块中，在此函数内又
会调用真正的线程函数。线程函数返回后_endthreadex被调用，该函数获取主调线程_tiddata数据块的地址，然后释放。
释放后调用操作系统提供的ExitThread销毁线程。

    整个过程弄清楚了，接下来总结一下：什么情况C/C++对象的析构函数不会调用，什么情况下_tiddata数据块不会被释放。
函数执行时，局部的C/C++对象的构造函数被调用，函数返回时析构函数被调用。由于ExitThread和TerminateThread不仅仅会
导致进程终止还会阻止函数返回。也就说线程函数执行到ExitThread或TerminateThread时就结束了。由于没有函数的返回局部
的C/C++对象的析构函数当然没有被调用。在多线程开发时，_beginthreadex为每个线程准备了一个_tiddata数据块，用于
存储局部于线程的数据，防止多线程互相影响，这个数据块是从堆中分配的。对应的应该调用_endthreadex，否则将会导致内存泄露。
切不可与CreateThread或ExitThread、TerminateThread混用。

    在创建线程时应该使用_beginthreadex，经常见到CreateThread大部分情况下这是可以的。当使用CreateThread时，一个线程
调用一个需要_tiddata结构的C/C++运行库函数时会发生下面的情况。首先C/C++运行库尝试取得线程数据块的地址，如果NULL被当做
_tiddata数据块的地址返回，表明主调线程没有与之关联的_tiddata数据块。此时，C/C++运行库函数会为主调线程分配并初始化
一个_tiddata块，然后将此块与线程关联。而且只要线程还在这个块就一直与线程进行关联。此后C/C++运行库可以使用_tiddata
数据块，此后的任何C/C++运行库函数也可以使用。也就是说即使你使用CreateThread，C/C++运行库检测到NULL时，也会分配并
初始化一个_tiddata块，只是在调用ExitThread时此内存块不会被调用，导致内存泄露。另一个问题是结构化异常没有就绪，
当使用C/C++运行库的signal函数时将会导致进程终止。


一般建议使用_beginthreadex和_endthreadex配合使用。
}

对象    操作    Linux Pthread API                             Windows SDK 库对应 API
线程    创建    pthread_create                                CreateThread
        退出    pthread_exit                                  ThreadExit
        等待    pthread_join                                  WaitForSingleObject
互斥锁  创建    pthread_mutex_init                            CreateMutex
        销毁    pthread_mutex_destroy                         CloseHandle
        加锁    pthread_mutex_lock                            WaitForSingleObject
        解锁    pthread_mutex_unlock                          ReleaseMutex
条件    创建    pthread_cond_init                             CreateEvent
        销毁    pthread_cond_destroy                          CloseHandle
        触发    pthread_cond_signal                           SetEvent
        广播    pthread_cond_broadcast                        SetEvent / ResetEvent
        等待    pthread_cond_wait / pthread_cond_timedwait    SingleObjectAndWait 

        
Thread(SuspendThread和ResumeThread)
{
    线程内核对象中有一个值表示挂起计数。调用CreateThread时系统创建线程内核对象，并把挂起计数初始化为1。这样cpu就
不会调度它。在初始化之后，系统检查是否有CREATE_SUSPEND标识传入。如果有函数返回，进程仍保持挂起状态。否则将挂起
计数递减为0，此时线程就可以被调度了。

    通过创建一个挂起的进程或线程我们可以在它们执行任何代码前改变它们的环境，比如将其添加到作业中或是改变优先级。
然后将它们设为可调度的。这可以通过调用ResumeThread函数。ResumeThread执行成功将返回前一次的挂起计数。
失败则返回0xFFFFFFFF。

    一个线程可以被挂起多次。除了在创建时传入CREATE_SUSPEND标识外，还可以调用SuspendThread函数。第一个参数为想要
挂起的线程句柄。任何线程都可以挂起另一个线程。挂起n次的线程要想变为可调度的必须调用ResumeThread（）n次。

    实际开发中，在调用SuspendThread时必须非常小心，因为我们无法知道线程此时在干什么。如果一个线程在分配堆中的内存，
线程将锁定堆，其他想要分配堆的线程将被挂起。直到第一个线程分配完毕。如果第一个线程被挂起，将会出现死锁的情况。

    由于进程不是cpu调度的单位，所以不存在挂起进程的概念。但是我们可以挂起进程中所有的线程。可以调用调试器函数
WaitForDebugEvent函数。恢复时可以调用ContinueDebugEvent。

    除了被别人调用SuspendThread挂起外，线程也可以告诉系统在一段时间内，可以将自己挂起，不需要调度。这可以调用Sleep实现。
    系统提供一个名为SwitchToThread函数，如果存在另一个可调度的线程，那么系统将让此线程运行。
    BOOL SwitchToThread（）；
    调用此函数时，系统查看是否存在急需cpu时间的饥饿线程。如没有则函数返回。如果存在，SwitchToThread将调度该线程。
它与Sleep(0)很相似。区别在于SwitchToThread允许执行低优先级线程。
  
}

Thread(GetThreadTime, QueryPerformanceFrequency, QueryPerformanceCounter)
{
 Windows提供了一个函数可以返回一个线程以获得cpu时间：   
 BOOL GetThreadTime(  
HANDLE hThread,  
PFILETIME pftCreationTime,  
PFILETIME pftExitTime,  
PFILETIME pftKernelTime,  
PFILETIME pftUserTime);
第一个参数为想获得的线程句柄。
第二个参数返回（线程创建时间-1601年1月1日0:00）的秒数。单位是100ns。
第三个表示退出时间-1601年1月1日0:00的秒数。单位是100ns。
第四个表示线程执行内核模式下的时间的绝对值。单位是100ns。
第五个表示线程执行用户模式代码的时间的绝对值。单位是100ns。
类似的，GetProcessTime可以返回进程中所有线程的时间之和。


在进行高精度的计算时上述函数仍然不够。此时windows提供了以下函数：
    BOOL QueryPerformanceFrequency(LARGE_INTEGER *pliFrequency)  
    BOOL  QueryPerformanceCounter(LARGE_INTEGER *pliCount);  
    这两个函数假设正在执行的线程不会被抢占。它们都是针对生命期很短的代码块。GetCPUFrequencyInMHZ可以获得cpu频率。
}
Thread(优先级)
{
    Windows的线程优先级从0到31。每个线程都会分配一个优先级。当系统确定给哪个线程分配cpu时，它会首先查看优先级为
31的线程，直至所有优先级为31的线程都被调度。

    系统启动时会创建一个优先级为0的idle线程，整个系统只有它的优先级为0。它在系统中没有其他线程运行时将系统内存
中所有闲置页面清0。

    Windows中的线程优先级是由优先级类和相对线程优先级来确定的。系统通过线程的相对优先级加上线程所属进程的优先级
来确定线程的优先级值。这个值被称为线程的基本优先级值。

    Windows支持6个进程优先级类：idle ,below normal ,normal ,above normal,high和real-time。它们是相对与进程的。
Normal最为常用，为99%的进程使用。
real-time        REALTIME_PRIORITY_CLASS
high            HIGH_PRIORITY_CLASS
above normal     ABOVE_NORMAL_PRIORITY_CLASS
normal          NORMAL_PRIORITY_CLASS
below_normal    BELOW_NORMAL_PRIORITY_CLASS
idle             IDLE_PRIORITY_CLASS

BOOL SetPriorityClass(HANDLE hProcess,  DWORD fdwPriority);  
可以调用GetPriorityClass来获得进程的优先级类。
DWORD GetPriorityClass(HANDLE hProcess);

BOOL SetThreadPriority(HANDLE hThread, int nPriority);
nPriority可以是以下标识符：
time-critical       THREAD_PRIORITY_TIME_CRITICAL
highest           THREAD_PRIORITY_HIGHEST
above-normal      THREAD_PRIORITY_ABOVE_NORMAL
normal           THREAD_PRIORITY_NORMAL
below-normal      THREAD_PRIORITY_BELOW_NORMAL
lowest            THREAD_PRIORITY_LOWEST
idle              THREAD_PRIORITY_IDLE
但是在调用CreateThread时需要传入CREATE_SUSPEND，使线程暂停执行。
相应的可以调用int GetThreadPriority(HANDLE hThread);返回线程相对优先级。

注意：线程的当前优先级不会低于进程的基本优先级。而且设备驱动程序可以决定动态提升的幅度。系统只提升优先级值在
1~15的线程。这个范围被称为动态优先级范围。可以通过调用以下函数来禁止系统对线程优先级进行动态 提升：
BOOL SetProcessPriorityBoost(HANDLE hProcess, BOOL bDisablePriorityBoost);

此函数禁止动态提升此进程内的所有线程的优先级。
BOOL SetThreadPriorityBoost(HANDLE hThread, BOOL bDisablePriorityBoost);  
此函数禁止动态提升某个线程的优先级。

第一个参数代表要设置的进程句柄。
第二参数是一个位掩码。代表线程可以在哪些cpu上运行。
注意子进程将继承父进程的关联性。
    GetProcessAffinityMask返回进程的关联掩码。
    相应的还可以设置某个线程只在一组cpu上运行：
    SetThreadAffinityMask。
    有时候强制一个线程只在某个特定的cpu上运行并不是什么好主意。Windows允许一个线程运行在一个cpu上，但如果需要，它将被移动到一个空闲的cpu上。
    要给线程设置一个理想的cpu，可以调用：
    DWORD SetThreadIdealProcessro(HANDLE hThread,DWORD dwIdealProcessor);  
    dwIdealProcessor是一个0到31/63之间的整数。表示线程希望设置的cpu。可以传入MAXIMUM_PROCESSOR值，
表示没有理想的cpu。
}
pthread(尽量设置 recursive 属性以初始化 Linux 的互斥变量)     
{
pthread_mutexattr_init(&attr); 
// 设置 recursive 属性
pthread_mutexattr_settype(&attr,PTHREAD_MUTEX_RECURSIVE_NP); 
pthread_mutex_init(theMutex,&attr);
    建议尽量设置 recursive 属性以初始化 Linux 的互斥锁，这样既可以解决同一线程递归加锁的问题，又可以避免很多情况下
死锁的发生。这样做还有一个额外的好处，就是可以让Windows和Linux下让锁的表现统一。
}


pthread(注意 Linux 平台上触发条件变量的自动复位问题)
{
    条件变量的置位和复位有两种常用模型：第一种模型是当条件变量置位（signaled）以后，如果当前没有线程在等待，其状态
会保持为置位（signaled），直到有等待的线程进入被触发，其状态才会变为复位（unsignaled），这种模型的采用以 Windows 
平台上的 Auto-set Event 为代表。
    第二种模型则是 Linux 平台的 Pthread 所采用的模型，当条件变量置位（signaled）以后，即使当前没有任何线程在等待，
其状态也会恢复为复位（unsignaled）状态。

具体来说，Linux 平台上 Pthread 下的条件变量状态变化模型是这样工作的：调用 pthread_cond_signal() 释放被条件阻塞的线程时，
无论存不存在被阻塞的线程，条件都将被重新复位，下一个被条件阻塞的线程将不受影响。而对于 Windows，当调用 SetEvent 触发
 Auto-reset 的 Event 条件时，如果没有被条件阻塞的线程，那么条件将维持在触发状态，直到有新的线程被条件阻塞并被释放为止。
}

pthread(注意条件返回时互斥锁的解锁问题)
{
    在 Linux 调用 pthread_cond_wait 进行条件变量等待操作时，我们增加一个互斥变量参数是必要的，这是为了避免线程间的竞争
和饥饿情况。但是当条件等待返回时候，需要注意的是一定不要遗漏对互斥变量进行解锁。
}

pthread(等待的绝对时间问题)
{
int pthread_cond_timedwait(pthread_cond_t *restrict cond, 
              pthread_mutex_t *restrict mutex, 
              const struct timespec *restrict abstime);

    参数 abstime 在这里用来表示和超时时间相关的一个参数，但是需要注意的是它所表示的是一个绝对时间，而不是一个时间间隔数值，
只有当系统的当前时间达到或者超过 abstime 所表示的时间时，才会触发超时事件。这对于拥有 Windows 平台线程开发经验的人
来说可能尤为困惑。因为 Windows 平台下所有的 API 等待参数（如 SignalObjectAndWait，等）都是相对时间，
}



pthread(正确处理Linux 平台下的线程结束问题)
{
    在 Linux 平台下，当处理线程结束时需要注意的一个问题就是如何让一个线程善始善终，让其所占资源得到正确释放。在 Linux 
平台默认情况下，虽然各个线程之间是相互独立的，一个线程的终止不会去通知或影响其他的线程。但是已经终止的线程的资源并不会
随着线程的终止而得到释放，我们需要调用 pthread_join() 来获得另一个线程的终止状态并且释放该线程所占的资源。

int pthread_join(pthread_t th, void **thread_return);
int pthread_detach(pthread_t th);
}


pthread(同步)
{
    在 Windows 上，同步是使用等待函数中的同步对象来实现的。同步对象可以有两种状态：有信号（signaled）状态和无信号
（non-signaled）状态。当在一个等待函数中使用同步对象时，等待函数就会阻塞调用线程，直到同步对象的状态被设置为有信号为止。
下面是在 Windows 上可以使用的一些同步对象：
    事件（Event）
    信号量（Semaphore）
    互斥（Mutexe）
    临界区（Critical section）
    在 Linux 中，可以使用不同的同步原语。Windows 与 Linux 的不同之处在于每个原语都有自己的等待函数（所谓等待函数就是用
来修改同步原语状态的函数）；在 Windows 中，有一些通用的等待函数来实现相同的目的。以下是 Linux 上可以使用的一些同步原语：
    信号量（Semaphore）
    条件变量（Conditional variable）
    互斥（Mutexe）
}

pthread(信号量)
{
    信号量的类型： Windows 提供了有名（named）信号量和无名（unnamed）信号量。有名信号量可以在进程之间进行同步。
在 Linux 上，在相同进程的不同线程之间，则只使用 POSIX 信号量。在进程之间，可以使用 System V 信号量。
    等待函数中的超时： 当在一个等待函数中使用时，可以为 Windows 信号量对象指定超时值。在 Linux 中，并没有提供这种功能，
只能通过应用程序逻辑处理超时的问题。


Semaphore(创建信号量)
{
在 Windows 中，可以使用 CreateSemaphore() 创建或打开一个有名或无名的信号量。
HANDLE CreateSemaphore(
  LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
  LONG lInitialCount,
  LONG lMaximumCount,
  LPCTSTR lpName
);
在这段代码中：
    lpSemaphoreAttributes 是一个指向安全性属性的指针。如果这个指针为空，那么这个信号量就不能被继承。
    lInitialCount 是该信号量的初始值。
    lMaximumCount 是该信号量的最大值，该值必须大于 0。
    lpName 是信号量的名称。如果该值为 NULL，那么这个信号量就只能在相同进程的不同线程之间共享。否则，就可以在不同的进程之间进行共享。
这个函数创建信号量，并返回这个信号量的句柄。它还将初始值设置为调用中指定的值。这样就可以允许有限个线程来访问某个共享资源。
}
Semaphore(打开信号量)
{
打开信号量

在 Windows 中，我们使用 OpenSemaphore() 来打开某个指定信号量。只有在两个进程之间共享信号量时，才需要使用信号量。在成功打开信号量之后，这个函数就会返回这个信号量的句柄，这样就可以在后续的调用中使用它了。

HANDLE OpenSemaphore(
  DWORD dwDesiredAccess,
  BOOL bInheritHandle,
  LPCTSTR lpName
)
在这段代码中：
    dwDesiredAccess 是针对该信号量对象所请求的访问权。
    bInheritHandle 是用来控制这个信号量句柄是否可继承的标记。如果该值为 TRUE，那么这个句柄可以被继承。
    lpName 是这个信号量的名称。
    
}

Semaphore(获取信号量)
{
获取信号量
在 Windows 中，等待函数提供了获取同步对象的机制。可以使用的等待函数有多种类型；在这一节中，我们只考虑 WaitForSingleObject()（其他类型将会分别进行讨论）。这个函数使用一个信号量对象的句柄作为参数，并会一直等待下去，直到其状态变为有信号状态或超时为止。
DWORD WaitForSingleObject( HANDLE hHandle, DWORD dwMilliseconds );
在这段代码中：
    hHandle 是指向互斥句柄的指针。
    dwMilliseconds 是超时时间，以毫秒为单位。如果该值是 INFINITE，那么它阻塞调用线程/进程的时间就是不确定的。
}

Semaphore(释放信号量)
{
释放信号量
在 Windows 中，ReleaseSemaphore() 用来释放信号量。
BOOL ReleaseSemaphore(
  HANDLE hSemaphore,
  LONG lReleaseCount,
  LPLONG lpPreviousCount
);
在这段代码中：
    hSemaphore 是一个指向信号量句柄的指针。
    lReleaseCount 是信号量计数器，可以通过指定的数量来增加计数。
    lpPreviousCount 是指向上一个信号量计数器返回时的变量的指针。如果并没有请求上一个信号量计数器的值，那么这个参数可以是 NULL。
这个函数会将信号量计数器的值增加在 lReleaseCount 中指定的值上，然后将这个信号量的状态设置为有信号状态。
}

Semaphore(销毁信号量)
{
关闭/销毁信号量
在 Windows 中，我们使用 CloseHandle() 来关闭或销毁信号量对象。
BOOL CloseHandle(
  HANDLE hObject
);
hObject 是指向这个同步对象句柄的指针。
}

}

Thread(事件)
{
    在 Windows 中，事件对象是那些需要使用 SetEvent() 函数显式地将其状态设置为有信号状态的同步对象。
事件对象来源有两种类型：
    在手工重置事件（manual reset event） 中，对象的状态会一直维持为有信号状态，直到使用 ResetEvent() 
函数显式地重新设置它为止。
    在自动重置事件（auto reset event） 中，对象的状态会一直维持为有信号状态，直到单个正在等待的线程
被释放为止。当正在等待的线程被释放时，其状态就被设置为无信号的状态。
事件对象有两种状态，有信号（signaled）状态 和 无信号（non-signaled）状态。对事件对象调用的等待函数会阻塞调用线程，直到其状态被设置为有信号状态为止。

在进行平台的迁移时，需要考虑以下问题：
    Windows 提供了 有名（named） 和 无名（un-named） 的事件对象。有名事件对象用来在进程之间进行同步，
而在 Linux 中， pthreads 和 POSIX 都提供了线程间的同步功能。为了在 Linux 实现与 Windows 中有名事件
对象相同的功能，可以使用 System V 信号量或信号。
    Windows 提供了两种类型的事件对象 —— 手工重置对象和自动重置对象。Linux 只提供了自动重置事件的特性。
    在 Windows 中，事件对象的初始状态被设置为有信号状态。在 Linux 中，pthreads 并没有提供初始状态，
而 POSIX 信号量则提供了一个初始状态。
    Windows 事件对象是异步的。在 Linux 中，POSIX 信号量和 System V 信号量也都是异步的，不过 pthreads
条件变量不是异步的。
    当在一个等待函数中使用事件对象时，可以指定 Windows 的事件对象的超时时间值。在 Linux 中，只有
pthreads 在等待函数中提供了超时的特性。 
    
Event(创建事件)
{
创建/打开事件对象
在 Windows 中，我们使用 CreateEvent() 来创建事件对象。
HANDLE CreateEvent(
  LPSECURITY_ATTRIBUTES lpEventAttributes,
  BOOL bManualReset,
  BOOL bInitialState,
  LPCTSTR lpName
)
在这段代码中：
    lpEventAttributes 是一个指针，它指向一个决定这个句柄是否能够被继承的属性。如果这个指针为 NULL，那么这个对象就不能被初始化。
    bManualReset 是一个标记，如果该值为 TRUE，就会创建一个手工重置的事件，应该显式地调用 ResetEvent()，将事件对象的状态设置为无信号状态。
    bInitialState 是这个事件对象的初始状态。如果该值为 true，那么这个事件对象的初始状态就被设置为有信号状态。
   lpName 是指向这个事件对象名的指针。对于无名的事件对象来说，该值是 NULL。
}

Event(打开事件)
{
OpenEvent() 用来打开一个现有的有名事件对象。这个函数返回该事件对象的句柄。
HANDLE OpenEvent(
  DWORD dwDesiredAccess,
  BOOL bInheritHandle,
  LPCTSTR lpName
)
在这段代码中：
    dwDesiredAccess 是针对这个事件对象所请求的访问权。
    bInheritHandle 是用来控制这个事件对象句柄是否可继承的标记。如果该值为 TRUE，那么这个句柄就可以被继承；否则就不能被继承。
    lpName 是一个指向事件对象名的指针。
}

Event(获取事件)
{
等待某个事件

在 Windows 中，等待函数提供了获取同步对象的机制。我们可以使用不同类型的等待函数（此处我们只考虑 WaitForSingleObject()）。
这个函数会使用一个互斥对象的句柄，并一直等待，直到它变为有信号状态或超时为止。
DWORD WaitForSingleObject(
  HANDLE hHandle,
  DWORD dwMilliseconds
);
在这段代码中：
    hHandle 是指向互斥句柄的指针。
    dwMilliseconds 是超时时间的值，单位是毫秒。如果该值为 INFINITE，那么它阻塞调用线程/进程的时间就
是不确定的。
}

Event(改变事件状态)
{
改变事件对象的状态
    函数 SetEvent() 用来将事件对象的状态设置为有信号状态。
对一个已经设置为有信号状态的事件对象再次执行该函数是无效的。
BOOL SetEvent(
  HANDLE hEvent
)
}

Event(重置事件的状态)
{
在 Windows 中，ResetEvent() 用来将事件对象的状态重新设置为无信号状态。
BOOL ResetEvent(
  HANDLE hEvent
);
}

Event(关闭/销毁事件对象)
{
在 Windows 中，CloseHandle() 用来关闭或销毁事件对象。
BOOL CloseHandle(
  HANDLE hObject
);
在这段代码中，hObject 是指向同步对象句柄的指针。
}


}

process(Windows-Linux)
{
Windows                     Linux            类别
CreateProcess()            fork()            可映射
CreateProcessAsUser()      setuid()
                           exec()
TerminateProcess()         kill()            可映射
SetThreadpriority()        setpriority()     可映射
GetThreadPriority()        getPriority()
GetCurrentProcessID()      getpid()          可映射
Exitprocess()              exit()            可映射
Waitforsingleobject()      waitpid()
Waitformultipleobject()    Using Sys V semaphores, Waitforsingleobject/multipleobject
GetExitCodeProcess()       不能实现
GetEnvironmentVariable      getenv()         可映射
SetEnvironmentVariable      setenv()

}

Thread(Windows-Linux)
{
Windows                          Linux                       类别
CreateThread                     pthread_create
                                 pthread_attr_init
                                 pthread_attr_setstacksize   可映射
                                 pthread_attr_destroy
ThreadExit                       pthread_exit                可映射
WaitForSingleObject              pthread_join
                                 pthread_attr_setdetachstate 可映射
                                 pthread_detach

SetPriorityClass
SetThreadPriority               setpriority                  与上下文相关
                                sched_setscheduler
                                sched_setparam
                                
                                pthread_setschedparam
                                pthread_setschedpolicy
                                pthread_attr_setschedparam
                                pthread_attr_setschedpolicy
}

Mutex(Critical Section)
{
                Mutex                                                                  Critical Section
性能和速度      慢。                                                                   快。
                Mutex是内核对象，相关函数的执行（WaitForSingleObject，                 Critical Section本身不是内核对象，相关函数（EnterCriticalSection，LeaveCriticalSection）
                ReleaseMutex）需要用户模式（User Mode）到内核模式（Kernel Mode）的转换，的调用一般都在用户模式内执行，在x86处理器上一般只需要发费9个左右的 CPU指令周期。只有当
                在x86处理器上这种转化一般要发费600个左右的 CPU指令周期。               想要获得的锁正好被别的线程拥有时才会退化成和Mutex一样，即转换到内核模式，发费600个左右的
                                                                                       CPU指令周期     
能否跨越进程
（Process）边界   可以                                                                  不可
定义写法          HANDLE hmtx;                                                          CRITICAL_SECTION cs;
初始化写法        hmtx= CreateMutex (NULL, FALSE, NULL);                                InitializeCriticalSection(&cs);
结束清除写法      CloseHandle(hmtx);                                                    DeleteCriticalSection(&cs);
无限期等待的写法  WaitForSingleObject (hmtx, INFINITE);                                 EnterCriticalSection(&cs);
0等待（状态检测）的写法  WaitForSingleObject (hmtx, 0);                                 TryEnterCriticalSection(&cs);
任意时间等待的写法       WaitForSingleObject (hmtx, dwMilliseconds);                     不支持
锁释放的写法             ReleaseMutex(hmtx);                                             LeaveCriticalSection(&cs);
能否被一道用于等待其他内核对象 可以                                                      不可以
当拥有锁的线程死亡时  Mutex变成abandoned状态，其他的等待线程可以获得锁。                Critical Section的状态不可知（undefined），以后的动作就不能保证了。
自己会不会锁住自己    不会                                                               不会

}

Mutex(Event)
{
信号量包含的几个操作原语： 
    CreateEvent（） 创建一个信号量 
    OpenEvent（） 打开一个事件 
    SetEvent（） 回置事件 
    WaitForSingleObject（） 等待一个事件 
    WaitForMultipleObjects（）　等待多个事件
    
    MFC为事件相关处理也提供了一个CEvent类，共包含有除构造函数外的4个成员函数PulseEvent（）、
ResetEvent（）、SetEvent（）和UnLock（）。在功能上分别相当与Win32 API的PulseEvent（）、
ResetEvent（）、SetEvent（）和CloseHandle（）等函数。而构造函数则履行了原CreateEvent（）
函数创建事件对象的职责，其函数原型为：

    CEvent(BOOL bInitiallyOwn = FALSE, BOOL bManualReset = FALSE, LPCTSTR lpszName = NULL, 
LPSECURITY_ATTRIBUTES lpsaAttribute = NULL );


原创)Event和Mutex区别
### 事件
事件是用来同步地位不相等的线程的，事件可以用来使一个线程完成一件事情，然后另外的线程完成剩下的事情。
事件的使用很灵活，自动事件的激发态是由人工来控制的，而Mutex在释放（releaseMetux）后就一直处于激发态，
直到线程WaitForSingleObject。事件可以用来控制经典的读写模型和生产者和消费者模型。相应的方式为，
生成者等待消费者的消费，再消费者消费完后通知生产者进行生产。
### Mutex
Mutex是排他的占有资源，一般用于地位相等的现在进行同步，每个线程都可以排他的访问一个资源或代码段，
不存在哪个线程对资源访问存在优先次序。一个线程只能在Mutex处于激发态的时候访问被保护的资源或代码段，
线程可以通过WaitForSingelObject来等待Mutex，在访问资源完成之后，ReleaseMutex释放Mutex，此时Mutex
处于激发态。Mutex具有成功等待的副作用，在等待到Mutex后，Mutex自动变为未激发态，直到调用ReleaseMutex
使Mutex变为激发态为止。自动事件也具有成功等待的副作用。手动事件没有，必须ResetEvent使手动事件变为
未激发态。进程和线程也没有成功等待的副作用。当线程或者进程函数返回时，线程内核对象变为激发态，
但WaitForSingleObject并没有使线程或者进程的内核对象变为未激发态。
总之，事件一般用于控制线程的先后顺序，而Mutex一般用于排他的访问资源。


    系统核心对象中的Event事件对象，在进程、线程间同步的时候是比较常用，发现它有两个触发函数，
一个是SetEvent，还有一个PulseEvent，两者的区别是：
    SetEvent和PulseEvent都是将指定的事件设为有信号状态。不同的是如果是一个人工重设事件，正在等候事件的、
被挂起的所有线程都会进入活动状态，函数随后将事件设回，并返回；如果是一个自动重设事件，则正在等候事件的、
被挂起的单个线程会进入活动状态，事件随后设回无信号，并且函数返回。

    也就是说在自动重置模式下PulseEvent和SetEvent的作用没有什么区别，但在手动模式下PulseEvent就有明显的不同，
可以比较容易的控制程序是单步走，还是连续走。如果让循环按要求执行一次就用PulseEvent，如果想让循环连续不停的
运转就用SetEvent，在要求停止的地方发个ResetEvent就OK了。
}
