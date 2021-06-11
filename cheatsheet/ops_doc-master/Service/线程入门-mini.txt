#线程入门	{#welcome}


=====================

linux进程创建一个新线程时，线程将拥有自己的栈（因为线程有自己的局部变量），但与它的创建者共享全局变量、文件描述符、信号句柄和当前目录状态。进程可以看成一个资源的基本单位，而线程是程序调度的基本单位，一个进程内部的线程之间共享进程获得的时间片。一个进程在同一时刻只做一件事情。有了多个控制线程以后,在程序设计时可以把进程设计成在同一时刻能够做不止一件事,每个线程处理各只独立的任务。

##多线程的好处
- 提高应用程序的响应
>可以对任何一个包含许多相互独立的活动的程序进行重新设计,以便将每个活动定义为一个线程。例如,多线程 GUI的用户不必等待一个活动完成即可启动另一个活动。

- 更有效地使用多处理器
>通常,要求并发线程的应用程序无需考虑可用处理器的数量。使用额外的处理器可以明显提高应用程序的性能。具有高度并行性的数值算法和数值应用程序(如矩阵乘法)在多处理器上通过多个线程实现时,运行速度会快得多。

- 改进程序结构
>许多应用程序都以更有效的方式构造为多个独立或半独立的执行单元,而非整块的单个线程。多线程程序比单线程程序更能适应用户需求的变化。

- 占用较少的系统资源
>如果两个或多个进程通过共享内存访问公用数据,则使用这些进程的程序可以实现对多个线程的控制。但是,每个进程都有一个完整的地址空间和操作环境状态。每个进程用于创建和维护大量状态信息的成本,与一个线程相比,无论是在时间上还是空间上代价都更高。此外,进程间所固有的独立性使得程序员需要花费很多精力来处理不同进程间线程的通信或者同步这些线程的操作。

##线程基本函数

在一个程序里的多个执行路线就叫做线程。更准确的定义是:线程是“一个进程内部的一个控制序列”。如果我们需要对一个 posix变量静态的初始化,可使用的方法是用一个互斥量对该变量的初始化进行控制。但有时候我们需要对该变量进行动态初始化,pthread_once 就会方便的多。
通过 pthread 取消功能,可以对线程进行异步终止或延迟终止。异步取消可以随时发生,而延迟取消只能发生在所定义的点。延迟取消是缺省类型。

**函数头文件#include< pthread.h>:**

- 使用 pthread_create(3C)可以向当前进程中添加新的受控线程。函数原型int pthread_create(pthread_t *tid, const pthread_attr_t *tattr,void*(*start_routine)(void *), void *arg);
>当 pthread_create() 成功时,所创建线程的 ID 被存储在由 tid 指向的位置中。使用 NULL 属性参数或缺省属性调用 pthread_create() 时,pthread_create() 会创建一个缺省线程。在对 tattr 进行初始化之后,该线程将获得缺省行为。
pthread_create() 在调用成功完成之后返回零。其他任何返回值都表示出现了错误。如果检测到以下任一情况,pthread_create() 将失败并返回相应的值:
>- EAGAIN描述: 超出了系统限制,如创建的线程太多。
>- EINVAL 描述: tattr 的值无效。

- 线程终止
使用 pthread_exit(3C) 终止线程。
>函数原型：void pthread_exit(void *status)，该函数返回一个指向某对象的指针，《注意》：绝不能用它返回一个指向局部变量的指针，因为线程调用该函数后，这个局部变量就不存在了，这将引起严重的程序漏洞。该函数可用来终止调用线程。将释放所有线程特定数据绑定。如果调用线程尚未分离,则线程 ID 和 status 指定的退出状态将保持不变,直到应用程序调用 pthread_join() 以等待该线程。否则,将忽略 status。线程 ID 可以立即回收。函数返回时调用线程将终止,退出状态设置为 status 的内容。

- pthread_join() 函数会一直阻塞调用线程,直到指定的线程终止。指定的线程必须位于当前的进程中,而且不得是分离线程。
函数原型：int pthread_join(thread_t tid, void **status);
>当 status 不是 NULL 时,status 指向某个位置,在 pthread_join() 成功返回时,将该位置设置为已终止线程的退出状态。如果多个线程等待同一个线程终止,则所有等待线程将一直等到目标线程终止。然后,一个等待线程成功返回。其余的等待线程将失败并返回 ESRCH 错误。在 pthread_join() 返回之后,应用程序可回收与已终止线程关联的任何数据存储空间。
调用成功完成后,pthread_join() 将返回零。其他任何返回值都表示出现了错误。如果检测到以下任一情况,pthread_join() 将失败并返回相应的值:
>- ESRCH 描述: 没有找到与给定的线程 ID 相对应的线程。
>- EDEADLK 描述: 将出现死锁,如一个线程等待其本身,或者线程 A 和线程 B 互相等待。
>- EINVAL 描述: 与给定的线程 ID 相对应的线程是分离线程。
**注意：pthread_join() 仅适用于非分离的目标线程。如果没有必要等待特定线程终止之后才进行其他处理,则应当将该线程分离。**
线程同步int pthread_join()方法：信号量和互斥量。
线程属性常用的函数：属性变量的初始化、设置线程绑定、设置线程分离、设置创建线程调度策略、设置线程优先级、对线程属性变量销毁、堆栈地址和大小。
>共有四种同步模型:互斥锁、读写锁、条件变量和信号。
互斥锁分为：快速互斥锁、递归互斥锁、检错互斥锁。
- pthread_detach(3C) 是 pthread_join(3C) 的替代函数,可回收创建时 detachstate 属性设置为PTHREAD_CREATE_JOINABLE 的线程的存储空间。
函数原型：int pthread_detach(thread_t tid);pthread_detach() 函数用于指示应用程序在线程 tid 终止时回收其存储空间。如果 tid 尚未终止,pthread_detach() 不会终止该线程。
>thread_detach() 在调用成功完成之后返回零。其他任何返回值都表示出现了错误。如果检测到以下任一情况,pthread_detach() 将失败并返回相应的值。
EINVAL 描述: tid 是分离线程。
ESRCH 描述: tid 不是当前进程中有效的未分离的线程。

- 获取线程标识符
使用 pthread_self(3C) 获取调用线程的 thread identifier。
>函数原型：pthread_t pthread_self(void);pthread_self() 返回调用线程的 thread identifier。

- 比较线程ID
使用 pthread_equal(3C) 对两个线程的线程标识号进行比较。
>函数原型:int pthread_equal(pthread_t tid1, pthread_t tid2);
如果 tid1 和 tid2 相等,pthread_equal() 将返回非零值,否则将返回零。如果 tid1 或 tid2 是无效的线程标识号,则结果无法预测。

- 初始化线程
使用 pthread_once(3C),可以在首次调用 pthread_once 时调用初始化例程。以后调用pthread_once() 将不起作用。
> 函数原型：int pthread_once(pthread_once_t *once_control,void (*init_routine)(void));
once_control 参数用来确定是否已调用相关的初始化例程。
该函数返回值pthread_once() 在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下情况,pthread_once() 将失败并返回相应的值：EINVAL 描述: once_control 或 init_routine 是 NULL。

- 停止执行线程
使用 sched_yield(3RT),可以使当前线程停止执行,以便执行另一个具有相同或更高优先级的线程。
> 函数原型：int sched_yield(void);**注意该函数头文件为#include< sched.h>**  该函数在成功完成之后返回零。否则,返回 -1,并设置 errno 以指示错误状态：ENOSYS 描述: 本实现不支持 sched_yield。

- 设置线程的优先级
使用 pthread_setschedparam(3C) 修改现有线程的优先级。此函数对于调度策略不起作用。
>函数原型：int pthread_setschedparam(pthread_t tid, int policy,const struct sched_param *param);pthread_setschedparam() 在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,pthread_setschedparam() 函数将失败并返回相应的值:
>- EINVAL 描述: 所设置属性的值无效。
>- ENOTSUP 描述: 尝试将该属性设置为不受支持的值。

- 获取线程的优先级
pthread_getschedparam(3C) 可用来获取现有线程的优先级。
>函数原型：int pthread_getschedparam(pthread_t tid, int policy,struct schedparam *param);该函数在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：
ESRCH 描述: tid 指定的值不引用现有的线程。

- 向线程发送信号
使用 pthread_kill(3C) 向线程发送信号。**注意在该函数头文件中还要加#include< signal.h>
>函数原型：int pthread_kill(thread_t tid, int sig);
pthread_kill() 将信号 sig 发送到由 tid 指定的线程。tid 所指定的线程必须与调用线程在同一个进程中。sig 参数必须来自 signal(5) 提供的列表。如果 sig 为零,将执行错误检查,但并不实际发送信号。此错误检查可用来检查 tid 的有效性。该函数在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,pthread_kill()将失败并返回相应的值。
>- EINVAL 描述: sig 是无效的信号量。
>- ESRCH 描述: 当前的进程中找不到 tid。

- 访问调用线程的信号掩码
使用 pthread_sigmask(3C) 更改或检查调用线程的信号掩码。**头文件还要加#include< signal.h>
>函数原型：int pthread_sigmask(int how, const sigset_t *new, sigset_t *old);how 用来确定如何更改信号组。how 可以为以下值之一:
>- SIG_BLOCK。向当前的信号掩码中添加 new,其中 new 表示要阻塞的信号组。
>- SIG_UNBLOCK。从当前的信号掩码中删除 new,其中 new 表示要取消阻塞的信号组。
>- SIG_SETMASK。将当前的信号掩码替换为 new,其中 new 表示新的信号掩码。
>- 当 new 的值为 NULL 时,how 的值没有意义,线程的信号掩码不发生变化。
要查询当前已阻塞的信号,请将 NULL 值赋给 new 参数。除非 old 变量为 NULL,否则 old 指向用来存储以前的信号掩码的空间。
该函数在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下情况,pthread_sigmask() 将失败并返回相应的值：EINVAL 描述: 未定义 how 的值。

- 安全地fork
函数原型：int pthread_atfork(void (*prepare) (void), void (*parent) (void),void (*child) (void) );
该函数在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下情况,pthread_atfork() 将失败并返回相应的值：ENOMEM 描述: 表空间不足,无法记录 Fork 处理程序地址。

- 线程的结束
>- 线程可通过以下方法来终止执行:
>- 从线程的第一个(最外面的)过程返回,使线程启动例程。调用 pthread_exit(),提供退出状态。
>- 使用 POSIX 取消函数执行终止操作。请参见 pthread_cancel()。
线程的缺省行为是拖延,直到其他线程通过 "joining" 拖延线程确认其已死亡。此行为与非分离的缺省 pthread_create() 属性相同,请参见 pthread_detach。join 的结果是 joining 线
程得到已终止线程的退出状态,已终止的线程将消失。有一个重要的特殊情况,即当初始线程(即调用 main() 的线程)从 main() 调用返回时或调用 exit()时,整个进程及其所有的线程将终止。因此,一定要确保初始线程不会从 main()过早地返回。

**请注意,如果主线程仅仅调用了pthread_exit,则仅主线程本身终止。进程及进程内的其他线程将继续存在。所有线程都已终止时,进程也将终止。**

##为线程特定数据创建键/删除/设置/获取线程特定数据


头文件#include< pthread.h>

- 单线程 C 程序有两类基本数据:局部数据和全局数据。对于多线程 C 程序,添加了第三类数据:**线程特定数据**。线程特定数据与全局数据非常相似,区别在于前者为线程专有。线程特定数据基于每线程进行维护。TSD(特定于线程的数据)是定义和引用线程专用数据的唯一方法。每个线程特定数据项都与一个作用于进程内所有线程的键关联。通过使用key,线程可以访问基于每线程进行维护的指针 (void *)。
>函数原型：int pthread_key_create(pthread_key_t *key,void (*destructor) (void *));
可以使用 pthread_key_create(3C)分配用于标识进程中线程特定数据的键。键对进程中的所有线程来说是全局的。创建线程特定数据时,所有线程最初都具有与该键关联的 NULL值。使用各个键之前,会针对其调用一次pthread_key_create()。不存在对键(为进程中所有的线程所共享)的隐含同步。创建键之后,每个线程都会将一个值绑定到该键。这些值特定于线程并且针对每个线程单独维护。如果创建该键时指定了 destructor 函数,则该线程终止时,系统会解除针对每线程的绑定。
当 pthread_key_create() 成功返回时,会将已分配的键存储在 key 指向的位置中。调用方必须确保对该键的存储和访问进行正确的同步。使用可选的析构函数 destructor 可以释放过时的存储。如果某个键具有非 NULL destructor
函数,而线程具有一个与该键关联的非 NULL 值,则该线程退出时,系统将使用当前的相关值调用 destructor 函数。destructor 函数的调用顺序不确定。
pthread_key_create() 在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,pthread_key_create() 将失败并返回相应的值:
>- EAGAIN 描述: key 名称空间已经用完。
>- ENOMEM 描述: 此进程中虚拟内存不足,无法创建新键。

- 用 pthread_key_delete(3C) 可以销毁现有线程特定数据键。由于键已经无效,因此将释放与该键关联的所有内存。引用无效键将返回错误。
>函数原型：int pthread_key_delete(pthread_key_t key);
如果已删除键,则使用调用 pthread_setspecific()  pthread_getspecific() 引用该键
时,生成的结果将是不确定的。程序员在调用删除函数之前必须释放所有线程特定资源。删除函数不会调用任何析构函数。反复调用 pthread_key_create() 和 pthread_key_delete() 可能会产生问题。如果pthread_key_delete() 将键标记为无效,而之后 key 的值不再被重用,那么反复调用它们就会出现问题。对于每个所需的键,应当只调用 pthread_key_create() 一次。
pthread_key_delete() 在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下情况,pthread_key_delete() 将失败并返回相应的值：EINVAL 描述: key 的值无效。
- 使用 pthread_setspecific(3C)可以为指定线程特定数据键设置线程特定绑定。

>函数原型int pthread_setspecific(pthread_key_t key, const void *value);
pthread_setspecific()在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,pthread_setspecific() 将失败并返回相应的值:
>> - ENOMEM 描述: 虚拟内存不足。
>> - EINVAL 描述: key 无效

>**注意：设置新绑定时,pthread_setspecific()不会释放其存储空间。必须释放现有绑定,否则会出现内存泄漏。**
- 使用 pthread_getspecific(3C) 获取调用线程的键绑定,并将该绑定存储在 value 指向的位置中。
>>函数原型：void *pthread_getspecific(pthread_key_t key);
pthread_getspecific 不返回任何错误。

##取消线程
取消操作允许线程请求终止其所在进程中的任何其他线程。不希望或不需要对一组相关的线程执行进一步操作时,可以选择执行取消操作。
取消线程的一个示例是异步生成取消条件,例如,用户请求关闭或退出正在运行的应用程序。另一个示例是完成由许多线程执行的任务。其中的某个线程可能最终完成了该任务,而其他线程还在继续运行。由于正在运行的线程此时没有任何用处,因此应当取消这些线程。
使用 pthread_cancel(3C) 取消线程。头文件< pthread.h>
>函数原型：int pthread_cancel(pthread_t thread);取消请求的处理方式取决于目标线程的状态。状态由以下两个函数确定: pthread_setcancelstate(3C) 和 pthread_setcanceltype(3C)。
该函数在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：ESRCH 描述: 没有找到与给定线程 ID 相对应的线程。

- 启用或禁用取消功能
请使用 pthread_setcancelstate(3C) 启用或禁用线程取消功能。创建线程时,缺省情况下线
程取消功能处于启用状态。
>函数原型：int pthread_setcancelstate(int state, int *oldstate);该函数在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下情况,pthread_setcancelstate() 函数将失败并返回相应的值：EINVAL 描述: 状态不是 PTHREAD_CANCEL_ENABLE 或 PTHREAD_CANCEL_DISABLE。

- 取消点
仅当取消操作安全时才应取消线程。
pthreads 标准指定了几个取消点,其中包括:
>- 通过 pthread_testcancel 调用以编程方式建立线程取消点。
>- 线程等待 pthread_cond_wait 或 pthread_cond_timedwait(3C) 中的特定条件出现。
>- 被 sigwait(2) 阻塞的线程。
>- 一些标准的库调用。通常,这些调用包括线程可基于其阻塞的函数。
缺省情况下将启用取消功能。有时,您可能希望应用程序禁用取消功能。如果禁用取消功能,则会导致延迟所有的取消请求,直到再次启用取消请求。

- 放置取消点
执行取消操作存在一定的危险。大多数危险都与完全恢复不变量和释放共享资源有关。取消线程时一定要格外小心,否则可能会使互斥保留为锁定状态,从而导致死锁。或者,已取消的线程可能保留已分配的内存区域,但是系统无法识别这一部分内存,从而无法释放它。
标准 C 库指定了一个取消接口用于以编程方式允许或禁止取消功能。该库定义的**取消点**是一组可能会执行取消操作的点。该库还允许定义取消处理程序的范围,以确保这些处理程序在预期的时间和位置运行。取消处理程序提供的清理服务可以将资源和状态恢复到与起点一致的状态。必须对应用程序有一定的了解,才能放置取消点并执行取消处理程序。
**互斥肯定不是取消点,只应当在必要时使之保留尽可能短的时间。**
请将异步取消区域限制在没有外部依赖性的序列,因为外部依赖性可能会产生挂起的资源或未解决的状态条件。在从某个备用的嵌套取消状态返回时,一定要小心地恢复取消状态。该接口提供便于进行恢复的功能:pthread_setcancelstate(3C) 在所引用的变量中保留当前的取消状态,pthread_setcanceltype(3C) 以同样的方式保留当前的取消类型。
>在以下三种不同的情况下可能会执行取消操作:
>- 异步
>- 执行序列中按标准定义的各个点
>- 调用 pthread_testcancel() 时
缺省情况下,仅在 POSIX 标准可靠定义的点执行取消操作。无论何时,都应注意资源和状态恢已复到与起点一致的状态。

- 设置取消类型
使用 pthread_setcanceltype(3C)可以将取消类型设置为延迟或异步模式。创建线程时,缺省情况下会将取消类型设置为延迟模式。在延迟模式下,只能在取消点取消线程。在异步模式下,可以在执行过程中的任意一点取消线程。因此建议不使用异步模式。
>函数原型：int pthread_setcanceltype(int type, int *oldtype);该函数在成功完成之后返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：EINVAL 描述: 类型不是 PTHREAD_CANCEL_DEFERRED 或PTHREAD_CANCEL_ASYNCHRONOUS。

- 创建取消点
请使用 pthread_testcancel(3C) 为线程建立取消点。
>函数原型：void pthread_testcancel(void);当线程取消功能处于启用状态且取消类型设置为延迟模式时,pthread_testcancel() 函数
有效。如果在取消功能处于禁用状态下调用 pthread_testcancel(),则该函数不起作用。请务必仅在线程取消操作安全的序列中插入 pthread_testcancel()。除通过
pthread_testcancel() 调用以编程方式建立的取消点以外,pthread 标准还指定了几个取消点。该函数没有返回值。

- 将处理程序推送到栈上
使用清理处理程序,可以将状态恢复到与起点一致的状态,其中包括清理已分配的资源和恢复不变量。使用 pthread_cleanup_push(3C) 和 pthread_cleanup_pop(3C) 函数可以管理清理处理程序。
在程序的同一词法域中可以推送和弹出清理处理程序。推送和弹出操作应当始终匹配,否则会生成编译器错误。
请使用 pthread_cleanup_push(3C) 将清理处理程序推送到清理栈 (LIFO)。
>函数原型：void pthread_cleanup_push(void(*routine)(void *), void *args);该函数没有返回值。

- 从栈中弹出处理程序
请使用 pthread_cleanup_pop(3C) 从清理栈中弹出清理处理程序。
>函数原型：void pthread_cleanup_pop(int execute);该函数没有返回值。
如果弹出函数中的参数为非零值,则会从栈中删除该处理程序并执行该处理程序。如果该参数为零,则会弹出该处理程序,而不执行它。线程显式或隐式调用 pthread_exit(3C)时,或线程接受取消请求时,会使用非零参数有效地调用 pthread_cleanup_pop()。

##线程结构
  
线程包含了表示进程内执行环境必需的信息,其中包括进程中标识线程的线程 ID,一组寄存器值、调度优先级和策略、栈、信号屏蔽子,errno变量以及线程私有数据。进程的所有信息对该进程的所有线程都是共享的,包括可执行的程序文本,程序的全局内存和堆内存、栈以及文件描述符。注意：关于进程的编译我们都要加上参数 –lpthread否则提示找不到函数的错误。具体编译方法是 gcc –lpthread –o gettid gettid.c（经测试该方式不行，应为gcc gettid.c -o gettid -lpthread).
>当一个线程通过调用 pthread_exit退出或者简单地从启动历程中返回时,进程中的其他线程可以通过调用 pthread_join 函数获得进程的退出状态。调用pthread_join 进程将一直阻塞,直到指定的线程调用 pthread_exit,从启动例程中或者被取消。

在默认情况下,线程的终止状态会保存到对该线程调用 pthread_join,如果线程已经处于分离状态,线程的底层存储资源可以在线程终止时立即被收回。当线程被分离时,并不能用 pthread_join函数等待它的终止状态。对分离状态的线程进行 pthread_join 的调用会产生失败,返回 EINVAL.pthread_detach 调用可以用于使线程进入分离状态。
线程可以选择忽略取消方式和控制取消方式。pthread_cancel 并不等待线程终止,它仅仅提出请求。
>线程并发性是指如果至少有两个线程正在进行,则会出现此情况。并发是一种更广义的并行性,其中可以包括分时这种形式的虚拟并行性。线程并行性是指如果至少有两个线程正在同时执行,则会出现此情况。
在单个处理器的多线程进程中,处理器可以在线程之间切换执行资源,从而执行并发。在共享内存的多处理器环境内的同一个多线程进程中,进程中的每个线程都可以在一个单独的处理器上并发运行,从而执行并行。如果进程中的线程数不超过处理器的数目,则线程的支持系统和操作环境可确保每个线程在不同的处理器上执行。例如,在线程数和处理器数目相同的矩阵乘法中,每个线程和每个处理器都会计算一行结果。

用户级线程状态以下状态对于每个线程是唯一的。

- 线程 ID
- 寄存器状态(包括 PC 和栈指针)
- 栈
- 信号掩码
- 优先级
- 线程专用存储
由于线程可共享进程指令和大多数进程数据,因此一个线程对共享数据进行的更改对进程内其他线程是可见的。一个线程需要与同一个进程内的其他线程交互时,该线程可以在不涉及操作系统的情况下进行此操作。

##创建缺省进程
如果未指定属性对象,则该对象为NULL,系统会创建具有以下属性的缺省线程:
- 进程范围
- 非分离
- 缺省栈和缺省栈大小
- 零优先级
还可以用 pthread_attr_init()创建缺省属性对象,然后使用该属性对象来创建缺省线程。



##线程属性

- 初始化属性
使用 pthread_attr_init(3C)将对象属性初始化为其缺省值。存储空间是在执行期间由线程系统分配的，线程的属性用 pthread_attr_t 表示,在对该结构进行处理之前必须进行初始化(用pthread_attr_init 函数),在使用后需要对其去除初始化(用pthread_attr_destroy)。如果pthread_attr_init实现时为属性对象分配了动态内存空间,pthread_attr_destroy还会用无效的值初始化属性对象,因此如果经pthread_attr_destroy 去除初始化之后的 pthread_attr_t 结构被 pthread_create 函数调用,将会导致其返回错误。pthread_attr_init() 成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：ENOMEM 描述:如果未分配足够的内存来初始化线程属性对象,将返回该值。

- 设置分离状态
如果创建分离线程(PTHREAD_CREATE_DETACHED),则该线程一退出,便可重用其线程 ID 和其他资源。如果调用线程不准备等待线程退出,请使用 pthread_attr_setdetachstate(3C)。线程的分离状态决定一个线程以什么样的方式来终止自己。在默认情况下线程是非分离状态的,这种情况下,原有的线程等待创建的线程结束。只有当pthread_join()函数返回时,创建的线程才算终止,才能释放自己占用的系统资源。
>函数原型：int
pthread_attr_setdetachstate(pthread_attr_t *tattr,int detachstate);该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：EINVAL 描述: 指示 detachstate 或 tattr 的值无效。
如果使用 PTHREAD_CREATE_JOINABLE创建非分离线程,则假设应用程序将等待线程完成。也就是说,程序将对线程执行pthread_join()。无论是创建分离线程还是非分离线程,在所有线程都退出之前,进程不会退出。有关从main()提前退出而导致的进程终止的讨论。非分离线程在终止后,必须要有一个线程用join来等待它。否则,不会释放该线程的资源以供新线程使用,而这通常会导致内存泄漏。因此,如果不希望线程被等待,请将该线程作为分离线程来创建。
**注意：如果未执行显式同步来防止新创建的分离线程失败,则在线程创建者从pthread_create() 返回之前,可以将其线程 ID 重新分配给另一个新线程。**
>可以使用 pthread_attr_setdetachstate 函数把线程属性 detachstate 设置为下面的两个合法值之一:
>- 设置为PTHREAD_CREATE_DETACHED,以分离状态启动线程;
>- 设置为PTHREAD_CREATE_JOINABLE,正常启动线程。可以使用pthread_attr_getdetachstate 函数获取当前的 datachstate 线程属性。

- 获取分离状态
使用 pthread_attr_getdetachstate(3C)检索线程创建状态(可以为分离或连接)。
>函数原型：int pthread_attr_getdetachstate(const pthread_attr_t *tattr, int *detachstate);该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。
EINVAL 描述: 指示 detachstate 的值为 NULL 或 tattr 无效。

- 销毁属性
使用 pthread_attr_destroy(3C)删除初始化期间分配的存储空间。属性对象将会无效。
>函数原型：int pthread_attr_destroy(pthread_attr_t *tattr);
该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：EINVAL描述: 指示 tattr 的值无效。

- 属性对象
通过设置属性,可以指定一种不同于缺省行为的行为。使用pthread_create(3C) 创建线程时,或初始化同步变量时,可以指定属性对象。缺省值通常就足够了。属性对象是不透明的,而且不能通过赋值直接进行修改。系统提供了一组函数,用于初始化、配置和销毁每种对象类型。初始化和配置属性后,属性便具有进程范围的作用域。使用属性时最好的方法即是在程序执行早期一次配置好所有必需的状态规范。然后,根据需要引用相应的属性对象。
>使用属性对象具有两个主要优点:
>- 使用属性对象可增加代码可移植性。
即使支持的属性可能会在实现之间有所变化,但您不需要修改用于创建线程实体的函数调用。这些函数调用不需要进行修改,因为属性对象是隐藏在接口之后的。如果目标系统支持的属性在当前系统中不存在,则必须显式提供才能管理新的属性。管理这些属性是一项非常容易的移植任务,因为只需明确定义的位置初始化属性对象一次即可。
>- 应用程序中的状态规范已被简化。
例如,假设进程中可能存在多组线程。每组线程都提供单独的服务。每组线程都有各自的状态要求。在应用程序执行初期的某一时间,可以针对每组线程初始化线程属性对象。以后所有线程的创建都会引用已经为这类线程初始化的属性对象。初始化阶段是简单和局部的。将来就可以快速且可靠地进行任何修改。在进程退出时需要注意属性对象。初始化对象时,将为该对象分配内存。必须将此内存返回给系统。pthreads 标准提供了用于销毁属性对象的函数调用。

- 设置栈溢出保护区大小
使用pthread_attr_setguardsize(3C) 可以设置 attr 对象的 guardsize。
>函数原型：int pthread_attr_getguardsize(const pthread_attr_t *attr,size_t *guardsize);允许一致的实现将 guardsize 中包含的值向上舍入为可配置系统变量 PAGESIZE 的倍数。请参见 sys/mman.h 中的 PAGESIZE。如果实现将 guardsize 的值向上舍入为 PAGESIZE 的倍数,则以guardsize(先前调用 pthread_attr_setguardsize() 时指定的溢出保护区大小)为单位存储对指定 attr 的 pthread_attr_getguardsize() 的调用。
如果出现以下情况,pthread_attr_getguardsize() 将失败:
EINVAL描述: 参数 attr 无效,参数 guardsize 无效,或参数 guardsize 包含无效值。

- 设置范围
使用 pthread_attr_setscope(3C)建立线程的争用范围(PTHREAD_SCOPE_SYSTEM 或PTHREAD_SCOPE_PROCESS)。 使用 PTHREAD_SCOPE_SYSTEM 时,此线程将与系统中的所有线程进行竞争。使用 PTHREAD_SCOPE_PROCESS 时,此线程将与进程中的其他线程进行竞争。
>函数原型：int pthread_attr_setscope(pthread_attr_t *tattr,int scope);该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。EINVAL 描述: 尝试将 tattr 设置为无效的值。

- 获取范围
请使用 pthread_attr_getscope(3C) 检索线程范围。
>函数原型：int pthread_attr_getscope(pthread_attr_t *tattr, int *scope);该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。
EINVAL 描述: scope 的值为 NULL 或 tattr 无效。

- 设置线程并行级别
针对标准符合性提供了 pthread_setconcurrency(3C)。应用程序使用pthread_setconcurrency() 通知系统其所需的并发级别。对于 Solaris 9 发行版中引入的线程实现,此接口没有任何作用,所有可运行的线程都将被连接到 LWP。
>函数原型：int pthread_setconcurrency(int new_level);
如果出现以下情况,pthread_setconcurrency() 将失败:
>- EINVAL 描述: new_level 指定的值为负数。
>- EAGAIN 描述: new_level 指定的值将导致系统资源不足。

- 获取线程并行级别
使用pthread_getconcurrency(3C) 返回先前调用pthread_setconcurrency() 时设置的值。
>int pthread_getconcurrency(void);如果以前未调用 pthread_setconcurrency() 函数,则 pthread_getconcurrency() 将返回零。该函数始终会返回先前调用 pthread_setconcurrency() 时设置的并发级别。



##线程的继承性

函数 pthread_attr_setinheritsched和pthread_attr_getinheritsched 分别用来设置和得到线程的继承性,这两个函数具有两个参数,第1个是指向属性对象的指针,第2个是继承性或指向继承性的指针。
继承性决定调度的参数是从创建的进程中继承还是使用在schedpolicy和schedparam属性中显式设置的调度信息。Pthreads不为inheritsched指定默认值,因此如果你关心线程的调度策略和参数,必须先设置该属性。
和PTHREAD_EXPLICIT_SCHED
>如果你需要显式的设置一个线程的调度策略或参数,那么你必须在设置之前将 inheritsched 属性设置为 PTHREAD_EXPLICIT_SCHED.

- 设置继承的调度策略
请使用 pthread_attr_setinheritsched(3C) 设置继承的调度策略。
>函数原型：int pthread_attr_setinheritsched(pthread_attr_t *tattr, int inherit);nherit 值 PTHREAD_INHERIT_SCHED 表示新建的线程将继承创建者线程中定义的调度策略。将忽略在 pthread_create()调用中定义的所有调度属性。如果使用缺省值 PTHREAD_EXPLICIT_SCHED,则将使用pthread_create()调用中的属性。(表示使用在schedpolicy 和 schedparam属性中显式设置的调度策略和参数)。pthread_attr_setinheritsched() 成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>>- EINVAL 描述: 尝试将 tattr 设置为无效的值。
>>- ENOTSUP 描述: 尝试将属性设置为不受支持的值。

- 获取继承的调度策略
pthread_attr_getinheritsched(3C) 将返回由pthread_attr_setinheritsched() 设置的调度策略。
>函数原型：int pthread_attr_getinheritsched(pthread_attr_t *tattr, int *inherit);该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：EINVAL 描述: 参数 inherit 为 NULL 或 tattr 无效。

##线程的调度策略
函数 pthread_attr_setschedpolicy和pthread_attr_getschedpolicy 分别用来设置和得到线程的调度策略。这两个函数具有两个参数,第1个参数是指向属性对象的指针,第2个参数是调度策略或指向调度策略的指针。

- 设置调度策略
请使用 pthread_attr_setschedpolicy(3C) 设置调度策略。POSIX 标准指定 SCHED_FIFO(先入先出)、SCHED_RR(循环)或SCHED_OTHER(实现定义的方法)的调度策略属性。

>- 函数原型：int pthread_attr_setschedpolicy(pthread_attr_t *tattr, int policy);该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值：
>>- EINVAL 描述: 尝试将 tattr 设置为无效的值。
>>- ENOTSUP 描述: 尝试将该属性设置为不受支持的值。

>POSIX 标准指定SCHED_FIFO(先入先出)、SCHED_RR(循环)或SCHED_OTHER(实现定义的方法)的调度策略属性：
>- SCHED_FIFO 策略允许一个线程运行直到有更高优先级的线程准备好,或者直到它自愿阻塞自己。在SCHED_FIFO调度策略下,当有一个线程准备好时,除非有平等或更高优先级的线程已经在运行,否则它会很快开始执行。
如果调用进程具有有效的用户 ID 0,则争用范围为系统 (PTHREAD_SCOPE_SYSTEM) 的先入先出线程属于实时 (RT)调度类。如果这些线程未被优先级更高的线程抢占,则会继续处理该线程,直到该线程放弃或阻塞为止。对于具有进程争用范围(PTHREAD_SCOPE_PROCESS)) 的线程或其调用进程没有有效用户 ID 0 的线程,请使用SCHED_FIFO。SCHED_FIFO 基于 TS 调度类。

>- CHED_RR(轮循)策略是基本相同的,不同之处在于:如果有一个SCHED_RR策略的线程执行了超过一个固定的时期(时间片间隔)没有阻塞,而另外的SCHED_RR 或 SCHBD_FIPO 策略的相同优先级的线程准备好时,运行的线程将被抢占以便准备好的线程可以执行。
如果调用进程具有有效的用户 ID 0,则争用范围为系统(PTHREAD_SCOPE_SYSTEM)) 的循环线程属于实时 (RT)调度类。如果这些线程未被优先级更高的线程抢占,并且这些线程没有放弃或阻塞,则在系统确定的时间段内将一直执行这些线程。对于具有进程争用范围(PTHREAD_SCOPE_PROCESS) 的线程,请使用 SCHED_RR(基于 TS 调度类)。此外,这些线程的调用进程没有有效的用户 ID 0。
SCHED_FIFO 和 SCHED_RR 在 POSIX       
标准中是可选的,而且仅用于实时线程。

当有 SCHED_FIFO 或SCHED_RR策赂的线程在一个条件变量上等持或等持加锁同一个互斥量时,它们将以优先级顺序被唤醒。即,如果一个低优先级的SCHED_FIFO 线程和一个高优先织的 SCHED_FIFO线程都在等待锁相同的互斥且,则当互斥量被解锁时,高优先级线程将总是被首先解除阻塞。

- 获取调度策略
请使用 pthread_attr_getschedpolicy(3C) 检索调度策略。
>函数原型：int pthread_attr_getschedpolicy(pthread_attr_t *tattr, int *policy);该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。EINVAL 描述: 参数 policy 为 NULL 或 tattr 无效。



##线程的调度参数

系统支持的最大和最小优先权值可以用sched_get_priority_max函数和 sched_get_priority_min 函数分别得到。
>注意:如果不是编写实时程序,不建议修改线程的优先级。因为,调度策略是一件非常复杂的事情,如果不正确使用会导致程序错误,从而导致死锁等问题。如:在多线程应用程序中为线程设置不同的优先级别,有可能因为共享资源而导致优先级倒置。

- 设置调度参数
pthread_attr_setschedparam(3C) 可以设置调度参数。
>函数原型：int pthread_attr_setschedparam(pthread_attr_t *tattr,const struct sched_param *param);调度参数是在 param 结构中定义的。仅支持优先级参数。新创建的线程使用此优先级运行该函数成功完成后将返回零。其他任何返回值都表示出现了错误。
如果出现以下情况,该函数将失败并返回对应的值:EINVAL 描述: param 的值为 NULL 或 tattr 无效。可以采用两种方式之一来管理 pthreads 优先级:
>- 创建子线程之前,可以设置优先级属性
>- 可以更改父线程的优先级,然后再将该优先级改回来

- 获取调度参数
pthread_attr_getschedparam(3C) 将返回由 pthread_attr_setschedparam() 定义的调度参数。
> 函数原型：int pthread_attr_getschedparam(pthread_attr_t *tattr,const struct sched_param *param);该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：EINVAL 描述: param 的值为 NULL 或 tattr 无效。

 创建线程之前,可以设置优先级属性。将使用在 sched_param 结构中指定的新优先级创建子线程。此结构还包含其他调度信息。
>创建子线程时建议执行以下操作:
>- 获取现有参数
>- 更改优先级
>- 创建子线程
>- 恢复原始优先级

##线程的作用域

函数 pthread_attr_setscope和pthread_attr_getscope分别用来设置和得到线程的作用域,这两个函数具有两个参数,第1个是指向属性对象的指针,第 2 个是作用域或指向作用域的指针,作用域控制线程是否在进程内或在系统级上竞争资源,可能的值是PTHREAD_SCOPE_PROCESS(进程内竞争资源)PTHREAD_SCOPE_SYSTEM.(系统级上竞争资源)。

##线程的堆栈大小和地址
- 关于栈
通常,线程栈是从页边界开始的。任何指定的大小都被向上舍入到下一个页边界。不具备访问权限的页将被附加到栈的溢出端。大多数栈溢出都会导致将 SIGSEGV 信号发送到违例线程。将直接使用调用方分配的线程栈,而不进行修改。指定栈时,还应使用 PTHREAD_CREATE_JOINABLE 创建线程。在该线程的 pthread_join(3C) 调用返回之前,不会释放该栈。在该线程终止之前,不会释放该线程的栈。了解这类线程是否已终止的唯一可靠方式是使用 pthread_join(3C)。
函数 pthread_attr_setstacksize 和 pthread_attr_getstacksize 分别用来设置和得到线程堆栈的大小,这两个参数具有两个参数,第 1 个是指向属性对象的指针,第 2 个是堆栈大小或指向堆栈大小的指针。
函数 pthread_attr_setstackaddr 和 pthread_attr_getstackaddr 分别用来设置和得到线程堆栈的位置,这两个函数具有两个参数,第 1 个是指向属性对象的指针,第 2 个是堆栈地址或指向堆栈地址的指针
线程栈末尾的警戒缓冲区大小

>如果希望改变栈的默认大小,但又不想自己处理线程栈的分配问题,这时使用 pthread_attr_setstacksize 函数就非常有用。
线程属性 guardsize控制着线程栈末尾之后以避免栈溢出的扩展内存大小。这个属性默认设置为 PAGESIZE 个字节。可以把 guardsize 线程属性设为 0,从而不允许属性的这种特征行为发生:在这种情况下不会提供警戒缓存区。同样地,如果对线程属性stackaddr作了修改,系统就会假设我们会自己管理栈,并使警戒栈缓冲区机制无效,等同于把 guardsize 线程属性设为0。

- 为线程分配栈空间
一般情况下,不需要为线程分配栈空间。系统会为每个线程的栈分配 1 MB(对于 32 位系统)或 2 MB(对于 64位系统)的虚拟内存,而不保留任何交换空间。系统将使用 mmap()的 MAP_NORESERVE 选项来进行分配。系统创建的每个线程栈都具有红色区域。系统通过将页附加到栈的溢出端来创建红色区域,从而捕获栈溢出。此类页无效,而且会导致内存(访问时)故障。红色区域将被附加到所有自动分配的栈,无论大小是由应用程序指定,还是使用缺省大小。极少数情况下需要指定栈和/或栈大小。甚至专家也很难了解是否指定了正确的大小。甚至符合 ABI 标准的程序也不能静态确定其栈大小。栈大小取决于执行中特定运行时环境的需要。
**注意：对于库调用和动态链接,运行时栈要求有所变化。应绝对确定,指定的栈满足库调用和动态链接的运行时要求。**

- 生成自己的栈
指定线程栈大小时,必须考虑被调用函数以及每个要调用的后续函数的分配需求。需要考虑的因素应包括调用序列需求、局部变量和信息结构。有时,您需要与缺省栈略有不同的栈。典型的情况是,线程需要的栈大小大于缺省栈大小。而不太典型的情况是,缺省大小太大。您可能正在使用不足的虚拟内存创建数千个线程,进而处理数千个缺省线程栈所需的数千兆字节的栈空间。对栈的最大大小的限制通常较为明显,但对其最小大小的限制如何呢?必须存在足够的栈空间来处理推入栈的所有栈帧,及其局部变量等。要获取对栈大小的绝对最小限制,请调用宏 PTHREAD_STACK_MIN。PTHREAD_STACK_MIN 宏将针对执行 NULL 过程的线程返回所需的栈空间量。有用的线程所需的栈大小大于最小栈大小, 因此缩小栈大小时应非常谨慎。


- 设置栈大小
pthread_attr_setstacksize(3C) 可以设置线程栈大小。
>函数原型：int pthread_attr_setstacksize(pthread_attr_t *tattr,size_t size);stacksize属性定义系统分配的栈大小(以字节为单位)。size 不应小于系统定义的最小栈大小。size包含新线程使用的栈的字节数。如果 size 为零,则使用缺省大小。在大多数情况下,零值最适合。PTHREAD_STACK_MIN 是启动线程所需的栈空间量。此栈空间没有考虑执行应用程序代码所需的线程例程要求。pthread_attr_setstacksize()成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：EINVAL描述: size 值小于 PTHREAD_STACK_MIN,或超出了系统强加的限制,或者 tattr 无效。

- 获取栈大小
pthread_attr_getstacksize(3C) 将返回由 pthread_attr_setstacksize() 设置的栈大小。
>函数原型：int pthread_attr_getstacksize(pthread_attr_t *tattr,size_t *size);成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值:EINVAL 描述: tattr 无效。

- 设置栈地址和大小
pthread_attr_setstack(3C) 可以设置线程栈地址和大小。
>函数原型：int pthread_attr_setstack(pthread_attr_t *tattr,void *stackaddr,size_t stacksize);stackaddr 属性定义线程栈的基准(低位地址)。stacksize属性指定栈的大小。如果将stackaddr 设置为非空值,而不是缺省的NULL,则系统将在该地址初始化栈,假设大小为stacksize。base 包含新线程使用的栈的地址。如果 base 为 NULL,则 pthread_create(3C) 将为大小至少为 stacksize 字节的新线程分配栈。pthread_attr_setstack() 成功完成后将返回零。其他任何返回值都表示出现了错误。如果
出现以下情况,该函数将失败并返回对应的值:EINVAL 描述: base 或 tattr 的值不正确。stacksize 的值小于 PTHREAD_STACK_MIN。

- 获取栈地址和大小
pthread_attr_getstack(3C) 将返回由 pthread_attr_setstack() 设置的线程栈地址和大小。
>函数原型：int pthread_attr_getstack(pthread_attr_t *tattr,void * *stackaddr,size_t *stacksize);该函数成功完成后将返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：EINVAL 描述: tattr 的值不正确。

##线程清理处理程序

线程可以安排它退出时需要调用的函数,这样的函数称为线程清理处理程序,线程可以建立多个清理处理程序。处理程序记录在栈中,也就是说它们的**执行顺序与它们注册时的顺序相反**。

>要注意的是如果线程是通过从他的启动例程中返回而终止的,它的处理程序要就不会调用。还要注意清理处理程序是按照与它们安装时相反的顺序调用的。

##Posix 有名信号灯

函数 sem_open 创建一个新的有名信号灯或打开一个已存在的有名信号灯。sem_t *sem_open(const char *name,int oflag,/*mode_t mode,unsigned int value*/);参数：name信号灯的外部名字；oflag选择创建或打开一个现有的信号灯；mode 权限位;value信号灯初始值。
>有名信号灯总是既可用于线程间的同步,又可以用于进程间的同步。oflag参数可以是0、O_CREAT(创建一个信号灯)或O_CREAT|O_EXCL(如果没有指定的信号灯就创建),如果指定了O_CREAT,那么第三个和第四个参数是需要的;其中mode参数指定权限位,value参数指定信号灯的初始值,通常用来指定共享资源的书面。该初始不能超过SEM_VALUE_MAX,这个常值必须低于为32767。二值信号灯的初始值通常为 1,计数信号灯的初始值则往往大于 1。如果指定了 O_CREAT(而没有指定O_EXCL),那么只有所需的信号灯尚未存在时才初始化它。所需信号灯已存在条件下指定O_CREAT不是一个错误该标志的意思仅仅是“如果所需信号灯尚未存在,那就创建并初始化它”。但是所需信号灯等已存在条件下指定O_CREAT|O_EXCL却是一个错误。sem_open 返回指向sem_t信号灯的指针,该结构里记录着当前共享资源的数目。

一个进程终止时,内核还对其上仍然打开着的所有有名信号灯自动执行这样的**信号灯关闭**（sem_close）操作。不论该进程是自愿终止的还是非自愿终止的,这种自动关闭都会发生。
但应注意的是关闭一个信号灯并没有将它从系统中删除。这就是说,Posix有名信号灯至少是随内核持续的:即使当前没有进程打开着某个信号灯,它的值仍然保持。
有名信号灯使用 sem_unlink从系统中删除。每个信号灯有一个引用计数器记录当前的打开次数,sem_unlink必须等待这个数为 0 时才能把name所指的信号灯从文件系统中删除。也是要等待最后一个 sem_close 发生。

**测试信号灯** sem_getvalue在由valp指向的正数中返回所指定信号灯的当前值。如果该信号灯当前已上锁,那么返回值或为0,或为某个负数,其绝对值就是等待该信号灯解锁的线程数。

我们可以用 sem_wait来**申请共享资源**,sem_wait函数可以测试所指定信号灯的值,如果该值大于0,那就将它减1并立即返回。我们就可以使用申请来的共享资源了。如果该值等于0,调用线程就被进入睡眠状态,直到该值变为大于0,这时再将它减 1,函数随后返回。sem_wait 操作必须是原子的。sem_wait 和sem_trywait的差别是:当所指定信号灯的值已经是 0 时,后者并不将调用线程投入睡眠。相反,它返回一个 EAGAIN 错误。

**挂出共享资源**使用sem_post函数，当一个线程使用完某个信号灯时,它应该调用 sem_post 来告诉系统申请的资源已经用完。本函数和 sem_wait 函数的功能正好相反,它把所指定的信号灯的值加1,然后唤醒正在等待该信号灯值变为正数的任意线程。
>使用posix有名信号灯注意:

> - Posix 有名信号灯的值是随内核持续的。也就是说,一个进程创建了一个信号灯,这个进程结束后,这个信号灯还存在,并且信号灯的值也不会改变.
> - 当持有某个信号灯锁的进程没有释放它就终止时,内核并不给该信号灯解锁。

Posix 也提供**基于内存的信号灯**,它们由应用程序分配信号灯的内存空间,然后由系统初始化它们的值。基于内存的信号灯是由 sem_init 初始化的。sem 参数指向必须由应用程序分配的 sem_t变量。如果 shared 为0,那么待初始化的信号灯是在同一进程的各个线程共享的,否则该信号灯是在进程间共享的。 shared 为零时,该信号灯必须存放在即将使用它的所有进程当都能访问的某种类型的共享内存中。 sem_open一样,value参数是该信号灯的初始值。跟使用完一个基于内存的信号灯后,我们调用sem_destroy 关闭它。除了 sem_open 和 sem_close 外,其它的poisx有名信号灯函数都可以用于基于内存的信号灯。
>注意:posix 基于内存的信号灯和 posix 有名信号灯有一些区别

> - sem_open 不需要类型与shared的参数,有名信号灯总是可以在不同进程间共享的。
>- sem_init 不使用任何类似于 O_CREAT标志的东西,也就是说,sem_init  总是初始化信号灯的值。因此,对于一个给定的信号灯,我们必须小心保证只调用一次sem_init。
> - sem_open 返回一个指向某个sem_t变量的指针,该变量由函数本身分配并初始化。sem_init的第一个参数是一个指向某个sem_t变量的指针,该变量由调用者分配,但然后由 sem_init 函数初始化。
> - posix 有名信号灯是通过内核持续的,一个进程创建一个信号灯,另外的进程可以通过该信号灯的外部名(创建信号灯使用的文件名)来访问它。posix 基于内存的信号灯的持续性却是不定的,如果基于内存的信号灯是由单个进程内的各个线程共享的,那么该信号灯就是随进程持续的,当该进程终止时它也会消失。如果某个基于内存的信号灯是在不同进程间同步的,该信号灯必须存放在共享内存区中,这要只要该共享内存区存在,该信号灯就存在。
> - 基于内存的信号灯应用于线程很麻烦,而有名信号灯却很方便,基于内存的信号灯比较适合应用于一个进程的多个线程。

注意：sem 信号灯不在共享内存区中。fork出来的子进程通常不共享父进程的内存空间。子进程是在父进程内存空间的拷贝上启动的,它跟共享内存不是一回事。

##用同步对象编程
同步对象是内存中的变量,可以按照与访问数据完全相同的方式对其进行访问。不同进程中的线程可以通过放在由线程控制的共享内存中的同步对象互相通信。尽管不同进程中的线程通常互不可见,但这些线程仍可以互相通信。同步对象还可以放在文件中。同步对象可以比创建它的进程具有更长的生命周期。
>同步对象具有以下可用类型:

>- 互斥锁
>- 条件变量
>- 读写锁
>- 信号

>同步的作用包括以下方面:

>-  同步是确保共享数据一致性的唯一方法。
>-  两个或多个进程中的线程可以合用一个同步对象。由于重新初始化同步对象会将对象的状态设置为解除锁定,因此应仅由其中的一个协作进程来初始化同步对象。
>- 同步可确保可变数据的安全性。
>- 进程可以映射文件并指示该进程中的线程获取记录锁。一旦获取了记录锁,映射此文件的任何进程中尝试获取该锁的任何线程都会被阻塞,直到释放该锁为止。
>- 访问一个基本类型变量(如整数)时,可以针对一个内存负荷使用多个存储周期。如果整数没有与总线数据宽度对齐或者大于数据宽度,则会使用多个存储周期。尽管这种整数不对齐现象不会出现在 SPARC® Platform Edition 体系结构上,但是可移植的程序却可能会出现对齐问题。

注意：注 – 在 32 位体系结构上,long long 不是原子类型。(原子操作不能划分成更小的操作。)long long 可作为两个 32 位值进行读写。类型 int、char、float 和指针在 SPARC Platform Edition 计算机和 Intel 体系结构的计算机上是原子类型。

##互斥量

POSIX标准规定,对于某一具体的实现,可以把这种类型的互斥锁定义为其他类型的互斥锁。
另一种在多线程程序中同步访问手段是使用互斥量。程序员给某个对象加上一把“锁”,每次只允许一个线程去访问它。如果想对代码关键部分的访问进行控制,你必须在进入这段代码之前锁定一把互斥量,在完成操作之后再打开它。
>互斥量函数有:

> - pthread_mutex_init初始化一个互斥量；mutex 是我们要锁住的互斥量,attr 是互斥锁的属性,可用相应的函数修改,要用默认的属性初始化互斥量,只需把 attr 设置为 NULL。
> - pthread_mutex_destroy释放对互斥变量分配的资源; 
> - pthread_mutex_lock给一个互斥量加锁;
pthread_mutex_unlock 解锁.
对互斥量进行加锁,需要调用pthread_mutex_lock,如果互斥量已经上锁,调用线程阻塞直至互斥量解锁。对互斥量解锁,需要调用pthread_mutex_unlock.如果线程不希望被阻塞,他可以使用pthread_mutex_trylock 尝试对互斥量进行加锁。
> - pthread_mutex_trylock 加锁,如果失败不阻塞。如果调用 pthread_mutex_trylock时互斥量处于未锁住状态,那么pthread_mutex_trylock 将锁住互斥量,否则就会失败,不能锁住互斥量,而返回EBUSY。

**当主线程把互斥量锁住后,子线程就不能对共享资源进行操作了。**
可以通过使用 pthread的互斥接口保护数据,确保同一时间只有一个线程访问数据。互斥量从本质上说是一把锁,在访问共享资源前对互斥量进行加锁,在访问完成后释放互斥量上的锁。对互斥量进行加锁以后,任何其他试图再次对互斥量加锁的线程将会被阻塞直到当前线程释放该互斥锁。如果释放互斥锁时有多个线程阻塞,所以在该互斥锁上的阻塞线程都会变成可进行状态,第一个变成运行状态的线程可以对互斥量加锁,其他线程再次被阻塞,等待下次运行状态。

互斥量用 pthread_mutex_t来表示**数据类型**,在使用互斥量以前,必须首先对它进行初始化,可以把它置为常量PTHREAD_MUTEX_INITIALIZER(只对静态分配的互斥量),也可以通过调用 pthread_mutex_init 函数进行初始化,如果动态地分配互斥量,那么释放内存前需要调用 pthread_mutex_destroy.

##互斥锁属性
使用互斥锁(互斥)可以使线程按顺序执行。通常,互斥锁通过确保一次只有一个线程执行代码的临界段来同步多个线程。互斥锁还可以保护单线程代码。
要更改缺省的互斥锁属性,可以对属性对象进行声明和初始化。通常,互斥锁属性会设置在应用程序开头的某个位置,以便可以快速查找和轻松修改。

- 初始化互斥锁属性对象
使用 pthread_mutexattr_init(3C)可以将与互斥锁对象相关联的属性初始化为其缺省值。在执行过程中,线程系统会为每个属性对象分配存储空间。线程和线程的同步对象(互斥量,读写锁,条件变量)都具有属性。在修改属性前都需要对该结构进行初始化。使用后要把该结构回收。（我们用 pthread_mutexattr_init 函数对 pthread_mutexattr结构进行初始化,用pthread_mutexattr_destroy函数对该结构进行回收。）pthread_mutexattr_init将属性对象的值初始化为缺省值。并分配属性对象占用的内存空间。attr 中 pshared 属性)或 PTHREAD_PROCESS_SHARED。
>函数原型：int pthread_mutexattr_init(pthread_mutexattr_t *mattr);调用此函数时,pshared 属性的缺省值为 PTHREAD_PROCESS_PRIVATE。该值表示可以在进程内
使用经过初始化的互斥锁。mattr 的类型为 opaque,其中包含一个由系统分配的属性对象。mattr范围可能的值为PTHREAD_PROCESS_PRIVATE 和 PTHREAD_PROCESS_SHARED。表示用这个属性对象创建的互斥锁的作用域,它的取值可以是PTHREAD_PROCESS_PRIVATE(缺省值,表示由这个属性对象创建的互斥锁只能在进程内使用.pthread_mutexattr_init() 成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值:ENOMEM 描述: 内存不足,无法初始化互斥锁属性对象。

- 销毁互斥锁属性对象
pthread_mutexattr_destroy(3C) 可用来取消分配用于维护 pthread_mutexattr_init() 所创建的属性对象的存储空间。
>函数原型：int pthread_mutexattr_destroy(pthread_mutexattr_t *mattr);该函数成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值：EINVAL
描述: 由 mattr 指定的值无效。

- 设置互斥锁的范围
pthread_mutexattr_setpshared(3C)可用来设置互斥锁变量的作用域。
>函数原型：int pthread_mutexattr_setpshared(pthread_mutexattr_t *mattr,int pshared);互斥锁变量可以是进程专用的(进程内)变量,也可以是系统范围内的(进程间)变量。要在多个进程中的线程之间共享互斥锁,可以在共享内存中创建互斥锁,并将 pshared 属性设置为 PTHREAD_PROCESS_SHARED。 此行为与最初的 Solaris 线程实现中 mutex_init() 中的 USYNC_PROCESS 标志等效。如果互斥锁的 pshared 属性设置为 PTHREAD_PROCESS_PRIVATE,则仅有那些由同一个进程创建的线程才能够处理该互斥锁。pthread_mutexattr_setpshared()成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值，EINVAL 描述: 由 mattr 指定的值无效。

- 获取互斥锁的范围
pthread_mutexattr_getpshared(3C) 可用来返回由 pthread_mutexattr_setpshared() 定义的互斥锁变量的范围。
>函数原型：int pthread_mutexattr_getpshared(pthread_mutexattr_t *mattr,int *pshared);此函数可为属性对象 mattr 获取pshared 的当前值。该值为 PTHREAD_PROCESS_SHARED 或 PTHREAD_PROCESS_PRIVATE。pthread_mutexattr_getpshared()成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值:EINVAL 描述: 由 mattr 指定的值无效。

- 设置互斥锁类型的属性
pthread_mutexattr_settype(3C) 可用来设置互斥锁的 type 属性。
>函数原型：int pthread_mutexattr_settype(pthread_mutexattr_t *attr , int type);如果运行成功,pthread_mutexattr_settype 函数会返回零。否则,将返回用于指明错误的错误号。 EINVAL 描述: 值为 type 无效或者 attr 指定的值无效。
>类型属性的缺省值为 PTHREAD_MUTEX_DEFAULT。
type 参数指定互斥锁的类型。以下列出了有效的互斥锁类型:
>>- PTHREAD_MUTEX_NORMAL 描述:此类型的互斥锁不会检测死锁。如果线程在不首先解除互斥锁的情况下尝试重新锁定该互斥锁,则会产生死锁。尝试解除由其他线程锁定的互斥锁会产生不确定的行为。如果尝试解除锁定的互斥锁未锁定,则会产生不确定的行为。
这种类型的互斥锁不会自动检测死锁。如果一个线程试图对一个互斥锁重复锁定将会引起这个线程的死锁。如果试图解锁一个由别的线程锁定的互斥锁会引发不可预料的结果。如果一个线程试图解锁已经被解锁的互斥锁也会引发不可预料的结果。
>>- PTHREAD_MUTEX_ERRORCHECK
描述: 此类型的互斥锁可提供错误检查。如果线程在不首先解除锁定互斥锁的情况下尝试重新锁定该互斥锁,则会返回错误。如果线程尝试解除锁定的互斥锁已经由其他线程锁定,则会返回错误。如果线程尝试解除锁定的互斥锁未锁定,则会返回错误。
这种类型的互斥锁会自动检测死锁。如果一个线程试图对一个互斥锁重复锁定,将会返回一个错误代码。如果试图解锁一个由别的线程锁定的互斥锁将会返回一个错误代码。如果一个线程试图解锁已经被解锁的互斥锁也将会返回一个错误代码。
>>- PTHREAD_MUTEX_RECURSIVE
描述: 如果线程在不首先解除锁定互斥锁的情况下尝试重新锁定该互斥锁,则可成功锁定该互斥锁。 与 PTHREAD_MUTEX_NORMAL 类型的互斥锁不同,对此类型互斥锁进行重新锁定时不会产生死锁情况。多次锁定互斥锁需要进行相同次数的解除锁定才可以释放该锁,然后其他线程才能获取该互斥锁。如果线程尝试解除锁定的互斥锁已经由其他线程锁定,则会返回错误。如果线程尝试解除锁定的互斥锁未锁定,则会返回错误。
如果一个线程对这种类型的互斥锁重复上锁,不会引起死锁,一个线程对这类互斥锁的多次重复上锁必须由这个线程来重复相同数量的解锁,这样才能解开这个互斥锁,别的线程才能得到这个互斥锁。如果试图解锁一个由别的线程锁定的互斥锁将会返回一个错误代码。如果一个线程试图解锁已经被解锁的互斥锁也将会返回一个错误代码。这种类型的互斥锁只能是进程私有的(作用域属性为PTHREAD_PROCESS_PRIVATE)。
>>- PTHREAD_MUTEX_DEFAULT
描述: 如果尝试以递归方式锁定此类型的互斥锁,则会产生不确定的行为。对于不是由调用线程锁定的此类型互斥锁,如果尝试对它解除锁定,则会产生不确定的行为。对于尚未锁定的此类型互斥锁,如果尝试对它解除锁定,也会产生不确定的行为。允许在实现中将该互斥锁映射到其他互斥锁类型之一。对于 Solaris 线程,PTHREAD_PROCESS_DEFAULT
会映射到 PTHREAD_PROCESS_NORMAL。
这种类型的互斥锁不会自动检测死锁。如果一个线程试图对一个互斥锁重复锁定将会引起不可预料的结果。如果试图解锁一个由别的线程锁定的互斥锁会引发不可预料的结果。如果一个线程试图解锁已经被解锁的互斥锁也会引发不可预料的结果。

- 获取互斥锁的类型属性
pthread_mutexattr_gettype(3C) 可用来获取由 pthread_mutexattr_settype() 设置的互斥锁的 type 属性。
>函数原型：int pthread_mutexattr_gettype(pthread_mutexattr_t *attr , int *type);如果成功完成,pthread_mutexattr_gettype() 会返回 0。其他任何返回值都表示出现了错误。
类型属性的缺省值为PTHREAD_MUTEX_DEFAULT。
type 参数指定互斥锁的类型。有效的互斥锁类型包括:
>- PTHREAD_MUTEX_NORMAL
>- PTHREAD_MUTEX_ERRORCHECK
>- PTHREAD_MUTEX_RECURSIVE
>- PTHREAD_MUTEX_DEFAULT

- 设置互斥锁属性的协议
pthread_mutexattr_setprotocol(3C)可用来设置互斥锁属性对象的协议属性。
>函数原型：int pthread_mutexattr_setprotocol(pthread_mutexattr_t *attr, int protocol);如果成功完成,pthread_mutexattr_setprotocol() 会返回 0。其他任何返回值都表示出现了错误，如果出现以下任一情况,pthread_mutexattr_setprotocol() 将失败并返回对应的值。
>- ENOSYS 描述: 选项 _POSIX_THREAD_PRIO_INHERIT 和 _POSIX_THREAD_PRIO_PROTECT 均未定义并且该实现不支持此函数。
>- ENOTSUP 描述: protocol 指定的值不受支持。如果出现以下任一情况,pthread_mutexattr_setprotocol() 可能会失败并返回对应的值。
>- EINVAL 描述: attr 或 protocol 指定的值无效。
>- EPERM 描述: 调用方无权执行该操作。
>>attr 指示以前调用 pthread_mutexattr_init() 时创建的互斥锁属性对象。protocol 可定义应用于互斥锁属性对象的协议。pthread.h 中定义的 protocol 可以是以下值之一:PTHREAD_PRIO_NONE、
PTHREAD_PRIO_INHERIT 或 PTHREAD_PRIO_PROTECT。
>>- PTHREAD_PRIO_NONE
线程的优先级和调度不会受到互斥锁拥有权的影响。
>>- PTHREAD_PRIO_INHERIT
此协议值(如 thrd1)会影响线程的优先级和调度。如果更高优先级的线程因 thrd1 所拥有的一个或多个互斥锁而被阻塞,而这些互斥锁是用 PTHREAD_PRIO_INHERIT 初始化的,则 thrd1 将以高于它的优先级或者所有正在等待这些互斥锁(这些互斥锁是 thrd1指所拥有的互斥锁)的线程的最高优先级运行。如果 thrd1 因另一个线程 (thrd3) 拥有的互斥锁而被阻塞,则相同的优先级继承效应会以递归方式传播给 thrd3。
使用 PTHREAD_PRIO_INHERIT可以避免优先级倒置。低优先级的线程持有较高优先级线程所需的锁时,便会发生优先级倒置。只有在较低优先级的线程释放该锁之后,较高优先级的线程才能继续使用该锁。设置 PTHREAD_PRIO_INHERIT,以便按与预期的优先级相反的优先级处理每个线程。

 >如果为使用协议属性值 PTHREAD_PRIO_INHERIT 初始化的互斥锁定义了_POSIX_THREAD_PRIO_INHERIT,则互斥锁的属主失败时会执行以下操作。属主失败时的行为取决于pthread_mutexattr_setrobust_np() 的 robustness 参数的值。
>- 解除锁定互斥锁。
>- 互斥锁的下一个属主将获取该互斥锁,并返回错误 EOWNERDEAD。
>- 互斥锁的下一个属主会尝试使该互斥锁所保护的状态一致。如果上一个属主失败,则状态可能会不一致。如果属主成功使状态保持一致,则可针对该互斥锁调用 pthread_mutex_init()并解除锁定该互斥锁。
**注意：如果针对以前初始化的但尚未销毁的互斥锁调用pthread_mutex_init(),则该互斥锁不会重新初始化。**
>如果属主无法使状态保持一致,请勿调用pthread_mutex_init(),而是解除锁定该互斥锁。在这种情况下,所有等待的线程都将被唤醒。以后对 pthread_mutex_lock()的所有调用将无法获取互斥锁,并将返回错误代码 ENOTRECOVERABLE。现在,通过调用pthread_mutex_destroy() 来取消初始化该互斥锁,即可使其状态保持一致。调用pthread_mutex_init() 可重新初始化互斥锁。如果已获取该锁的线程失败并返回 EOWNERDEAD,则下一个属主将获取该锁及错误代码 EOWNERDEAD。
>>- PTHREAD_PRIO_PROTECT
当线程拥有一个或多个使用 PTHREAD_PRIO_PROTECT初始化的互斥锁时,此协议值会影响其他线程(如 thrd2)的优先级和调度。thrd2 以其较高的优先级或者以 thrd2 拥有的所有互斥锁的最高优先级上限运行。基于被 thrd2 拥有的任一互斥锁阻塞的较高优先级线程对于 thrd2 的调度没有任何影响。
如果某个线程调用 sched_setparam() 来更改初始优先级,则调度程序不会采用新优先级将该线程移到调度队列末尾。
>>>- 线程拥有使用 PTHREAD_PRIO_INHERIT 或 PTHREAD_PRIO_PROTECT 初始化的互斥锁线程解除锁定使用 PTHREAD_PRIO_INHERIT 或 PTHREAD_PRIO_PROTECT 初始化的互斥锁;
>>- 一个线程可以同时拥有多个混合使用 PTHREAD_PRIO_INHERIT 和 PTHREAD_PRIO_PROTECT 初始化的互斥锁。在这种情况下,该线程将以通过其中任一协议获取的最高优先级执行。




**互斥量属性分为共享互斥量属性和类型互斥量属性。**两种属性分别由不同的函数得到并由不同的函数进行修改.
pthread_mutexattr_getpshared 和pthread_mutexattr_setpshared函数可以获得和修改共享互斥量属性 。pthread_mutexattr_gettype 和 pthread_mutexattr_settype 函数可以获得和修改类型互斥量属性。

共享互斥量属性用于规定互斥锁的**作用域**。互斥锁的域可以是进程内的也可以是进程间的。pthread_mutexattrattr_ getpshared 可以返回属性对象的互斥锁作用域属性。可以是以下值:
PTHREAD_PROCESS_SHARED,PTHREAD_PROCESS_PRIVATE。如果互斥锁属性对象的 pshared属性被置PTHREAD_PROCESS_SHARED。那么由这个属性对象创建的互斥锁将被保存在共享内存中,可以被多个进程中的线程共享。如果 pshared属性被置为PTHREAD_PROCESS_PRIVATE,那么只有和创建这个互斥锁的线程在同一个进程中的线程才能访问这个互斥锁。

- 获取互斥锁属性的协议
pthread_mutexattr_getprotocol(3C) 可用来获取互斥锁属性对象的协议属性。
>函数原型：int pthread_mutexattr_getprotocol(const pthread_mutexattr_t *attr,int *protocol);如果成功完成,pthread_mutexattr_getprotocol() 会返回 0。其他任何返回值都表示出现了错误。如果出现以下情况,pthread_mutexattr_getprotocol() 将失败并返回对应的值:
>>- ENOSYS描述: _POSIX_THREAD_PRIO_INHERIT 选项和 _POSIX_THREAD_PRIO_PROTECT 选项均未定义并且该实现不支持此函数。如果出现以下任一情况,pthread_mutexattr_getprotocol() 可能会失败并返回对应的值。
attr 指示以前调用pthread_mutexattr_init()时创建的互斥锁属性对象。protocol 包含以下协议属性之一:PTHREAD_PRIO_NONE、PTHREAD_PRIO_INHERIT 或PTHREAD_PRIO_PROTECT。
>- EINVAL 描述: attr 指定的值无效。
>- EPERM  描述: 调用方无权执行该操作。

- 设置互斥锁属性的优先级上限
pthread_mutexattr_setprioceiling(3C)可用来设置互斥锁属性对象的优先级上限属性。
>函数原型：int pthread_mutexattr_setprioceiling(pthread_mutexatt_t *attr,int prioceiling, int *oldceiling);如果成功完成,pthread_mutexattr_setprioceiling() 会返回 0。其他任何返回值都表示出现了错误。如果出现以下任一情况,pthread_mutexattr_setprioceiling() 将失败并返回对应的值。
>- ENOSYS 描述: 选项 _POSIX_THREAD_PRIO_PROTECT 未定义并且该实现不支持此函数。如果出现以下任一情况,pthread_mutexattr_setprioceiling() 可能会失败并返回对应的值。
>- EINVAL 描述: attr 或 prioceiling 指定的值无效。
>- EPERM 描述: 调用方无权执行该操作。

 >attr 指示以前调用 pthread_mutexattr_init() 时创建的互斥锁属性对象。prioceiling指定已初始化互斥锁的优先级上限。优先级上限定义执行互斥锁保护的临界段时的最低优先级。prioceiling 位于 SCHED_FIFO所定义的优先级的最大范围内。要避免优先级倒置,请将 prioceiling设置为高于或等于可能会锁定特定互斥锁的所有线程的最高优先级。oldceiling包含以前的优先级上限值。
- 获取互斥锁属性的优先级上限pthread_mutexattr_getprioceiling(3C) 可用来获取互斥锁属性对象的优先级上限属性。
>函数原型：int pthread_mutexattr_getprioceiling(const pthread_mutexatt_t *attr,int *prioceiling);如果成功完成会返回0。其他任何返回值都表示出现了错误。如果出现以下任一情况,pthread_mutexattr_getprioceiling() 将失败并返回对应的值。
>- ENOSYS 描述: _POSIX_THREAD_PRIO_PROTECT选项未定义并且该实现不支持此函数。如果出现以下任一情况,pthread_mutexattr_getprioceiling() 可能会失败并返回对应的值。
>- EINVAL 描述: attr 指定的值无效。
>- EPERM 描述: 调用方无权执行该操作。
attr 指定以前调用 pthread_mutexattr_init()时创建的属性对象。
**注意： 仅当定义了 _POSIX_THREAD_PRIO_PROTECT 符号时,attr 互斥锁属性对象才会包括优先级上限属性。**
pthread_mutexattr_getprioceiling() 返回 prioceiling 中已初始化互斥锁的优先级上限。优先级上限定义执行互斥锁保护的临界段时的最低优先级。prioceiling 位于 SCHED_FIFO 所定义的优先级的最大范围内。要避免优先级倒置,请将prioceiling 设置为高于或等于可能会锁定特定互斥锁的所有线程的最高优先级。

- 设置互斥锁的优先级上限pthread_mutexattr_setprioceiling(3C) 可用来设置互斥锁的优先级上限。
>函数原型：int pthread_mutex_setprioceiling(pthread_mutex_t *mutex,int prioceiling,int *old_ceiling);如果成功完成,pthread_mutex_setprioceiling() 会返回 0。其他任何返回值都表示出现了错误。如果出现以下情况,pthread_mutexatt_setprioceiling() 将失败并返回对应的值。
>- ENOSYS 描述: 选项_POSIX_THREAD_PRIO_PROTECT未定义并且该实现不支持此函数。如果出现以下任一情况,pthread_mutex_setprioceiling() 可能会失败并返回对应的值。
>- EINVAL 描述: prioceiling 所请求的优先级超出了范围。
>- EINVAL 描述: mutex 指定的值不会引用当前存在的互斥锁。
>- ENOSYS 描述: 该实现不支持互斥锁的优先级上限协议。
>- EPERM 描述: 调用方无权执行该操作。
>>pthread_mutex_setprioceiling() 可更改互斥锁 mutex 的优先级上限 prioceiling。pthread_mutex_setprioceiling() 可锁定互斥锁(如果未锁定的话),或者一直处于阻塞状态,直到 pthread_mutex_setprioceiling()成功锁定该互斥锁,更改该互斥锁的优先级上限并将该互斥锁释放为止。锁定互斥锁的过程无需遵循优先级保护协议。如果 pthread_mutex_setprioceiling() 成功,则将在 old_ceiling 中返回以前的优先级上限值。如果pthread_mutex_setprioceiling() 失败,则互斥锁的优先级上限保持不变。

- 获取互斥锁的优先级上限pthread_mutexattr_getprioceiling(3C) 可用来获取互斥锁的优先级上限。
>函数原型：int pthread_mutex_getprioceiling(const pthread_mutex_t *mutex,int *prioceiling);如果成功完成,pthread_mutex_getprioceiling() 会返回 0。其他任何返回值都表示出现了错误。如果出现以下任一情况,pthread_mutexatt_getprioceiling() 将失败并返回对应的值。
>- ENOSYS 描述: _POSIX_THREAD_PRIO_PROTECT选项未定义并且该实现不支持此函数。如果出现以下任一情况,pthread_mutex_getprioceiling() 可能会失败并返回对应的值。
>- EINVAL 描述: mutex 指定的值不会引用当前存在的互斥锁。
>- ENOSYS 描述: 该实现不支持互斥锁的优先级上限协议。
>- EPERM 描述: 调用方无权执行该操作。

 >pthread_mutex_getprioceiling() 会返回 mutex 的优先级上限 prioceiling。

- 设置互斥锁的强健属性pthread_mutexattr_setrobust_np(3C) 可用来设置互斥锁属性对象的强健属性。
>函数原型：int pthread_mutexattr_setrobust_np(pthread_mutexattr_t *attr,int *robustness);如果成功完成,pthread_mutexattr_setrobust_np() 会返回 0。其他任何返回值都表示出现了错误。 如果出现以下任一情况,pthread_mutexattr_setrobust_np()将失败并返回对应的值:
>- ENOSYS 描述: 选项 _POSIX_THREAD_PRIO__INHERIT 未定义,或者该实现不支持pthread_mutexattr_setrobust_np()。
>- ENOTSUP 描述: robustness 指定的值不受支持。
pthread_mutexattr_setrobust_np() 可能会在出现以下情况时失败:
>- EINVAL 描述: attr 或 robustness 指定的值无效。

 **注意： 仅当定义了符号_POSIX_THREAD_PRIO_INHERIT时,pthread_mutexattr_setrobust_np()才适用。**
attr 指示以前通过调用 pthread_mutexattr_init() 创建的互斥锁属性对象。robustness定义在互斥锁的属主失败时的行为。pthread.h 中定义的 robustness 的值为 PTHREAD_MUTEX_ROBUST_NP 或PTHREAD_MUTEX_STALLED_NP。缺省值为
PTHREAD_MUTEX_STALLED_NP。
>- THREAD_MUTEX_ROBUST_NP如果互斥锁的属主失败,则以后对 pthread_mutex_lock() 的所有调用将以不确定的方式被阻塞。
>- PTHREAD_MUTEX_STALLED_NP互斥锁的属主失败时,将会解除锁定该互斥锁。互斥锁的下一个属主将获取该互斥锁,并返回错误 EOWNWERDEAD。
**注意：应用程序必须检查 pthread_mutex_lock() 的返回代码,查找返回错误 EOWNWERDEAD 的互斥锁。**
>>- 互斥锁的新属主应使该互斥锁所保护的状态保持一致。如果上一个属主失败,则互斥锁状态可能会不一致。
>>- 如果新属主能够使状态保持一致,请针对该互斥锁调用pthread_mutex_consistent_np(),并解除锁定该互斥锁。
>>- 如果新属主无法使状态保持一致,请勿针对该互斥锁调用pthread_mutex_consistent_np(),而是解除锁定该互斥锁。所有等待的线程都将被唤醒,以后对 pthread_mutex_lock()的所有调用都将无法获取该互斥锁。返回代码为 ENOTRECOVERABLE。通过调用 pthread_mutex_destroy() 取消对互斥锁的初始化,并调用 pthread_mutex_int() 重新初始化该互斥锁,可使该互斥锁保持一致。
如果已获取该锁的线程失败并返回EOWNERDEAD,则下一个属主获取该锁时将返回代码EOWNERDEAD。

- 获取互斥锁的强健属性
使用pthread_mutexattr_getrobust_np(3C)可用来获取互斥锁属性对象的强健属性。**仅当定义了符号 _POSIX_THREAD_PRIO_INHERIT 时,pthread_mutexattr_getrobust_np()才适用。**
>函数原型：int pthread_mutexattr_getrobust_np(const pthread_mutexattr_t *attr,int *robustness);如果成功完成,pthread_mutexattr_getrobust_np() 会返回 0。其他任何返回值都表示出现了错误。如果出现以下任一情况,pthread_mutexattr_getrobust_np() 将失败并返回对应的值。
>- ENOSYS 描述: 选项 _POSIX_THREAD_PRIO__INHERIT 未定义,或者该实现不支持pthread_mutexattr_getrobust_np()。
pthread_mutexattr_getrobust_np() 可能会在出现以下情况时失败:
>- EINVAL描述: attr 或 robustness 指定的值无效。

 >attr 指示以前通过调用 pthread_mutexattr_init() 创建的互斥锁属性对象。robustness 是互斥锁属性对象的强健属性值。

 **应用互斥量注意以下几点：**

- 互斥量需要时间来加锁和解锁。锁住较少互斥量的程序通常运行得更快。所以,互斥量应该尽量少,够用即可,每个互斥量保护的区域应则尽量大。
- 互斥量的本质是串行执行。如果很多线程需要频繁地加锁同一个互斥量,则线程的大部分时间就会在等待,这对性能是有害的。如果互斥量保护的数据(或代码)包含彼此无关的片段,则可以特大的互斥量分解为几个小的互斥量来提高性能。这样,任意时刻需要小互斥量的线程减少,线程等待时间就会减少。所以,互斥量应该足够多(到有意义的地步),每个互斥量保护的区域则应尽量的少。

##使用互斥锁
缺省调度策略 SCHED_OTHER不指定线程可以获取锁的顺序。如果多个线程正在等待一个互斥锁,则获取顺序是不确定的。出现争用时,缺省行为是按优先级顺序解除线程的阻塞。

- 初始化互斥锁
使用 pthread_mutex_init(3C) 可以使用缺省值初始化由 mp 所指向的互斥锁,还可以指定已经使用 pthread_mutexattr_init() 设置的互斥锁属性。mattr 的缺省值为 NULL。**注意：注初始化互斥锁之前,必须将其所在的内存清零。**
>函数原型：int pthread_mutex_init(pthread_mutex_t *mp,
const pthread_mutexattr_t *mattr);该函数在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>>- EBUSY 描述: 该实现已检测到系统尝试重新初始化 mp 所引用的对象,即以前进行过初始化但 尚未销毁的互斥锁。
>- EINVAL 描述: mattr 属性值无效。互斥锁尚未修改。
>- EFAULT 描述: mp 所指向的互斥锁的地址无效。

>如果互斥锁已初始化,则它会处于未锁定状态。互斥锁可以位于进程之间共享的内存中或者某个进程的专用内存中。将 mattr 设置为NULL 的效果与传递缺省互斥锁属性对象的地址相同,但是没有内存开销。使用 PTHREAD_MUTEX_INITIALIZER宏可以将以静态方式定义的互斥锁初始化为其缺省属性。当其他线程正在使用某个互斥锁时,请勿重新初始化或销毁该互斥锁。如果任一操作没有正确完成,将会导致程序失败。如果要重新初始化或销毁某个互斥锁,则应用程序必须确保当前未使用该互斥锁。

- 使互斥保持一致
如果某个互斥锁的属主失败,该互斥锁可能会变为不一致。使用 pthread_mutex_consistent_np 可使互斥对象 mutex 在其属主停止之后保持一致。**仅当定义了 _POSIX_THREAD_PRIO_INHERIT 符号时,pthread_mutex_consistent_np() 才适用,并且仅适用于使用协议属性值 PTHREAD_PRIO_INHERIT 初始化的互斥锁。**
>函数原型：int
pthread_mutex_consistent_np(pthread_mutex_t *mutex);该函数在成功完成之后会返回零。其他任何返回值都表示出现了错误。pthread_mutex_consistent_np() 会在出现以下情况时失败:
>- ENOSYS 描述: 选项 _POSIX_THREAD_PRIO_INHERIT未定义,或者该实现不支持pthread_mutex_consistent_np()。pthread_mutex_consistent_np()可能会在出现以下情况时失败:
>- EINVAL 描述: mattr 属性值无效。
调用 pthread_mutex_lock() 会获取不一致的互斥锁。EOWNWERDEAD 返回值表示出现不一致的互斥锁。持有以前通过调用pthread_mutex_lock() 获取的互斥锁时可调用pthread_mutex_consistent_np()。如果互斥锁的属主失败,则该互斥锁保护的临界段可能会处于不一致状态。在这种情况下,仅当互斥锁保护的临界段可保持一致时,才能使该互斥锁保持一致。针对互斥锁调用 pthread_mutex_lock()、pthread_mutex_unlock() 和 pthread_mutex_trylock() 会以正常方式进行。对于不一致或者未持有的互斥锁,pthread_mutex_consistent_np() 的行为是不确定的。

- 锁定互斥锁
使用 pthread_mutex_lock(3C) 可以锁定 mutex 所指向的互斥锁。
>函数原型：int pthread_mutex_lock(pthread_mutex_t *mutex);该函数在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>- EAGAIN 描述: 由于已超出了互斥锁递归锁定的最大次数,因此无法获取该互斥锁。
>- EDEADLK 描述: 当前线程已经拥有互斥锁。如果定义了 _POSIX_THREAD_PRIO_INHERIT 符号,则会使用协议属性值 PTHREAD_PRIO_INHERIT对互斥锁进行初始化。此外,如果 pthread_mutexattr_setrobust_np() 的 robustness 参数是
PTHREAD_MUTEX_ROBUST_NP,则该函数将失败并返回以下值之一:
>- EOWNERDEAD 描述:该互斥锁的最后一个属主在持有该互斥锁时失败。该互斥锁现在由调用方拥有。调用方必须尝试使该互斥锁所保护的状态一致.如果调用方能够使状态保持一致,请针对该互斥锁调用 pthread_mutex_consistent_np()并解除锁定该互斥锁。以后对 pthread_mutex_lock() 的调用都将正常进行;如果调用方无法使状态保持一致,请勿针对该互斥锁调用 pthread_mutex_init(),但要解除锁定该互斥锁。以后调用 pthread_mutex_lock() 时将无法获取该互斥锁,并且将返回错误代码 ENOTRECOVERABLE。如果获取该锁的属主失败并返回EOWNERDEAD,则下一个属主获取该锁时将返回EOWNERDEAD。
>- ENOTRECOVERABLE 描述:尝试获取的互斥锁正在保护某个状态,此状态由于该互斥锁以前的属主在持有该锁时失败而导致不可恢复。尚未获取该互斥锁。如果满足以下条件,则可能出现此不可恢复的情况:
>>- 以前获取该锁时返回 EOWNERDEAD
>>- 该属主无法清除此状态
>>- 该属主已经解除锁定了该互斥锁,但是没有使互斥锁状态保持一致 

 >- ENOMEM
描述: 已经超出了可同时持有的互斥锁数目的限制。

 当 pthread_mutex_lock()返回时,该互斥锁已被锁定。调用线程是该互斥锁的属主。如果该互斥锁已被另一个线程锁定和拥有,则调用线程将阻塞,直到该互斥锁变为可用为止。
>- 如果互斥锁类型为PTHREAD_MUTEX_NORMAL,则不提供死锁检测。尝试重新锁定互斥锁会导致死锁。如果某个线程尝试解除锁定的互斥锁不是由该线程锁定或未锁定,则将产生不确定的行为。
如果互斥锁类型为PTHREAD_MUTEX_ERRORCHECK,则会提供错误检查。如果某个线程尝试重新锁定的互斥锁已经由该线程锁定,则将返回错误。如果某个线程尝试解除锁定的互斥锁不是由该线程锁定或者未锁定,则将返回错误。
>- 如果互斥锁类型为 PTHREAD_MUTEX_RECURSIVE,则该互斥锁会保留锁定计数这一概念。线程首次成功获取互斥锁时,锁定计数会设置为1。线程每重新锁定该互斥锁一次,锁定计数就增加1。线程每解除锁定该互斥锁一次,锁定计数就减小 1。 锁定计数达到 0 时,该互斥锁即可供其他线程获取。如果某个线程尝试解除锁定的互斥锁不是由该线程锁定或者未锁定,则将返回错误。
>- 如果互斥锁类型是PTHREAD_MUTEX_DEFAULT,则尝试以递归方式锁定该互斥锁将产生不确定的行为。对于不是由调用线程锁定的互斥锁,如果尝试解除对它的锁定,则会产生不确定的行为。如果尝试解除锁定尚未锁定的互斥锁,则会产生不确定的行为。

- 解除锁定互斥锁
使用 pthread_mutex_unlock(3C) 可以解除锁定 mutex 所指向的互斥锁。
>函数原型：int pthread_mutex_unlock(pthread_mutex_t *mutex);该函数在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。EPERM 描述: 当前线程不拥有互斥锁。
pthread_mutex_unlock() 可释放 mutex 引用的互斥锁对象。互斥锁的释放方式取决于互斥锁的类型属性。 如果调用 pthread_mutex_unlock() 时有多个线程被 mutex 对象阻塞,则互斥锁变为可用时调度策略可确定获取该互斥锁的线程。 对于 PTHREAD_MUTEX_RECURSIVE 类型的互斥锁,当计数达到零并且调用线程不再对该互斥锁进行任何锁定时,该互斥锁将变为可用。

- 使用非阻塞互斥锁锁定
使用 pthread_mutex_trylock(3C) 可以尝试锁定 mutex 所指向的互斥锁。
>函数原型：int pthread_mutex_trylock(pthread_mutex_t *mutex);该函数在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>- EBUSY 描述: 由于 mutex 所指向的互斥锁已锁定,因此无法获取该互斥锁。
>- EAGAIN 描述: 由于已超出了 mutex 的递归锁定最大次数,因此无法获取该互斥锁。

 >如果定义了 _POSIX_THREAD_PRIO_INHERIT 符号,则会使用协议属性值 PTHREAD_PRIO_INHERIT对互斥锁进行初始化。此外,如果 pthread_mutexattr_setrobust_np() 的 robustness 参数是 PTHREAD_MUTEX_ROBUST_NP,则该函数将失败并返回以下值之一:
>- EOWNERDEAD 描述: 该互斥锁的最后一个属主在持有该互斥锁时失败。该互斥锁现在由调用方拥有。调用方必须尝试使该互斥锁所保护的状态一致。
如果调用方能够使状态保持一致,请针对该互斥锁调用 pthread_mutex_consistent_np()并解除锁定该互斥锁。以后对 pthread_mutex_lock() 的调用都将正常进行。如果调用方无法使状态保持一致,请勿针对该互斥锁调用 pthread_mutex_init(),而要解除锁定该互斥锁。以后调用 pthread_mutex_trylock() 时将无法获取该互斥锁,并且将返回错误代码 ENOTRECOVERABLE。 如果已获取该锁的属主失败并返回EOWNERDEAD,则下一个属主获取该锁时返回EOWNERDEAD。
>- ENOTRECOVERABLE 描述: 尝试获取的互斥锁正在保护某个状态,此状态由于该互斥锁以前的属主在持有该锁时失败而导致不可恢复。尚未获取该互斥锁。 以下条件下可能会出现此情况:
>>- 以前获取该锁时返回 EOWNERDEAD
>>- 该属主无法清除此状态
>>- 该属主已经解除锁定了该互斥锁,但是没有使互斥锁状态保持一致 
 
 >- ENOMEM
描述: 已经超出了可同时持有的互斥锁数目的限制。

 pthread_mutex_trylock() 是 pthread_mutex_lock() 的非阻塞版本。如果 mutex 所引用的互斥对象当前被任何线程(包括当前线程)锁定,则将立即返回该调用。否则,该互斥锁将处于锁定状态,调用线程是其属主。

- 销毁互斥锁
使用 pthread_mutex_destroy(3C) 可以销毁与 mp 所指向的互斥锁相关联的任何状态。
>函数原型：int pthread_mutex_destroy(pthread_mutex_t *mp);该函数在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。EINVAL 描述: mp 指定的值不会引用已初始化的互斥锁对象。

- 锁分层结构的使用示例
有时,可能需要同时访问两个资源。您可能正在使用其中的一个资源,随后发现还需要另一个资源。如果两个线程尝试声明这两个资源,但是以不同的顺序锁定与这些资源相关联的互斥锁,则会出现问题。例如,如果两个线程分别锁定互斥锁 1 和互斥锁 2,则每个线程    尝试锁定另一个互斥锁时,将会出现死锁。

 避免此问题的最佳方法是,确保线程在锁定多个互斥锁时,以同样的顺序进行锁定。如果始终按照规定的顺序锁定,就不会出现死锁。此方法称为**锁分层结构**,它通过为互斥锁指定逻辑编号来对这些锁进行排序。另外,请注意以下限制:如果您持有的任何互斥锁其指定编号大于 n,则不能提取指定编号为 n 的互斥锁。但是,不能始终使用此方法。有时,必须按照与规定不同的顺序提取互斥锁。要防止在这种情况下出现死锁,请使用 pthread_mutex_trylock()。如果线程发现无法避免死锁时,该线程必须释放其互斥锁。

- 嵌套锁定和单链接列表的结合使用示例
嵌套锁定和循环链接列表的示例（见99页-100页）


##条件变量

与互斥锁不同,条件变量是用来等待而不是用来上锁的。条件变量用来自动阻塞一个线程,直到某特殊情况发生为止。通常条件变量和互斥锁同时使用。条件变量使我们可以睡眠等待某种条件出现。
条件变量是利用线程间共享的全局变量进行同步的一种机制,主要包括两个动作:一个线程等待"条件变量的条件成立"而挂起;另一个线程使"条件成立"(给出条件成立信号)。
条件的检测是在互斥锁的保护下进行的。如果一个条件为假,一个线程自动阻塞,并释放等待状态改变的互斥锁。如果另一个线程改变了条件,它发信号给关联的条件变量,唤醒一个或多个等待它的线程,重新获得互斥锁,重新评价条件。**如果两进程共享可读写的内存,条件变量可以被用来实现这两进程间的线程同步。**

使用条件变量之前要先进行**初始化**。可以在单个语句中生成和初始化一个条件变量如:
pthread_cond_t my_condition=PTHREAD_COND_INITIALIZER;(用于进程间线程的通信)。也可以利用函数 pthread_cond_init动态初始化。

###条件变量函数
- pthread_cond_init 函数可以用来初始化一个条件变量。他使用变量 attr 所指定的属性来初始化一个条件变量,如果参数 attr为空,那么它将使用缺省的属性来设置所指定的条件变量。
- pthread_cond_destroy 函数可以用来摧毁所指定的条件变量,同时将会释放所给它分配的资源。调用该函数的进程也并不要求等待在参数所指定的条件变量上。
- pthread_cond_wait/pthread_cond_timedwait条件变量等待函数，第一个参数*cond是指向一个条件变量的指针。第二个参数*mutex 则是对相关的互斥锁的指针。函数pthread_cond_timedwait函数类型与函数 pthread_cond_wait,区别在于,如果达到或是超过所引用的参数*abstime,它将结束并返回错误ETIME.pthread_cond_timedwait 函数的参数*abstime 指向一个 timespec 结构。
- pthread_cond_signal/pthread_cond_broadcast
条件变量通知函数，参数*cond 是对类型为 pthread_cond_t 的一个条件变量的指针。当调用pthread_cond_signal时一个在相同条件变量上阻塞的线程将被解锁。如果同时有多个线程阻塞,则由调度策略确定接收通知的线程。如果调用pthread_cond_broadcast,则将通知阻塞在这个条件变量上的所有线程。一旦被唤醒线程仍然会要求互斥锁。如果当前没有线程等待通知,则上面两种调用实际上成为一个空操作。如果参数*cond指向非法地址,则返回值EINVAL。

###条件变量属性
使用条件变量可以以原子方式阻塞线程,直到某个特定条件为真为止。条件变量始终与互斥锁一起使用。
使用条件变量,线程可以以原子方式阻塞,直到满足某个条件为止。对条件的测试是在互斥锁(互斥)的保护下进行的。
>如果条件为假,线程通常会基于条件变量阻塞,并以原子方式释放等待条件变化的互斥锁。如果另一个线程更改了条件,该线程可能会向相关的条件变量发出信号,从而使一个或多个等待的线程执行以下操作:

>- 唤醒
- 再次获取互斥锁
- 重新评估条件
在以下情况下,条件变量可用于在进程之间同步线程:
- 线程是在可以写入的内存中分配的
- 内存由协作进程共享
调度策略可确定唤醒阻塞线程的方式。对于缺省值SCHED_OTHER,将按优先级顺序唤醒线程。

**注意：必须设置和初始化条件变量的属性,然后才能使用条件变量。**
条件变量属性类型为 pthread_condattr_t,pthread_condattr_init/pthread_condattr_destroy该函数用来初始化/回收 pthread_condattr_t 结构。
一旦某个条件变量对象被初始化了,我们就可以利用pthread_condattr_getpshared/pthread_condattr_setpshared函数来查看或修改特定属性了。pthread_condattr_getpshared 函数在由 valptr 指向的整数中返回这个属性的当前值,pthread_condattr_setpshared 则根据 value 的值设置这个属性的当前值。value的值可以是 PTHREAD_PROCESS_PRIVATE或PTHREAD_PROCESS_SHARED(进程间共享).

- 初始化条件变量属性
使用 pthread_condattr_init(3C)可以将与该对象相关联的属性初始化为其缺省值。在执行过程中,线程系统会为每个属性对象分配存储空间。
>函数原型：int pthread_condattr_init(pthread_condattr_t *cattr);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>- ENOMEM 描述: 分配的内存不足,无法初始化线程属性对象。
>- EINVAL 描述: cattr 指定的值无效。

 >调用此函数时,pshared属性的缺省值为PTHREAD_PROCESS_PRIVATE。pshared的该值表示可以在进程内使用已初始化的条件变量。cattr 的数据类型为 opaque,其中包含一个由系统分配的属性对象。cattr 范围可能的值为 PTHREAD_PROCESS_PRIVATE 和 PTHREAD_PROCESS_SHARED。PTHREAD_PROCESS_PRIVATE 是缺省
值。条件变量属性必须首先由 pthread_condattr_destroy(3C) 重新初始化后才能重用。pthread_condattr_init() 调用会返回指向类型为 opaque 的对象的指针。如果未销毁该对象,则会导致内存泄漏。

- 删除条件变量属性
使用 pthread_condattr_destroy(3C)可以删除存储并使属性对象无效。
>函数原型：int pthread_condattr_destroy(pthread_condattr_t *cattr);在成功完成之后会返回零。其他任何返回值都表示出现了错
误。如果出现以下情况,该函数将失败并返回对应的值。EINVAL 描述: cattr 指定的值无效。

- 设置条件变量的范围
pthread_condattr_setpshared(3C)可用来将条件变量的范围设置为进程专用(进程内)或系统范围内(进程间)。
>函数原型：int pthread_condattr_setpshared(pthread_condattr_t *cattr,int pshared);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。EINVAL 描述: cattr 或 pshared 的值无效。
如果 pshared 属性在共享内存中设置为PTHREAD_PROCESS_SHARED,则其所创建的条件变量可以在多个进程中的线程之间共享。此行为与最初的 Solaris 线程实现中 mutex_init() 中的USYNC_PROCESS 标志等效。如果互斥锁的 pshared 属性设置为 PTHREAD_PROCESS_PRIVATE,则仅有那些由同一个进程创建的线程才能够处理该互斥锁。PTHREAD_PROCESS_PRIVATE 是缺省值。 PTHREAD_PROCESS_PRIVATE 所产生的行为与在最初的 Solaris线程的 cond_init() 调用中使用 USYNC_THREAD 标志相同。PTHREAD_PROCESS_PRIVATE 的行为与局部条件变量相同。 PTHREAD_PROCESS_SHARED 的行为与全局条件变量等效。

- 获取条件变量的范围pthread_condattr_getpshared(3C) 可用来获取属性对象 cattr 的 pshared 的当前值。
>函数原型：int pthread_condattr_getpshared(const pthread_condattr_t *cattr,int *pshared);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。
EINVAL 描述: cattr 的值无效。
属性对象的值为 PTHREAD_PROCESS_SHARED 或 PTHREAD_PROCESS_PRIVATE。

##使用条件变量

- 初始化条件变量
使用 pthread_cond_init(3C) 可以将 cv 所指示的条件变量初始化为其缺省值,或者指定已经使用 pthread_condattr_init() 设置的条件变量属性。
>函数原型：int pthread_cond_init(pthread_cond_t *cv,
const pthread_condattr_t *cattr);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>- EINVAL 描述: cattr 指定的值无效。
>- EBUSY 描述: 条件变量处于使用状态。
>- EAGAIN 描述: 必要的资源不可用。
>- ENOMEM 描述: 内存不足,无法初始化条件变量。
cattr 设置为 NULL。将 cattr 设置为 NULL 与传递缺省条件变量属性对象的地址等效,但是没有内存开销。对于 Solaris 线程,请参见第 209 页中的 “cond_init 语法”。使用 PTHREAD_COND_INITIALIZER宏可以将以静态方式定义的条件变量初始化为其缺省属性。PTHREAD_COND_INITIALIZER 宏与动态分配具有 null 属性的 pthread_cond_init() 等效,但是不进行错误检查。多个线程决不能同时初始化或重新初始化同一个条件变量。如果要重新初始化或销毁某个条件变量,则应用程序必须确保该条件变量未被使用。

- 基于条件变量阻塞
使用 pthread_cond_wait(3C) 可以以原子方式释放 mp 所指向的互斥锁,并导致调用线程基于 cv 所指向的条件变量阻塞。 
>函数原型：int pthread_cond_wait(pthread_cond_t *cv,pthread_mutex_t *mutex);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值:EINVAL
描述: cv 或 mp 指定的值无效。
阻塞的线程可以通过 pthread_cond_signal() 或 pthread_cond_broadcast() 唤醒,也可以在信号传送将其中断时唤醒。不能通过 pthread_cond_wait() 的返回值来推断与条件变量相关联的条件的值的任何变化。必须重新评估此类条件。pthread_cond_wait()例程每次返回结果时调用线程都会锁定并且拥有互斥锁,即使返回错误时也是如此。该条件获得信号之前,该函数一直被阻塞。该函数会在被阻塞之前以原子方式释放相关的互斥锁,并在返回之前以原子方式再次获取该互斥锁。通常,对条件表达式的评估是在互斥锁的保护下进行的。如果条件表达式为假,线程会基于条件变量阻塞。然后,当该线程更改条件值时,另一个线程会针对条件变量发出信号。这种变化会导致所有等待该条件的线程解除阻塞并尝试再次获取互斥锁。必须重新测试导致等待的条件,然后才能从 pthread_cond_wait() 处继续执行。唤醒的线程重新获取互斥锁并从 pthread_cond_wait() 返回之前,条件可能会发生变化。等待线程可能并未真正唤醒。建议使用的测试方法是,将条件检查编写为调用 pthread_cond_wait() 的 while() 循环。

 如果有多个线程基于该条件变量阻塞,则无法保证按特定的顺序获取互斥锁。pthread_cond_wait()是取消点。如果取消处于暂挂状态,并且调用线程启用了取消功能,则该线程会终止,并在继续持有该锁的情况下开始执行清除处理程序。

- 解除阻塞一个线程
对于基于 cv 所指向的条件变量阻塞的线程,使用pthread_cond_signal(3C) 可以解除阻塞该线程。
>函数原型：int pthread_cond_signal(pthread_cond_t *cv);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。EINVAL 描述: cv 指向的地址非法。

 应在互斥锁的保护下修改相关条件,该互斥锁用于获得信号的条件变量中。否则,可能在条件变量的测试和 pthread_cond_wait()阻塞之间修改该变量,这会导致无限期等待。调度策略可确定唤醒阻塞线程的顺序。对于SCHED_OTHER,将按优先级顺序唤醒线程。如果没有任何线程基于条件变量阻塞,则调用 pthread_cond_signal() 不起作用。
 
- 在指定的时间之前阻塞
pthread_cond_timedwait(3C) 的用法与 pthread_cond_wait() 的用法基本相同,区别在于在由 abstime 指定的时间之后  pthread_cond_timedwait() 不再被阻塞。**加头文件< time.h>**
>函数原型：int pthread_cond_timedwait(pthread_cond_t *cv, pthread_mutex_t *mp, const struct timespec *abstime);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>- EINVAL 描述: cv 或 abstime 指向的地址非法。
>- ETIMEDOUT描述: abstime 指定的时间已过。
>
超时会指定为当天时间,以便在不重新计算值的情况下高效地重新测试条件.


 pthread_cond_timewait() 每次返回时调用线程都会锁定并且拥有互斥锁,即使pthread_cond_timedwait() 返回错误时也是如此。pthread_cond_timedwait() 函数会一直阻塞,直到该条件获得信号,或者最后一个参数所指定的时间已过为止。pthread_cond_timedwait() 也是取消点。

- 在指定的时间间隔内阻塞
使用pthread_cond_reltimedwait_np(3C)的用法与 pthread_cond_timedwait() 的用法基本相同,唯一的区别在于 pthread_cond_reltimedwait_np()会采用相对时间间隔而不是将来的绝对时间作为其最后一个参数的值。加头文件< time.h>
>函数原型：int pthread_cond_reltimedwait_np(pthread_cond_t *cv, pthread_mutex_t *mp, const struct timespec *reltime);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>- EINVAL 描述: cv 或 reltime 指示的地址非法。
>- ETIMEDOUT 描述: reltime 指定的时间间隔已过。


 pthread_cond_reltimedwait_np() 每次返回时调用线程都会锁定并且拥有互斥锁,即使 pthread_cond_reltimedwait_np() 返回错误时也是如此。pthread_cond_reltimedwait_np() 函数会一直阻塞,直到该条件获得信号,或者最后一个参数指定的时间间隔已过为止。**– pthread_cond_reltimedwait_np() 也是取消点。**

- 解除阻塞所有线程
对于基于 cv 所指向的条件变量阻塞的线程,使用 pthread_cond_broadcast(3C) 可以解除阻塞所有这些线程,这由 pthread_cond_wait() 来指定。
>函数原型：int pthread_cond_broadcast(pthread_cond_t *cv);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。EINVAL 描述: cv 指示的地址非法。


 如果没有任何线程基于该条件变量阻塞,则调用 pthread_cond_broadcast() 不起作用。由于 pthread_cond_broadcast()会导致所有基于该条件阻塞的线程再次争用互斥锁,因此请谨慎使用pthread_cond_broadcast()。例如,通过使用 pthread_cond_broadcast(),线程可在资源释放后争用不同的资源量,应在互斥锁的保护下修改相关条件,该互斥锁用于获得信号的条件变量中。否则,可能在条件变量的测试和 pthread_cond_wait() 阻塞之间修改该变量,这会导致无限期等待。

- 销毁条件变量状态
使用 pthread_cond_destroy(3C) 可以销毁与 cv 所指向的条件变量相关联的任何状态。请注意,没有释放用来存储条件变量的空间。
>函数原型：int pthread_cond_destroy(pthread_cond_t *cv);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。EINVAL 描述: cv 指定的值无效。

- 唤醒丢失问题
如果线程未持有与条件相关联的互斥锁,则调用pthread_cond_signal() 或 pthread_cond_broadcast() 会产生唤醒丢失错误。
>满足以下所有条件时,即会出现唤醒丢失问题:
>- 一个线程调用 pthread_cond_signal() 或 pthread_cond_broadcast()
>- 另一个线程已经测试了该条件,但是尚未调用 pthread_cond_wait()
>- 没有正在等待的线程信号不起作用,因此将会丢失
>
仅当修改所测试的条件但未持有与之相关联的互斥锁时,才会出现此问题。只要仅在持有关联的互斥锁同时修改所测试的条件,即可调用pthread_cond_signal() 和 pthread_cond_broadcast(),而无论这些函数是否持有关联的互斥锁。
- 生成方和使用者问题
并发编程中收集了许多标准的众所周知的问题,生成方和使用者问题只是其中的一个问题。此问题涉及到一个大小限定的缓冲区和两类线程(生成方和使用者),生成方将项放入缓冲区中,然后使用者从缓冲区中取走项。生成方必须在缓冲区中有可用空间之后才能向其中放置内容。使用者必须在生成方向缓冲区中写入之后才能从中提取内容。**条件变量表示一个等待某个条件获得信号的线程队列。**
获取互斥锁可确保该线程再次以独占方式访问缓冲区的数据结构。该线程随后必须检查缓冲区中是否确实存在可用空间。如果空间可用,该线程会向下一个可用的空位置中进行写入。与此同时,使用者线程可能正在等待项出现在缓冲区中。刚在缓冲区中存储内容的生成方线程会调用 pthread_cond_signal() 以唤醒下一个正在等待的使用者。如果没有正在等待的使用者,此调用将不起作用。最后,生成方线程会解除锁定互斥锁,从而允许其他线程处理缓冲区的数据结构。

请注意 assert() 语句的用法。除非在编译代码时定义了NDEBUG,否则 assert() 在其参数的计算结果为真(非零)时将不执行任何操作。如果参数的计算结果为假(零),则该程序会中止。在多线程程序中,此类断言特别有用。如果断言失败,assert() 会立即指出运行时问题。assert()还有另一个作用,即提供有用的注释。

>断言和注释都是不变量的示例。这些不变量是逻辑语句,在程序正常执行时不应将其声明为假,除非是线程正在修改不变量中提到的一些程序变量时的短暂修改过程中。当然,只要有线程执行语句,断言就应当为真。

使用不变量是一种极为有用的方法。即使没有在程序文本中声明不变量,在分析程序时也应将其视为不变量。每次线程执行包含注释的代码时,生成方代码中表示为注释的不变量始终为真。不变量可用于表示一个始终为真的属性,除非一个生成方或一个使用者正在更改缓冲区的状态。线程在互斥锁的保护下处理缓冲区时,该线程可能会暂时声明不变量为假。但是,一旦线程结束对缓冲区的操作,不变量即会恢复为真。

>**条件变量与互斥锁、信号量的区别:**

>- 互斥锁必须总是由给它上锁的线程解锁,信号量的挂出即不必由执行过它的等待操作的同一进程执行。一个线程可以等待某个给定信号灯,而另一个线程可以挂出该信号灯。
>- 互斥锁要么锁住,要么被解开(二值状态,类型二值信号量)。
>- 由于信号量有一个与之关联的状态(它的计数值),信号量挂出操作总是被记住。然而当向一个条件变量发送信号时,如果没有线程等待在该条件变量上,那么该信号将丢失。
>- 互斥锁是为了上锁而优化的,条件变量是为了等待而优化的,信号灯即可用于上锁,也可用于等待,因而可能导致更多的开销和更高的复杂性。

##读写锁属性
通过读写锁,可以对受保护的共享资源进行并发读取和独占写入。读写锁是可以在读取或写入模式下锁定的单一实体。要修改资源,线程必须首先获取互斥写锁。必须释放所有读锁之后,才允许使用互斥写锁。

对数据库的访问可以使用读写锁进行同步。读写锁支持并发读取数据库记录,因为读操作不会更改记录的信息。要更新数据库时,写操作必须获取互斥写锁。要更改缺省的读写锁属性,可以声明和初始化属性对象。通常,可以在应用程序开头的某个位置设置读写锁属性,设置在应用程序的起始位置可使属性更易于查找和修改。头文件< pthread.h>

- 初始化读写锁属性
pthread_rwlockattr_init(3C)使用实现中定义的所有属性的缺省值来初始化读写锁属性对象 attr。
>函数原型：int pthread_rwlockattr_init(pthread_rwlockattr_t *attr);如果成功,pthread_rwlockattr_init()会返回零。否则,将返回用于指明错误的错误号。ENOMEM 描述: 内存不足,无法初始化读写锁属性对象。

 如果调用 pthread_rwlockattr_init来指定已初始化的读写锁属性对象,则结果是不确定的。读写锁属性对象初始化一个或多个读写锁之后,影响该对象的任何函数(包括销毁)不会影响先前已初始化的读写锁。

- 销毁读写锁属性
pthread_rwlockattr_destroy(3C) 可用来销毁读写锁属性对象。
>函数原型：int pthread_rwlockattr_destroy(pthread_rwlockattr_t *attr);如果成功会返回零。否则,将返回用于指明错误的错误
号。EINVAL 描述: attr 指定的值无效。

 >在再次调用 pthread_rwlockattr_init() 重新初始化该对象之前,使用该对象所产生的影响是不确定的。实现可以导致 pthread_rwlockattr_destroy() 将 attr 所引用的对象设置为无效值。

- 设置读写锁属性
pthread_rwlockattr_setpshared(3C) 可用来设置由进程共享的读写锁属性。
>函数原型：int pthread_rwlockattr_setpshared(pthread_rwlockattr_t *attr,int pshared);如果成功,pthread_rwlockattr_setpshared() 会返回零。否则,将返回用于指明错误的错误号。EINVAL 描述: attr 或 pshared 指定的值无效。
>读写锁属性可以为以下值之一:
>- PTHREAD_PROCESS_SHARED
描述: 允许可访问用于分配读写锁的内存的任何线程对读写锁进行处理。即使该锁是在由多个进程共享的内存中分配的,也允许对其进行处理。
>- PTHREAD_PROCESS_PRIVATE
描述: 读写锁只能由某些线程处理,这些线程与初始化该锁的线程在同一进程中创建。如果不同进程的线程尝试对此类读写锁进行处理,则其行为是不确定的。

 >由进程共享的属性的缺省值为 PTHREAD_PROCESS_PRIVATE。

- 获取读写锁属性
pthread_rwlockattr_getpshared(3C) 可用来获取由进程共享的读写锁属性。
>函数原型：int pthread_rwlockattr_getpshared(const pthread_rwlockattr_t *attr,int *pshared);如果成功会返回零。否则,将返回用于指明错误的错误号。EINVAL 描述: attr 或 pshared 指定的值无效。
pthread_rwlockattr_getpshared() 从 attr 引用的已初始化属性对象中获取由进程共享的属性的值。

##使用读写锁
配置读写锁的属性之后,即可初始化读写锁。以下函数用于初始化或销毁读写锁、锁定或解除锁定读写锁或尝试锁定读写锁。头文件< pthread.h>

- 初始化读写锁
使用 pthread_rwlock_init(3C) 可以通过 attr 所引用的属性初始化 rwlock 所引用的读写锁。
>函数原型：int pthread_rwlock_init(pthread_rwlock_t *rwlock, const pthread_rwlockattr_t *attr);如果成功会返回零。否则,将返回用于指明错误的错误号。
如果 pthread_rwlock_init() 失败,将不会初始化 rwlock,并且 rwlock 的内容是不确定的。EINVAL 描述: attr 或 rwlock 指定的值无效。

 >如果 attr 为 NULL,则使用缺省的读写锁属性,其作用与传递缺省读写锁属性对象的地址相同。初始化读写锁之后,该锁可以使用任意次数,而无需重新初始化。成功初始化之后,读写锁的状态会变为已初始化和未锁定。如果调用 pthread_rwlock_init() 来指定已初始化的读写锁,则结果是不确定的。如果读写锁在使用之前未初始化,则结果是不确定的。
如果缺省的读写锁属性适用,则 PTHREAD_RWLOCK_INITIALIZER 宏可初始化以静态方式分配的读写锁,其作用与通过调用 pthread_rwlock_init() 并将参数 attr 指定为 NULL 进行动态初始化等效,区别在于不会执行错误检查。

- 获取读写锁中的读锁
pthread_rwlock_rdlock(3C) 可用来向 rwlock 所引用的读写锁应用读锁。
>函数原型：int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock );如果成功会返回零。否则,将返回用于指明错误的错误号。EINVAL 描述: attr 或 rwlock 指定的值无效。

 > 如果写入器未持有读锁,并且没有任何写入器基于该锁阻塞,则调用线程会获取读锁。如果写入器未持有读锁,但有多个写入器正在等待该锁时,调用线程是否能获取该锁是不确定的。如果某个写入器持有读锁,则调用线程无法获取该锁。如果调用线程未获取读锁,则它将阻塞。调用线程必须获取该锁之后,才能从 pthread_rwlock_rdlock()返回。如果在进行调用时,调用线程持有 rwlock 中的写锁,则结果是不确定的。为避免写入器资源匮乏,允许在多个实现中使写入器的优先级高于读取器。
一个线程可以在 rwlock中持有多个并发的读锁,该线程可以成功调用
pthread_rwlock_rdlock() n 次。该线程必须调用 pthread_rwlock_unlock() n 次才能执行匹配的解除锁定操作。如果针对未初始化的读写锁调用pthread_rwlock_rdlock(),则结果是不确定的。线程信号处理程序可以处理传送给等待读写锁的线程的信号。从信号处理程序返回后,线程将继续等待读写锁以执行读取,就好像线程未中断一样。

- 读取非阻塞读写锁中的锁
pthread_rwlock_tryrdlock(3C) 应用读锁的方式与 pthread_rwlock_rdlock() 类似,区别在于如果任何线程持有 rwlock 中的写锁或者写入器基于 rwlock 阻塞,则 pthread_rwlock_tryrdlock() 函数会失败。
>函数原型：int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);如果获取了用于在 rwlock 所引用的读写锁对象中执行读取的锁,则 pthread_rwlock_tryrdlock()将返回零。如果没有获取该锁,则返回用于指明错误的错误号。EBUSY 描述: 无法获取读写锁以执行读取,因为写入器持有该锁或者基于该锁已阻塞。

- 写入读写锁中的锁
pthread_rwlock_wrlock(3C) 可用来向 rwlock 所引用的读写锁应用写锁。
>函数原型：int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock );如果获取了用于在 rwlock 所引用的读写锁对象中执行写入的锁,则pthread_rwlock_rwlock() 将返回零。如果没有获取该锁,则返回用于指明错误的错误号。


 >如果没有其他读取器线程或写入器线程持有读写锁rwlock,则调用线程将获取写锁。否则,调用线程将阻塞。调用线程必须获取该锁之后,才能从 pthread_rwlock_wrlock() 调用返回。如果在进行调用时,调用线程持有读写锁(读锁或写锁),则结果是不确定的。为避免写入器资源匮乏,允许在多个实现中使写入器的优先级高于读取器。如果针对未初始化的读写锁调用 pthread_rwlock_wrlock(),则结果是不确定的。线程信号处理程序可以处理传送给等待读写锁以执行写入的线程的信号。从信号处理程序返回后,线程将继续等待读写锁以执行写入,就好像线程未中断一样。

- 写入非阻塞读写锁中的锁
pthread_rwlock_trywrlock(3C) 应用写锁的方式与 pthread_rwlock_wrlock() 类似,区别在于如果任何线程当前持有用于读取和写入的 rwlock,则 pthread_rwlock_trywrlock() 函数会失败。
>函数原型：int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);如果获取了用于在 rwlock 引用的读写锁对象中执行写入的锁,则pthread_rwlock_trywrlock() 将返回零。否则,将返回用于指明错误的错误号。EBUSY 描述: 无法为写入获取读写锁,因为已为读取或写入锁定该读写锁。

 > 如果针对未初始化的读写锁调用 pthread_rwlock_trywrlock(),则结果是不确定的。线程信号处理程序可以处理传送给等待读写锁以执行写入的线程的信号。从信号处理程序返回后,线程将继续等待读写锁以执行写入,就好像线程未中断一样。

- 解除锁定读写锁
pthread_rwlock_unlock(3C) 可用来释放在 rwlock 引用的读写锁对象中持有的锁。
>函数原型：int pthread_rwlock_unlock (pthread_rwlock_t *rwlock);如果成功,pthread_rwlock_unlock()会返回零。否则,将返回用于指明错误的错误号。

 >- 如果调用线程未持有读写锁 rwlock,则结果是不确定的。如果通过调用 pthread_rwlock_unlock() 来释放读写锁对象中的读锁,并且其他读锁当前由该锁对象持有,则该对象会保持读取锁定状态。
>- 如果 pthread_rwlock_unlock() 释放了调用
线程在该读写锁对象中的最后一个读锁,则调用线程不再是该对象的属主。如果 pthread_rwlock_unlock() 释放了该读写锁对象的最后一个读锁,则该读写锁对象将处于无属主、解除锁定状态。
>- 如果通过调用 pthread_rwlock_unlock() 释放了该读写锁对象的最后一个写锁,则该读写锁对象将处于无属主、解除锁定状态。
>- 如果 pthread_rwlock_unlock() 解除锁定该读写锁对象,并且多个线程正在等待获取该对象以执行写入,则通过调度策略可确定获取该对象以执行写入的线程。如果多个线程正在等待获取读写锁对象以执行读取,则通过调度策略可确定等待线程获取该对象以执行写入的顺序。
>- 如果多个线程基于 rwlock 中的读锁和写锁阻塞,则无法确定读取器和写入器谁先获得该锁。
>- 如果针对未初始化的读写锁调用 pthread_rwlock_unlock(),则结果是不确定的。

- 销毁读写锁
pthread_rwlock_destroy(3C) 可用来销毁 rwlock 引用的读写锁对象并释放该锁使用的任何资源。
>函数原型：int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);如果成功,pthread_rwlock_destroy() 会返回零。否则,将返回用于指明错误的错误号。EINVAL 描述: attr 或 rwlock 指定的值无效。

 >在再次调用 pthread_rwlock_init() 重新初始化该锁之前,使用该锁所产生的影响是不确定的。实现可能会导致 pthread_rwlock_destroy() 将 rwlock 所引用的对象设置为无效值。如果在任意线程持有 rwlock 时调用 pthread_rwlock_destroy(),则结果是不确定的。尝试销毁未初始化的读写锁会产生不确定的行为。已销毁的读写锁对象可以使用 pthread_rwlock_init() 来重新初始化。销毁读写锁对象之后,如果以其他方式引用该对象,则结果是不确定的。

##使用信号进行同步
信号是 E. W. Dijkstra 在二十世纪六十年代末设计的一种编程架构。Dijkstra 的模型与铁路操作有关:假设某段铁路是单线的,因此一次只允许一列火车通过。在计算机版本中,信号以简单整数来表示。线程等待获得许可以便继续运行,然后发出信号,表示该线程已经通过针对信号执行 P 操作来继续运行。线程必须等到信号的值为正,然后才能通过将信号值减 1 来更改该值。完成此操作后,线程会执行 V 操作,即通过将信号值加 1 来更改该值。这些操作必须以原子方式执行,不能再将其划分成子操作,即,在这些子操作之间不能对信号执行其他操作。
在 P 操作中,信号值在减小之前必须为正,从而确保生成的信号值不为负,并且比该值减小之前小 1。在 P 和 V 操作中,必须在没有干扰的情况下进行运算。如果针对同一信号同时执行两个 V 操作,则实际结果是信号的新值比原来大 2。
对于大多数人来说,如同记住 Dijkstra 是荷兰人一样,记住 P 和 V 本身的含义并不重要。但是,从真正学术的角度来说,P 代表 prolagen,这是由 proberen te verlagen 演变而来的杜撰词,其意思是尝试减小。V 代表 verhogen,其意思是增加。Dijkstra 的技术说明 EWD 74 中介绍了这些含义。sem_wait(3RT) 和 sem_post(3RT) 分别与 Dijkstra 的 P 和 V 操作相对应。sem_trywait(3RT) 是 P 操作的一种条件形式。如果调用线程不等待就不能减小信号的值,则该调用会立即返回一个非零值。
>有两种基本信号:二进制信号和计数信号量。二进制信号的值只能是 0 或 1,计数信号量可以是任意非负值。二进制信号在逻辑上相当于一个互斥锁。不过,尽管不会强制,但互斥锁应当仅由持有该锁的线程来解除锁定。因为不存在“持有信号的线程”这一概念,所以,任何线程都可以执行 V 或 sem_post(3RT) 操作。计数信号量与互斥锁一起使用时的功能几乎与条件变量一样强大。在许多情况下,使用计数信号量实现的代码比使用条件变量实现的代码更为简单.但是,将互斥锁用于条件变量时,会存在一个隐含的括号。该括号可以清楚表明程序受保护的部分。对于信号则不必如此,可以使用并发编程当中的 go to 对其进行调用。信号的功能强大,但是容易以非结构化的不确定方式使用。

- 命名信号和未命名信号
POSIX 信号可以是未命名的,也可以是命名的。未命名信号在进程内存中分配,并会进行初始化。未命名信号可能可供多个进程使用,具体取决于信号的分配和初始化的方式。未命名信号可以是通过 fork() 继承的专用信号,也可以通过用来分配和映射这些信号的常规
文件的访问保护功能对其进行保护。命名信号类似于进程共享的信号,区别在于命名信号是使用路径名而非 pshared 值引用的。命名信号可以由多个进程共享。命名信号具有属主用户 ID、组 ID 和保护模式。
对于 open、retrieve、close 和 remove 命名信号,可以使用以下函数:sem_open、sem_getvalue、sem_close 和 sem_unlink。通过使用 sem_open,可以创建一个命名信号,其名称是在文件系统的名称空间中定义的。**特别提醒：头文件为#include < semaphore.h>**


- 计数信号量概述
从概念上来说,信号量是一个非负整数计数。信号量通常用来协调对资源的访问,其中信号计数会初始化为可用资源的数目。然后,线程在资源增加时会增加计数,在删除资源时会减小计数,这些操作都以原子方式执行。如果信号计数变为零,则表明已无可用资源。计数为零时,尝试减小信号的线程会被阻塞,直到计数大于零为止。
由于信号无需由同一个线程来获取和释放,因此信号可用于异步事件通知,如用于信号处理程序中。同时,由于信号包含状态,因此可以异步方式使用,而不用象条件变量那样要求获取互斥锁。但是,信号的效率不如互斥锁高。缺省情况下,如果有多个线程正在等待信号,则解除阻塞的顺序是不确定的。信号在使用前必须先初始化,但是信号没有属性。

- 初始化信号
使用 sem_init(3RT) 可以将 sem 所指示的未命名信号变量初始化为 value。
>函数原型：int sem_init(sem_t *sem, int pshared, unsigned int value);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>- EINVAL 描述: 参数值超过了 SEM_VALUE_MAX。
>- ENOSPC 描述: 初始化信号所需的资源已经用完。到达信号的 SEM_NSEMS_MAX 限制。
>- ENOSYS 描述: 系统不支持 sem_init() 函数。
>- EPERM 描述: 进程缺少初始化信号所需的适当权限。
> 
如果 pshared 的值为零,则不能在进程之间共享信号。如果 pshared 的值不为零,则可以在进程之间共享信号。
>- 初始化进程内信号 
当pshared 为 0 时,信号只能由该进程内的所有线程使用。
>- 初始化进程间信号
pshared 不为零时,信号可以由其他进程共享。

 **注意：多个线程决不能初始化同一个信号。不得对其他线程正在使用的信号重新初始化。**

- 增加信号
使用 sem_post(3RT) 可以原子方式增加 sem 所指示的信号。
>函数原型：int sem_post(sem_t *sem);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。EINVAL 描述: sem 所指示的地址非法。如果所有线程均基于信号阻塞,则会对其中一个线程解除阻塞。

- 基于信号计数进行阻塞
使用 sem_wait(3RT) 可以阻塞调用线程,直到 sem 所指示的信号计数大于零为止,之后以原子方式减小计数。
>函数原型：int sem_wait(sem_t *sem);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>- EINVAL 描述: sem 所指示的地址非法。
>- EINTR 描述: 此函数已被信号中断。

- 减小信号计数
使用 sem_trywait(3RT) 可以在计数大于零时,尝试以原子方式减小 sem 所指示的信号计数。 此函数是 sem_wait() 的非阻塞版本。sem_trywait() 在失败时会立即返回。
>函数原型：int sem_trywait(sem_t *sem)；在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下任一情况,该函数将失败并返回对应的值。
>- EINVAL 描述: sem 所指示的地址非法。
>- EINTR 描述: 此函数已被信号中断。
>- EAGAIN 描述: 信号已为锁定状态,因此该信号不能通过 sem_trywait() 操作立即锁定。

- 销毁信号状态
使用 sem_destroy(3RT) 可以销毁与 sem 所指示的未命名信号相关联的任何状态。不会释放用来存储信号的空间。
>函数原型：int sem_destroy(sem_t *sem);在成功完成之后会返回零。其他任何返回值都表示出现了错误。如果出现以下情况,该函数将失败并返回对应的值。EINVAL 描述: sem 所指示的地址非法。

- 使用信号时的生成方和使用者问题（多线程编写手册128页）

##跨进程边界同步

每个同步元语都可以跨进程边界使用。通过确保同步变量位于共享内存段中,并调用适当的 init() 例程,可设置元语。元语必须已经初始化,并且其共享属性设置为在进程间使用。

- 生成方和使用者问题示例(多线程编写手册138页）
创建子进程是为了运行使用者,父进程则运行生成方。

- 比较元语
线程中最基本的同步元语是互斥锁。因此,在内存使用和执行时间这两个方面,互斥锁都是最高效的机制。互斥锁的基本用途是按顺序访问资源。
线程中第二高效的元语是条件变量。条件变量的基本用途是基于状态的变化进行阻塞。条件变量可提供线程等待功能。**请注意,线程在基于条件变量阻塞之前必须首先获取互斥锁**,在从 pthread_cond_wait() 返回之后必须解除锁定互斥锁。线程还必须在状态发生改变期间持有互斥锁,然后才能对 pthread_cond_signal() 进行相应的调用。信号比条件变量占用更多内存。由于信号变量基于状态而非控制来工作,因此在某些情况下更易于使用。与锁不同,信号没有属主。任何线程都可以增加已阻塞的信号。通过读写锁,可以对受保护的资源进行并发读取和独占写入。读写锁是可以在读取或写入模式下锁定的单一实体。要修改资源,线程必须首先获取互斥写锁。必须释放所有读锁之后,才允许使用互斥写锁。

##安全和不安全的接口

- 线程安全
线程安全可以避免数据竞争。不管数据值设置的正确与否,都会出现数据争用的情况,具体取决于多个线程访问和修改数据的顺序。不需要共享时,请为每个线程提供一个专用的数据副本。如果共享非常重要,则提供显式同步,以确保程序以确定的方式操作。当某个过程由多个线程同时执行时,如果该过程在逻辑上是正确的,则认为该过程是线程安全的。

 >实际上,一般可分为以下几种安全性级别。
>- 不安全
>- 线程安全,可串行化
>- 线程安全,MT 安全

 通过将过程包含在语句中来锁定和解除锁定互斥,可以使不安全过程变成线程安全过程,而且可以进行串行化。单一互斥比通常需要的同步效果更强。当两个线程使用 fputs() 将输出发送到不同文件时,一个线程无需等待另一个线程。只有在共享输出文件时,线程才需要进行同步。最新版本是 MT 安全的。此版本对每个文件都使用一个锁定,允许两个线程同时指向不同的文件。因此,只要例程是线程安全的,该例程就是 MT 安全的,而且例程的执行不会对性能造成负面影响。

- MT 接口安全级别(多线程编程手册166页）
出于以下原因,特意未将某些函数设为安全的。
>- 设置为 MT 安全的接口对单线程应用程序的性能有负面影响。
>- 库具有不安全的接口。例如,函数可能会返回指向栈中缓冲区的指针。可以对其中的某些函数使用可重复执行的对应函数。可重复执行的函数名称是在原始函数名称后附加"_r"。
**注意：确定名称不以 "_r" 结尾的函数是否是 MT 安全的唯一方法就是查看该函数的手册页。必须使用同步设备或通过限制初始线程来保护对标识为非 MT 安全的函数的使用。**

 不安全接口的可重复执行函数
对于包含不安全接口的大多数函数而言,存在例程的 MT 安全版本。新的 MT 安全例程的名称始终为原有不安全例程的名称附加 "_r" 后的形式。

- 异步信号安全函数
可以从信号处理程序中安全调用的函数就是异步信号安全函数。
- 库的 MT 安全级别
所有可能由线程从多线程程序中调用的例程都应该是 MT 安全的。因此,例程的两项或多项激活操作必须能够同时正确执行。这样,多线程程序使用的每个库接口都必须是 MT 安全级别。
- 不安全库
只有在单线程调用时,多进程程序才能安全地调用库中无法保证是 MT 安全级别的例程。

##共享内存
共享内存区是最快的可用IPC形式。它允许多个不相关的进程去访问同一部分逻辑内存。如果需要在两个运行中的进程之间传输数据,共享内存将是一种效率极高的解决方案。一旦这样的内存区映射到共享它的进程的地址空间,这些进程间数据的传输就不再涉及内核。这样就可以减少系统调用时间,提高程序效率.
共享内存是由 IPC为一个进程创建的一个特殊的地址范围,它将出现在进程的地址空间中。其他进程可以把同一段共享内存段“连接到”它们自己的地址空间里去。所有进程都可以访问共享内存中的地址。如果一个进程向这段共享内存写了数据,所做的改动会立刻被有访问同一段共享内存的其他进程看到。要**注意**的是共享内存本身没有提供任何同步功能。也就是说,在第一个进程结束对共享内存的写操作之前,并没有什么自动功能能够预防第二个进程开始对它进行读操作。
共享内存的访问同步问题必须由程序员负责。可选的同步方式有互斥锁、条件变量、读写锁、纪录锁、信号灯。

**mmap 函数**把一个文件或一个 Posix 共享内存区对象映射到调用进程的地址空间。头文件#include < sys/mman.h>addr指向映射存储区的起始地址；len 映射的字节；prot 对映射存储区的保护要求；flag 标志位；filedes 要被映射文件的描述符；off 要映射字节在文件中的起始偏移量。
参数详解：addr 参数用于指定映射存储区的起始地址。通常将其设置为 NULL,这表示由系统选择该映射区的起始地址。
filedes 指要被映射文件的描述符。在映射该文件到一个地址空间之前,先要打开该文件。len 是映射的字节数。
off 是要映射字节在文件中的起始偏移量。通常将其设置为 0。
prot 参数说明对映射存储区的保护要求。可将 prot 参数指定为PROT_NONE,或者是PROT_READ(映射区可读),PROT_WRITE(映射区可写),PROT_EXEC(映射区可执行)任意组合的按位或,也可以是
PROT_NONE(映射区不可访问)。对指定映射存储区的保护要求不能超过文件open 模式访问权限。
>flag 参数影响映射区的多种属性:

>- MAP_FIXED 返回值必须等于addr.因为这不利于可移植性,所以不鼓励使用此标志。
>- MAP_SHARED 这一标志说明了本进程对映射区所进行的存储操作的配置。此标志指定存储操作修改映射文件。
>- MAP_PRIVATE 本标志导致对映射区建立一个该映射文件的一个私有副本。所有后来对该映射区的引用都是引用该副本,而不是原始文件。
>>要注意的是必须指定 MAP_FIXED 或 MAP_PRIVATE标志其中的一个,指定前者是对存储映射文件本身的一个操作,而后者是对其副本进行操作。


函数若成功则返回映射区的起始地址,若出错则返回 MAP_FAILED。
使用该函数有三个目的:

- 使用普通文件以提供内存映射 I/O
- 使用特殊文件以提供匿名内存映射。
- 使用 shm_open 以提供无亲缘关系进程间的 Posix 共享内存区。
  
**解除存储映射函数**：int munmap(caddr_t addr,size_t len);
其中 addr 参数是由 mmap 返回的地址,len 是映射区的大小。再次访问这些地址导致向调用进程产生一个 SIGSEGV 信号。如果被映射区是使用 MAP_PRIVATE 标志映射的,那么调用进程对它所作的变动都被丢弃掉。
内核的虚存算法保持内存映射文件(一般在硬盘上)与内存映射区(在内存中)的同步(前提它是 MAP_SHARED 内存区)。这就是说,如果我们修改了内存映射到某个文件的内存区中某个位置的内容,那么内核将在稍后某个时刻相应地更新文件。然而有时候我们希望确信硬盘上的文件内容与内存映射区中的文件内容一致,于是调用 msync 来执行这种同步。

函数int msync(void *addr,size_t len,int flags);其中 addr 和 len 参数通常指代内存中的整个内存映射区,不过也可以指定该内存区的一个子集。flags 参数为 MS_ASYNC(执行异步写),MS_SYNC(执行同步写),MS_INVALIDATE(使高速缓存的数据实效)。其中 MS_ASYNC 和MS_SYNC两个常值中必须指定一个,但不能都指定。它们的差别是,一旦写操作已由内核排入队列,MS_ASYNC 即返回,而 MS_SYNC 则要等到写操作完成后才返回。如果还指定了MS_INVALIDATE,那么与其最终拷贝不一致的文件数据的所有内存中拷贝都失效。后续的引用将从文件取得数据。

函数void *memcpy(void *dest,const void *src,size_t n);
dest待复制的映射存储区；src复制后的映射存储区；n待复制的映射存储区的大小。函数返回 dest 的首地址。头文件#include < string.h>，实现拷贝 n 个字节从 dest 到 src。

###posix 共享内存函数
posix 共享内存区涉及两个步骤:
>- 指定一个名字参数调用shm_open,以创建一个新的共享内存区对象或打开一个以存在的共享内存区对象。头文件#include《sys/mman.h》参数：name 共享内存区的名字；cflag 标志位；mode 权限位;函数成功返回 0,出错返回-1

>- 调用 mmap 把这个共享内存区映射到调用进程的地址空间。传递给shm_open 的名字参数随后由希望共享该内存区的任何其他进程使用。
>>oflag 参数必须含有 O_RDONLY 和 O_RDWR标志,还可以指定如下标志:
O_CREAT,O_EXCL 或 O_TRUNC.mode 参数指定权限位,它指定 O_CREAT 标志的前提下使用。删除一个共享内存区i，nt shm_unlink(const char *name);shm_unlink函数删除一个共享内存区对象的名字,删除一个名字仅仅防止后续的 open,mq_open 或 sem_open调用取得成功。

普通文件或共享内存区对象的大小都可以通过调用 ftruncate 修改。该函数用来调整文件或共享内存区大小，头文件#include < unistd.h>。

当打开一个已存在的共享内存区对象时,我们可调用 fstat 来获取有关该对象的信息。头文件#include< unistd.h>;#include< sys/types.h>;#include < sys/stat.h >

###共享内存区的写入和读出
通过上面这些函数,把进程映射到共享内存区。然后我们就可以通过共享内存区进行进程间通信了。
                                         
                                          整理于2014.8.18
##编译多线程应用程序（多线程编程手册170页）

许多选项可用于头文件、定义标志和链接。

> 多线程程序中常见的疏忽性问题

>- 将指针作为新线程的参数传递给调用方栈。
>- 在没有同步机制保护的情况下访问全局内存的共享可更改状态。
>- 两个线程尝试轮流获取对同一对全局资源的权限时导致死锁。 其中一个线程控制第一种资源,另一个线程控制第二种资源。其中一个线程放弃之前,任何一个线程都无法继续操作。
>- 尝试重新获取已持有的锁(递归死锁)。
>- 在同步保护中创建隐藏的间隔。如果受保护的代码段包含的函数释放了同步机制,而又在返回调用方之前重新获取了该同步机制,则将在保护中出现此间隔。结果具有误导性。对于调用方,表面上看全局数据已受到保护,而实际上未受到保护。
>- 将 UNIX 信号与线程混合时,使用 sigwait(2) 模型来处理异步信号。
>- 调用 setjmp(3C) 和 longjmp(3C),然后长时间跳跃,而不释放互斥锁。
>- 从对 *_cond_wait() 或 *_cond_timedwait() 的调用中返回后无法重新评估条件。
>- 忘记已创建缺省线程 PTHREAD_CREATE_JOINABLE 并且必须使用 pthread_join(3C) 来进行回收。请注意,pthread_exit(3C) 不会释放其存储空间。
>- 执行深入嵌套、递归调用以及使用大型自动数组可能会导致问题,因为多线程程序与单线程程序相比对栈大小的限制更多。
>- 指定不适当的栈大小,或使用非缺省栈。

多线程程序(特别是那些包含错误的程序)经常在两次连续运行中的行为方式不同,即使输入相同也是如此。此行为是由线程调度顺序的差异所导致的。一般情况下,多线程错误是统计得出的,不具有确定性。通常,与基于断点的调试相比,跟踪是用于查找执行顺序问题的一种更有效的方法。

##编程原则


- 重新考虑全局变量
以前,大多数代码都是为单线程程序设计的。此代码设计特别适合于大多数从 C 程序调用的库例程。
>对于单线程代码,进行了以下隐含假设:
>>- 写入全局变量,随后又从该变量中读取时,读取的内容就是写入的内容。
>- 写入非全局静态存储,随后又从变量中读取时,所读取的内容恰好就是写入的内容。
>- 不需要进行同步,因为不会调用对变量的并发访问。
                                 
 当两个线程几乎同时失败而出现的错误不同时会发生的情况。两个线程都期望在 errno 中找到其错误代码,但 errno 的一个副本不能同时包含两个值。此全局变量方法不适用于多线程程序。线程可通过概念上的新存储类来解决此问题:线程特定数据。此类存储似于全局存储。可从正在运行的线程的任何过程访问线程特定数据。但是,线程特定数据专门用于线程。当两个线程引用同名称的线程特定数据位置时,这些线程引用的是两个不同的存储区域。
因此,使用线程时,对 errno 的每个引用都是特定于线程的,因为每个线程都具有专用的 errno 副本。在此实现方案中,通过使 errno 成为可扩展到函数调用的宏来实现特定于线程的 errno 调用。

- 提供静态局部变量
通常情况下,使用返回到局部变量的指针不是一个好办法。在本示例中使用指针有效,是因为变量是静态的。但是,当两个线程同时使用不同的计算机名称调用此变量时,使用静态存储会发生冲突。与 errno 问题一样,可以使用线程特定数据来替换静态存储。但是,此替换涉及到动态分配存储,并且会增加调用开支。

 处理该问题的更好方法是使 gethostbyname() 的调用方为调用结果提供存储。调用方可通过例程的其他输出参数来提供存储。其他输出参数需要 gethostbyname() 函数的新接口。在线程中常使用此技术来解决许多问题。在大多数情况下,新接口的名称就是原有名称附加 "_r",如 gethostbyname_r(3NSL)。

- 同步线程
共享数据和进程资源时,应用程序中的线程必须彼此协作并进行同步。多个线程调用处理同一对象的函数时,会引发问题。在单线程环境中,同步对这类对象的访问不是问题。请注意,对于多线程程序,可以安全调用 printf(3S) 函数。

- 单线程策略
一个策略是,只要应用程序中的任何线程处于运行状态并在必须阻塞之前被释放,即可获取单个应用程序范围的互斥锁。由于无论何时都只能有一个线程可以访问共享数据,因此每个线程都有一致的内存视图。由于此策略仅对单线程非常有效,因此此策略的使用范围非常小。

- 可重复执行函数
更好的方法是利用模块化和数据封装的原理。可重复执行函数可以在同时被多个线程调用的情况下正确执行。要编写可重复执行函数,需要大致了解正确操作对此特定函数的意义。必须使被多个线程调用的函数可重复执行。要使函数可重复执行,可能需要对函数接口或实现进行更改。访问全局状态(如内存或文件)的函数具有可重复执行问题。这些函数需要借助线程提供的相应同步机制来保护其全局状态的使用。使模块中的函数可重复执行的两个基本策略是代码锁定和数据锁定。
>- 代码锁定
代码锁定是在函数调用级别执行的,而且可保证函数在锁定保护下完全执行。该假设针对通过函数对数据执行的所有访问。共享数据的函数应该在同一锁定下执行。某些并行编程语言提供一种构造,称为监视程序。监视程序可以对监视程序范围内定义的函数隐式执行代码锁定。还可以通过互斥锁来实现监视。可保证受同一互斥锁保护或同一监视程序中的函数相对于监视程序中的其他函数以原子方式执行。
>- 数据锁定
数据锁定可保证一直维护对数据集合的访问。对于数据锁定,代码锁定概念仍然存在,但代码锁定只是对共享(全局)数据的轮流引用。对于互斥锁,在每个数据集合的临界段中只能有一个线程。另外,在多个读取器、单个写入器协议中,允许每个数据集合或一个写入器具有多个读取器。当多个线程对不同数据集合执行操作时,这些线程可以在单个模块中执行。需要特别指出的是,对于多个读取器、单个写入器协议,这些线程不会在单个集合上发生冲突。因此,数据锁定通常比代码锁定具备的并发性更多。

 >使用锁定时应使用哪种策略,在程序中实现互斥、条件变量还是信号?是要尝试通过仅在必要时锁定并在不必要时尽快解除锁定来实现**最大并行性**(这种方法称作“细粒度锁定 (fine-grained locking)”)?还是要长期持有锁定,以使使用和释放锁的开销降到**最低程度**(这种方法称作“粗粒度锁定 (coarse-grained locking)”)?
锁定的粒度取决于锁定所保护的数据量。粒度非常粗的锁定可能是单一锁定,目的是保护所有数据。划分由适当数目的锁定保护数据的方式非常重要。锁定粒度过细可能会降低性能。当应用程序包含太多锁定时,与获取和释放锁关联的开销可能会变得非常大。

 >常见的明智之举是先使用粗粒度方法,确定瓶颈,并在必要时添加细粒度锁定来缓解瓶颈。此方法听起来是很合理的建议,但是您应该自行判断如何在最大化并行性与最小化锁定开销之间找到平衡。
 
 >- 不变量和锁定
对于代码锁定和数据锁定,不变量对于控制锁定复杂性非常重要。不变量指始终为真的条件或关系。对于并发执行,其定义修改如下(在上述定义的基础上稍加修改即可得到此定义):不变量是在设置关联锁定时为真的条件或关系。设置锁定后,不变量可能为假。但是,在释放锁之前,持有锁的代码必须重新建立不变量。不变量还可以是设置锁定时为真的条件或关系。条件变量可以被认为含有一个不变量,而这个不变量就是这个条件。

 >  assert() 语句用于测试不变量。cond_wait() 函数不保留不变量,这就是在线程返回时必须重新评估不变量的原因所在。另一个示例就是用于管理双重链接的元素列表的模块。对于该列表中的每一项,良好的不变量是列表中前一项的向前指针。向前指针还应与向前项的向后指针指向同一元素。假设此模块使用基于代码的锁定,进而受到单个全局互斥锁的保护。删除或添加项时,将获取互斥锁,正确处理指针,而且会释放互斥锁。显然,在处理指针的某一时间点,不变量为假,但在释放互斥锁之前,需要重新建立不变量。

- 避免死锁
死锁是指永久阻塞一组争用一组资源的线程。仅因为某个线程可以继续执行,并不表示不会在某个其他位置发生死锁。
导致死锁的最常见错误是自死锁或递归死锁。在自死锁或递归死锁中,线程尝试获取已被其持有的锁。递归死锁是在编程时很容易犯的错误。例如,假设代码监视程序让每个模块函数在调用期间都获取互斥锁。随后,由互斥锁保护的模块内函数间的任何调用都会立即死锁。函数调用模块外的代码时,如果迂回调入任何受同一互斥锁保护的方法,则该函数也会发生死锁。

 这种死锁的解决方案就是避免调用模块外可能通过某一路径依赖此模块的函数。需要特别指出的是,应避免在未重新建立不变量的情况下调用回调入模块的函数,而且在执行调用之前不要删除所有的模块锁。当然,在调用完成和重新获取锁定之后,必须验证状态,以确保预期的操作仍然有效。另一种死锁的示例就是当两个线程(线程 1 和线程2)分别获取互斥锁 A 和 B 时的情况。假设,线程 1 尝试获取互斥锁 B,线程 2 尝试获取互斥锁 A。如果线程 1 在等待互斥锁 B 时受到阻塞,而无法继续执行。线程 2 在等待互斥锁 A 时受到阻塞也无法继续执行。任何情况都不会发生变化。

 因此,在这种情况下,将永久阻塞线程,即出现死锁现象。通过建立获取锁定的顺序(锁定分层结构),可以避免这种死锁。当所有线程始终按指定的顺序获取锁定时,即可避免这种死锁。遵循严格的锁定获取顺序并不总是非常理想。例如,线程 2 具有许多有关在持有互斥锁 B 时模块状态的假设。放弃互斥锁 B 以获取互斥锁 A,然后按相应的顺序重新获取互斥锁 B 将导致线程放弃其假设。必须重新评估模块的状态。

 阻塞同步元语通常具有变体,这些变体将尝试获取锁定,并在无法获取锁定时失败。例如mutex_trylock()。元语变体的这种行为允许线程在不出现争用时破坏锁定分层结构。出现争用时,通常必须放弃持有的锁定,并按顺序重新获取锁定。

- 与调用相关的死锁
由于不能保证获取锁定的顺序,因此如果特定线程永远不能获取锁定就会出现问题。持有锁的线程释放锁,一小段时间后重新获取锁定时,通常会出现此问题。由于锁被释放,因此其他线程似乎理应可以获取锁。但是,持有锁的线程未被阻塞。因此,从线程释放锁到重新获取锁定的时间内,该线程将持续运行。这样,就不会运行其他线程。通常,通过在进行重新获取锁定的调用前调用 thr_yield(3C),可以解决此类型的问题。thr_yield() 允许其他线程运行并获取锁定。
由于应用程序的时间片要求是可变的,因此系统不会强加任何要求。可通过调用thr_yield() 来使线程根据需要进行分时操作。

- 锁定原则
请遵循以下的简单锁定原则。
>- 请勿尝试在可能会对性能造成不良影响的长时间操作(如 I/O)中持有锁。
>- 请勿在调用模块外且可能重进入模块的函数时持有锁。
>- 一般情况下,请先使用粗粒度锁定方法,确定瓶颈,并在必要时添加细粒度锁定来缓解瓶颈。大多数锁定都是短期持有,而且很少出现争用。因此,请仅修复测得争用的那些锁定。
>- 使用多个锁定时,通过确保所有线程都按相同的顺序获取锁定来避免死锁。

##线程代码的一些基本原则

- 了解要导入的内容并了解其是否安全。线程程序不能随意输入非线程代码。
- 线程代码只能从初始线程中安全引用不安全的代码。以此方式引用不安全的代码确保了仅该线程使用与初始线程关联的静态存储。
- 使库可以安全地用于多线程时,请勿通过线程执行全局进程操作。请不要将全局操作或具有全局负面影响的操作更改为以线程方式执行。例如,如果将文件I/O更改为每线程操作,则线程无法在访问文件时进行协作。对于线程特定的行为或线程识别的行为,请使用线程功能。例如,终止 main() 时,应该仅终止将退出 main() 的线程。
- 除非明确说明 Sun 提供的库是安全的,否则假定这些库不安全。如果参考手册项没有明确声明接口是 MT-Safe,则假定接口不安全。
- 请使用编译标志来管理二进制不兼容源代码更改。
>有关完整的说明

 >- -D_REENTRANT 启用多线程。
>- -D_POSIX_C_SOURCE 提供 POSIX 线程行为。
>- -D_POSIX_PTHREADS_SEMANTICS 启用 Solaris 线程和 pthread 接口。当这两个接口发生冲突时,将优先使用 POSIX 接口。

##创建和使用线程
线程软件包会对线程数据结构和栈进行高速缓存,以使重复创建线程的代价较为合理。 但是,与管理等待独立工作的线程池相比,在需要线程时创建和销毁线程的代价通常会更高。RPC服务器就是一个很好的示例,该服务器可以为每个请求创建一个线程,并在传送回复时销毁该线程。创建线程的开销比创建进程的开销要少。但是,与创建几个指令的成本相比,创建线程并不是最经济的。请在至少持续处理数千个计算机指令时创建线程。

##使用多处理器
借助多线程,可以充分利用多处理器,主要是通过并行性和可伸缩性。程序员应该了解多处理器与单处理器的内存模块之间的差异。内存一致性与询问内存的处理器直接相关。对于单处理器,内存显然是一致的,因为只有一个处理器查看内存。

要提高多处理器性能,应放宽内存一致性。不应始终假设由一个处理器对内存所做的更改立即反映在该内存的其他处理器视图中。使用共享变量或全局变量时,可借助同步变量来避免这种复杂性。屏障同步有时是控制多处理器上并行性的一种有效方式。
另一个多处理器问题是在线程必须等到所有线程都到达执行的共同点时进行有效同步。


##基础体系结构


线程使用线程同步例程来同步对共享存储位置的访问。使用线程同步时,在共享内存多处理器上运行程序与在单处理器上运行程序的效果相同。但是,在许多情况下,程序员可能很想利用多处理器,并使用“技巧”来避免同步例程。
>了解常见多处理器体系结构支持的内存模块有助于了解这类危险。
主要的多处理器组件为:

>- 运行程序的处理器
>- 存储缓冲区,将处理器连接至其高速缓存
>- 高速缓存,存放最近访问或修改的存储位置的内容
>- 内存,主存储区且供所有处理器共享

 在简单的传统模型中,多处理器的行为方式就像将处理器直接连接到内存一样:当一个处理器存储在一个位置,而另一个处理器从同一位置直接装入时,第二个处理器将装入第一个处理器存储的内容。可以使用高速缓存来加快平均内存访问速度。当该高速缓存与其他高速缓存保持一致时,即可实现所需的语义。

该简单方法存在的问题是,必须经常延迟处理器以确定是否已实现所需的语义。许多现代的多处理器使用各种技术来防止这类延迟,遗憾的是,这会更改内存模型的语义。


- 示例：“共享内存”多处理器/Peterson 算法（手册229页）


##在共享内存并行计算机上并行化循环


在许多应用程序(特别是数值应用程序)中,一部分算法可以并行化,而其他部分却具有固有的顺序性,屏障将强制所有执行并行计算的线程一直等待,直到所有涉及到的线程都达到屏障为止。所有线程到达屏障后,即释放线程并同时开始计算。
         
                              整理于2014.8.28






