https://blog.csdn.net/gqtcgq/article/details/43112571 或
https://www.cnblogs.com/gqtcgq/category/1043750.html
https://github.com/nmathewson/libevent-book
https://www.monkey.org/~provos/libevent/doxygen-2.0.1/files.html


https://blog.csdn.net/luotuo44/column/info/libevent-src/2
https://blog.csdn.net/sparkliang/article/category/660506

https://github.com/bartman/event-loop-benchmark # libevent libev libuv libeuv picoev

Steven Grimm libevent

https://github.com/fan2/FuturismSchedule/tree/master/libevent

https://github.com/fan2/FuturismSchedule # 有些意思

使用库说明
    @section usage Standard usage
#include <event2/event.h>
-levent: 包括dns协议，http协议，TLV协议和事件驱动，IO缓存功能
-lcore_event: 包括事件驱动和IO缓存功能
    @section setup Library setup
event_set_mem_functions()   更换内存管理
event_enable_debug_mode().  使能debug功能
    @section base Creating an event base
event_base_new()                构建event_base
event_base_new_with_config()    构建event_base_config
    @section event Event notification
event_new()      新建和设置
event_assign()   设置
event_add()      添加到event_base
    @section loop Dispatching events.
event_base_dispatch()  调度
event_base_loop()      更深入的调度
    @section bufferevent I/O Buffers
bufferevent_socket_new()                      创建基于buffer的socket
bufferevent_enable() bufferevent_disable().   使能读写或取消读写使能
bufferevent_read() bufferevent_write().       读缓冲区和写缓冲区
#include <event2/bufferevent*.h>
    @section timers Timers
evtimer_new()     创建超时
evtimer_add()     添加超时
evtimer_del()     删除超时
    @section evdns Asynchronous DNS resolution
<event2/dns.h>
    @section evhttp Event-driven HTTP servers
<event2/http.h>
    @section evrpc A framework for RPC servers and clients
    @section api API Reference
event2/event.h      The primary libevent header
event2/thread.h     Functions for use by multithreaded programs
event2/buffer.h and event2/bufferevent.h    Buffer management for network reading and writing
event2/util.h       Utility functions for portable nonblocking network code
event2/dns.h        Asynchronous DNS resolution
event2/http.h       An embedded libevent-based HTTP server
event2/rpc.h        A framework for creating RPC servers and clients
event2/watch.h      "Prepare" and "check" watchers.
  


阻塞：send recv gethostbyname connect

定制顺序：内存分配->日志记录->线程锁。

1. 处理单路IO方式blocking阻塞方式即可。 --- 简单高效
2. 处理多路IO的一种方式；libevent，redis和moosefs --- 从复杂高效，趋向简单高效
3. 处理多路IO方式还有，多线程和多进程。 --- 复杂(线程间通信)低效；多用处理只有blocking阻塞方式


1. evutil  对不同平台下的网络实现的差异进行抽象。
2. event和event_base libevent的核心。为各种平台特定的、基于事件的非阻塞IO后端提供抽象API，
   让程序可以知道套接字何时已经准备好读或写，并且处理基本的超时功能，检测OS信号。
3. bufferevent 为libevent基于事件的核心提供更方便的封装。可以使你的程序请求缓存的读和写，
   让你知道何时真正的发生IO，而不是在sockets准备好时通知你。
   还让程序可以请求缓冲的读写操作而不是什么时候socket可以读写，同时，可以知道何时IO已经真正发生。
   (bufferevent接口有多个后端，可以采用系统能够提供的更快的非阻塞IO方式，如Windows中的IOCP。)
4. evbuffer: 在bufferevent层之下实现了缓冲功能，并且提供了方便有效的访问函数。
5. evhttp : 简单的HTTP客户端/服务端的实现。
6. evdns:   简单的DNS客户端/服务端实现。
7. evrpc:   简单的RPC实现。

libevent(默认安装){
--disable-thread-support
--disable-malloc-replacement
--disable-openssl
--disable-debug-mode
--enable-verbose-debug

-DUSE_DEBUG
-DUNICODE -D_UNICODE # windows

make dist
make distcheck
}
libevent(库){
当libevent安装时，以下的库已经默认安装：
libevent_core   该库包含了所有的事件和buffer功能，该库包含了所有的event_base, evbuffer, bufferevent和其他功能函数。
libevent_extra  该库包含了你可能在应用中使用的协议功能，包括HTTP, DNS和RPC。
libevent        这个库因历史原因而存在，他包含了libevent_core和libevent_extra库。你不应该使用他，他可能在将来的版本中移除。

下面的库只在特定平台安装：
libevent_pthreads
    该库基于可移植线程库pthreads，增加了线程和锁的实现机制。它独立于libevent_core，因此，
除非你要在多线程中使用libevent，否则不需要连接pthreads库。
libevent_openssl
    这个库为使用bufferevent和OpenSSL进行加密的通信提供支持。它独立于libevent_core，因此，
除非你确实需要加密通信，否则不需要连接OpenSSL库。
}
libevent(头文件){
当前libevent所有的公共的头文件都安装在event2目录下。头文件分为3类： # /usr/local/include/event2
1. API 头文件
该头文件是当前版本libevent公共接口的头文件。该类头文件没有特殊的后缀。

2. 兼容的头文件
兼容头文件包含一些不提倡使用的函数。一般不使用他，除非你正在使用旧版本的libevent。

3. 数据结构头文件
这些头文件定义了一些数据结构。其中部分已经暴露出来方便你快速使用数据结构，一些因为历史原因暴露出来。
直接使用依赖头文件中的数据结构会打破你编译出来的可执行文件的兼容性，有时非常难调试。这些头文件以"_struct.h"结束。
bufferevent_struct.h
dns_struct.h    
event_struct.h
keyvalq_struct.h  
rpc_struct.h
http_struct.h
}
    libevent有一些全局的设置共享给所有的程序。他影响整个库。你必须在使用libevent任一库之前来设置这些变量，
否则会导致libevent状态的不一致。
libevent(设置libevent库: 日志打印){ 实例见 test/regress_util.c
1. libevnet的日志消息 # debug级别需要:编译时设置
    libevent可以记录内部的错误和警告。如果编译添加了对日志记录的支持，你也可以记录调试信息。
这些信息默认的被输出了stderr。你可以提供自己的日志记录函数来覆盖原来的日志记录的方式。
--enable-verbose-debug; --disable-debug-mode.

1.1 日志回调函数
#define EVENT_LOG_DEBUG     0
#define EVENT_LOG_MSG       1
#define EVENT_LOG_WARN      2
#define EVENT_LOG_ERR       3

a. 日志回传
typedef void (*event_log_cb)(int severity, const char *msg);
void event_set_log_callback(event_log_cb cb);
    为了覆盖原来的日志记录函数，首先你要编写一个event_log_cb的函数，然后将其作为参数传给
event_set_log_callback()。当libevent想要记录信息是，它将会调用你提供的函数去记录。
# 通过调用event_set_log_callback()用NULL作为参数来设置使用原来的默认的日志记录方式。
# 注意
    在用户提供的event_log_cb回调函数中调用libevent 函数是不安全的。比如说，如果试图编写一个使用
bufferevent将警告信息发送给某个套接字的日志回调函数，可能会遇到奇怪而难以诊断的bug。未来版本libevent
的某些函数可能会移除这个限制。

b. 处理致命错误
    当libevent遇到一个无法恢复的内部错误的时候，它的默认行为是调用exit()或abort()退出当前运行的进程。
这些错误意味着程序存在bug，要么在程序的代码中，要么在libevent本身。
typedef void (*event_fatal_cb)(int err); 
void event_set_fatal_callback(event_fatal_cb cb);
# 注意：
    替代函数不要将控制返回到Libevent，否则会遇到非定义的行为，而且Libevent会退出。所以一旦你的函数被调用，
就不要再次调用任何其他的Libevent函数。

1.2. 调整日志debug级别
通常，debug级别的日志是禁用的，并且不会发送到日志回调函数中。如果在构建libevent时支持的话，可以手动启用。
#define EVENT_DBG_NONE  0
#define EVENT_DBG_ALL   0xffffffffu

void event_enable_debug_logging(ev_uint32_t which);
    调试信息在大多数情况下是冗余的没有多大用处的。
# 使用EVENT_DBG_NONE参数调用event_enable_debug_logging()关闭debug
# 使用EVENT_DBG_ALL参数调用event_enable_debug_logging()打开所有支持的debug日志。

    这些函数在<event2/event.h>中声明。除了event_enable_debug_logging()在libevent2.1.1-alpha版本中首次出现外，
其他的都在libevent1.0c中首次出现。

1.3 兼容性注意
在libevent2.0.19-stable版本之前，EVENT_LOG_*宏被定义为以下划线开头，例如：_EVENT_LOG_DEBUG, 
_EVENT_LOG_MSG, _EVENT_LOG_WARN和_EVENT_LOG_ERR。这些先前的宏是弃用的，你只应该在为了向前兼容
libevent2.0.18-stable和之前的版本时使用。他们将会在将来的版本中被移除。
}

libevent(设置libevent库: 内存管理){ test/regress_dns.c 或 test/regress_buffer.c
1. 内存回调函数
void event_set_mem_functions(void *(*malloc_fn)(size_t sz),
                            void *(*realloc_fn)(void *ptr, size_t sz),
                            void (*free_fn)(void *ptr));
# 在实际环境中，需要加上锁机制，以防止在多线程环境中遇到错误。

2. 注意事项
  替换内存管理函数，将会影响到libevent中所有内存分配，调整大小和释放内存操作。因此，
需要在调用任何其他libevent函数之前，进行这种替换。否则的话，libevent将会使用你提供的free函数，
来释放由C库的malloc函数申请的空间。
  你的malloc和realloc函数应该同C库返回的内存块一样，具有同样的内存地址对齐特性。
  你的realloc函数需要正确的处理realloc(NULL,sz)(也就是将其当做malloc(sz)处理)。
  你的realloc函数需要正确的处理realloc(ptr,0)(也就是将其当做free(ptr)处理)。
  你的free函数无需处理free(NULL)。
  你的malloc函数，无需处理malloc(0)。
  如果在多线程环境中使用libevent的话，需要保证你的内存管理函数是线程安全的。
  如果替代了libevent内存管理函数，那么libevent将会使用替代函数来分配内存，所以，
应该使用free的替代版本来释放由libevent返回的内存。

3. 编译链接时禁用
    可以在禁止event_set_mem_functions函数的配置下编译libevent。这时候使用
event_set_mem_functions将不会编译或者链接。
    可以通过检查是否定义了EVENT_SET_MEM_FUNCTIONS_IMPLEMENTED宏来确定
event_set_mem_functions函数是否存在。
}
libevent(设置libevent库: 锁和线程){ evthread_pthread.c 或  evthread_win32.c -> <event2/thread.h>
1. 锁说明
    当你知道你的程序中可能会使用到多线程，在多线程同时访问有些数据的时候不可能总是线程安全。
libevent数据结构通常可以使用以下三种方式在多线程中工作。
  一些结构体是单线程使用的：多线程同时使用是不安全的；
  一些结构体带有可选的锁：针对这种结构体，你可以告诉Libevent，是否会需要多个线程同时访问它
  一些结构体是带有强制锁：如果Libevent支持锁机制的话，那么这些结构体永远是线程安全的。

    为了获得Libevent中的锁机制，必须在调用任何分配多线程共享的结构体的函数之前，告诉Libevent使用哪些锁函数。
    如果使用pthreads库，或者使用原有的Windows多线程代码，那么已经有设置好的libevent预定义函数，
能够正确的使用pthreads或者Windows函数。

2. 推荐锁的类型：
    0：普通的，不需要递归的锁。
    EVTHREAD_LOCKTYPE_RECURSIVE
    如果一个线程已经获取它，再次获取他的时候不会阻塞。只有等到所有的上锁都解锁之后其他的线程才能获取这个锁。
    EVTHREAD_LOCKTYPE_READWRITE
    允许多个读线程同时获取它， 但同一时刻只允许一个写线程获取它。写线程获取到之后其他读线程也不能获取到。
3. 推荐的锁的模式：
    EVTHREAD_READ：  只对"读写锁"：为读获取或释放锁。
    EVTHREAD_WRITE： 只对"读写锁"：为写读取或释放锁。
    EVTHREAD_TRY：   只对"上锁"：获取锁如果锁可以立即获取。
    id_fn参数必须是一个返回unsigned long类型表示正在调用这个函数的线程的线程标示符的的函数。
它在相同的线程中返回的值必须一样，在同时执行的不同的线程中必须返回不恩给你的值

evthread_condition_callbacks数据结构描述了跟条件变量相关的回调函数。
lock_api_version字段必须设置为EVTHREAD_CONDITION_API_VERSION。
alloc_condition函数必须返回一个条件变量的指针，它接受0为它的参数。
free_condition函数必须释放由条件变量持有的资源和存贮空间。
wait_condition接受三个参数：由alloc_condition申请的条件变量， 
    由evthread_lock_callbacks申请的锁，malloc函数和可选的超时时间。锁将会被持有无论什么时候他被调用，
    它必须释放锁，等待直到条件被触发或是超时。在它返回之前，他应该确保他再次持有锁。
singal_condition函数会唤醒一个等待条件变量的线程(如果广播被禁止的话)
    或唤醒所有等待该条件变量的线程(如果广播被允许的话)。它将被持有当锁和条件绑定。
    
4. 锁调试
evthread_enable_lock_debugging(void)
为帮助调试锁的使用，libevent 有一个可选的"锁调试"特征。这个特征包装了锁调用，以便
捕获典型的锁错误，包括：
1. 解锁并没有持有的锁
2. 重新锁定一个非递归锁
如果发生这些错误中的某一个，libevent将给出断言失败并且退出。
}

libevent(设置libevent库: 调试事件的使用){ test/test-ratelim.c 和 -DUSE_DEBUG
在使用事件时，libevent可以诊断并报告给你一些通用的错误，他们包括：
1. 默认事件(event)已经初始化。
2. 尝试重新初始化一个挂起的事件(event)。
    # 跟踪哪个event被初始化需要额外的内存和CPU，所以应该仅调试程序时才使能调试模式。
    void event_enable_debug_mode(void);
    # 该函数必须在event_base创建之前调用。
    当使用debug模式时，如果你使用event_assign()[而不是使用event_new()]创建了大量的事件(event)的话，
有可能会内存溢出，这是因为libevent无法知道使用event_assign创建的事件(event)已经不再使用。
(通过调用event_free()可以告诉libevent使用event_new()创建的事件已经不合法了。)如果你想在debug模式
下内存溢出，你可以精确的告诉libevent事件(event)不当做分配的事件(assigned event)。
void event_debug_unassign(struct event *ev)
# 注意：如果没有使能调试模式，那么调用event_debug_unassign无效。

    详细的事件(event)调试只能在编译的时候使用CFLAG环境变量"-DUSE_DEBUG"来开启。当设置了这个标志，
任何编译违反libevent的都会输出，这些信息包括但并不仅限以下：
    事件的添加
    事件的删除
    平台相关的事件通知信息
# 这个特性不能通过API来设置，它必须在编译时设定。这些debug函数在libevent2.0.3-alpha中添加。
}
libevent(调试){
1. 日志
--disable-debug-mode     # disable support for running in debug mode
--enable-verbose-debug   # verbose debug logging
typedef void (*event_log_cb)(int severity, const char *msg);
void event_set_log_callback(event_log_cb cb);

void event_enable_debug_logging(ev_uint32_t which);

2. 内存
void event_set_mem_functions(void *(*malloc_fn)(size_t sz),
                            void *(*realloc_fn)(void *ptr, size_t sz),
                            void (*free_fn)(void *ptr));
                            
3. 锁
evthread_enable_lock_debugging(void)

4. 事件状态调试
void event_enable_debug_mode(void);
-DUSE_DEBUG

5. void event_base_dump_events(struct event_base *base, FILE *f);
得到的列表格式是人可读的形式，将来版本 的libevent可能会改变其格式。
}
libevent(设置libevent库: 检测libevent的版本){ test/regress main/version --verbose
探测当前安装的libevent的版本是不是最好的版本来编译你的程序。
debug时显示libevent的版本。
通过探测libevent的版本来警告一些bug，或者是绕过他们。

#define libevent_VERSION_NUMBER 0x02000300
#define libevent_VERSION "2.0.3-alph"
const char *event_get_version(void);
ev_uint32_t event_get_version_number(void);
以上的宏可用于libevent库的版本编译；函数返回运行时的版本。
# 注意，如果你动态绑定libevent，版本可能有些不同。
}

libevent(设置libevent库: 释放libevent全局结构){
    即使你已经释放了所有libevent分配的对象，依然会残留一些全局分配的结构。一般来说这不会有问题：
一旦程序退出了，所有资源都会被清理。但是，保留这些全局结构可能会使一些调试工具认为libevent有内存泄露。
如果希望libevent释放所有内部"库全局"数据结构的话，需要调用： 
    void  libevent_global_shutdown(void);
# 注意，该函数不会释放任何libevent返回给你的结构体。你若希望退出之前释放所有内存，则必须亲自释放所有的
events, event_bases，bufferevents等。
  调用libevent_global_shutdown()会使其他的libevent函数变得不可预知。所以该函数应该作为最后一个
  调用的libevent函数。
}
libevent(使用){
1. 单线程基础版：
包含头文件   <event2/event.h>
配置连接文件 -levent 或 -levent_core(精简版本)
结构体        struct event event_base
函数          event_new(), event_free(), event_base_new(), event_add(), event_base_dispatch()
后端屏蔽: 
setenv("EVENT_NOEPOLL", "1", 1);
setenv("EVENT_NOPOLL", "1", 1);
setenv("EVENT_NOSELECT", "1", 1);

2. 多线程支持： 
包含头文件 <event2/thread.h>
evthread_use_pthreads() 或者调用 evthread_use_windows_threads()

3. 内存管理
调用 event_set_mem_functions() 

4. debug模式
调用 event_enable_debug_mode()

5. 流程：
event_base_new() 或 event_base_new_with_config() 
                    配置event_config对象
                    struct event_config *event_config_new(void);
                    int event_config_require_features(struct event_config *cfg, enum event_method_feature feature);
                    int event_config_set_flag(struct event_config *cfg, enum event_base_config_flag flag);
                    int event_config_set_max_dispatch_interval (
                        struct event_config   *cfg,
                        const struct timerval *mac_interval,
                        int                    max_callbacks,
                        int                    min_priority);
                    event_config_free(struct event_config *cfg);
   支持后端和特性
   const char **event_get_supported_methods(void);
   const char *event_base_get_method (const struct event_base *base);
   enum event_method_feature event_base_get_features (const struct event_base *base); 
   优先级
   int event_base_priority_init (structr event_base *base, int n_priorities);
   int event_base_get_npriorities(struct event_base *base);   

event_new()动态内存管理+event_assign() 或 event_assign() 

event_add() # struct event *需要在堆上申请内存

event_base_dispatch() 或者 event_base_loop()提供更多控制
之后即可单线程基于事件执行；多线程可以创建多个event_base实例或者使用消息队列


6. timer
evtimer_new() 
evtimer_add()
evtimer_del()

7. evdns开发
包含头文件<event2/dns.h>
8. http开发
包含头文件<event2/http.h>
9. rpc
包含头文件<event2/rpc.h>

event2/event.h      The primary libevent header
event2/thread.h     Functions for use by multithreaded programs
event2/buffer.h and event2/bufferevent.h   Buffer management for network reading and writing
                                           bufferevent：缓存化的read/write接口，并且可以与SSL互相封装。
event2/util.h       Utility functions for portable nonblocking network code
event2/dns.h        Asynchronous DNS resolution
event2/http.h       An embedded libevent-based HTTP server
event2/rpc.h A      framework for creating RPC servers and clients
}

event_base_new(), 
event_base_free(), 
event_base_loop(),
event_base_new_with_config()
event_base(配置和获取后端){
    使用libevent函数之前需要分配一个或者多个event_base结构体。 # 每一个event_base持有和管理多个event，
# 并且判断哪些event是被激活的。
    如果设置event_base使用锁，则可以安全地在多个线程中访问它。然而，其事件循环只能运行在一个线程中。
如果需要用多个线程检测IO，则需要为每个线程使用一个event_base。

# libevent 支持启用或禁用其中的method
event_config_avoid_method: 可以通过名字让libevent 避免使用特定的可用后端。 # 成功返回0，失败返回-1.
int event_config_avoid_method(struct event_config*cfg, const char*method); # 避免使用特定后端 运行时
event_config_avoid_method(cfg, "select");
EVENT_NOKQUEUE                                                             # 避免使用特定后端 编译时

1. 设置默认event_base: 选择OS支持的最快的event_base
struct event_base *event_base_new(void); # 如果发生错误，则返回NULL。
这个函数alloc并返回一个带默认配置的event base。
void event_base_free(struct event_base *base);

2. 设置复杂event_base: 获得一个复杂的event_base
struct event_config *event_config_new(void);
struct event_base *event_base_new_with_config(const struct event_config *cfg); # event_base_new_with_config()返回NULL
void event_config_free(struct event_config *cfg);
这几个函数的基本功能就是：获得一个config，配置好后作为event_base创建的参数。用完后记得将config给free掉。

2.1 event_config_require_feature # 禁止libevent使用任何无法提供一组特性的后端方法。
int event_config_require_features(struct event_config *cfg, enum event_method_feature feature); # 成功时返回0，失败时返回-1；
这里的枚举值有以下几个：
EV_FEATURE_ET： 需要边沿触发的I/O                                     epoll     kqueue
EV_FEATURE_OI： 在add和delete event的时候，需要后端(backend)方法      epoll     kqueue
EV_FEATURE_FDS：支持任意文件描述符类型的后台方法，而不仅仅支持socket  /dev/poll kqueue poll select
上述的值都是mask，可以位与(|)。
设置event_config，请求OS不能提供的后端是很容易的。
比如说，对于libevent 2.0.1-alpha，在Windows中是没有O(1)后端的；
在Linux中也没有同时提供EV_FEATURE_FDS和EV_FEATURE_O1特 征 的 后 端 。 
如果创建了libevent 不能满足的配置，event_base_new_with_config()会返回NULL。
# epoll支持EV_FEATURE_ET|EV_FEATURE_O1

2.2 event_config_set_flag让libevent # 设置一些运行时标志。
int event_config_set_flag(struct event_config *cfg, enum event_base_config_flag flag); # 成功时返回0，失败时返回-1；
这里的枚举值有以下几个：
EVENT_BASE_FLAG_NOLOCK：       不要为event_base分配锁。设置这个选项可以为event_base节省一点用于锁定和解锁的时间，
                               但是让在多个线程中访问event_base成为不安全的。
EVENT_BASE_FLAG_IGNORE_ENV：   选择使用的后端时，不要检测EVENT_*环境变量。
                               使用这个标志需要三思：这会让用户更难调试你的程序与libevent 的交互。
EVENT_BASE_FLAG_STARTUP_IOCP： 仅用于Windows，让libevent 在启动时就启用任何必需的IOCP分发逻辑，而不是按需启用。
EVENT_BASE_FLAG_NO_CACHE_TIME：不是在事件循环每次准备执行超时回调时检测当前时间，而是在每次超时回调后进行检测。
                               注意：这会消耗更多的CPU时间。
EVENT_BASE_FLAG_EPOLL_USE_CHANGELIST：告诉libevent，如果决定使用epoll后端，可以安全地使用更快的基于changelist的后端。
                               epoll-changelist后端可以在后端的分发函数调用之间，同样的fd多次修改其状态的情况下，
                               避免不必要的系统调用。但是如果传递任何使用dup()或者其变体克隆的fd给libevent，epoll-changelist
                               后端会触发一个内核bug，导致不正确的结果。在不使用epoll后端的情况下，这个标志是没有效果的。
EVENT_BASE_FLAG_PRECISE_TIMER：使用更加精确的定时机制 在CMake中提供EVENT_PRECISE_TIMER该环境变量进行设置。
# Windows没有O(1)的后端方法，而且Linux也不能提供EV_FEATURE_FDS和 EV_FEATURE_O1的后端方法。
# 如果配置的Libevent无法满足的话，那么event_base_new_with_config()会返回NULL。

2.3 防止优先级反转
int event_config_set_max_dispatch_interval(
                        struct event_config   *cfg,
                        const struct timerval *max_interval,
                        int                    max_callbacks,
                        int                    min_priority);
max_interval ：经过该时间之后，libevent应该停止运行回调，而检查新的events，
               如果该参数为NULL，则无此时间限制。
max_callbacks：经过max_callbacks个回调之后，libevent应该停止运行回调，并且检查更多的events。
              如果该参数为-1，则无此个数限制。
min_priority：低于该优先级的events，max_interval和max_callbacks将不会生效。
              如果该值为0，则所有优先级的events都会生效。
              如果置为1，则针对优先级为1，以及更高优先级的events才会生效。
# 通过在检查更高优先级的events之前，限制有多少低优先级的event回调可以被调用而实现的。
  如果max_interval非NULL，在每次回调之后，event loop都会检查时间，而且经过max_interval时间之后，重新扫描更高优先级的
events。如果max_callbacks非0，那么max_callback个回调被调用之后，event loop会检查更多的events。这些规则针对min_priority
以及以上的events有效。
  该接口设置在经过多长时间，或者(以及)经过多少个回调之后，重新检查新的events。默认情况下，event_base在检查新events
之前，会运行尽可能多的被激活的高优先级events。如果设置了max_interval之后，那么每次回调之后都会检查时间，保证检查新events
的最长时间间隔就是max_interval。如果设置了大于0的max_callbacks，那么在检查新的events之前，最多运行max_callbacks个回调。
# 该接口可以减少高优先级events的延迟。而且在有多个低优先级events时，避免出现优先级倒置。但是这是以降低吞吐量为代价的。

2.4 可支持的优先级
    libevent支持在event上设置多个优先级。默认情况下，一个event_base仅有一个优先级。
可以通过函数event_base_priority_init来设置event_base的优先级等级数。

    int event_base_priority_init(structr event_base *base, int n_priorities);  # 该函数成功时返回0，失败是返回-1。
第二个参数表示可支持的优先级，至少为1。调用该函数之后，新的events的优先级等级就是从0(最高)到n_priorities-1(最低)。
　　常数EVENT_MAX_PRIORITIE，是n_priorities的值的上限。如果使用比该常数还要大的数调用该函数，就会发生错误。
    int event_base_get_npriorities(struct event_base *base); # 可以得到当前event_base所支持的优先级等级个数。
    默认情况下，所有关联到event_base的events的初始优先级都是n_priorities/2。
# 注意，必须在任何events变为激活时调用该函数。最好是创建event_base之后就立即调用它。
    
3. 检测event_base的后端方法
const char **event_get_supported_methods(void); # 数组最后一个元素为NULL。
    event_get_supported_methods()返回一个指向数组的指针。该数组包含所有当前libevent所支持的后端方法的名字，

const char *event_base_get_method(conststruct event_base *base);                 # event_base实际使用的后端方法名称
enum event_method_featureevent_base_get_features(const struct event_base *base); # 支持的特性的掩码组合

4. 释放event_base
当一个event_base完成任务的时候，就可以调用event_base_free释放它。
void event_base_free(struct event_base *base);
# 注意，该函数并不释放任何与event_base所关联的events，也不会关闭sockets，更不会释放他们的指针。

5. fork之后，重新初始化event_base
    并不是所有event后端，在fork之后都能正确工作。所以，如果你的程序使用fork(或其他系统调用)
开始一个新进程，如果在fork之后，还想继续使用event_base，那么需要对其进行重新初始化。
int event_reinit(structevent_base *base); # 该方法在成功是返回0，失败是返回-1.
}

event_loop_dispatch(注册回调){
1. 运行loop
一旦一些events在event_base注册之后，就可以使libevent等待events，并且在events准备好时能够通知你。
int event_base_loop (struct event_base *base, int flags);
int event_base_dispatch (struct event_base *base);
# 默认情况下，event_base_loop()会在event_base上一直运行，直到其上已经没有注册的events了 或者event_base_loopexit() | event_base_loopbreak() 被调用。
    运行loop时，它会重复检查那些已经注册的events是否触发了(比如，一个读event的文件描述符变得可读，
或者后一个超时event已经超时)。一旦触发，该函数会将这些触发的events标记为active，并且开始运行回调函数。
　　参数flags可以用来修改默认行为，有以下掩码值：
1.1 EVLOOP_ONCE：            loop将会一直等待，直到一些events变为active，然后运行这些激活的events的回调函数，直到运行完所有激活的events为止，最后函数返回。
1.2 EVLOOP_NONBLOCK：        不会等待events变为触发，它仅仅检查是否有事件准备好了，然后运行他们的回调函数，最后函数返回。
1.3 EVLOOP_NO_EXIT_ON_EMPTY: loop只有在没有pending或active状态的events时，才会退出. event_base_loopexit() | event_base_loopbreak()
1.4 默认模式:                没有active和pending注册事件组后就退出。

event_base_loop函数 = 0表示正常退出，
                    = -1表示后端方法发生了错误。
                    = 1表示已经没有pending或active状态的events了。

2. 停止loop
int event_base_loopexit (struct event_base *base, const struct timeval *tv); # 成功是返回0， 失败时返回-1。
int event_base_loopbreak (struct event_base *base);                          # 成功是返回0， 失败时返回-1。
    第一个函数要求event_base在指定时间后立即停止，如果tv为NULL，则立即停止。
但这个函数实际上会使得event_base在执行完全部的callback之后才返回。
　　第二个函数的不同之处是使event_base在执行完当前的callback之后，无视其他active事件而立即停止。但需要注意的是，
如果当前没有callback，这会导致event_base等到执行完下一个callback之后才退出。
int event_base_got_exit (struct event_base *base);  # 成功返回True，失败返回False
int event_base_got_break (struct event_base *base)  # 成功返回True，失败返回False
用来判断是否获得了exit或者是break请求。注意返回值实际上应该是BOOL而不是int
# 注意，当event loop没有运行时，event_base_loopexit(base, NULL)和 event_base_loopbreak(base)的行为是不同的：
loopexit使下一轮event loop在下一轮回调运行之后立即停止（就像设置了EVLOOP_ONCE一样），
而loopbreak仅仅停止当前loop的运行，而且在event loop未运行时没有任何效果。

3. 重新检查events
    一般情况下，libevent会检查events，然后从高优先级的激活events开始运行，然后再次检查events。
# 有时，你可能希望在运行完当前运行的回调函数之后，告知libevent重新检查events。与event_base_loopbreak()
类似，这可以通过调用event_base_loopcontinue()实现。
    int event_base_loopcontinue(struct event_base *); # 成功返回0。失败返回-1
    如果当前没有运行events的回调函数的话，则该函数没有任何效果。
    
4. 检查event_loop内部的时间
int event_base_gettimeofday_cached (struct event_base *base, struct timeval *tv);  # 成功返回0。失败返回负数
int event_base_update_cache_time (struct event_base *base); # 成功返回0。失败返回-1
    获得event_loop时间。第一个函数获得event_loop最近的时间，比较快，但是不精确。
第二个函数可以强制event_loop立即同步更新时间。

5. 转储event_base状态
    void event_base_dump_events(struct event_base *base, FILE *f);
    为了调试程序的方便，有时会需要得到所有关联到event_base的events的列表以及他们的状态。
调用event_base_dump_events()可以将该列表输出到文件f中。
    得到的列表格式是人可读的形式，将来版本的libevent可能会改变其格式。

6. event_base中的每个event运行同一个回调函数
typedef int (*event_base_foreach_event_cb)(const struct event_base *, const structevent *, void *); # 0继续，非0停止
int event_base_foreach_event(struct event_base *base,
                            event_base_foreach_event_cb fn,
                             void *arg); # 0 遍历了所有event. 非0 如果loop已经退出
    # initialized 和 actived 状态事件变量过程被回调。
    调用函数event_base_foreach_event()，遍历运行与event_base关联的每一个active或pending的event。每一个
event都会运行一次所提供的回调函数，运行顺序是未指定的。event_base_foreach_event()函数的第三个参数将会传递
给回调函数的第三个参数。
    # 回调函数必须返回0，才能继续执行遍历。否则会停止遍历。回调函数最终的返回值，就是event_base_foreach_function函数的返回值。
    回调函数不可修改它接收到的events参数，也不能为event_base添加或删除events，或修改关联到event_base上
的任何events。否则将会发生未定义的行为，甚至是崩溃。
    在调用event_base_foreach_event期间，event_base的锁会被锁住。这样就会阻止其他线程使用该event_base，
因而需要保证提供的回调函数不会运行太长时间。
}

event_new(), 
event_free(), 
event_assign(), 
event_get_assignment(),
event_add(), 
event_del(), 
event_active(), 
event_pending(),
event_get_fd(), event_get_base(), event_get_events(),event_get_callback(), event_get_callback_arg(),
event_priority_set()
https://www.monkey.org/~provos/libevent/doxygen-2.0.1/include_2event2_2event_8h.html
event(含义及操作集){
    struct event对象与event_base、事件、回调函数关联到了一起
    通过这个struct event对象，就可以知道什么事件发生时，才执行什么动作。
    关键函数在于event_new， 它把事件、event_base、回调函数关联到一起了。
    
1. libevent的基本处理单元是event，每个event代表一组条件：
    文件描述符已经准备好读或写
    文件描述符正在变为就绪，准备好读或写(仅限于边沿触发)
    超时事件
    信号发生
    用户触发事件
1.1 当一个event被设置好，并且关联到一个event_base里面时，它被称为"initialized"。
1.2 此时你可以执行add，这使得它进入pending状态。
1.3 在pending状态下，当event被触发或超时时，它的状态称为active，这个情况下对应的callback会被调用。
1.4 如果event被配置为persist，那么它在callback执行前后都会保持pending状态。
1.5 如果event未被配置为persist，那么它在callback执行后，不再保持pending状态。
1.6 可以通过del操作，将一个pending状态的event变为non-pending状态(non-pending)，
1.7 可以通过add操作，将non-pending的event变为pending状态。

2. 分配并且创建一个event对象
typedef void (*event_callback_fn) (evutil_socket_t fd, short what, void *arg);
struct event *event_new (struct event_base *base,
                         evutil_socket_t    fd,
                         short              what,
                         event_callback_fn  cb,
                         void              *arg); # 如果发生了内部错误，或者参数非法，则event_new返回NULL。
void event_free (struct event *event);
    event_new() 函数分配并且创建一个新的event对象，并与base进行关联。what参数是下面列出标志的集合。
如果fd是非负的整数，则它代表了我们需要观察可读或可写事件的文件。当event变为激活时，libevent就会调用
回调函数cb，将文件描述符参数fd，所有触发事件的标志位域，以及event_new的最后一个参数：arg传递个cb。
    event_free()释放event的资源。如果event是active或者是pending状态，则函数会将event先变成非active
且非pending的状态，然后再释放它。
　　参数what表示这个event的需要关注绑定在该fd上的哪些事件。有以下几个掩码值：
    EV_TIMEOUT：超时时间过后，该event变为"激活"状态。
                在构建event时，EV_TIMEOUT标志是被忽略的：当add event时可以设置超时时间，也可以不设置。
                当超时发生时，回调函数的what参数将会设置该标志。
    EV_READ：   当文件描述符准备好读时，event将会变为"激活"。
    EV_WRITE：  当文件描述符准备好写时，event将会变为"激活"。
    EV_SIGNAL： 用来实现信号探测，参见下面的"构造信号事件"。
    EV_PERSIST：标志该event具有"持久"属性，参见下面的"事件持久性" # 要么是因为fd准备好读或写，要么是超时时间到
    EV_ET：     如果event_base的底层方法支持"边沿触发"的话，那么该event应该是边沿触发的。这将会影响到EV_READ和EV_WRITE

    所有新的events都是"已初始化"和"非挂起"状态，可以调用event_add函数将这样的event变为"挂起"状态。
    调用event_free可以销毁event。对"挂起"或"激活"状态的event调用event_free也是安全的：在销毁它之前，
会将其变为"非挂起"以及"非激活"状态。
    
    同一时刻，针对同一个文件描述符，可以有任意数量的event在同样的条件上"挂起"。比如，
当给定的fd变为可读时，可以使两个events都变为激活状态。但是他们的回调函数的调用顺序是未定义的。
    
EV_PERSIST说明：
    默认情况下，当一个"挂起"的event变为"激活"时(要么是因为fd准备好读或写，要么是超时时间到)，
那么在它的回调函数执行之前，它就会变为"非挂起"状态。因此，如果希望再次使event变为"挂起"状态，
可以在回调函数内部再次调用event_add函数。
    如果event设置了EV_PERSIST标志，那么event就是"持久"的。这意味着event在回调函数激活的时候，
依然保持"挂起"状态。如果希望在回调函数中将event变为"非挂起"状态，则可以调用event_del函数。
    当event的回调函数运行时，"持久"的event的超时时间就会被重置。因此，如果某个event标志为
EV_READ|EV_PERSIST，并且将超时时间设置为5秒，则该event在下面的条件发生时，会变为"激活"：
2.1 当该socket准备好读时；
2.2 距离上次event变为激活状态后，又过了5秒钟。

3. 创建一个可以将自身作为回调函数参数的的event
    经常可能会希望创建这样一个event，event本身就是回调函数的参数之一。不能仅仅传递一个指向event的指针作为
event_new的参数，因为彼时它还没有创建。此时，可以通过调用event_self_cbarg函数解决这样的问题。
    void* event_self_cbarg();
    event_self_cbarg()返回一个"魔术"指针，使得event_new创建一个本身就能作为回调函数参数的event。
    event_self_cbarg()还可以与函数event_new,evtimer_new, evsignal_new,event_assign, evtimer_assign和
evsignal_assign一起使用。然而对于非event来说，他不会作为回调函数的参数。

4. 纯超时events
    方便起见，libevent提供了一系列以evtimer_开头的宏，这些宏可以代替event_*函数，来分配和操作纯超时events。
使用这些宏仅能提高代码的清晰度而已。
#define evtimer_new(base,  callback,  arg)   event_new((base), -1, 0, (callback), (arg))
        evtimer_new(base,  cb,  NULL);
#define evtimer_add(ev,  tv)                 event_add((ev),(tv))
#define evtimer_del(ev)                      event_del(ev)
#define evtimer_pending(ev,  tv_out)         event_pending((ev), EV_TIMEOUT, (tv_out))

5. 构造信号事件
    libevent也可以监控POSIX类的信号。构建一个信号处理函数，可以使用下面的接口：
#define evsignal_new(base,  signum,  cb,  arg)\
    event_new(base,  signum,  EV_SIGNALEV_SIGNAL|EV_PERSIST,  cb,  arg)
除了提供一个代表信号值的整数，而不是一个文件描述符之外。它的参数与event_new是一样的。
    struct event * hup_event;
    struct event_base  *base = event_base_new();
    /*call sighup_function on a HUP signal */
    hup_event= evsignal_new(base,  SIGHUP,  sighup_function,  NULL);

对于信号event，同样有一些方便的宏可以使用：
#define evsignal_add(ev,  tv)                 event_add((ev), (tv))
#define evsignal_del(ev)                      event_del(ev)
#define evsignal_pending(ev,  what,  tv_out)  event_pending((ev), (what), (tv_out))

# 注意：信号回调函数是在信号发生之后，在eventloop中调用的。所以，它们可以调用那些，
#       对于普通POSIX信号处理函数来说不是信号安全的函数。
# 注意：不要在一个信号event上设置超时，不支持这样做。
    警告：当前版本的libevent，对于大多数的后端方法来说，同一时间，每个进程仅能有一个event_base
可以用来监听信号。如果一次向两个event_base添加event，即使是不同的信号，也仅仅会只有一个
event_base可以接收到信号。对于kqueue来说，不存在这样的限制。

6. 不在堆中分配event
出于性能或者其他原因的考虑，一些人喜欢将event作为一个大的结构体的一部分进行分配。对于这样的event，它节省了：
    6.1 内存分配器在堆上分配小对象的开销；
    6.2 event指针的解引用的时间开销；
    6.3 如果event没有在缓存中，缓存不命中的时间开销。
这种方法的风险在于，与其他版本的libevent之间不满足二进制兼容性，他们可能具有不同的event大小。
    这些开销都非常小，对于大多数应用来说是无关紧要的。除非确定知道，应用程序因为使用堆分配的event而
存在严重的性能损失，否则应该坚持实用event_new。如果后续版本的libevent使用比当前libevent更大的event结构，
那么使用event_assign有可能会导致难以诊断的错误。
int event_assign(struct  event * event, struct  event_base * base,
                  evutil_socket_t fd,  short  what,
                  void(*callback)(evutil_socket_t,  short,  void *),  void * arg); # 该函数成功时返回0，失败时返回-1.
event_assign的参数与event_new相同，除了event参数，该参数指针必须指向一个未初始化的event。
    警告：
    1. 对于已经在event_base中处于"挂起"状态的event，永远不要调用event_assign。这样做会导致极为难以诊断的错误。
    2. 如果event已经初始化，并且处于"挂起"状态，那么在调用event_assign之前应该先调用event_del。
    
    对于使用event_assign分配的纯超时event或者信号event，同样有方便的宏可以使用：
#define evtimer_assign(event,  base,  callback, arg) \
        event_assign(event, base,  -1,  0,  callback,  arg)
#define evsignal_assign(event,  base,  signum, callback,  arg) \
        event_assign(event, base,  signum,  EV_SIGNAL|EV_PERSIST,  callback,  arg)
    
    size_t event_get_struct_event_size(void);
    该函数返回需要为event结构预留的字节数。再次提醒，只有在确定堆分配导致很明显的性能问题时，
才应该使用该函数，因为它使你的代码难读又难写。
    注意，将来版本的event_get_struct_event_size()的返回值可能比sizeof(structevent)小，这意味着
event结构的末尾的额外字节仅仅是保留用于未来版本的libevent的填充字节。
    
7. 使事件进入pending和non-pending
7.1 int event_add(struct event *ev, const struct timeval *tv);  # 函数返回0表示成功，返回-1表示失败。
    在"非挂起"状态的events上执行event_add操作，则会使得该event在配置的event_base上变为"挂起"状态。
该函数返回0表示成功，返回-1表示失败。如果tv为NULL，则该event没有超时时间。否则，tv以秒和毫妙表示超时时间。
    如果在已经是"挂起"状态的event进行event_add操作，则会保持其"挂起"状态， # 并且会重置其超时时间。
如果event已经是"挂起"状态，而且以NULL为超时时间对其进行re-add操作，则event_add没有任何作用。
    注意：不要设置tv为希望超时事件执行的时间，比如如果置tv->tv_sec=time(NULL)+10，
并且当前时间为2010/01/01，则超时时间为40年之后，而不是10秒之后。

7.2 int event_del(struct event *ev);  # 该函数返回0表示成功，返回-1表示失败。
    在已经初始化状态的event上调用event_del，则会将其状态变为"非挂起"以及"非激活"状态。如果event的当前状态
不是"挂起"或"激活"状态，则该函数没有任何作用。
    注意，如果在event刚变为"激活"状态，但是它的回调函数还没有执行时，调用event_del函数，则该操作使得它的
回调函数不会执行。

7.3 int event_remove_timer(struct event *ev); # 该函数返回0表示成功，-1表示失败。
    可以在不删除event上的IO事件或信号事件的情况下，删除一个"挂起"状态的event上的超时事件。
如果该event没有超时事件，则event_remove_timer没有作用。
如果event没有IO事件或信号事件，只有超时事件的话，则event_remove_timer等同于event_del。
    
8. 使用优先级的事件
    当多个事件在同一时间触发时，libevent对于他们回调函数的调用顺序是没有定义的。
可以通过优先级，定义某些"更重要"的events。
    每一个event_base都有一个或多个优先级的值。在event初始化之后，添加到event_base之前，
可以设置该event的优先级。
    int event_priority_set (struct event *event, int priority);  # 该函数返回0表示成功，返回-1表示失败。
event的优先级数必须是位于0到"event_base优先级"-1这个区间内。
    当具有多种优先级的多个events同时激活的时候，低优先级的events不会运行。libevent会只运行高优先级的events，
然后重新检查events。只有当没有高优先级的events激活时，才会运行低优先级的events。
    如果没有设置一个event的优先级，则它的默认优先级是"event_base队列长度"除以2。该函数在文件<event2/event.h>中声明。

9. 观察event状态
    有时可能希望知道event是否已经添加了(处于"挂起"状态)，或者检查他关联到哪个event_base等。
int event_pending(const struct event *ev, short what, struct timeval *tv_out);
    event_pending函数检查给定的event是否处于"挂起"或"激活"状态。如果确实如此，并且在what参数中设置了任何
EV_READ, EV_WRITE, EV_SIGNAL或EV_TIMEOUT标志的话， # 则该函数返回所有该event当前正在"挂起"或"激活"的标志。
    如果提供了tv_out参数，且在what参数中设置了EV_TIMEOUT参数，并且当前event确实在超时事件上"挂起"或者"激活"，
则tv_out就会设置为event的超时时间。
         
#define event_get_signal(ev) /* ... */
evutil_socket_t event_get_fd(const  struct  event *ev);
event_get_fd和event_get_signal函数返回event上配置的文件描述符或者信号值。

struct event_base *event_get_base(const  struct event  *ev);
event_get_base()返回其配置的event_base。

short event_get_events (const struct event *ev);
event_get_events() 返回event上配置的事件标志(EV_READ,EV_WRITE等)。

event_callback_fn event_get_callback (const struct event *ev);
void *event_get_callback_arg (const struct event *ev);
event_get_callback函数和event_get_callback_arg函数返回event的回调函数和参数指针。

int event_get_priority(const struct event *ev);
event_get_priority函数返回event的当前优先级。

void event_get_assigement(const struct event  *event,
                           struct event_base  **base_out,
                           evutil_short_t      *fd_out,
                           short               *events_out,
                           event_callback_fn   *callback_out,
                           void                *arg_out);
event_get_assignment函数在提供的参数指针中返回event的所有成分，如果参数指针为NULL，则该成分被忽略。

10. 寻找当前运行中event # 在调试程序时，可以得到当前正在运行的event的指针。
    struct event *event_base_get_running_event (struct event_base *base); 
    注意这个函数只支持在event的loop中调用，在其它线程调用的话是不支持的，而且会导致未定义的行为。

11. 配置一次性的events
    如果不需要对一个event进行多次添加，或者对一个非持久的event，在add之后就会delete，则可以使用event_base_once函数。
int event_base_once(struct event_base *base,
                     evutil_socket_t    fd,
                     short              what,
                     event_callback_fn  cb,
                     void              *arg,
                     const struct timeval *tv); # 该函数成功时返回0，失败是返回-1.

    event_base_once的参数与event_new一样，不同的是它不支持EV_SIGNAL或EV_PERSIST标志。
得到的内部event会以默认的优先级添加到event_base中并运行。当它的回调函数执行完成之后，
libevent将会释放该内部event。
    通过event_base_once插入的event不能被删除或者手动激活。如果希望可以取消一个event，
则需要通过常规的event_new或event_assign接口创建event。
    注意：如果它们的回调函数的参数具有关联的内存，那么除非程序中进行释放，否则这些内存永远不会被释放。

12. 手动激活event
    某些极少的情况下，你可能希望在条件未被触发的情况下就激活event；
    void event_active (struct event *ev, int what, short ncalls);
    # 该接口使得event变为"激活"状态，激活标志在what中传入(EV_READ, EV_WRITE和EV_TIMEOUT的组合)。
# 该event之前的状态不一定非得要是"挂起"状态，而且将其激活不会使其状态变为"挂起"状态。
    警告：在同一个event上递归调用event_active可能会导致资源耗尽。
    
13. 优化一般性超时
    当前版本的libevent使用二叉堆算法来对"挂起"状态的event超时时间值进行跟踪。对于有序的添加和删除event
超时时间的操作，二叉堆算法可以提供O(lg n)的性能。这对于添加随机分布的超时时间来说，性能是最优的，但是如果是
大量相同时间的events来说就不是了。
    比如，假设有一万个事件，每一个event的超时时间都是在他们被添加之后的5秒钟。在这种情况下，
使用双向队列实现的话，可以达到O(1)的性能。
    正常情况下，一般不希望使用队列管理所有的超时时间值，因为队列仅对于恒定的超时时间来说是快速的。如果一
些超时时间或多或少的随机分布的话，那添加这些超时时间到队列将会花费O(n)的时间，这样的性能要比二叉堆差多了。
    libevent解决这种问题的方法是将一些超时时间值放置在队列中，其他的则放入二叉堆中。可以向libevent请求一
个"公用超时时间"的时间值，然后使用该时间值进行事件的添加。如果存在大量的event，它们的超时时间都是这种单
一公用超时时间的情况，那么使用这种优化的方法可以明显提高超时事件的性能。
const struct  timeval * event_base_init_common_timeout(
     struct event_base *base,  const  struct  timeval* duration);
    该方法的参数有event_base，以及一个用来初始化的公用超时时间值。该函数返回一个指向特殊timeval结构体的指针，
可以使用该指针表明将event添加到O(1)的队列中，而不是O(lg n)的堆中。这个特殊的timeval结构可以在代码中自由的复制和分配。
该timeval只能工作在特定的event_base上(参数)。不要依赖于该timeval的实际值：libevent仅使用它们来指明使用哪个队列。

14. 从已清除的内存识别事件
    libevent提供了这样的函数，可以从已经清0的内存中(比如以calloc分配，或者通过memset或bzero清除)识别出已初始化的event。
    int  event_initialized(const  struct  event*ev);  # 已init等于1， 否则等于0
#define evsignal_initialized(ev)  event_initialized(ev)
#define evtimer_initialized(ev)  event_initialized(ev)
    警告：这些函数不能在一块未初始化的内存中识别出已经初始化了的event。除非你能确定该内存要么被清0，
要么被初始化为event，否则不要使用这些函数。
#     一般情况下，除非你的应用程序有着极为特殊的需求，否则不要轻易使用这些函数。通过event_new返回的
# events永远已经初始化过的。

15. 过时的event处理函数
    libevent2.0之前的版本中，没有event_assign或者event_new函数，而只有event_set函数，该函数返回的event与
"当前"base相关联。如果有多个event_base，则还需要调用event_base_set函数指明event与哪个base相关联。
void  event_set(struct  event  *event, evutil_socket_t  fd,  short what,
        void(*callback)(evutil_socket_t,  short,  void *),  void *arg);
int  event_base_set(struct  event_base * base,  struct  event *event);
    event_set函数类似于event_assign，除了它使用"当前"base的概念。event_base_set函数改变event所关联的base。
    如果是处理超时或者信号events，event_set也有一些便于使用的变种：evtimer_set类似于evtimer_assign，
而evsignal_set类似于evsignal_assign。
}

evutil_socket_t(辅助函数以及类型:与linux的int兼容+各种兼容性类型){ 
1. socket的抽象。除了Windows之外，其他系统都是一个int类型。如果考虑Windows的兼容性的话，建议用这个类型。
其他一些类型

2. ev_ssize_t
    在那些具有ssize_t的类型的平台上，ev_ssize_t就被定义为ssize_t（signedsize_t），对于没有这种类型的平台，
ev_ssize_t会被定义为合理的默认值。ev_ssize_t类型可能的最大值是EV_SSIZE_MAX；最小值为EV_SSIZE_MIN。

3. ev_off_t
    ev_off_t类型用来表示一个文件或一段内存中的偏移值。在那些具有合理的off_t类型定义的系统上，
ev_off_t被定义为off_t，在Windows上被定义为ev_int4_t。

4. ev_socklen_t
    某些socket API的实现提供了长度类型socklen_t，而某些却没有提供。在那些提供该类型的平台上，
ev_uintptr_t就被定义为socklen_t，而那些没有定义的平台，ev_socklen_t被定义为一个合理的默认值。

5. ev_intptr_t
    ev_intptr_t类型是一个，具有足够大的空间来保存一个指针而不会丢失位的有符号整数类型。
ev_uintptr_t类型是一个，具有足够大的空间来保存一个指针而不会丢失位的无符号整数类型。

}

socket(辅助函数以及类型:Socket API兼容性){
1. 由于历史原因，Windows从未真正的以良好的兼容性实现伯克利Socket API。下面的函数可以规避这种情况：
int  evutil_closesocket(evutil_socket_t  s);
#define EVUTIL_CLOSESOCKET(s)  evutil_closesocket(s)

2. 
#define EVUTIL_SOCKET_ERROR()
#define EVUTIL_SET_SOCKET_ERROR(errcode)
#define evutil_socket_geterror(sock)
#define evutil_socket_error_to_string(errcode)
这些宏访问并操作socket错误码。EVUTIL_SOCKET_ERROR返回本线程最近一次的socket操作的全局错误码。
evutil_socket_geterror针对某个特定socket做同样的事。(在类Unix系统上，全局错误码就是errno)。
    EVUTIL_SET_SOCKET_ERROR改变当前的socket错误码(类似于在Unix上设置errno)，
evutil_socket_error_to_string返回给定错误码的字符串描述。(类似于Unix上的strerror)
(之所以需要这些函数，是因为Windows没有为socket函数的错误定义errno，而是使用函数WSAGetLastError)
    注意：在windows上，套接字错误码与标准C错误码errno是不同的。

evutil_socket_t listener = socket(AF_INET, SOCK_STREAM, 0);  # evutil_socket_t即int类型

evutil_socket_t Win下与 SOCKET 类型相同，Linux下与 int 类型相同

# if (evutil_socketpair(AF_UNIX, SOCK_STREAM, 0, pair) == -1)
int evutil_socketpair(int d, int type, int protocol, evutil_socket_t sv[2]);
# 成功返回0； 否则返回-1；
int evutil_make_socket_nonblocking(evutil_socket_t sock);  # 在Unix上，置为O_NONBLOCK，在Windows上置为FIONBIO。
# 成功返回0； 否则返回-1；
int evutil_make_listen_socket_reuseable(evutil_socket_t sock);  # 在Unix上，是设置SO_REUSEADDR，而在Windows上，该标志却有其他意义。
# 成功返回0； 否则返回-1；
int evutil_make_listen_socket_reuseable_port(evutil_socket_t sock); 
# 成功返回0； 否则返回-1；
int evutil_make_socket_closeonexec(evutil_socket_t sock);  # 在Unix上是设置FD_CLOEXEC 标志，而在Windows上什么也不做。
# 成功返回0； 否则返回-1；
int evutil_make_tcp_listen_socket_deferred(evutil_socket_t sock);  TCP_DEFER_ACCEPT
# 成功返回0； 否则返回-1；
}

timeval(辅助函数以及类型:可移植的定时器函数){
计算timeval数据加减的宏，vvp = tvp +/- uvp。注意三者都要使用指针
#define evutili_timer_add(tvp, uvp, vvp)
#define evutili_timer_sub(tvp, uvp, vvp)

将timeval清零，或者判断是否被清零
#define evutil_timerclear(tvp)
#define evutil_timerisset(tvp)
evutil_timerclear将一个timeval清空是将其值置为0。
evutil_timerisset检查timeval，如果timeval的值为非0，则该宏返回true，否则返回false。

#define evutil_timercmp(tvp, uvp, cmp)
判断timeval的先后，其中cmp是比较，比如==, <=, >=, <, >, !=

int evutil_gettimeofday(struct timeval *tv, struct timezone *tz); # 成功返回0； 否则返回-1；
evutil_gettimeofday函数设置tv为当前时间，参数tz无用。
}

socket(Socket相关的函数){
#define evutil_socket_geterror (sock)
#define evutil_socket_error_to_string (errcode)

获得指定socket的error code，以及转为可读的string
int evutil_make_socket_nonblocking (evutil_sopcket_t sock);
将一个socket非阻塞。
}

string(可移植的字符串操作函数){

ev_int64_t evutil_strtoll (const char *s, char **endptr, int base); # 该函数类似于strtol，但是可以处理64位整数。在某些平台上，它仅支持十进制。
int evutil_snprintf(char *but, size_t buflen, const char *format, ...); # 返回格式化buff长度
int evutil_vsnprintf(char *bug, size_t buflen, const char *format, va_list ap); # 返回格式化buff长度

2. 区域无关的字符串处理函数
int evutil_ascii_strcasecmp(const char *str1, const char *str2);
int evutil_ascii_strncasecmp(const char *str1, const char *str2, size_t n);
}

addr_port_present(辅助函数: 地址接口表示转换){
const char *evutil_inet_ntop(int af, const void *src, char *dst, size_t len); # 失败时返回NULL，成功时返回指向dst的指针。
int evutil_inet_pton(int af, const char *src, void *dst); # 函数成功时返回1，失败是返回0。
这些函数类似于标准的inet_ntop和inet_pton函数，根据RFC3493中的规定，解析和格式化IPv4和IPv6地址。

int evutil_parse_sockaddr_port(const char *str, struct sockaddr *out, int *outlen); # 成功时返回0，失败是返回-1
解析str中的字符串地址，并将结果写入到out中。outlen是一个值-结果参数，入参时指向一个out长度的整数，返回时变为实际使用的字节数。
- [ipv6]:port (as in "[ffff::]:80")
- ipv6 (as in "ffff::")
- [ipv6] (as in "[ffff::]")
- ipv4:port (as in "1.2.3.4:80")
- ipv4 (as in "1.2.3.4")
如果没有给定port，则在sockaddr的结果中，port被置为0.

int evutil_sockaddr_cmp(const struct sockaddr *sa1, const struct sockaddr *sa2, int include_port); 
如果sa1在sa2前面，则返回负数，
如果它们相等就返回0，
如果sa2在sa1前面，就返回正数。

如果include_port置为false，那么如果两个sockaddrs仅在port不同的情况下，该函数将他们视为相同的。否则，
如果include_port置为true，则会视为不同的。
}

evutil_offsetof(辅助函数: 结构体可移植函数){
#define evutil_offsetof (type, field)
类似于标准的offsetof宏，该宏返回field域在type中的偏移字节。
}

evutil_random(){
很多应用都需要一个难以预测的随机数源来保证它们的安全性。
void  evutil_secure_rng_get_bytes(void * buf,  size_t  n);
    该接口将n个字节的随机数据填充到buf中。如果平台提供了arc4random函数，则libevent会使用该函数。
否则的话，libevent使用自己实现的arc4random函数。种子则来自操作系统的熵池(entropy pool)
(Windows中的CryptGenRandom，其他平台中的/dev/urandom)

int  evutil_secure_rng_init(void);
void  evutil_secure_rng_add_bytes(const  char * dat,  size_t  datlen);
一般不需要手动初始化安全随机数生成器，但是如果需要保证它确实成功的初始化，可以调用evutil_secure_rng_init()函数。
它会seed RNG(随机数生成器)(如果还没有seed过)，并且在成功时返回0。如果返回-1，表明libevent无法在系统上找到好的
熵源，而且在没有自己初始化时，不能安全的使用RNG。

如果程序运行在可能会放弃权限的环境中(比如说，通过执行chroot())，在放弃权限前应该调用evutil_secure_rng_init()。
可以调用evutil_secure_rng_add_bytes()向熵池加入更多随机字节，但通常不需要这么做。
}

evutil_addrinfo(域名转换为IP地址){
int evutil_getaddrinfo(const char *nodename, const char *servname,
    const struct evutil_addrinfo *hints_in, struct evutil_addrinfo **res); # 成功返回0，否则返回非0
void evutil_freeaddrinfo(struct evutil_addrinfo *ai)
const char *evutil_gai_strerror(int err);
}
evutil_monotonic_timer(结构管理){
evutil_date_rfc1123(char *date, const size_t datelen, const struct tm *tm);
struct evutil_monotonic_timer * evutil_monotonic_timer_new(void);
void evutil_monotonic_timer_free(struct evutil_monotonic_timer *timer);
int evutil_configure_monotonic_time(struct evutil_monotonic_timer *timer, int flags);
int evutil_gettime_monotonic(struct evutil_monotonic_timer *timer, struct timeval *tp);

}
evutil(辅助函数以及类型: 标准整数类型){
ev_uint64_t,  ev_uint32_t, ev_uint16_t, ev_uint8_t
ev_int64_t,   ev_int32_t,  ev_int16_t,  ev_int8_t
ev_uintptr_t, ev_intptr_t
ev_ssize_t
ev_off_t

1. 内部性
evutil_socket_(int domain, int type, int protocol) 
}

https://www.monkey.org/~provos/libevent/doxygen-2.0.1/bufferevent_8h.html
bufferevent(基本概念){
    很多时候，应用程序除了能响应事件之外，还希望能够处理一定量的数据缓存。比如，当写数据的时候，一般会经历下列步骤:
1. 决定向一个链接中写入一些数据；
2. 将数据放入缓冲区中；
3. 告知select|poll|epoll期望进行写数据
4. 等待该链接变得可写；
5. 写入尽可能多的数据；
6. 记住写入的数据量，如果还有数据需要写入，则需要：再次告知select|poll|epoll期望进行写数据。

    这种IO缓冲模式很常见，因此libevent为此提供了一种通用机制。bufferevent由一个底层传输系统(比如socket)，
一个读缓冲区和一个写缓冲区组成。
普通的events在底层传输系统准备好读或写的时候就调用回调函数。
bufferevent 在已经写入或者读出数据之后才调用回调函数。
    
总结：将对系统IO的收发数据读写操作与对缓冲区内数据的读写操作绑定，将读写缓冲区操作抽象成特定的接口，
使得对系统IO的读写操作转换成回调函数内对缓冲区数据的读写操作。
    
libevent有多种bufferevent，它们共享通用的接口。截至本文撰写时，有下列bufferevent类型：
1. 基于socket的bufferevents：在底层流式socket上发送和接收数据，使用event_*接口作为其后端。
2. 异步IO的bufferevents：使用WindowsIOCP接口在底层流式socket上发送和接收数据的bufferevent.(仅限于Windows，实验性的)
3. 过滤型bufferevent：在数据传送到底层bufferevent对象之前，对到来和外出的数据进行前期处理的bufferevent，比如对数据进行压缩或者转换
4. 成对的bufferevent：两个相互传送数据的bufferevent
    还要注意：bufferevent目前仅能工作在流式协议上，比如TCP。未来可能会支持数据报协议，比如UDP。

1. bufferevent和evbuffers
    每一个bufferevent都有一个输入缓冲区和一个输出缓冲区。它们的类型都是"struct evbuffer"。
  如果bufferevent上有数据输出，则需要将数据写入到输出缓冲区中，
  如果bufferevent上有数据需要读取，则需要从输入缓冲区中进行抽取。
    evbuffer接口支持很多操作，会在以后的章节中进行讨论。
    
2. 回调函数和"水位线"
    每一个bufferevent都有两个数据相关的回调函数：读回调函数和写回调函数。默认情况下，当从底层传输系统读取
到任何数据的时候会调用读回调函数；当写缓冲区中足够多的数据已经写入到底层传输系统时，会调用写回调函数。通过
调整bufferevent的读取和写入"水位线"(watermarks)，可以改变这些函数的默认行为。
    每个bufferevent都有4个水位线：
    1. 读低水位线：当bufferevent的输入缓冲区的数据量到达该水位线或者更高时，bufferevent的读回调函数就会被调用。
该水位线默认为0，所以每一次读取操作都会导致读回调函数被调用。
    2. 读高水位线：如果bufferevent的输入缓冲区的数据量到达该水位线时，那么bufferevent就会停止读取，直到输入
缓冲区中足够多的数据被抽走，从而数据量再次低于该水位线。默认情况下该水位线是无限制的，所以从来不会因为输入
缓冲区的大小而停止读取操作。
    3. 写低水位线：当写操作使得输出缓冲区的数据量达到或者低于该水位线时，才调用写回调函数。默认情况下，该值为0，
所以输出缓冲区被清空时才调用写回调函数。
    4. 写高水位线：并非由bufferevent直接使用，对于bufferevent作为其他bufferevent底层传输系统的时候，该水位线
才有特殊意义。所以可以参考后面的过滤型bufferevent。
# 读低水位线：高于读低水位线开始读回调；
# 读高水位线：高于读高水位线停止读调用；
# 写低水位线：高于写低水位线开始写回调；
# 写高水位线：高于写高水位线停止写回调；

bufferevent同样具有"错误"或者"事件"回调函数，用来通知应用程序关于非数据引起的事件，比如关闭连接或者发生错误。
定义了下面的event标志：
    BEV_EVENT_READING：  读操作期间发生了事件。具体哪个事件参见其他标志。
    BEV_EVENT_WRITING：  写操作期间发生了事件。具体哪个事件参见其他标志。
    BEV_EVENT_ERROR：    在bufferevent操作期间发生了错误，调用EVUTIL_SOCKET_ERROR函数，可以得到更多的错误信息。
    BEV_EVENT_TIMEOUT：  bufferevent上发生了超时
    BEV_EVENT_EOF：      bufferevent上遇到了EOF标志
    BEV_EVENT_CONNECTED：在bufferevent上请求链接过程已经完成

    EVBUFFER_READ
    EVBUFFER_WRITE
    EVBUFFER_ERROR
    EVBUFFER_TIMEOUT
    EVBUFFER_EOF
    
3. 延迟回调函数
    默认情况下，当相应的条件发生的时候，bufferevent回调函数会立即执行。(evbuffer的回调也是这样的，随后会介绍)
当依赖关系变得复杂的时候，这种立即调用就会有问题。比如一个回调函数用来在evbuffers A变空时将数据移入到该缓冲区，
而另一个回调函数在evbuffer A变满时从其中取出数据进行处理。如果所有这些调用都发生在栈上的话，在依赖关系足够复杂
的时候，有栈溢出的风险。
    为了解决该问题，可以通知bufferevent(以及evbuffer)应该延迟回调函数。当条件发生时，延迟回调函数不是立即调用，
而是在event_loop()调用中被排队，然后在常规的event回调之后执行

4. bufferevent的选项标志
    创建bufferevent时，可以使用下列一个或多个标志来改变其行为，
这些标志有：
    BEV_OPT_CLOSE_ON_FREE：当释放bufferevent时，关闭底层的传输系统。这将关闭底层套接字，释放底层bufferevent等。
    BEV_OPT_THREADSAFE：自动为bufferevent分配锁，从而在多线程中可以安全使用。
    BEV_OPT_DEFER_CALLBACKS：设置该标志，bufferevent会将其所有回调函数进行延迟调用(就像上面描述的那样)
    BEV_OPT_UNLOCK_CALLBACKS：默认情况下，当设置bufferevent为线程安全的时候，任何用户提供的回调函数调用时都会锁住bufferevent的锁。设置该标志可以在提供的回调函数被调用时不锁住bufferevent的锁。

5. 基于socket的bufferevent
    最简单的bufferevents就是基于socket类型的bufferevent。基于socket的bufferevent使用libevent底层event机制探测
底层网络socket何时准备好读和写，而且使用底层网络调用(比如readv，writev，WSASend或WSARecv)进行传送和接受数据。

5.1 创建一个基于socket的bufferevent
可以使用bufferevent_socket_new创建一个基于socket的bufferevent：
struct bufferevent *bufferevent_socket_new(struct event_base *base,
                                           evutil_socket_t fd,
                                           enum bufferevent_options options);
base表示event_base，
options是bufferevent选项的位掩码(BEV_OPT_CLOSE_ON_FREE等)。
fd参数是一个可选的socket文件描述符。

# 如果希望以后再设置socket文件描述符，可以将fd置为-1。
#     提示：要确保提供给bufferevent_socket_new的socket是非阻塞模式。libevent提供了便于使用的
evutil_make_socket_nonblocking来设置非阻塞模式。
# bufferevent_socket_new成功时返回一个bufferevent，失败时返回NULL。

5.2 在基于socket的bufferevent上进行建链
如果一个bufferevent的socket尚未建链，则可以通过下面的函数建立新的连接：
int  bufferevent_socket_connect(struct bufferevent *bev,
                                struct sockaddr *address, int addrlen); # 该函数如果在建链成功时，返回0，如果发生错误，则返回-1.
address和addrlen参数类似于标准的connect函数。
如果该bufferevent尚未设置socket，则调用该函数为该bufferevent会分配一个新的流类型的socket，并且置其为非阻塞的。
如果bufferevent已经设置了一个socket，则调用函数bufferevent_socket_connect会告知libevent该socket尚未建链，
    在建链成功之前，不应该在其上进行读写操作。 # 
# 在建链成功之前，向输出缓冲区添加数据是可以的。
非阻塞情况下，应该就是返回-1啊？

# 注意：如果使用bufferevent_socket_connect进行建链的话，会得到BEV_EVENT_CONNECTED事件。
#       如果自己手动调用connect，则会得到write事件。
      如果在手动调用connect的情况下，仍然想在建链成功的时候得到BEV_EVENT_CONNECTED事件，可以在connect返回-1，
并且errno为EAGAIN或EINPROGRESS之后，调用bufferevent_socket_connect(bev, NULL, 0)函数。
      
3. 通过hostname建链
经常性的，可能希望将解析主机名和建链操作合成一个单独的操作，可以使用下面的接口：
int bufferevent_socket_connect_hostname(struct  bufferevent *bev,
                                        struct evdns_base *dns_base,  
                                        int family, 
                                        const char *hostname,
                                        int port); # 该函数如果在建链成功时，返回0，如果发生错误，则返回-1.
int bufferevent_socket_get_dns_error(struct  bufferevent *bev);
    该函数解析主机名，查找family类型的地址(family的类型可以是AF_INET, AF_INET6和AF_UNSPEC)。
3.1 如果解析主机名失败，会以错误event调用回调函数。
3.2 如果成功了，则会像 bufferevent_connect一样，接着进行建链。
    dns_base参数是可选的。如果该参数为空，则libevent会一直阻塞，等待主机名解析完成，一般情况下不会这么做。
如果提供了该参数，则libevent使用它进行异步的主机名解析。
如果提供 dns_base 参数,libevent将使用它来异步地查询主机
    类似于bufferevent_socket_connect，该函数会告知libevent，bufferevent上已存在的socket尚未建链，在解析完成，
并且建链成功之前，不应该在其上进行读写操作。
    如果发生了错误，有可能是DNS解析错误。可以通过调用函数bufferevent_socket_get_dns_error函数得到最近发生的
错误信息。 # 如果该函数返回的错误码为0，则表明没有检查到任何DNS错误。

4. 一般性的bufferevent操作
4.1：释放bufferevent
    void  bufferevent_free(struct  bufferevent *bev);
    该函数释放bufferevent。bufferevent在内部具有引用计数，所以即使当释放bufferevent时，如果bufferevent还有
未决的延迟回调，那该bufferevent在该回调完成之前也不会删除。
    bufferevent_free函数会尽快释放bufferevent。然而，如果bufferevent的输出缓冲区中尚有残留数据要写，该函数
也不会在释放bufferevent之前对缓冲区进行flush。
    如果设置了BEV_OPT_CLOSE_ON_FREE标志，并且该bufferevent有socket或者其他底层bufferevent作为其传输系统，
则在释放该bufferevent时，会关闭该传输系统。

4.2：回调函数、水位线、使能操作
typedef void (*bufferevent_data_cb)(struct  bufferevent*bev,  void *ctx);
typedef void (*bufferevent_event_cb)(struct  bufferevent*bev, short  events,void *ctx);
void  bufferevent_setcb(struct  bufferevent * bufev,
                        bufferevent_data_cb readcb,
                        bufferevent_data_cb writecb,
                        bufferevent_event_cb eventcb,
                        void *cbarg);
void  bufferevent_getcb(struct  bufferevent * bufev,
                        bufferevent_data_cb *readcb_ptr,
                        bufferevent_data_cb *writecb_ptr,
                        bufferevent_event_cb *eventcb_ptr,
                        void **cbarg_ptr);
    bufferevent_setcb函数改变bufferevent的一个或多个回调函数。当读取了数据，写入数据或者event发生的时候，
就会相应的调用readcb、writecb和eventcb函数。这些函数的第一个参数就是发生event的bufferevent，最后一个参数
是bufferevent_setcb的cbarg参数：可以使用该参数传递数据到回调函数。event回调函数的events参数是event标志的
位掩码：参考上面的"回调函数和水位线"一节。
    可以通过传递NULL来禁止一个回调。注意bufferevent上的所有回调函数共享一个cbarg，所以改变改值会影响到所有
回调函数。
    可以通过向bufferevent_getcb函数传递指针来检索bufferevent当前设置的回调函数，该函数会将
*readcb_ptr设置为当前的读回调函数，
*writecb_ptr设置为写回调函数，
*eventcb_ptr设置为当前的event回调函数，并且
*cbarg_ptr设置为当前回调函数的参数。
如果任何一个指针设置为NULL，则会被忽略。

void  bufferevent_enable(struct bufferevent *bufev, short events);
void  bufferevent_disable(struct bufferevent *bufev, short events);
short bufferevent_get_enabled(struct bufferevent *bufev);
    可以将bufferevent上的EV_READ,EV_WRITE或EV_READ|EV_WRITE使能或者禁止。如果禁止了读取和写入操作，
则bufferevent不会读取和写入数据。
    当输出缓冲区为空时，禁止写操作是不必要的：bufferevent会自动停止写操作，而且在有数据可写时又会重启写操作。
    类似的，当输入缓冲区达到它的高水位线的时候，没必要禁止读操作：bufferevent会自动停止读操作，而且在有空间读取的时候，又重新开启读操作。
    默认情况下，新创建的bufferevent会使能写操作，而禁止读操作。
    可以调用bufferevent_get_enabled函数得到该bufferevent当前使能哪些事件。

void bufferevent_setwatermark(struct bufferevent *bufev, short events,
                              size_t lowmark, size_t highmark);
    bufferevent_setwatermark调整一个bufferevent的读水位线和写水位线。
如果在events参数中设置了EV_READ参数，则会调整读水位线，
如果设置了EV_WRITE标志，则会调整写水位线。将高水位线标志置为0，表示"无限制"。

5. 在bufferevent中操作数据
如果不能操作读写的数据，则从网络中读写数据没有任何意义。bufferevent提供函数可以操作读写的数据。
struct evbuffer *bufferevent_get_input(struct bufferevent *bufev);
struct evbuffer *bufferevent_get_output(struct bufferevent *bufev);
    这两个函数可以返回读写缓冲区中的数据。在evbuffer类型上所能进行的所有操作，可以参考下一章。
    注意，应用程序只能从输入缓冲区中移走(而不是添加)数据，而且只能向输出缓冲区添加(而不是移走)数据。

    如果bufferevent上的写操作因为数据太少而停滞(或者读操作因为数据太多而停滞)，则向输出缓冲区中添加数据
(或者从输入缓冲区中移走数据)可以自动重启写(读)操作。
int bufferevent_write(struct bufferevent *bufev, const void *data, size_t size);  # 返回0表示成功，返回-1表示发生了错误。
int bufferevent_write_buffer(struct bufferevent *bufev, struct evbuffer *buf);    # 返回0表示成功，返回-1表示发生了错误。
    这些函数向bufferevent的输出缓冲区中添加数据。
    调用bufferevent_write函数添加data中的size个字节的数据到输出缓冲区的末尾。
    调用 bufferevent_write_buffer函数则将buf中所有数据都移动到输出缓冲区的末尾。

size_t bufferevent_read(struct bufferevent *bufev, void *data, size_t size);  # 该函数返回0实际移除的字节数，返回-1表示失败。
int bufferevent_read_buffer(struct bufferevent *bufev, struct evbuffer *buf); # 该函数返回0表示成功，返回-1表示失败。
    这些函数从bufferevent的输入缓冲区中移走数据。
    bufferevent_read函数从输入缓冲区中移动size个字节到data中。它返回实际移动的字节数。
    bufferevent_read_buffer函数则移动输入缓冲区中的所有数据到buf中，
# 注意bufferevent_read函数中，data缓冲区必须有足够的空间保存size个字节。

6. 读写超时
同其他events一样，某段时间过去之后，bufferevent还没有成功的读或写任何数据，则可以触发某个超时事件。
void bufferevent_set_timeouts(struct bufferevent *bufev,
                               const struct timeval *timeout_read, 
                               const struct timeval *timeout_write);
    将timeout设置为NULL，意味着移除超时时间；然而在libevent 2.1.2-alpha版本之前，这种方式并非在所有event类型上
都有效。(对于较老版本的，取消超时时间的有效方法是，可以将超时时间设置为好几天，并且/或者使eventcb函数忽略BEV_TIMEOUT事件)。
# 当bufferevent试图读取数据时，等待了timeout_read秒还没有数据，则读超时事件就会触发。
# 当bufferevent试图写数据时，至少等待了timeout_write秒，则写超时事件就会触发。
注意，只有在bufferevent读或写的时候，才会对超时时间进行计时。换句话说，
# 如果bufferevent上禁止了读操作，或者当输入缓冲区满(达到高水位线)时，则读超时时间不会使能。类似的，
# 如果bufferevent上禁止了写操作，或者没有数据可写，则写超时时间也会被禁止。
    当读或写超时发生的时候，则bufferevent上相应的读写操作就会被禁止。相应的event回调函数就会以
BEV_EVENT_TIMEOUT|BEV_EVENT_READING或BEV_EVENT_TIMEOUT|BEV_EVENT_WRITING进行调用

7. 在bufferevent上进行flush
int  bufferevent_flush(struct bufferevent *bufev,
                       short iotype, 
                       enum bufferevent_flush_mode state); 
    # bufferevent_flush函数返回-1表示失败，返回0表示没有任何数据被flush，返回1表示有数据被flush。
    对一个bufferevent进行flush，使bufferevent尽可能多的从底层传输系统上读取或者写入数据，
而忽略其他可能阻止写入的限制条件。该函数的细节依赖于不同类型的bufferevent。
    iotype参数可以是EV_READ,EV_WRITE, 或 EV_READ|EV_WRITE，指明处理读操作、写操作，还是两者都处理。
state参数应该是BEV_NORMAL, BEV_FLUSH, 或 BEV_FINISHED。BEV_FINISHED 指明另一端会被告知已无数据可发送；
BEV_NORMAL和BEV_FLUSH之间的区别依赖于bufferevent的类型。

    目前(libevent2.0.5-beta)，bufferevent_flush函数只在某些bufferevent类型上进行了实现，特别是
基于socket的bufferevent并不支持该操作。

8. 特定类型的bufferevent函数
下列bufferevent函数并不是所有bufferevent类型都支持：
int bufferevent_priority_set(struct bufferevent *bufev, int pri);
int bufferevent_get_priority(struct bufferevent *bufev);
该函数将实现bufev的events的优先级调整为pri，关于优先级更多的信息，可以参考event_priority_set函数。
# 该函数返回0表示成功，返回-1表示失败，该函数只能工作在基于socket的bufferevent上。

int bufferevent_setfd(struct bufferevent *bufev, evutil_socket_t fd); # 函数返回-1表示失败，setfd返回0表示成功。
evutil_socket_t bufferevent_getfd(struct  bufferevent  *bufev);
该函数设置或者返回一个基于fd的event的文件描述符。只有基于socket的bufferevent支持setfd操作。

struct event_base *bufferevent_get_base(struct bufferevent *bev);
该函数返回一个bufferevent的event_base。

struct bufferevent *bufferevent_get_underlying(struct bufferevent *bufev);
如果bufferevent作为其他bufferevent的底层传输系统的话，则该函数返回该底层bufferevent。
参考过滤型bufferevent，获得关于这种情况的更多信息。

9. 在bufferevent上手动加锁或者解锁
    类似于evbuffers，有时希望保证在bufferevent上的一系列操作是原子性的。
libevent提供了可以手动加锁和解锁bufferevent的函数。
void  bufferevent_lock(struct bufferevent *bufev);
void  bufferevent_unlock(struct bufferevent *bufev);
    注意，如果一个bufferevent在创建时没有指定BEV_OPT_THREADSAFE 标志，或者libevent的线程支持功能没有激活，
则加锁一个bufferevent没有效果。
    通过该函数对bufferevent进行加锁的同时，也会加锁evbuffers。这些函数都是递归的：对一个已经加锁的bufferevent
再次加锁是安全的。当然，对于每次锁定都必须进行一次解锁。
}

bufferevent(高级应用){
1. 成对的bufferevent
    有时，网络程序可能需要与自己本身进行对话。比如，某个程序用来在某些协议之上进行隧道用户链接，而有时它
需要在这种协议之上，隧道与自己的连接。当然，这可以通过打开一个到自己监听端口的链接来实现，然而通过网络栈
来实现与自己的对话，显然是浪费资源的。
    作为替代，可以创建一对"成对的"bufferevent(paired  bufferevents)，写入一个bufferevent的字节都会在
另一个bufferevent上接收到(反之亦然)，但是不使用任何实际的socket平台。

int bufferevent_pair_new(struct event_base *base, int options,
                         struct bufferevent *pair[2]);
    调用bufferevent_pair_new，将pair[0]和pair[1]设置为"bufferevent对"，它们之间相互建链。基本上所有常规的
选项都支持，除了没有任何效果的BEV_OPT_CLOSE_ON_FREE，以及需要始终支持的BEV_OPT_DEFER_CALLBACKS。
    为什么bufferevent对需要延迟回调函数呢？下面的场景很常见：在成对元素之一进行操作，会调用回调函数，
进而改变bufferevent的状态，而这又会引起另一个bufferevent回调函数的调用，如此会一直循环往复下去。如果
回调函数不被延迟，那么这种调用链条就会导致栈溢出，饿死其他链接，并且使得所有回调函数都折返。
    "bufferevent对"支持flush；无论是设置为BEV_NORMAL还是BEV_FLUSH，都会使所有相关数据从bufferevent对的
一端传送到另一端，而忽略水位线的限制。设置BEV_FINISHED还会使对端bufferevent额外的产生EOF事件。
    释放"bufferevent对"的一端，不会使得另一端也自动释放或是产生EOF事件；这只会使得对端的bufferevent
变为unlink。一旦bufferevent变为unlink状态，那它就再也不能进行读写数据，也不会产生任何事件了。
 
struct bufferevent  *bufferevent_pair_get_partner(struct  bufferevent  *bev)
    有时会需要在给定"bufferevent对"的一端的情况下，得到对端的bufferevent。这可以通过调用
bufferevent_pair_get_partner函数进行实现。如果bev是"bufferevent对"的一个成员，而且对端bufferevent依然存在，
则该函数会返回对端bufferevent，否则会返回NULL。

2. 过滤型bufferevent
有时会需要对经过bufferevent的所有数据进行转换。比如这样可以增加一个压缩层，或者在另一个传输协议中封装一个协议。
enum  bufferevent_filter_result {
    BEV_OK = 0,
    BEV_NEED_MORE = 1,
    BEV_ERROR = 2
};

typedef enum  bufferevent_filter_result(*bufferevent_filter_cb)(
                                         struct evbuffer  * source,  
                                         struct  evbuffer *destination, 
                                         ev_ssize_t  dst_limit,
                                         enum  bufferevent_flush_mode  mode,  
                                         void *ctx);
struct bufferevent  *bufferevent_filter_new(struct bufferevent  *underlying,
                                            bufferevent_filter_cb  input_filter,
                                            bufferevent_filter_cb  output_filter,
                                            int  options,
                                            void (*free_context)(void *),
                                            void  *ctx);
                                            
   bufferevent_filter_new函数在一个已存在的底层bufferevent之上，创建一个新的过滤型bufferevent。
所有通过底层bufferevent接收到的数据，在到达过滤型bufferevent之前都会经过输入过滤器进行转换，
而且所有传送到底层bufferevent的数据，之前都会发送到过滤型bufferevent，通过输出过滤器进行转换。
   为一个底层bufferevent添加过滤，会替换底层bufferevent的回调函数。依然可以向底层bufferevent的
evbuffers添加回调函数，但是如果希望过滤器还能工作的话，就不能设置bufferevent本身的回调函数。
   输入过滤器input_filter和输出过滤器output_filter函数在下面进行描述。
options中支持所有常用选项。如果设置了BEV_OPT_CLOSE_ON_FREE，那么释放过滤型bufferevent也会释放底层bufferevent。
ctx是一个传递给过滤函数的可选指针；如果提供了free_context函数的话，则在关闭过滤型bufferevent之前，该函数会在ctx上进行调用。
   
   当底层bufferevent的输入缓冲区中有新的可读数据时，就会调用输入过滤器函数。
   当过滤型bufferevent的输出缓冲区中有新的可写数据时，就会调用输出过滤器函数。
每个过滤器函数都会接收一对evbuffers作为参数：从source evbuffer中读取数据，向destination evbuffer中写入数据。
dst_limit参数描述了向destination中添加数据的上限。过滤器函数可以忽略该参数，但是这样做可能会违反高水位线或速率限制。
如果dst_limit置为-1，则表示无限制。

    mode参数用于在输出时改变过滤器的行为。
    如果置为BEV_NORMAL，意味着便于转化的输出，置为
    BEV_FLUSH意味着尽可能多的输出，
    BEV_FINISHED意味着过滤器函数需要在流的末尾进行必要的清理工作。
最后，过滤器函数的ctx参数是在调用函数bufferevent_filter_new()时提供的void指针。
   
   只要有任何数据成功的写入了目标buffer中，过滤器函数就必须返回BEV_OK，BEV_NEED_MORE意味着不能
再向目标buffer写入更多的数据了，除非获得更多的输入，或者使用不同的flush模式。如果过滤器中发生
了不可恢复的错误，则返回BEV_ERROR。
   创建过滤器会使能底层bufferevent上的读和写操作。无需亲自管理读写：当不再需要读取时，过滤器就会
挂起底层bufferevent的读操作。对于2.0.8-rc以及之后的版本，允许独立于过滤器，对底层bufferevent的输入
和输出操作进行使能或禁止操作。但是这样做的话，有可能会使得过滤器不能得到它想要的数据。
   输入过滤器和输出过滤器无需全部指定，如果省略了某个过滤器，则数据不会被转化而直接被转送。

3. 限制单次读写最大量
    默认情况下，在每次event loop的调用中，bufferevent不会读写最大可能的数据量，这样做会导致怪异的非公正
行为以及资源耗尽。然而另一方面，这种默认行为未必对所有情况都是合理的。
int bufferevent_set_max_single_read(struct bufferevent *bev, size_t size);
int bufferevent_set_max_single_write(struct bufferevent *bev, size_t  size);

ev_ssize_t bufferevent_get_max_single_read(struct  bufferevent  *bev);
ev_ssize_t bufferevent_get_max_single_write(struct  bufferevent  *bev);
    两个set函数设置当前读写的最大量。如果size为0或者高于EV_SSIZE_MAX，那么将会设置最大量为默认值。
# 这些函数成功时返回0，失败是返回-1.
    两个get函数返回当前每次loop调用时的读写最大量。

4. bufferevent的速率限制
4.1：速率限制模式
    libevent的速率限制，使用令牌桶算法来决定每次读写的数据量。在任何给定时间，每一个速率限制对象，
都有一个"读桶"和"写桶"，它们的大小决定了该对象能够立即读写的字节数。每个桶都有一个填充速率，一个
突发量的最大值以及一个时间单元（或tick）。当经过了一个时间单元之后，桶按照填充速率产生新的令牌—
但是如果填充量大于突发量的话，多余的字节将会丢失。
    所以，填充速率决定了对象发送和接受字节的最大平均速率，而突发量决定了在单次突发中所能发送和
接受的最大数据量。时间单元决定了流量的流畅度。
4.2 设置bufferevent的速率限制
#define EV_RATE_LIMIT_MAX EV_SSIZE_MAX
struct ev_token_bucket_cfg;
提供最大平均读取速率、最大突发读取量、最大平均写入速率、最大突发写入量,以及一个滴答的长度
如果 tick_len 参数为 NULL,则默认的滴答长度为一秒。
struct ev_token_bucket_cfg  *ev_token_bucket_cfg_new(size_t read_rate,  
                                                     size_t read_burst,
                                                     size_t write_rate,  
                                                     size_t write_burst,
                                                     const struct timeval *tick_len);
void ev_token_bucket_cfg_free(struct ev_token_bucket_cfg *cfg);
int bufferevent_set_rate_limit(struct bufferevent *bev,  
                               struct ev_token_bucket_cfg *cfg);
    ev_token_bucket_cfg结构代表了一对令牌桶的配置的值，这对令牌桶就是用来限制单个bufferevent
或一组bufferevents的读写的对象。调用ev_token_bucket_cfg_new函数可以创建ev_token_bucket_cfg结构，
调用该函数需要提供最大平均读速率，最大读突发量，最大写速率，最大写突发量，以及tick的长度。
如果tick_len参数为NULL，则tick长度默认为一秒。如果发生错误，该函数返回NULL。
    注意，read_rate和write_rate参数按照每tick的字节数进行度量。也就是说，如果tick为1/10秒，
并且read_rate为300，那么最大平均读速率为每秒3000个字节。不支持超过EV_RATE_LIMIT_MAX的速率和突发量。
    为了限制一个bufferevent的传输速率，可以以一个ev_token_bucket_cfg为参数来调用函数bufferevent_set_rate_limit。
# 该函数成功时返回0，失败时返回-1。
    相同ev_token_bucket_cfg结构可以设置任意数量的bufferevent。如果以NULL为cfg参数调用函数
bufferevent_set_rate_limit，则可以移除bufferevent的速率限制。
    调用ev_token_bucket_cfg_free函数可以释放ev_token_bucket_cfg结构。
    注意，直到没有任何bufferevent使用该ev_token_bucket_cfg结构时，释放它才是安全的。

4.3 检测当前速率限制值
有时希望得到给定的某个bufferevent或组的当前速率限制的值，libevent提供了相关函数。
ev_ssize_t bufferevent_get_read_limit(struct bufferevent  *bev);
ev_ssize_t bufferevent_get_write_limit(struct bufferevent *bev);
ev_ssize_t bufferevent_rate_limit_group_get_read_limit(struct bufferevent_rate_limit_group *);
ev_ssize_t bufferevent_rate_limit_group_get_write_limit(struct bufferevent_rate_limit_group *);
    上述函数返回一个bufferevent或一个组的读/写令牌桶的当前字节数。注意，如果某个bufferevent的值
超过分配值的话(刷新bufferevent)，这些值可以为负数。

ev_ssize_t bufferevent_get_max_to_read(struct bufferevent *bev);
ev_ssize_t bufferevent_get_max_to_write(struct bufferevent *bev);
ev_ssize_t bufferevent_get_max_to_read(struct bufferevent *bev);
ev_ssize_t bufferevent_get_max_to_write(struct bufferevent *bev);
    这些函数根据应用到该bufferevent上的任何速率限制、它的速率限制组，以及由libevent视为一个整体
的任何每次读写最大值，该函数返回bufferevent当前正要读写的字节数。

void  bufferevent_rate_limit_group_get_totals(struct bufferevent_rate_limit_group  *grp,
                                              ev_uint64_t *total_read_out,  
                                              ev_uint64_t *total_written_out);
void  bufferevent_rate_limit_group_reset_totals(struct  bufferevent_rate_limit_group  *grp);
    bufferevent_rate_limit_group函数记录所有经过他发送的字节数。利用该值，可以得到组中一些bufferevent的总使用量。
在组上调用bufferevent_rate_limit_group_get_totals可以设置*total_read_out 和 *total_written_out为一个bufferevent
组的读写字节总数。这些字节总数在group建立的时候置为0，当在组上再次调用bufferevent_rate_limit_group_reset_totals时，
该值重置为0。

4.4 设置速率限制组中的最小共享(the smallest share)
    一般不希望将每个tick中所有可得流量均匀的分布到速率限制组中的所有bufferevent上。比如，
如果一个速率限制组有10,000个激活的bufferevent，每个tick总共有10,000个字节用来输出，因为
系统调用以及TCP报文头的原因，每个bufferevent每个tick只能输出1个字节的话是很没有效率的。
    为了解决这种问题，每一个速率限制组都有"最小共享"(minimum share)的概念。在上面的情况中，
不采用每个bufferevent每次tick写1个字节这种方式，而是允许每个tick中，10000/SHARE个bufferevent
写SHARE个字节，而其余的bufferevent可以不输出任何字节。每一个tick中，哪些bufferevent被允许先进行输出是随机选择的。
    选择的最小共享的默认值可以有不错的性能，当前（2.0.6-rc）被设置为64。可以通过下面的函数进行调整：
int  bufferevent_rate_limit_group_set_min_share(
struct  bufferevent_rate_limit_group  *group,  size_t  min_share);
如果将min_share设置为0，则将禁用最小共享的代码。

4.5 速率限制实现中的限制
在libevent 2.0中，需要知道速率限制的实现具有某些限制：
  不是所有bufferevent类型都能很好的支持速率限制，有些根本不支持。
  速率限制组不允许嵌套，并且一个bufferevent同一时间只能属于一个速率限制组。
  速率限制的实现仅仅对传输的TCP报文体重的字节数进行计数，不包含TCP报文头。
  读限制的实现依赖于TCP协议栈，注意，应用程序只能以一定的速率吸收数据，并且当缓冲区变满时，将数据推送到TCP链接的另一端。
  某些bufferevent的实现（特别是window的IOCP实现）可以过量使用（over-commit）
  令牌桶可以以一个完整tick的流量为开始。这意味着一个bufferevent可以立即开始读写操作，而不需要等待一个完整的tick过去之后才开始，这还意味着，如果一个bufferevent被限制速率为N.1个tick，他也可以传输N+1个tick的流量。
  ticks可以小于1毫秒，而且所有毫秒的小数部分将会被忽略。

5. bufferevent和SSL
    bufferevent可以使用OpenSSL库来实现SSL/TLS安全传输层。因为大多数应用不需要连接OpenSSL，
所以该功能在一个独立的库："libevent_openssl"中实现。未来版本的libevent可以支持其他的SSL/TLS库，
比如NSS或GnuTLS，但是当前只支持OpenSSL。
    注意，本节并非介绍OpenSSL，SSL/TLS或一般性密码学的教程。
    下面所有的函数都是在文件"event2/bufferevent_ssl.h"中声明。
}

evbuffer(基本操作){
    libevent的evbuffer功能实现了一个字节队列， # 优化了在队列尾端增加数据，以及从队列前端删除数据的操作。
evbuffer用来实现缓存网络IO中的缓存部分。它们不能用来在条件发生时调度IO或者触发IO：这是bufferevent做的事情。
本章介绍的函数，除了特别注明的，都是在文件"event2/buffer.h"中声明。

1. 创建或者释放evbuffer
struct evbuffer *evbuffer_new(void);
void evbuffer_free(struct evbuffer *buf);
evbuffer_new分配并且返回一个新的空evbuffer，evbuffer_free删除evbuffer及其所有内容。

2. evbuffer和线程安全
int evbuffer_enable_locking(struct evbuffer *buf, void *lock);
void evbuffer_lock(struct evbuffer *buf);
void evbuffer_unlock(struct evbuffer *buf);
    默认情况下，同一时间在多个线程中访问evbuffer是不安全的。如果需要多线程使用evbuffer，
可以在evbuffer上调用evbuffer_enable_locking函数。如果lock参数为NULL，则libevent使用提供给
evthread_set_lock_creation_callback的锁创建函数来分配一个新锁。否则，使用该参数作为新锁。
    evbuffer_lock() 和evbuffer_unlock()函数在evbuffer上进行加锁和解锁。可以使用它们将一些
操作原子化。如果evbuffer上没有使能锁机制，则这些函数不做任何事。
# 注意：不需要在单个操作上调用evbuffer_lock()和 evbuffer_unlock()：如果evbuffer上使能了锁机制，
# 单个操作已经是原子性的了。只在有多于一个操作需要执行，且不希望其他线程打断时，才需要手动锁住evbuffer。

3. 检查evbuffer
size_t evbuffer_get_length(const struct evbuffer *buf);
# 返回evbuffer中存储的字节数。

size_t evbuffer_get_contiguous_space(const struct evbuffer *buf);
#返回evbuffer前端的连续存储的字节数。
evbuffer中的字节存储在多个分离的内存块中；该函数返回当前存储在evbuffer中的第一个内存块中的字节数。

4. 向evbuffer中末尾添加数据：  末尾
int evbuffer_add(struct evbuffer *buf, const void *data, size_t datlen); # 该函数成功时返回0，失败时返回-1。
该函数向buf的末尾添加缓冲区data中的datlen个字节。

int evbuffer_add_printf(struct evbuffer *buf, const char *fmt, ...)
int evbuffer_add_vprintf(struct evbuffer *buf, const char  *fmt, va_list ap);
这些函数向buf中添加格式化的数据。format参数以及后续的其他参数类似于C库中的printf和vprintf函数中的参数。
# 这些函数返回添加到buf中的字节数。

int evbuffer_expand(struct evbuffer *buf, size_t datlen); # 成功返回0，失败返回-1
扩展evbuffer的可用空间，该函数会改变buffer中的最后一个内存块，或者添加一个新的内存块，将buffer的
可用空间扩展到至少datlen个字节。扩展buffer到足够大，从而在不需要进行更多的分配情况下就能容纳datlen个字节。
evbuffer_add(buf, "Hello world 2.0.1",  17);
evbuffer_add_printf(buf, "Hello %s %d.%d.%d", "world", 2, 0, 1);
        
5. evbuffer之间的数据移动
基于性能的考虑，libevent优化了在evbuffer间移动数据的功能。
int evbuffer_add_buffer(struct evbuffer *dst, struct evbuffer*src); # 该函数成功时返回0，失败时返回-1.
int evbuffer_remove_buffer(struct evbuffer *src, struct evbuffer *dst, size_t datlen);
evbuffer_add_buffer函数将src中的所有数据移动到dst的尾端。

evbuffer_remove_buffer函数将src中的datlen个字节的数据移动到dst的末尾，并且尽量少的复制。
如果数据量少于datlen，则移动所有数据。该函数返回移动的数据量。

6. 向evbuffer的前端添加数据  头部
int evbuffer_prepend(struct evbuffer *buf, const void  *data, size_t size);
int evbuffer_prepend_buffer(struct evbuffer *dst, struct evbuffer *  src);
这些函数类似于evbuffer_add()和 evbuffer_add_buffer()，只不过它们是将数据移动到目标buffer的前端。
这些函数要小心使用，不能用在由bufferevent共享的evbuffer上。

7. 重新安排evbuffer的内部布局 - 返回的指针可用于cmp比较
    有时候希望能够查看(但不取出)evbuffer前端的前N个字节，并将其视为一个连续存储的数组。
为此，必须首先保证buffer的前端确实是连续的。
unsigned char *evbuffer_pullup(struct evbuffer *buf, ev_ssize_t size);
    evbuffer_pullup函数将buf的最前面的size个字节"线性化"，通过对其复制或者移动，保证这些字节的
连续性并且都存储在同一个内存块中。
# 如果size是个负数，则该函数会将整个buffer进行线性化。
# 如果size大于buffer中的字节数，则该函数返回NULL，否则，该函数返回指向第一个字节的指针。

注意，使用evbuffer_get_contiguous_space的返回值作为size，
      调用evbuffer_pullup，则不会引起任何字节的复制或者移动。

8. 从evbuffer头中移除数据  头部
int evbuffer_drain(struct evbuffer *buf, size_t len); # len=-1 清空所有缓存
int evbuffer_remove(struct evbuffer *buf, void *data, size_t datlen);
    evbuffer_remove函数复制并且移动buf前端的datlen个字节到data中。如果buf中的字节数少于datlen个，
则该函数会复制所有的字节。
# 该函数失败返回-1，否则返回复制的字节数。
    evbuffer_drain()函数类似于evbuffer_remove，不同的是它不复制任何数据，而只是删除buffer前端的数据。
# 该函数成功返回0，失败返回-1。

9. 复制evbuffer中的数据
    有时希望只是复制buffer前端的数据而不删除它。比如，你可能希望确认某种类型的完整记录是否已经到达，
而不删除任何数据(就像evbuffer_remove的动作)，也不对buffer内部做任何重新部署(就像evbuffer_pullup那样)
ev_ssize_t evbuffer_copyout(struct evbuffer *buf, void *data, size_t datlen);
ev_ssize_t evbuffer_copyout_from(struct evbuffer *buf,
                                 const struct evbuffer_ptr *pos,
                                 void *data_out, 
                                 size_t datlen);
    evbuffer_copyout函数类似于evbuffer_remove，但是并不删除buffer中的任何数据。也就是说，
它只是复制buf前端的前datlen个字节到data中。
如果buffer中少于datlen个字节，则该函数复制所有存在的字节。
# 该函数失败时返回-1，成功时返回复制的字节数。

    evbuffer_copyout_from函数类似于evbuffer_copyout，但它不是复制buffer前端的数据，
而是以pos指明的位置为起点进行复制。参考"在evbuffer中搜索"一节，查看evbuffer_ptr结构的更多信息。
如果从buffer中复制数据太慢，则可以使用evbuffer_peek函数。

10. 基于行的输入
enum evbuffer_eol_style {
    EVBUFFER_EOL_ANY,
    EVBUFFER_EOL_CRLF,
    EVBUFFER_EOL_CRLF_STRICT,
    EVBUFFER_EOL_LF,
    EVBUFFER_EOL_NUL
};
char *evbuffer_readln(struct evbuffer *buffer, 
                      size_t *n_read_out,
                      enum evbuffer_eol_style  eol_style);
    很多互联网协议使用基于行的格式。evbuffer_readln函数从evbuffer的前端取出一行，并且将其复制返回到一个
新的以NULL为结尾的字符串中。
如果n_read_out非空，则将*n_read_out置为返回字符串的长度。
如果buffer中没有可读的一整行，则该函数返回NULL。
    注意，行结束符不包含在返回的复制字符串中。

    evbuffer_readln函数可以处理4种行结束符：
    EVBUFFER_EOL_LF：行末尾是单个的换行符(也就是"\n"，ASCII值为0x0A)；
    EVBUFFER_EOL_CRLF_STRICT：行末尾是回车符和换行符。(也就是"\r\n"，他们的ASCII码分别为0x0D  0x0A)。
    EVBUFFER_EOL_CRLF：行末尾是一个可选的回车符，跟着一个换行符。(也就是说，是"\r\n"或者"\n")。
                       这种格式在解析基于文本的互联网协议中是很有用的，因为一般而言，协议标准都
                       规定以"\r\n"作为行结束符，但是不符合标准的客户端有时候会使用"\n"。
    EVBUFFER_EOL_ANY：行的结尾是任何顺序任何数量的回车符和换行符。
                      这种格式不太常用，它的存在只是为了向后兼容性。
    EVBUFFER_EOL_NUL：行结束符是单个的0字节，也就是ASCII中的NULL字节。
    注意，如果使用了event_set_mem_functions函数替代默认的malloc，则函数evbuffer_readln 
返回的字符串将由指定的malloc替代函数进行分配。

11. 在evbuffer中搜索
evbuffer_ptr结构指向evbuffer内部的某个位置，该结构包含可以用来遍历evbuffer的成员。
struct  evbuffer_ptr{
    ev_ssize_t  pos;
        struct{
                /* internal fields */
        } _internal;
};
pos成员是唯一公开的成员；其他成员不能在用户代码中使用。pos指向相对于evbuffer首地址的偏移位置。
struct evbuffer_ptr evbuffer_search(struct evbuffer *buffer,
                                    const char *what, 
                                    size_t len,  
                                    const struct evbuffer_ptr *start);
struct evbuffer_ptr evbuffer_search_range(struct evbuffer *buffer,
                                          const char *what, size_t len,  
                                          const struct evbuffer_ptr *start,
                                          const struct evbuffer_ptr *end);
struct evbuffer_ptr evbuffer_search_eol(struct evbuffer *buffer,
                                        struct evbuffer_ptr *start,  
                                        size_t *eol_len_out,
                                        enum evbuffer_eol_style eol_style);

    evbuffer_search函数在buffer中扫描长度为len的what字符串的位置。
如果能找到该字符串，则返回的evbuffer_ptr结构中的pos指明该字符串的位置，否则pos为-1。
如果提供了start参数，则该参数指定开始搜索的位置；
如果没有提供，则表明从从buffer的开头开始搜索。

evbuffer_search_range函数类似于evbuffer_search，但它只在buffer中end参数指明的位置之前进行搜索。
    evbuffer_search_eol函数，类似于evbuffer_readlen，探测行结束符，只是该函数并不复制该行。
该函数返回evbuffer_ptr结构，其中的pos指明了行结束符的起始地址。
如果eol_len_out不是NULL，则其被置为EOL字符串的长度。

enum evbuffer_ptr_how {
    EVBUFFER_PTR_SET,
    EVBUFFER_PTR_ADD
};
int evbuffer_ptr_set(struct evbuffer *buffer, 
                     struct evbuffer_ptr *pos,
                     size_t position, 
                     enum evbuffer_ptr_how how
                     );
evbuffer_ptr_set函数设置evbuffer_ptr结构pos为buffer中的某个位置。
如果how为EVBUFFER_PTR_SET，则pos移动到buffer中的position位置，
如果是EVBUFFER_PTR_ADD，则pointer向后移动position个字节。因此，
如果pos没有初始化的话，则how参数只能为EVBUFFER_PTR_SET。
# 该函数成功时返回0，失败是返回-1.

12. 检查数据而不进行复制
    有时希望在不复制出数据的情况下读取evbuffer中的数据，而且不对evbuffer内部的内存进行重新部署。
有时候希望能够检查evbuffer中部的数据，可以使用下面的接口：
struct evbuffer_iovec {
void *iov_base;
size_t iov_len;
};

int evbuffer_peek(struct evbuffer *buffer, 
                  ev_ssize_t len,
                  struct evbuffer_ptr *start_at,
                  struct evbuffer_iovec *vec_out,  
                  int n_vec
                  );
    当调用evbuffer_peek函数时，在vec_out中给定一个evbuffer_iovec结构的数组。数组长度为n_vec。
该函数设置数组中的结构体，使每个结构体的iov_base都指向evbuffer内部的一个内存块，并且将iov_len置为内存块的长度。
    如果len小于0，则evbuffer_peek函数会尽可能的设置所有给定的evbuffer_iovec结构。否则，
要么至少填充len个字节到evbuffer_iovec中，要么将所有evbuffer_iovec都填充满。
    如果该函数能够得到所有请求的字节，则该函数将返回实际使用的evbuffer_iovec结构的个数，否则，
它返回为了能得到所有数据而需要的evbuffer_iovec的个数。
如果ptr为NULL，则evbuffer_peek从buffer的起始处开始取数据，否则，从start_at参数开始取数据。

13. 直接向evbuffer中添加数据
    如果需要向evbuffer中直接插入数据，而不是像evbuffer_add那样，先写入一个字符数组，然后再将字符数组复制到
evbuffer中。可以使用下面的函数：evbuffer_reserve_space() 和evbuffer_commit_space()。类似于evbuffer_peek，
这些函数使用evbuffer_iovec结构来直接访问evbuffer中的内存。
int evbuffer_reserve_space(struct evbuffer *buf,  
                           ev_ssize_t size,
                           struct evbuffer_iovec *vec,  
                           int n_vecs);
int evbuffer_commit_space(struct evbuffer *buf,
                          struct evbuffer_iovec *vec,  
                          int n_vecs)
    evbuffer_reserve_space函数扩充buf的最后一个内存块的空间，返回evbuffer内部空间的指针。它会将buffer的可
用空间扩充到至少size个字节；指向这些扩充的内存块的指针以及内存块长度将会存储在vec结构中，n_vec指明了该数组的长度。
    n_vec至少为1，如果只给定了一个vector，则libevent会保证将所有请求的连续空间填充到一个内存块中，但是这样
会对buffer重新布局，或者会浪费内存。如果想要更好的性能，则至少应该提供2个vector，该函数返回请求空间需要的vector个数。
    写入到这些vector中的数据，直到调用evbuffer_commit_space之前，都不算是buffer的一部分，该函数会使vector
中的数据成为buffer中的数据。如果希望提交少于请求的数据，可以减少任一evbuffer_iovec结构体的iov_len，或者还可
以传递较少的vector。evbuffer_commit_space函数成功时返回0，失败时返回-1。

注意：调用任何重新布局evbuffer的函数，或者向evbuffer添加数据，会使得从evbuffer_reserve_space返回的指针变得无效。

在当前的实现中，evbuffer_reserve_space不会使用多余两个的vector，而不管用户提供了多少，或许会在未来版本中有所改变。

调用多次evbuffer_reserve_space是安全的。
如果evbuffer在多线程中使用，则在调用evbuffer_reserve_space函数之前应该使用evbuffer_lock函数进行加锁，并且一旦commit会后就解锁。

14. 用evbuffer进行网络IO
    libevent中evbuffer最常见的用途是用来进行网络IO。evbuffer上执行网络IO的接口是：
int evbuffer_write(struct evbuffer *buffer, evutil_socket_t  fd);
int evbuffer_write_atmost(struct evbuffer *buffer, evutil_socket_t fd, ev_ssize_t howmuch);
int evbuffer_read(struct evbuffer *buffer, evutil_socket_t fd, int howmuch);
    evbuffer_read函数从fd中读取howmuch个字节到buffer的尾端。他返回成功读取的字节数，
遇到EOF时返回0，发生错误返回-1。
    注意发生错误有可能表明一个非阻塞的操作失败了；可以通过检查错误码是否为EAGAIN
(在Windows上为WSAEWOULDBLOCK )来确定。如果howmuch参数为负数，则evbuffer_read自己决定读取多少字节。
    evbuffer_write_atmost函数尝试从buffer的前端发送howmuch字节到fd上。该函数返回成功写入的字节数，
失败时返回-1。与evbuffer_read类似，需要检查错误码确定是否确实发生了错误，还是仅表明非阻塞IO不能
立即执行。如果howmuch为负数，则会尝试发送整个buffer的内容。
    调用evbuffer_write，等同于以负数howmuch调用函数evbuffer_write_atmost：它会尽可能的刷新buffer。
    在Unix上，这些函数可以工作在任何支持读写的文件描述符上，但是在Windows上，仅能用在socket上。
注意，当使用bufferevent时，不需要调用这些IO函数，bufferevent会替你调用他们。

15. evbuffer和回调函数
    使用evbuffer时，经常会想知道数据何时添加到或者移除出evbuffer。libevent提供了一般性的evbuffer
回调机制支持这种需求。
struct  evbuffer_cb_info {
    size_t orig_size;
    size_t n_added;
    size_t n_deleted;
};

typedef void(*evbuffer_cb_func)(struct evbuffer *buffer, const struct evbuffer_cb_info *info, void *arg);
    当数据添加到或者移除出evbuffer的时候，就会调用evbuffer的回调函数。该函数的参数是buffer，
    指向evbuffer_cb_info结构体的指针，以及一个用户提供的参数。
    evbuffer_cb_info结构的orig_size成员记录了buffer大小改变之前，buffer中的字节数；
    n_added成员记录了添加到buffer的字节数；
    n_deleted记录了移除的字节数。
  
struct  evbuffer_cb_entry;
struct  evbuffer_cb_entry *evbuffer_add_cb(struct evbuffer *buffer, evbuffer_cb_func cb, void *cbarg);
    evbuffer_add_cb函数向evbuffer中添加回调函数，并且返回一个非透明的指针，该指针后续可以用来
引用该特定的回调实例。cb参数就是会调用的回调函数，cbarg是用来传递给该函数的用户提供的参数。
    在单个evbuffer上可以有多个回调函数，添加新的回调不会删除旧的回调函数。

    注意，释放一个非空evbuffer并不算作从中抽取数据，而且释放evbuffer也不会释放其回调函数的用户提供的数据指针。
    如果不希望一个回调函数永久的作用在buffer上，可以将其移除（永久移除），或者禁止（暂时关闭）

int evbuffer_remove_cb_entry(struct evbuffer *buffer, struct evbuffer_cb_entry  *ent);
int  evbuffer_remove_cb(struct evbuffer *buffer, evbuffer_cb_func cb, void *cbarg);

#define  EVBUFFER_CB_ENABLED  1
int evbuffer_cb_set_flags(struct evbuffer *buffer,
                          struct evbuffer_cb_entry *cb,
                          ev_uint32_t flags);

int evbuffer_cb_clear_flags(struct evbuffer *buffer,
                            struct evbuffer_cb_entry *cb,
                            ev_uint32_t flags);
    可以通过添加时得到的evbuffer_cb_entry来删除回调，或者使用回调函数本身以及用户提供的参数指针来删除回调。
# evbuffer_remove_cb函数成功时返回0，失败时返回-1。
    evbuffer_cb_set_flags和evbuffer_cb_clear_flags函数可以在相应的回调函数上，设置或者移除给定的标志位。
当前只支持一个用户可见的标志：EVBUFFER_CB_ENABLED。
默认设置该标志，当清除该标志时，evbuffer上的修改不会再调用回调函数了。


int  evbuffer_defer_callbacks(struct  evbuffer  *buffer,  struct  event_base *base);
    类似于bufferevent的回调函数，可以当evbuffer改变时不立即运行evbuffer的回调，而是使其延迟并作为event_base
的event loop的一部分进行调用。如果有多个evbuffer，它们的回调函数会将数据从一个添加(或移除)到另外一个的时候，
这种延迟机制是有帮助的，可以避免栈崩溃。
如果evbuffer的回调函数被延迟了，在在其最终调用时，他们会对多个操作的结果进行聚合。
类似于bufferevent，evbuffer有内部引用计数，所以即使evbuffer尚有未执行的延迟回调，释放它也是安全的。

16. 避免在基于evbuffer的IO上复制数据
真正快速的网络程序会尽可能少的复制数据。libevent提供了一些机制来满足这种需求。
typedef void (*evbuffer_ref_cleanup_cb)(const void *data, size_t datalen, void *extra);

int evbuffer_add_reference(struct evbuffer *outbuf,
                           const void *data, 
                           size_t datlen,
                           evbuffer_ref_cleanup_cb cleanupfn, 
                           void *extra
                           );
    该函数通过引用向evbuffer的尾端添加数据：没有进行复制，相反的，evbuffer仅仅保存指向包含datlen
个字节的data的指针。因此，在evbuffer使用它期间，该指针应该保持是有效的。当evbuffer不再需要该数据的时候，
它会以data，datlen和extra为参数，调用用户提供的cleanupfn函数。
# 该函数成功时返回0，失败时返回-1。

17.向evbuffer中添加文件
一些操作系统提供了将文件写入到网络中，而不需要复制数据到用户空间中的方法。可以通过简单的接口访问这些机制：
    int evbuffer_add_file(struct evbuffer *output, int fd, ev_off_t offset, size_t length);
evbuffer_add_file函数假设已经有一个用来读的打开的文件描述符fd。该函数从该文件的offset位置开始，
读取length个字节，写入到output的尾端。
# 该函数成功时返回0，失败是返回-1。
    警告：在libevent2.0.x中，通过这种方式添加的数据，仅有下面几种操作数据的方式是可靠的：
    通过evbuffer_write*函数将数据发送到网络中；通过evbuffer_drain函数进行抽取数据，
    通过evbuffer_*_buffer函数将数据移动到其他evbuffer中。下列操作是不可靠的：
    通过evbuffer_remove函数从buffer中抽取数据；
    通过evbuffer_pullup线性化数据等等。libevent2.1.x会修复这些限制。
    如果操作系统支持splice和sendfile函数，则在调用evbuffer_write时，
libevent直接使用这些函数发送fd中的数据到网络中，而不需要将数据复制到用户内存中。
如果不存在splice或sendfile函数，但是有mmap函数，则libevent会对文件做mmap，并且
内核会知道不需要将数据复制到用户空间。如果上述函数都不存在的话，则libevent会将
数据从磁盘读取到内存中。
    当文件中的数据刷新到evbuffer之后，或者当释放evbuffer时，就会关闭文件描述符。
如果不希望关闭文件，或者希望对文件有更细粒度的控制，则可以参考下面的文件段(file_segment)功能。

18. 对文件段(file_segment)进行更细粒度的控制
如果需要多次添加同一个文件，则evbuffer_add_file是低效的，因为它会占有文件的所有权。

struct evbuffer_file_segment;
struct evbuffer_file_segment *evbuffer_file_segment_new(int fd,  
                                                        ev_off_t offset,  
                                                        ev_off_t length,  
                                                        unsigned flags);
void evbuffer_file_segment_free(struct evbuffer_file_segment *seg);

int evbuffer_add_file_segment(struct evbuffer *buf,
                              struct evbuffer_file_segment *seg, 
                              ev_off_t offset, 
                              ev_off_t length);

    evbuffer_file_segment_new函数创建并返回一个evbuffer_file_segment对象，
该对象代表了存储在文件fd中的，以offset为起点，共有length个字节的文件段。该函数如果发生错误时返回NULL。

    文件段通过sendfile、splice、mmap、CreateFileMapping或malloc()-and_read()中合适的函数进行实现。
它们使用系统支持的最轻量级的机制进行创建，并且在需要的时候会过渡到重量级的机制上。(比如，如果系统
支持sendfile和mmap，则会仅使用sendfile实现文件段，直到真正需要检查文件段内容时，在这一刻，会使用mmap)，
可以通过下列标志更加细粒度的控制文件段的行为：
EVBUF_FS_CLOSE_ON_FREE：如果设置了该标志，则通过函数evbuffer_file_segment_free释放文件段将会关闭底层文件。
EVBUF_FS_DISABLE_MMAP：如果设置了该标志，则文件段将永远不会使用mmap类型的后端（CreateFileMapping，mmap），即使它们非常合适。
EVBUF_FS_DISABLE_SENDFILE：如果设置了该标志，则文件段将永远不会使用sendfile类型的后端（sendfile，splice），即使它们非常合适。
EVBUF_FS_DISABLE_LOCKING：如果设置了该标志，则不会在文件段上分配锁：在多线程环境中使用文件段将是不安全的。

一旦得到一个evbuffer_file_segment结构，则可以使用evbuffer_add_file_segment函数将其中的一部分或者所有内容添加到evbuffer中。这里的offset参数是指文件段内的偏移，而不是文件内的偏移。

当不再使用文件段时，可以通过evbuffer_file_segment_free函数进行释放。但是其实际的存储空间不会释放，直到再也没有任何evbuffer持有文件段部分数据的引用为止。

typedef void (*evbuffer_file_segment_cleanup_cb)(struct evbuffer_file_segment  
                                                 const *seg, 
                                                 int flags,  
                                                 void *arg);
void  evbuffer_file_segment_add_cleanup_cb(struct  evbuffer_file_segment  *seg,
evbuffer_file_segment_cleanup_cb  cb,  void *arg);
    可以在文件段上添加一个回调函数，当文件段的最后一个引用被释放，并且文件段被释放时，该回调函数被调用。
该回调函数决不能在试图重新将该文件段添加到任何buffer上。

19. 通过引用将evbuffer添加到另一个evbuffer中
可以通过引用将evbuffer添加到另一个evbuffer中：而不是移动一个evbuffer中内容到另一个evbuffer中，当将evbuffer的引用添加到另一个evbuffer中时，它的行为类似于复制了所有字节。

int evbuffer_add_buffer_reference(struct evbuffer *outbuf, struct evbuffer *inbuf);
    evbuffer_add_buffer_reference函数的行为类似于复制outbuf中的所有数据到inbuf中，但是它却不会执行
 任何不必要的复制。
 # 该函数成功时返回0，失败是返回-1。
注意，inbuf内容后续的变化将不会反馈到outbuf中：该函数是通过引用添加evbuffer当前的内容，而不是evbuffer本身。
注意，不能嵌套buffer的引用：如果一个evbuffer是evbuffer_add_buffer_reference函数中的outbuf，则其不能作为
      另一个的inbuf。

20. 使一个evbuffer仅能添加或者仅能移除
int  evbuffer_freeze(struct  evbuffer  *buf,  int at_front);
int  evbuffer_unfreeze(struct  evbuffer  *buf,  int at_front);
    可以使用这些函数暂时性的禁止evbuffer前端或后端的改变。bufferevent会在内部使用这些函数，
用来防止输出缓冲区前端，或者输入缓冲区后端的意外改变。
   
}

listen(链接监听器接受TCP链接){
evconnlistener机制提供了监听并接受TCP链接的方法。除非特别注明，本章的所有函数和类型都在event2/listener.h中声明。
1. 创建或释放evconnlistener
struct evconnlistener *evconnlistener_new(struct event_base *base,
                                          evconnlistener_cb cb, 
                                          void *ptr, 
                                          unsigned flags, 
                                          int backlog,
                                          evutil_socket_t fd);

# listener = evconnlistener_new_bind(base, listener_accept_cb, NULL,
#                                   LEV_OPT_CLOSE_ON_FREE|LEV_OPT_REUSEABLE,
#                                   -1, (struct sockaddr *)&saddr, sizeof(saddr));
struct evconnlistener *evconnlistener_new_bind(struct event_base *base,
                                               evconnlistener_cb cb,  
                                               void *ptr,  
                                               unsigned flags,  
                                               int backlog,
                                               const struct sockaddr *sa,  
                                               int socklen);
void evconnlistener_free(struct evconnlistener *lev);
    两个evconnlistener_new*函数都是分配并返回一个新的链接监听器对象。链接监听器使用event_base，
在给定监听socket上监听新的TCP链接的到来。当一个新的链接到来时，它调用给定的回调函数。

base参数是监听器用来监听链接的event_base。
cb函数  是新链接到来时需要调用的回调函数； # 如果cb为NULL，则直到设置了回调函数为止，监听器相当于被禁用。
ptr指针 传递给回调函数。
flag参数控制监听器的行为 # 可以使用or运算将任意数量的标志绑定在一起
LEV_OPT_LEAVE_SOCKETS_BLOCKING：默认情况下，当链接监听器接收一个新的到来的socket时，会将其置为非阻塞状态，
                                从而方便libevent后续的操作。如果设置了该标志，则会禁止这种行为。
LEV_OPT_CLOSE_ON_FREE：         如果设置了该标志，则链接监听器会在释放时关闭底层的socket。
LEV_OPT_CLOSE_ON_EXEC：         设置该标志，链接监听器会在底层监听socket上设置"执行时关闭"(close-on-exec)标志。
                                详细信息可以参考操作系统手册中的fcntl和FD_CLOEXEC部分。
LEV_OPT_REUSEABLE：             默认情况下在某些平台上，当一个监听socket关闭时，只有经过一定时间之后，
                                其他的socket才能绑定到相同的端口上。设置该标志可以使libevent标志该socket为
                                可重复使用的，因此一旦它关闭了，则其他socket可以在同一个端口上进行监听。
LEV_OPT_THREADSAFE：            为监听器分配锁，因此可以在多线程中安全的使用。
LEV_OPT_DISABLED：              将监听器初始化为禁止状态。可以通过函数evconnlistener_enable手动将其使能。
LEV_OPT_DEFERRED_ACCEPT：       设置该标志，则告知内核，直到接收到对端数据，并且本地socket准备好读取之前，
                                不通知socket接收新链接。
    如果网络协议并非以客户端传递数据为开始，则不要使用该标志，因为这样有时会使得内核永远不通知新链接的到来。
并非所有系统都支持该标志：在那些不支持的系统上，该标志没有任何作用。

backlog参数表示在任何时刻，网络栈所允许的等待在"未接受"(not-yet-accepted)状态的挂起链接的最大个数。
  如果backlog为负数，则libevent会自行选择一个比较好的backlog值；
  如果该值为0，则libevent认为你已经在给定的socket上调用过listen函数了。

evconnlistener_new函数假定已经在希望监听的端口上绑定了socket，也就是fd参数。
如果希望libevent分配并绑定自己的socket，则可以调用evconnlistener_new_bind函数，并且传递一个希望绑定的sockaddr地址及其长度。
释放一个链接监听器，调用evconnlistener_free函数。

    注意：使用evconnlistener_new函数时，确定已经通过evutil_make_socket_nonblocking或者手动设置socket选
项，将监听socket设置为非阻塞模式。如果监听socket处于阻塞模式，则会有未定义的行为发生。
    
1.2 链接监听器的回调函数
typedef void (*evconnlistener_cb)(struct evconnlistener *listener,
                                  evutil_socket_t sock,  
                                  struct sockaddr *addr,  
                                  int len, 
                                  void *ptr);
    当新的链接到来时，就会调用回调函数。其中的listener参数就是接收链接的链接监听器，sock参数就是
新的socket本身。addr和len就是链接对端的地址及其长度。ptr就是用户提供的传递给evconnlistener_new函数的参数。

1.3 将evconnlistener使能和禁止
int evconnlistener_disable(struct evconnlistener *lev);
int evconnlistener_enable(struct evconnlistener *lev);
    这些函数可以将evconnlistener暂时的使能或禁止。
    
1.4 调整evconnlistener的回调函数
void evconnlistener_set_cb(struct evconnlistener *lev,
                           evconnlistener_cb cb,  
                           void *arg);
    该函数改变evconnlistener的回调函数及其参数。
    
1.5 监测evconnlistener
evutil_socket_t evconnlistener_get_fd(struct evconnlistener *lev);
struct event_base *evconnlistener_get_base(struct evconnlistener *lev);
    这些函数返回监听器的socket和event_base。

1.6 检测错误
    可以在监听器上设置错误回调函数，当accept调用失败时，就会调用该函数。当你遇到一个错误，
而且解决该错误之前进程会一直锁住的话，这种机制是很有用的。
typedef void (*evconnlistener_errorcb)(struct  evconnlistener *lis, void *ptr);
void evconnlistener_set_error_cb(struct evconnlistener *lev,
                                 evconnlistener_errorcb errorcb);

    如果使用evconnlistener_set_error_cb函数设置了错误回调函数，则在监听器上，每次发生错误时
都会调用该函数。监听器会作为第一个参数，传递给evconnlistener_new的ptr作为第二个参数。
}
resolv(dns:可移植的阻塞型域名解析){
struct evutil_addrinfo {int ai_flags;
                        int ai_family;
                        int ai_socktype;
                        int ai_protocol;
                        size_t ai_addrlen;
                        char *ai_canonname;
                        struct sockaddr *ai_addr;
                        struct evutil_addrinfo *ai_next;
};
#define  EVUTIL_AI_PASSIVE     /* ... */
#define  EVUTIL_AI_CANONNAME   /* ... */
#define  EVUTIL_AI_NUMERICHOST /* ... */
#define  EVUTIL_AI_NUMERICSERV /* ... */
#define  EVUTIL_AI_V4MAPPED    /* ... */
#define  EVUTIL_AI_ALL         /* ... */
#define  EVUTIL_AI_ADDRCONFIG  /* ... */

int evutil_getaddrinfo(const char *nodename, 
                       const char *servname,
                       const struct evutil_addrinfo *hints, 
                       struct evutil_addrinfo **res);
void evutil_freeaddrinfo(struct evutil_addrinfo *ai);
const char *evutil_gai_strerror(int err);
    evutil_getaddrinfo函数尝试根据hints中的规则，解析nodename和servname，并在evutil_addrinfo结构的链表
res中返回解析的结果。
# 该函数返回0表示成功，失败时返回一个非0的错误码。
    nodename和servname两者必须提供一个，
如果提供了nodename，则它可以是一个文字型的IPv4地址(类似于"127.0.0.1")，
                          或者一个文字型的IPv6地址(比如"::1")，
                          或者是一个域名(比如"www.example.com")。
如果提供了servname，则它既可以是网络服务的符号名称(比如"https")，
                    或者是一个十进制端口号的字符串(比如"443")。
如果没有指定servname，则在*res中，端口号将置为0。
如果不指定nodename，则*res中的地址要么是默认的本地地址，要么是"any"(如果设置了EVUTIL_AI_PASSIVE的话)

hints中的ai_flags字段提示evutil_getaddrinfo如何进行查找。它可以是0，或者是下列标志的组合：
EVUTIL_AI_PASSIVE：该标志表明，解析的地址将用来被动监听，而不是主动建链。
                   一般情况下两者没有区别，除非nodename为NULL：对于主动建链来说，一个为NULL的nodename意味着
                   本地地址(127.0.0.1或::1)，而对于被动监听来说，一个为NULL的nodename意味着ANY(0.0.0.0或::0).
EVUTIL_AI_CANONNAME：如果设置了该标志，则会尝试在ai_canonname字段报告主机的规范名称。
EVUTIL_AI_NUMERICHOST：如果设置了该标志，则仅会解析数字型的IPv4以及IPv6地址；
                       如果nodename是一个需要解析的域名的话，则该函数会返回EVUTIL_EAI_NONAME错误。
EVUTIL_AI_NUMERICSERV：如果设置了该标志，则仅会解析数字型的服务名，
                       如果servname既不是NULL，也不是十进制整数的话，则返回EVUTIL_EAI_NONAME错误。        
EVUTIL_AI_V4MAPPED：该标志表明，如果ai_family为AF_INET6，并且没有发现IPv6地址的话，
                    则会将任一IPv4地址返回为一个v4映射（v4-mapped）的IPv6地址。除非操作系统支持，
                    否则当前的evutil_getaddrinfo不支持该标志。
EVUTIL_AI_ALL：如果将该标志和EVUTIL_AI_V4MAPPED一起设置，则结果集中的IPv4地址都将返回为v4映射的IPv6地址，
               而不管是否找到了IPV6地址。除非操作系统支持，否则当前的evutil_getaddrinfo不支持该标志。
EVUTIL_AI_ADDRCONFIG：设置了该标志，则只有在系统具有非本地IPV4地址的时候，结果集中才包含IPv4地址，
                      并且只有在系统具有非本地的IPv6地址的时候，结果集中才包含IPv6地址。

hints中的ai_family字段用来告知evutil_getaddrinfo返回何种地址类型。
设置为AF_INET，则仅返回IPv4地址，
设置为AF_INET6，则仅返回IPv6地址，
设置为AF_UNSPEC，则返回所有可能的地址。

hints中的ai_socktype和ai_protocol字段用来告知evutil_getaddrinfo如何使用这些地址。
他们类似于传递给socket函数的socktype和protocol参数。

    如果evutil_getaddrinfo执行成功，则返回一个evutil_addrinfo结构的链表res，每个结构中的ai_next指针指向
下一个结构。这种链表是在堆中分配的，所以需要使用evutil_freeaddrinfo函数进行释放。

如果该函数执行失败，则返回下列数字错误码：
EVUTIL_EAI_ADDRFAMILY：请求的地址族对于nodename来说没有意义。
EVUTIL_EAI_AGAIN：在域名解析过程中发生了可恢复的错误，可以过后再次尝试。
EVUTIL_EAI_FAIL：域名解析过程中发生了不可恢复的错误，DNS服务器或者解析器可能已经崩溃了。
EVUTIL_EAI_BADFLAGS：hints中的ai_flags无效。
EVUTIL_EAI_FAMILY：不支持hints中的ai_family字段。
EVUTIL_EAI_MEMORY：解析过程中内存不足。
EVUTIL_EAI_NODATA：请求的主机虽然存在，但是却没有地址信息(或者对于请求的类型，没有相应的地址信息。)
EVUTIL_EAI_NONAME：请求的主机不存在。
EVUTIL_EAI_SERVICE：请求的服务不存在。
EVUTIL_EAI_SOCKTYPE：不支持请求的socket类型，或者它与ai_protocol不匹配。
EVUTIL_EAI_SYSTEM：域名解析过程中发生了其他系统错误，可以通过查看errno获得更多信息。
EVUTIL_EAI_CANCEL：DNS请求过程应该在完成之前被取消。evutil_getaddrinfo从不返回该错误，但是在下面介绍的evdns_getaddrinfo中可能会返回该错误。
可以通过evutil_gai_strerror函数，将这些错误码转换为一个可读的字符串信息。

注意：  如果操作系统定义了addrinfo结构，则evutil_addrinfo结构仅仅是操作系统内部结构的别名。
类似的，如果操作系统定义了任何AI_*标志，则相应的EVUTIL_AI_*标志也是他们的别名；
        如果操作系统定义了EAI_*错误，则相应的EVUTIL_EAI_*错误码等价于原始错误码。
}

https://www.monkey.org/~provos/libevent/doxygen-2.0.1/dns__compat_8h.html
resolv(dns:使用evdns_getaddrinfo进行非阻塞的域名解析){
typedef void (*evdns_getaddrinfo_cb)(
              int result, 
              struct evutil_addrinfo *res,  
              void *arg);
struct evdns_getaddrinfo_request;
struct evdns_getaddrinfo_request *evdns_getaddrinfo(struct evdns_base *dns_base,
                                                    const char *nodename, 
                                                    const char *servname,
                                                    const struct evutil_addrinfo *hints_in,
                                                    evdns_getaddrinfo_cb cb,  
                                                    void *arg); # NULL表示函数调用失败或成功--未阻塞；非NULL表示阻塞
void  evdns_getaddrinfo_cancel(struct  evdns_getaddrinfo_request  *req);
    evdns_getaddrinfo函数类似于evutil_getaddrinfo，除了它在请求DNS服务器时不阻塞，它使用libevent的
底层DNS功能来进行域名解析。因为可能无法立即返回结果，因此需要提供一个evdns_getaddrinfo_cb类型的回调函数，
并提供一个该回调函数的可选的用户提供的参数。
    另外，需要提供给evdns_getaddrinfo函数一个指向evdns_base的指针。该结构保存DNS解析器的状态和配置。
    如果evdns_getaddrinfo函数即刻成功，或者即刻失败，则其返回NULL。否则，它返回一个指向evdns_getaddrinfo_request
结构的指针，可以使用该指针，调用evdns_getaddrinfo_cancel函数，在请求结束前的任意时刻取消DNS请求。
# 注意，不管evdns_getaddrinfo函数返回NULL与否，也不管evdns_getaddrinfo_cancel是否调用，回调函数终将都会被调用。
    调用evdns_getaddrinfo函数时，对于nodename，servname以及hints参数，它都有自己的内部拷贝：在名称查找的
过程中，无需保证他们一直存在。
}
resolv(创建并配置evdns_base){
    在使用evdns进行非阻塞的DNS解析之前，需要对evdns_base进行配置。每一个evdns_base保存
一个域名服务器的列表，以及DNS配置选项，它对正在进行的DNS请求进行跟踪。
struct evdns_base *evdns_base_new(struct event_base *event_base, int initialize);
void  evdns_base_free(struct evdns_base *base, int fail_requests);
# evdns_base_new函数成功时返回一个新的evdns_base结构，失败时返回NULL。
    如果参数initialize为1，则该函数会根据操作系统的默认值合理的配置evdns_base。
    如果参数initialize为0，则会将evdns_base置空，不包含任何域名服务器以及配置选项。
    当不再需要evdns_base的时候，可以使用evdns_base_free将其释放。如果其fail_requests参数为真，
则在释放base之前，会使所有进行中的请求以错误码EVUTIL_EAI_CANCEL来调用他们的回调函数。
    
1：根据系统配置初始化evdns
如果需要对evdns_base如何初始化进行更多的控制，可以将initialize参数设置为0调用evdns_base_new，并调用下列函数：
#define  DNS_OPTION_SEARCH  1
#define  DNS_OPTION_NAMESERVERS  2
#define  DNS_OPTION_MISC  4
#define  DNS_OPTION_HOSTSFILE  8
#define  DNS_OPTIONS_ALL  15
int evdns_base_resolv_conf_parse(struct evdns_base *base, 
                                 int flags,
                                 const char *filename);
#ifdef  WIN32
int  evdns_base_config_windows_nameservers(struct  evdns_base *);
#define  EVDNS_BASE_CONFIG_WINDOWS_NAMESERVERS_IMPLEMENTED
#endif

    evdns_base_resolv_conf_parse函数将会扫描resolv.conf格式的文件filename，并从该文件
中读取flags中列出的选项。(关于resolv.conf文件的更多信息，可以参考本地的Unix操作手册)
    DNS_OPTION_SEARCH：使evdns从resolv.conf文件中读取domain和search字段以及ndots选项，
并且根据这些字段决定用哪一个domain(如果有的话)来搜索不是全限定的主机名。
    DNS_OPTION_NAMESERVERS：该标志使evdns从resolv.conf文件中获取域名服务器。
    DNS_OPTION_MISC：该标志使evdns从resolv.conf文件中获取其他配置选项。
    DNS_OPTION_HOSTSFILE：该标志使evdns从/etc/hosts中读取主机列表，作为加载resolv.conf文件的一部分。
    DNS_OPTIONS_ALL：使evdns从resolv.conf文件中获取尽可能多的选项。
    在Windows上，因为没有resolv.conf文件指示域名服务器在哪，可以使用evdns_base_config_windows_nameservers函数
从注册表(或者NetworkParams，或者其他地方)中读取所有的域名服务器。

2：resolv.conf文件格式
    resolv.conf格式的文件是一个文本文件，每一行要么是空行，要么是以"#"开头的注释，
要么是包含若干参数的关键字。支持的关键字如下：
nameserver：后面跟着一个域名服务器的IP地址。作为扩展，libevent允许为域名服务器指定一个非标准的端口，使用IP:Port或者[IPv6]:port这种格式。
domain：    本地域名
search：    在解析本地主机名时，需要搜索的名字列表。包含少于ndots个点的名字会被认为是本地的，而且如果不能正确解析的话，则会在这些域名中进行查找。比如，如果search为example.com，并且ndots为1的话，如果用户需要解析www，则会将其当做www.example.com。
options：   一些以空格分割的选项。每一个选项要么是一个空字符串，要么是option:value格式。支持下列options：
ndots:INTEGER，用来配置search，参照上面"search"，默认值为1.
timeout:FLOAT，在请求DNS服务器时，等待的超时时间，以秒数为单位。默认为5秒。
max-timeouts:INT，DNS服务器超时几次才认为DNS服务器宕机，默认为3次。
max-inflight:INT：最多允许多少个未决的DNS请求(如果请求数过多，则多余的请求会阻塞，直到先前的请求应答了或者超时了)，默认为64.
attempts:INT，放弃之前，尝试发送DNS请求的次数，默认为3.
randomize-case:INT，如果非零，evdns会为发出的DNS请求设置随机的事务ID，并且确认回应具有同样的随机事务ID值。这种称作“0x20 hack”的机制可以在一定程度上阻止对DNS的简单激活事件攻击。这个选项的默认值是1。（存疑）
bind-to:ADDRESS，如果提供了该选项，则在发送请求到域名服务器时，会绑定到给定的地址。对于libevent2.0.4-alpha版本，该选项只应用在后面的域名服务器选项上。
initial-probe-timeout:FLOAT，当发现一个域名服务器down掉时，以指数抵减的频率探测其是否启动。该选项配置一系列超时时间的第一个超时时间，以秒为单位，默认为10。
getaddrinfo-allow-skew:FLOAT，当evdns_getaddrinfo同时请求IPv4地址以及IPv6地址时，它会在分离的DNS请求报文中进行，因为一些服务器无法在一个包中同时处理两种请求。一旦它对于一种地址类型有了回应，它会等待一段时间看另一个答案是否已经到达。该选项配置这段时间的长度，以秒为单位，默认为3秒。
不识别的符号和选项都会被忽略。

3：手动配置evdns
如果需要更加细粒度的控制evdns的行为，可以使用下列函数：
int evdns_base_nameserver_sockaddr_add(struct evdns_base *base,
                                       const struct sockaddr *sa, 
                                       ev_socklen_t len,
                                       unsigned  flags);  # 该函数成功是返回0，失败时返回负数。
int evdns_base_nameserver_ip_add(struct evdns_base *base,
                                 const char *ip_as_string);  # 该函数成功时返回0，失败时返回负数。
int evdns_base_load_hosts(struct evdns_base *base, 
                           const char *hosts_fname);   # 该函数成功时返回0，失败时返回负数。
void evdns_base_search_clear(struct evdns_base *base);
void evdns_base_search_add(struct evdns_base *base, 
                           const char *domain);
void evdns_base_search_ndots_set(struct evdns_base *base, 
                                 int ndots);
int evdns_base_set_option(struct evdns_base *base, 
                          const char *option,
                          const char *val);
int  evdns_base_count_nameservers(struct evdns_base *base);

    evdns_base_nameserver_sockaddr_add函数通过socket地址的形式，向evdns_base添加一个域名服务器。
flags参数目前是被忽略的，而且为了向前兼容性应该置为0。

    evdns_base_nameserver_ip_add函数也是向evdns_base添加域名服务器。不过它是以字符串的形式添加，
该字符串可以是一个IPv4地址，一个IPv6地址，一个有端口号的IPv4地址（IPv4:Port），
                      或者一个有端口号的IPv6地址（[IPv6]：port）。

    evdns_base_load_hosts函数从hosts_name中加载一个主机文件（类似于/etc/hosts的格式）。
    
    evdns_base_search_clear函数从evdns_base中清除所有当前的search后缀（就像search选项中配置的那样）；
evdns_base_search_add函数则增加一个后缀。
    evdns_base_set_option函数向evdns_base添加一个选项key和该选项的值value，key和value都是字符串的形式。
 （2.0.3版本之前，选项名后面必须有一个冒号）
    解析一系列的配置文件之后，如果希望看到是否已经添加了域名服务器，可以使用evdns_base_count_nameservers
查看有多少个域名服务器。

可以传递给回调函数的错误码如下：
错误码             意义
DNS_ERR_NONE        没有错误发生
DNS_ERR_FORMAT      服务器无法理解该请求
DNS_ERR_SERVERFAILED服务器发生了内部错误
DNS_ERR_NOTEXIST    对于给定的name，没有record
DNS_ERR_NOTIMPL     服务器无法理解该类型的请求
DNS_ERR_REFUSED     因策略设置，服务器决绝该请求
DNS_ERR_TRUNCATED   DNS 记录不适合UDP报文
DNS_ERR_UNKNOWN     未知的内部错误
DNS_ERR_TIMEOUT     请求超时
DNS_ERR_SHUTDOWN    用户要求关闭evdns系统
DNS_ERR_CANCEL      用户要求取消这次请求
DNS_ERR_NODATA      虽然收到了响应，但是其中却没有包含答案

4. 库端的配置
libevent提供了一对函数可以对evdns模块进行库级别的设置：
typedef  void (*evdns_debug_log_fn_type)(int  is_warning,  const  char  *msg);
void  evdns_set_log_fn(evdns_debug_log_fn_type  fn);
void  evdns_set_transaction_id_fn(ev_uint16_t  (*fn)(void));
由于历史的原因，evdns子系统具有其自己独立的日志功能；可以使用evdns_set_log_fn函数添加回调函数，对消息进行处理。
出于安全性的考虑，evdns需要一个好的随机数源：在使用“0x20 hack”时，它被用来获取难以被猜中的事务ID，从而用来随机化查询
（参考“randomize-case”选项）。然而老版本的Libevent，并没有提供一个安全的RNG。可以通过调用evdns_set_transaction_id_fn ，
并向其提供一个能够返回难以预测的2字节无符号整数的函数，来为evdns设置一个更好的随机数产生器
}
dns(DNS服务器接口){
1：创建和关闭DNS服务器
struct evdns_server_port *evdns_add_server_port_with_base(
    struct event_base *base,
    evutil_socket_t socket,
    int flags,
    evdns_request_callback_fn_type callback,
    void *user_data);

typedef void (*evdns_request_callback_fn_type)(
    struct evdns_server_request *request,
    void *user_data);

void evdns_close_server_port(struct evdns_server_port *port);
    调用evdns_add_server_port_with_base开始监听DNS请求。该函数的参数有：一个处理事件的event_base，
一个用来监听的UDP socket，flags变量（目前总是为0）；当收到新的DNS请求时调用的回调函数；一个用户提供
的回调函数的参数指针。该函数返回一个新的evdns_server_port对象。
    当DNS 服务器的工作完成时，可以将该对象传递给evdns_close_server_port函数进行关闭。

2：检测DNS请求
    不幸的是，Libevent目前没有为通过可编程的接口来获取DNS请求提供一个很好的方式。相反的，需要包含event2/dns_struct.h，
并且手动检测evdns_server_quest结构。
    将来版本的Libevent如果能提供一个更好的操作方式的话就好了。
struct  evdns_server_request {
    int  flags;
    int  nquestions;
    struct  evdns_server_question  **questions;
};

#define  EVDNS_QTYPE_AXFR  252
#define  EVDNS_QTYPE_ALL   255
struct  evdns_server_question {
    int  type;
    int  dns_question_class;
    char  name[1];
};
请求的flags字段包含了请求中设置的DNS标志；nquestions是请求中包含的问题数；questions是指向结构体evdns_server_question的指针数组。
每一个evdns_server_question都包含了请求的资源类型（参考下面的EVDNS_*_TYPE宏），请求的类型（典型的是EVDNS_CLASS_INET）以及请求主机名的名称。
int  evdns_server_request_get_requesting_addr(struct evdns_server_request  *req,
struct  sockaddr  *sa,  int addr_len);
    有时需要知道某特定的DNS请求来自何方。可以通过调用函数evdns_server_request_get_requestion_addr函数来获得。
需要传递一个足够大小的sockaddr来保存地址：建议使用sockaddr_storage结构。

3：响应DNS请求
    DNS服务器每收到一个请求，都会将该请求，连同用户提供的指针，一起传递到回调函数中。该回调函数必须要么能响应请求或者忽略请求，
要么保证该请求最终会被应答或者忽略。
在应答请求之前，可以向应答中添加一个或多个答案：

int  evdns_server_request_add_a_reply(struct  evdns_server_request  *req,
    const  char  *name, int  n,  const void  *addrs,  int  ttl); # 这些函数成功时返回0，失败时返回-1。
int  evdns_server_request_add_aaaa_reply(struct  evdns_server_request  *req,
    const  char  *name, int  n,  const void  *addrs,  int  ttl); # 这些函数成功时返回0，失败时返回-1。
int  evdns_server_request_add_cname_reply(struct  evdns_server_request  *req,
    const  char  *name, const  char  *cname, int  ttl);      # 这些函数成功时返回0，失败时返回-1。
上述函数会添加一个单独的RR（A，AAAA类型或者CNAME）到req请求的应答中。每个函数中，
参数name就是要添加到答案中的主机名，
ttl就是答案中的生存时间秒数。
对于A以及AAAA记录来说，n就是需要添加的地址个数，addrs是指向原始地址的指针，
    它要么是在A记录中的4字节的IPv4地址，要么是AAAA记录中的16字节的IPv6地址。

int  evdns_server_request_add_ptr_reply(struct  evdns_server_request  *req,
    struct  in_addr  *in,  const  char  *inaddr_name, const  char  *hostname,
    int  ttl);
    该函数向请求的应答中添加一个PTR记录。req和ttl参数类似于上面的参数。
必须以一个in（IPv4地址）或者inaddr_name（在.arpa域中的地址）表明要应答的那个地址。hostname参数就是PTR查询的答案。

#define  EVDNS_ANSWER_SECTION  0
#define  EVDNS_AUTHORITY_SECTION  1
#define  EVDNS_ADDITIONAL_SECTION  2

#define  EVDNS_TYPE_A       1
#define  EVDNS_TYPE_NS      2
#define  EVDNS_TYPE_CNAME   5
#define  EVDNS_TYPE_SOA     6
#define  EVDNS_TYPE_PTR    12
#define  EVDNS_TYPE_MX     15
#define  EVDNS_TYPE_TXT    16
#define  EVDNS_TYPE_AAAA   28

#define  EVDNS_CLASS_INET   1

int  evdns_server_request_add_reply(struc tevdns_server_request  *req,
    int  section, const  char  *name,  int type,  int  dns_class,  int  ttl,
    int  datalen, int  is_name,  const  char *data);
    该函数向req请求的DNS应答添加任意的RR。section参数表明需要添加哪一部分，而且该值必须是EVDNS_*_SECTION的其中之一。
name参数是RR中的name字段。type参数是RR中的type字段，而且可能的话应该是EVDNS_TYPE_*的其中之一。
dns_class参数是RR中的class字段，而且一般应该是EVDNS_CLASS_INET。
ttl参数是RR中的存活时间字段。RR中的rdata和rdlength字段将会由data中的datalen个字节产生。
如果is_name为true，则data将会编码为一个DNS名，否则，它将按照字面意思包含到RR中。

int  evdns_server_request_respond(struct  evdns_server_request  *req,  int err);
int  evdns_server_request_drop(struct  evdns_server_request  *req);
    evdns_server_request_respond函数发送一个DNS回应，包含所有RRs，以及错误码err。
如果收到一个不想应答的请求，可以通过调用evdns_server_request_drop函数忽略它，从而可以释放所有相关内存以及记录结构。

#define  EVDNS_FLAGS_AA 0x400
#define  EVDNS_FLAGS_RD 0x080
void  evdns_server_request_set_flags(struct  evdns_server_request  *req,  int flags);
如果需要在应答消息中设置任何标志，可以在发送应答之前的任意时间调用该函数。
}

https://www.monkey.org/~provos/libevent/doxygen-2.0.1/http_8h.html
http(){

}
event_init(废弃中){
初始化event_base结构体，赋值全局current_base
struct event_base *event_init(void);
由于该函数依赖全局变量current_base，在多线程中使用不安全，已被event_base_new()函数替代。
}
event_base_new(多线程更新){
创建默认的event_base
struct event_base *event_base_new(void)
}
event_base_new_with_config(获得一个复杂的event_base){
1. event_config配置管理
struct event_config *event_config_new(void);
struct event_base *event_base_new_with_config(const struct event_config *cfg);
void event_config_free(struct event_config *cfg);
这几个函数的基本功能就是：获得一个config，配置好后作为event_base创建的参数。用完后记得将config给free掉。
而配置config则需要用到要以下两个函数：

int event_config_require_features(struct event_config *cfg, enum event_method_feature feature);
这里的枚举值有以下几个：
EV_FEATURE_ET：需要边沿触发的I/O
EV_FEATURE_OI：在add和delete event的时候，需要后端(backend)方法
EV_FEATURE_FDS：需要能够支持任意文件描述符的后端方法
上述的值都是mask，可以位与(|)。

int event_config_set_flag(struct event_config *cfg, enum event_base_config_flag flag);
这里的枚举值有以下几个：
EVENT_BASE_FLAG_NOLOCK：event_base不使用lock初始化
EVENT_BASE_FLAG_IGNORE_ENV：挑选backend方法时，不检查EVENT_xxx标志。这个功能慎用
EVENT_BASE_FLAG_STARTUP_IOCP：仅用于Windows。起码我不关心
EVENT_BASE_FLAG_NO_CACHE_TIME：不检查timeout，代之以为每个event loop都准备调用timeout方法。这会导致CPU使用率偏高
EVENT_BASE_FLAG_EPOLL_USE_CHANGELIST：告诉libevent如果使用epoll的话，可以使用基于"changlist"的backend。
EVENT_BASE_FLAG_PRECISE_TIMER：使用更加精确的定时机制
以上两个函数成功时返回0，失败时返回-1；

2. 设置event_base的分离时间
int event_config_set_max_dispatch_interval (
                        struct event_config   *cfg,
                        const struct timerval *mac_interval,
                        int                    max_callbacks,
                        int                    min_priority);
    在检查高优先级的event之前，通过限制低优先级调用来防止优先级反转(priority inversion)。
而另一个限制条件是max_interval参数，这是表示高优先级事件被调用的最大延时。
成功时返回0，失败时返回-1。默认情况下，'event_base'被设置成默认优先级.

3. 检查event_base的backend方法
const char **event_get_supported_methods(void);
返回一个char*数组，说明了libevent支持的所有backend方法。数组以NULL结尾。

4. 读取指定event_base的配置
const char *event_base_get_method (const struct event_base *base);
enum event_method_feature event_base_get_features (const struct event_base *base);

5. 释放一个event_base资源
int event_base_priority_init (structr event_base *base, int n_priorities);
第二个参数表示可支持的优先级，至少为1。0是最优先。这样，event_base中的优先级即为0 ~ nPriorities-1。
　　最大支持的优先级数为EVENT_MAX_PRIORITIES。
int event_base_get_npriorities(struct event_base *base);
上一个函数的读版本
}

event_base_gettimeofday_cached(检查event_loop内部的时间){
int event_base_gettimeofday_cached (struct event_base *base, struct timeval *tv);
int event_base_update_cache_time(struct event_base *base);

获得event_loop时间。第一个函数获得event_loop最近的时间，比较快，但是不精确。
                    第二个函数可以强制event_loop立即同步更新时间。
                    
int evutil_gettimeofday(struct timeval *tv, struct timezone *tz)
}
event_base_dump_events(转储event_base状态){
void event_base_dump_events (struct event_base *base, FILE *f);
    为了调试程序的方便，有时会需要得到所有关联到event_base的events的列表以及他们的状态。
调用event_base_dump_events()可以讲该列表输出到文件f中。
    得到的列表格式是人可读的形式，将来版本 的libevent可能会改变其格式。
}
event_base_foreach_event(event_base中的每个event运行同一个回调函数){
typedef int (*event_base_foreach_Event_cb) (const struct event_base *,
                                            const struct event *,
                                            void *);
int event_base_foreach_event (struct event_base *base,
                              event_base_foreach_Event_cb fn,
                              void *arg);
每一次事件执行都会调用该函数。
    调用函数event_base_foreach_event()，遍历运行与event_base关联的每一个active 或pending的event。
每一个event都会运行一次所提供的回调函数，运行顺序是未指定的。event_base_foreach_event()函数的第三
个参数将会传递给回调函数的第三个参数。
    回调函数必须返回0，才能继续执行遍历。否则会停止遍历。回调函数最终的返回值，
就是event_base_foreach_function函数的返回值。
    回调函数不可修改它接收到的events参数，也不能为event_base添加或删除events，或修改关联到event_base
上的任何events。否则将会发生未定义的行为，甚至是崩溃。
    在调用event_base_foreach_event期间，event_base的锁会被锁住。这样就会阻止其他线程使用该event_base，
因而需要保证提供的回调函数不会运行太长时间。
}

event_dispatch(废弃中){ 事件循环指派
int event_dispatch(void); 不支持多线程
}
event_base_dispatch(更新中){ 线程安全的进行事件循环指派
int event_base_dispatch(struct event_base *base); 支持多线程
    无标志的event_base_loop()函数。因此，直到没有注册的events，或者调用了
event_base_loopbreak()、 event_base_loopexit()，该函数才会返回。

成功返回0 , 出错返回-1 , 如果没有event注册返回1。
}

event_loop(废弃中){ 比event_dispatch()更灵活的进行"事件循环指派"
int event_loop(int flags);
}
event_base_loop(更新中){ 比event_base_dispatch()更灵活的进行"事件循环指派"
等待事件变为活跃，然后运行事件回调函数
相比event_base_dispatch函数，这个函数更为灵活。默认情况下，loop会一直运行到没有等待事件或者激活的事件，或者
运行到调用event_base_loopbreak或者event_base_loopexit函数。你可以使用’flags‘调整loop行为。
参数base：event_base_new或者event_base_new_with_config产生的event_base结构体
flags：
EVLOOP_ONCE：    阻塞直到有活动事件，然后在所有活动事件运行回调后退出 
EVLOOP_NONBLOCK：非阻塞，查看现在准备好哪些事件，运行优先级最高的回调，然后退出
EVLOOP_NO_EXIT： loop一直运行，直到调用相关loop停止函数

返回值：成功则为0，失败则为-1，如果因为没有等待的事件或者激活事件而退出则返回1
1. 信号标记被设置，则调用信号的回调函数
2. 根据定时器最小时间，设置I/O多路复用的最大等待时间，这样即使没有I/O事件发生，也能在最小定时器超时时返回。
3. 调用I/O多路复用，监听事件，将活跃事件添加到活跃事件链表中
4. 检查定时事件，将就绪的定时事件从小根堆中删除，插入到活跃事件链表中
5. 对活跃事件链表中的事件，调用event_process_active()函数，在该函数内调用event的回调函数，优先级高的event先处理
int event_base_loop(struct event_base *base, int flags);

event_base_loop函数返回0表示正常退出，
                   返回-1表示后端方法发生了错误。
                   返回1表示已经没有pending或active状态的events了。
}

int event_base_got_exit(struct event_base *base);
int event_base_got_break(struct event_base *base);
用来判断是否获得了exit或者是break请求。注意返回值实际上应该是BOOL而不是int
event_loopexit(废弃中){
int event_loopexit(struct timeval *tv);
}
event_base_loopexit(指定时间内退出loop){ 使得event_base在经过了给定的超时时间之后，停止运行loop。
如果tv参数为NULL，则event_base会立即停止loop。
如果event_base正在运行active events的回调函数，则只有在运行完所有的回调之后，才停止loop。
int event_base_loopexit(struct event_base *base, struct timeval *tv); # 成功是返回0， 失败时返回-1
}

event_loopbreak(废弃中){
int event_loopbreak(void);
event_base_loopbreak(current_base)
}
event_base_loopbreak(模拟break直接从当前active事件回调中跳出){ 使event_base立即退出loop。
    与event_base_loopexit(base,NULL)不同之处在于，如果event_base当前正在运行任何激活events的回调函数，
则会在当前的回调函数返回之后，就立即退出。
int event_base_loopbreak(struct event_base *base); # 成功是返回0， 失败时返回-1
}
注意，当event loop没有运行时，event_base_loopexit(base, NULL)和 event_base_loopbreak(base)的行为是不同的：
loopexit使下一轮event loop在下一轮回调运行之后立即停止(就像设置了EVLOOP_ONCE一样)，
而loopbreak仅仅停止当前loop的运行，而且在event loop未运行时没有任何效果。

event_base_loopcontinue(){
    一般情况下，libevent会检查events，然后从高优先级的激活events开始运行，然后再次检查events。有时，
你可能希望在运行完当前运行的回调函数之后，告知libevent重新检查events。与event_base_loopbreak()类似，
这可以通过调用event_base_loopcontinue()实现。
    int event_base_loopcontinue(struct event_base *);
    如果当前没有运行events的回调函数的话，则该函数没有任何效果。
}

event_base_set(废弃中){
设置event的所属event_base
int event_base_set(struct event_base *base, struct event *);
将一个event_base关联到event上。
}
event_set(准备一个待添加的event对象){ 相类似的有evtimer_set 和 evsignal_set 
libevent2.0之前的版本中，没有event_assign或者event_new函数，而只有event_set函数，该函数返回的event与
"当前"base相关联。如果有多个event_base，则还需要调用event_base_set函数指明event与哪个base相关联。
void event_set(struct event *event, evutil_socket_t fd, short what,
               void(*callback)(evutil_socket_t,  short,  void *), 
               void *arg);
int event_base_set(struct event_base *base,  struct event *event);
    event_set函数类似于event_assign，除了它使用"当前"base的概念。event_base_set函数改变event所关联的base。
    如果是处理超时或者信号events，event_set也有一些便于使用的变种：evtimer_set类似于evtimer_assign，
而evsignal_set类似于evsignal_assign。

废弃版本              新版本                废弃版本              新版本
timeout_add           evtimer_add           signal_add            evsignal_add        
timeout_set           evtimer_set           signal_set            evsignal_set        
timeout_del           evtimer_del           signal_del            evsignal_del        
timeout_pending       evtimer_pending       signal_pending        evsignal_pending    
timeout_initialized   evtimer_initialized   signal_initialized    evsignal_initialized
                 新增 evtimer_new                            新增 evsignal_new
                 新增 evtimer_assign                         新增 evsignal_assign
                 
废弃版本 timeout_set + timeout_base_set == evtimer_new 或 evtimer_assign

event_set的what值选项：EV_TIMEOUT, EV_SIGNAL, EV_READ, 或 EV_WRITE。 
           what附加值：EV_PERSIST (EV_TIMEOUT, EV_SIGNAL, EV_READ, EV_WRITE)
           what附加值：EV_ET (EV_READ|EV_WRITE)
}

event_base_free(){ event_base_free(NULL) 用以释放current_base回调结构。
释放event_base对象
注意：这个函数不会释放当前与 event_base 关联的任何事件,或者关闭他们的套接字,或者释放任何指针
如果未决的关闭类型的回调，本函数会唤醒这些回调
void event_base_free(struct event_base *base);
}

event_new(分配并且创建一个新的event对象){ 创建待添加的event
根据监听事件类型，文件描述符，以及回调函数，回调函数参数等创建事件结构体                          
base：需要绑定的base                                                                              
fd：需要监听的文件描述符或者信号，或者为-1，如果为-1则是定时事件                                
events：事件类型，信号事件和IO事件不能同时存在                                                    
cb：回调函数，信号发生或者IO事件或者定时事件发生时                                          
arg：传递给回调函数的参数，一般是base
struct event *event_new(struct event_base *base, evutil_socket_t fd, short events, void (*cb)(evutil_socket_t, short, void *), void *arg)
}
event_assign(二进制不兼容){ 准备一个待添加的event
int event_assign(struct event *ev, struct event_base *base, evutil_socket_t fd, short events, void (*callback)(evutil_socket_t, short, v
oid *), void *arg)

  如果在调试模式下使用大量由event_assign(而不是event_new)创建的事件，程序可能
会耗尽内存，这是因为没有方式可以告知libevent 由event_assign创建的事件不会再被使
用了(可以调用event_free告知由event_new创建的事件已经无效了)。如果想在调试时
避免耗尽内存，可以显式告知libevent 这些事件不再被当作已分配的了：
void event_debug_unassign(struct event *ev);

出于性能或者其他原因的考虑，一些人喜欢将event作为一个大的结构体的一部分进行分配。对于这样的event，它节省了：
    内存分配器在堆上分配小对象的开销；
    event指针的解引用的时间开销；
    如果event没有在缓存中，缓存不命中的时间开销。
这种方法的风险在于，与其他版本的libevent之间不满足二进制兼容性，他们可能具有不同的event大小。
    这些开销都非常小，对于大多数应用来说是无关紧要的。除非确定知道，应用程序因为使用堆分配的event而
存在严重的性能损失，否则应该坚持实用event_new。如果后续版本的libevent使用比当前libevent更大的event结构，
那么使用event_assign有可能会导致难以诊断的错误。
int  event_assign(struct  event * event, struct  event_base * base,
                  evutil_socket_t fd,  short  what,
                  void(*callback)(evutil_socket_t,  short,  void *),  void * arg);
event_assign的参数与event_new相同，除了event参数，该参数指针必须指向一个未初始化的event。
该函数成功时返回0，失败时返回-1.
    警告：
    对于已经在event_base中处于"挂起"状态的event，永远不要调用event_assign。这样做会导致极为难以诊断的错误。
    如果event已经初始化，并且处于"挂起"状态，那么在调用event_assign之前应该先调用event_del。
    
    对于使用event_assign分配的纯超时event或者信号event，同样有方便的宏可以使用：
#define evtimer_assign(event,  base,  callback, arg) \
        event_assign(event, base,  -1,  0,  callback,  arg)
#define evsignal_assign(event,  base,  signum, callback,  arg) \
        event_assign(event, base,  signum,  EV_SIGNAL|EV_PERSIST,  callback,  arg)
}

event_callback_fn(event回调函数){
typedef void  (*event_callback_fn)(evutil_socket_t,  short,  void*);

EV_READ | EV_TIMEOUT:
  EV_TIMEOUT : 超时处理
  EV_READ: 1. recv 请求长度 == 读取长度  ~> event_add(arg, &timeout);
           2. recv 请求长度 >  读取长度  -> event_add(arg, &timeout);
           3. recv 读取长度 == -1
           4. recv 结束接收    shutdown(fd, EVUTIL_SHUT_RD);
           
EV_READ | EV_PERSIST:
  EV_READ 1. recv 请求长度 == 发送长度  -> event_del(arg);
          2. recv 请求长度 >  读取长度 
          3. recv 读取长度 == -1
          
EV_WRITE 
  EV_WRITE 1. send 请求长度 == 发送长度  ~> event_add(arg, &timeout);
           2. send 请求长度 >  发送长度  -> event_add(arg, &timeout);
           3. send 发送长度 == -1
           4. send 结束发送    shutdown(fd, EVUTIL_SHUT_WR);
           
EV_WRITE | EV_PERSIST
  EV_WRITE 1. send 请求长度 == 发送长度  -> event_del(arg);
           2. send 请求长度 >  发送长度  
           3. send 发送长度 == -1
           
evtimer_set
          1. 纯timer，不用判断，回调函数what的值肯定等于EV_TIMEOUT
          1.1 evtimer_add(ev[j], &tv);  周期定时器
          1.2 evtimer_del(ev[j]);       一次性定时器
          
EV_TIMEOUT|EV_PERSIST

 
EV_SIGNAL|EV_READ 不能同时被设置
}
evconnlistener_cb(listener回调函数){
typedef void (*evconnlistener_cb)(struct evconnlistener *listener, evutil_socket_t sock, struct sockaddr *addr, int len, void *ptr);
listener参数就是接收链接的链接监听器
sock参数就是新的socket本身
addr和len就是链接对端的地址及其长度
ptr就是用户提供的传递给evconnlistener_new函数的参数

 # 新建基于bufferevent的流
bufferevent_socket_new(base, sock, BEV_OPT_CLOSE_ON_FREE); 
bufferevent_setcb(bev, server_read_cb, NULL, server_event_cb, NULL);
bufferevent_enable(bev, EV_READ|EV_WRITE);

}

bufferevent_data_cb(bufferevent回调函数){
typedef void (*bufferevent_data_cb)(struct bufferevent *bev, void *ctx);

# 获取读缓冲区长度，读写
evbuffer_get_length(bufferevent_get_input(bev)) 
bufferevent_read(bev, &tmp, 1);
bufferevent_write(bev, &tmp, 1);


}
bufferevent_event_cb(bufferevent回调函数){
typedef void (*bufferevent_event_cb)(struct bufferevent *bev, short what, void *ctx);

1. BEV_EVENT_ERROR    bufferevent_free(bev);

2. BEV_EVENT_EOF      bufferevent_free(bev);

3. BEV_EVENT_CONNECTED  bufferevent_write(bev, &tmp, 1); 默认可读
   bufferevent_enable(bev, EV_READ); 使能可写
}


event_add(重复调用会更新超时时间){ 向监听集合添加监听事件
int event_add(struct event *ev, struct timeval *tv);  # 该函数返回0表示成功，返回-1表示失败。
    在"非挂起"状态的events上执行event_add操作，则会使得该event在配置的event_base上变为"挂起"状态。
如果tv为NULL，则该event没有超时时间。否则，tv以秒和毫妙表示超时时间。
    如果在已经是"挂起"状态的event进行event_add操作，则会保持其"挂起"状态，并且会重置其超时时间。
如果event已经是"挂起"状态，而且以NULL为超时时间对其进行re-add操作，则event_add没有任何作用。
    注意：不要设置tv为希望超时事件执行的时间，比如如果置tv->tv_sec=time(NULL)+10，
并且当前时间为2010/01/01，则超时时间为40年之后，而不是10秒之后。

注意: event_add添加event对象的存储期限必须足够长，保证当event处于active状态及以前必须有效。
      event_add添加event对象前需要调用event_set或者event_assign进行初始化；添加后不能再调用event_set或event_assign。
除非event超时或者调用过event_del之后。
      event_add添加event中tv=NULL，表示永久阻塞。
}

event_del(重复调用不会用影响){
从一系列监听的事件中移除事件，函数event_del将取消参数ev中的event。
如果event已经执行或者还没有添加成功，则此调用无效
int event_del(struct event *ev); # 该函数返回0表示成功，返回-1表示失败。
    在已经初始化状态的event上调用event_del，则会将其状态变为"非挂起"以及"非激活"状态。如果event的当前状态
不是"挂起"或"激活"状态，则该函数没有任何作用。
    注意，如果在event刚变为"激活"状态，但是它的回调函数还没有执行时，调用event_del函数，则该操作使得它的
回调函数不会执行。
}
event_remove_timer(){
int event_remove_timer(struct event *ev); # 该函数返回0表示成功，-1表示失败。
    可以在不删除event上的IO事件或信号事件的情况下，删除一个"挂起"状态的event上的超时事件。
1. 如果该event没有超时事件，则event_remove_timer没有作用。
2. 如果event没有IO事件或信号事件，只有超时事件的话，则event_remove_timer等同于event_del。
}

event_once(){
int event_once(int fd, short event, void (*fn)(int, short, void *), void *arg, struct timeval *tv); 
}
event_base_once(event_base自管理event){ 添加个一次性调度，用户不用管理event的生存期
    如果不需要对一个event进行多次添加，或者对一个非持久的event，在add之后就会delete，则可以使用event_base_once函数。
int event_base_once(struct event_base *base,
                     evutil_socket_t    fd,
                     short              what,
                     event_callback_fn  cb,
                     void              *arg,
                     const struct timeval *tv); # 该函数成功时返回0，失败是返回-1.

    event_base_once的参数与event_new一样，不同的是它不支持EV_SIGNAL或EV_PERSIST标志。
得到的内部event会以默认的优先级添加到event_base中并运行。当它的回调函数执行完成之后，
libevent将会释放该内部event。
    通过event_base_once插入的event不能被删除或者手动激活。如果希望可以取消一个event，
则需要通过常规的event_new或event_assign接口创建event。
    注意：如果它们的回调函数的参数具有关联的内存，那么除非程序中进行释放，否则这些内存永远不会被释放。
}

event_pending(查询pending状态){ 
int event_pending(struct event *ev, short event, struct timeval *tv);  # pending和active返回1，nonpending返回0.
    event_pending函数检查给定的event是否处于"挂起"或"激活"状态。如果确实如此，并且在what参数中设置了任何
EV_READ, EV_WRITE, EV_SIGNAL或EV_TIMEOUT标志的话，则该函数返回所有该event当前正在"挂起"或"激活"的标志。
    如果提供了tv_out参数，且在what参数中设置了EV_TIMEOUT参数，并且当前event确实在超时事件上"挂起"或者"激活"，
则tv_out就会设置为event的超时时间。
}
event_active(手动激活event){
    某些极少的情况下，你可能希望在条件未被触发的情况下就激活event；
void event_active (struct event *ev, int what, short ncalls);
    该接口使得event变为"激活"状态，激活标志在what中传入(EV_READ, EV_WRITE和EV_TIMEOUT的组合)。
该event之前的状态不一定非得要是"挂起"状态，而且将其激活不会使其状态变为"挂起"状态。
    警告：在同一个event上递归调用event_active可能会导致资源耗尽。
}
event_initialized(从已清除的内存识别事件){ 检验一个event是否被初始化
    libevent提供了这样的函数，可以从已经清0的内存中(比如以calloc分配，或者通过memset或bzero清除)识别出已初始化的event。
    int  event_initialized(const  struct  event*ev); # 已初始化返回1，否则返回0
#define evsignal_initialized(ev)  event_initialized(ev)
#define evtimer_initialized(ev)  event_initialized(ev)
    警告：这些函数不能在一块未初始化的内存中识别出已经初始化了的event。除非你能确定该内存要么被清0，
要么被初始化为event，否则不要使用这些函数。
    一般情况下，除非你的应用程序有着极为特殊的需求，否则不要轻易使用这些函数。通过event_new返回的
events永远已经初始化过的。
}
event_priority_init(){
设置event_base的优先级个数,并分配base->activequeues
优先级将从0( 最 高 ) 到n_priorities-1(最低)                                                   
int event_priority_init(int npriorities);
int event_base_priority_init(struct event_base *base, int npriorities) 
}
event_priority_set(){
    当多个事件在同一时间触发时，libevent对于他们回调函数的调用顺序是没有定义的。
可以通过优先级，定义某些"更重要"的events。
    每一个event_base都有一个或多个优先级的值。在event初始化之后，添加到event_base之前，
可以设置该event的优先级。
int event_priority_set (struct event *event, int priority);  # 该函数返回0表示成功，返回-1表示失败。
event的优先级数必须是位于0到"event_base优先级"-1这个区间内。
    当具有多种优先级的多个events同时激活的时候，低优先级的events不会运行。libevent会只运行高优先级的events，
然后重新检查events。只有当没有高优先级的events激活时，才会运行低优先级的events。

如果没有设置一个event的优先级，则它的默认优先级是"event_base队列长度"除以2。该函数在文件<event2/event.h>中声明。
}

evtimer(超时事件){
    方便起见，libevent提供了一系列以evtimer_开头的宏，这些宏可以代替event_*函数，来分配和操作纯超时events。
使用这些宏仅能提高代码的清晰度而已。
#define evtimer_new(base,  callback,  arg)   event_new((base), -1, 0, (callback), (arg))
#define evtimer_add(ev,  tv)                 event_add((ev),(tv))
#define evtimer_del(ev)                      event_del(ev)
#define evtimer_pending(ev,  tv_out)         event_pending((ev), EV_TIMEOUT, (tv_out))
}
event_base_init_common_timeout(优化一般性超时){
    当前版本的libevent使用二叉堆算法来对"挂起"状态的event超时时间值进行跟踪。对于有序的添加和删除event
超时时间的操作，二叉堆算法可以提供O(lg n)的性能。这对于添加随机分布的超时时间来说，性能是最优的，但是如果是
大量相同时间的events来说就不是了。
    比如，假设有一万个事件，每一个event的超时时间都是在他们被添加之后的5秒钟。在这种情况下，
使用双向队列实现的话，可以达到O(1)的性能。
    正常情况下，一般不希望使用队列管理所有的超时时间值，因为队列仅对于恒定的超时时间来说是快速的。如果一
些超时时间或多或少的随机分布的话，那添加这些超时时间到队列将会花费O(n)的时间，这样的性能要比二叉堆差多了。
    libevent解决这种问题的方法是将一些超时时间值放置在队列中，其他的则放入二叉堆中。可以向libevent请求一
个"公用超时时间"的时间值，然后使用该时间值进行事件的添加。如果存在大量的event，它们的超时时间都是这种单
一公用超时时间的情况，那么使用这种优化的方法可以明显提高超时事件的性能。
const struct  timeval * event_base_init_common_timeout(
     struct event_base *base,  const  struct  timeval* duration);
    该方法的参数有event_base，以及一个用来初始化的公用超时时间值。该函数返回一个指向特殊timeval结构体的指针，
可以使用该指针表明将event添加到O(1)的队列中，而不是O(lg n)的堆中。这个特殊的timeval结构可以在代码中自由的复制和分配。
该timeval只能工作在特定的event_base上(参数)。不要依赖于该timeval的实际值：libevent仅使用它们来指明使用哪个队列。
}

evtimer_new(){
evtimer_new(b, cb, arg)        event_new((b), -1, 0, (cb), (arg))
}
evtimer_set(){
void evtimer_set(struct event *ev, void (*fn)(int, short, void *), void *arg); 
}
evtimer_add(){
void evtimer_add(struct event *ev, struct timeval *); 
     evtimer_add(ev, tv)                            ; event_add((ev), (tv)) 
}
evtimer_del(){
void evtimer_del(struct event *ev); 
     evtimer_del(ev)              ; event_del(ev)
}
evtimer_pending(){
int evtimer_pending(struct event *ev, struct timeval *tv); 
    evtimer_pending(ev, tv)                              ; event_pending((ev), EV_TIMEOUT, (tv))
}
evtimer_initialized(){
int evtimer_initialized(struct event *ev); 
    evtimer_initialized(ev)              ; event_initialized(ev)
}

evsignal(信号事件){
    libevent也可以监控POSIX类的信号。构建一个信号处理函数，可以使用下面的接口：
#define evsignal_new(base,  signum,  cb,  arg)\
    event_new(base,  signum,  EV_SIGNAL|EV_PERSIST,  cb,  arg)
除了提供一个代表信号值的整数，而不是一个文件描述符之外。它的参数与event_new是一样的。
    struct event * hup_event;
    struct event_base  *base = event_base_new();
    /*call sighup_function on a HUP signal */
    hup_event= evsignal_new(base,  SIGHUP,  sighup_function,  NULL);

对于信号event，同样有一些方便的宏可以使用：
#define evsignal_add(ev,  tv)                 event_add((ev), (tv))
#define evsignal_del(ev)                      event_del(ev)
#define evsignal_pending(ev,  what,  tv_out)  event_pending((ev), (what), (tv_out))

注意：信号回调函数是在信号发生之后，在eventloop中调用的。所以，它们可以调用那些，
       对于普通POSIX信号处理函数来说不是信号安全的函数。
注意：不要在一个信号event上设置超时，不支持这样做。
    警告：当前版本的libevent，对于大多数的后端方法来说，同一时间，每个进程仅能有一个event_base
可以用来监听信号。如果一次向两个event_base添加event，即使是不同的信号，也仅仅会只有一个
event_base可以接收到信号。对于kqueue来说，不存在这样的限制。
}
evsignal_new(){
evsignal_new(b, x, cb, arg) event_new((b), (x), EV_SIGNAL|EV_PERSIST, (cb), (arg))
}
evsignal_assign(){
evsignal_assign(ev, b, x, cb, arg)  event_assign((ev), (b), (x), EV_SIGNAL|EV_PERSIST, cb, (arg))
}
signal_set(){
void signal_set(struct event *ev, int signal, void (*fn)(int, short, void *), void *arg); 
}
signal_add(){
void signal_add(struct event *ev, struct timeval *); 
   evsignal_add(ev, tv)                            ; event_add((ev), (tv))
}
signal_del(){
void signal_del(struct event *ev);
   evsignal_del(ev)              ; event_del(ev) 
}
signal_pending(){
int signal_pending(struct event *ev, struct timeval *tv);
   evsignal_pending(ev, tv)                             ; event_pending((ev), EV_SIGNAL, (tv)) 
}
signal_initialized(){
int signal_initialized(struct event *ev);
  evsignal_initialized(ev)              ; event_initialized(ev)
}

bufferevent(通用的bufferevent操作){ 
void bufferevent_free (struct bufferevent *bev);
释放bfferevent。如果callback是defered的，那么bufferevent会等到callback返回之后才释放。
如果指定了BEV_OPT_CLOSE_ON_FREE，那么socket也会被close掉。

typedef void (*bufferevent_data_cb) (struct bufferevent *bev, void *ctx);
typedef void (*bufferevent_event_cb) (struct bufferevent *bev, short events, void *ctx);
void buffevent_setcb (struct buffevent    *bufev,
                      bufferevent_data_cb  readcb,
                      bufferevent_data_cb  writecb,
                      bufferevent_event_cb eventcb,
                      void                *cbarg);
void bufferevent_get_cb (struct buffevent     *bufev,
                         bufferevent_data_cb  *readcb_ptr,
                         bufferevent_data_cb  *writecb_ptr,
                         bufferevent_event_cb *eventcb_ptr,
                         void                **cbarg_ptr);
设置。获取bufferevent的callback。如果不想使用某个callback，则传入NULL。

void bufferevent_enable (struct bufferevent *bufev, short events);
void bufferevent_disable (struct bufferevent *bufev, short events);
short bufferevent_getenabled (struct bufferevent *bufev);
使能/禁用指定的的callback。默认情况下，刚初始化的bufferevent，write使能，而read禁止。

void bufferevent_setwatermark (struct buffevent *bev,
                               short             events,
                               size_t            lowmark,
                               size_t            highmark);
设置watermark。对于high-watermark，0表示无限。

struct evbuffer *bufferevent_get_input (struct bufferevent *bev);
struct evbuffer *bufferevent_get_output(struct bufferevent *bev);
获取到bufferevent中对应的read/write buffer。

int bufferevent_write (struct bufferevent *ev, const void *data, size_t size);
int bufferevent_write_buffer (struct bufferevent *bev, struct evbuffer *buf);
函数一：直接向bufferevent附加数据
函数二：将evbuffer的全部内容附加到bufferevent中并晴空evbuffer

size_t bufferevent_read (struct bufferevent *bev, void *data, size_t size);
int bufferevent_read_buffer (struct bufferevent *bev, struct evbuffer *buf);
函数一：直接从bufferevent中读出数据，返回数据长度
函数二：将bufferevent中的全部数据抽取到evbuffer中

void bufferevent_set_timeouts (struct bufferevent  *bev,
                               const struct timeval *timeout_read,
                               const struct timeval *timeout_write);
设置timeout，使得当一段时间没有数据时，触发回调函数。此时的实践中会包含 BEV_EVENT_TIMEOUT位

int bufferevent_flush (struct bufferevent *bufev,
                       short               iotype,
                       enum bufferevent_flush_mode state);
强制读/写尽可能多的数据。这个函数目前对socket没有作用。
} 
bufferevent(类型特定的bufferevent函数){
以下几个函数的含义正如字面意思，就不特别说明了
int bufferevent_priority_set (struct bufferevent *bev, int pri);
int bufferevent_get_priority (struct bufferevent *bev);

int bufferevent_setfd (struct bufferevent *bev, evutil_socket_t fd);
evutil_socket_t bufferevent_getfd (struct bufferevent *bev);

struct event_base *bufferevent_get_base (struct bufferevent *bev);
struct bufferevent *bufferevent_get_underlying (struct bufferevent *bev);

void bufferevent_lock   (struct bufferevent *bev);
void buyfferevent_unlock(struct bufferevent *bev);
}
bufferevent(使用基于socket的bufferevent){
1. 创建用于socket的bufferevent
fd: 是一个可选的表示套接字的文件描述符。如果想以后设置文件描述符,可以设置fd为-1
options: 表示 bufferevent 选项(如 BEV_OPT_CLOSE_ON_FREE 等) 的位掩码.
struct bufferevent *bufferevent_socket_new (struct event_base *base,evutil_socket_t    fd,
                        enum bufferevent_options options);
                        BEV_OPT_CLOSE_ON_FREE       释放 bufferevent 时关闭底层传输端口
                        BEV_OPT_THREADSAFE          自动为 bufferevent 分配锁,可以安全地在多个线程中使用 bufferevent
                        BEV_OPT_DEFER_CALLBACKS     设置这个标志时,bufferevent 延迟所有回调
                        BEV_OPT_UNLOCK_CALLBACKS    在执行回调的时候不进行锁定

2. 设置bufferevent回调函数，设置后需要使用bufferevent_enable函数激活
bufferevent_setcb(bev, client_read_cb, NULL, client_event_cb, NULL); 

3. 申请一个非阻塞sockfd，接着就connect sa地址对应的服务器 
这是对connect()的封装。如果bev的fd是-1，那么会自动调用socket()，并且设置nonblock。，随后再异步调用connect()；
如果fd已经指定了，那么只是告诉bev去做connect()操作。正常情况下，这会引起BEV_EVENT_CONNECTED回调     
int bufferevent_socket_connect (struct bufferevent *bev,
                                struct sockaddr    *address,
                                int                 addrlen);

4. 释放bufferevent
bufferevent 内部具有引用计数,所以,如果释放时还有未决的延迟回调,则在回调完成之前 bufferevent 不会被删除。
如果设置了 BEV_OPT_CLOSE_ON_FREE 标志,并且 bufferevent 有一个套接字或者底层 bufferevent 作为其传输端口,
则释放 bufferevent 将关闭这个传输端口。
bufferevent_free(struct bufferevent *bufev)

5. 从data处开始的size字节添加到bufferevent的output缓冲区末尾
int bufferevent_write(struct bufferevent *bufev, const void *data, size_t size)

6. 至多从输入缓冲区移除size字节的数据,将其存储到内存中data处，返回实际移除的字节数
size_t bufferevent_read(struct bufferevent *bufev, void *data, size_t size)

7. 类似于event_add，使得bufferevent能工作
int bufferevent_enable(struct bufferevent *bufev, short event) EV_READ EV_TIMEOUT EV_WRITE EV_SIGNAL EV_PERSIST

8. 从bufferevent到event_base
struct event_base *bufferevent_get_base(struct bufferevent *bufev)

int bufferevent_socket_connect_hostname (
                struct bufferevent *bev,
                struct event_base  *dns_base,
                int                 family,
                const char         *hostname,
                int                 port);
这是connect()封装的另一个版本，但是目标改为hostname。这会导致bufferevent自动去解析DNS。其中family可选以下值：AF_INET, AF_INET6, AF_UNSPEC。
　　dns_base参数可选。如果是NULL，那么bufferevent会一直阻塞直到DNS解析完成——当然不推荐这么做。如果带了参数，则libevent会异步处理DNS请求。
　　剩下的工作与上面的connect封装相同。

int bufferevent_socket_get_dns_error (struct bufferevent *bev);

}
/*
 * Create a new buffered event object.
 *
 * The read callback is invoked whenever we read new data.
 * The write callback is invoked whenever the output buffer is drained.
 * The error callback is invoked on a write/read error or on EOF.
 *
 * Both read and write callbacks maybe NULL.  The error callback is not
 * allowed to be NULL and have to be provided always.
 */
struct bufferevent * bufferevent_new(int fd, evbuffercb readcb, evbuffercb writecb, everrorcb, void *cbarg); 
void bufferevent_free(struct bufferevent *bufev); 

从data处开始的size字节添加到bufferevent的output缓冲区末尾
int bufferevent_write(struct bufferevent *bufev, void *data, size_t size); 
移除 buf 的所有内容,将其放置到输出缓冲区的末尾 
int bufferevent_write_buffer(struct bufferevent *bufev, struct evbuffer *buf); 
至多从输入缓冲区移除size字节的数据,将其存储到内存中data处；返回实际移除的字节数
size_t bufferevent_read(struct bufferevent *bufev, void *data, size_t size); 
抽空输入缓冲区的所有内容,将其放置到 buf 中, 成功时返回0,失败时返回-1
int bufferevent_read_buffer(struct bufferevent *bufev, struct evbuffer *buf)
类似于event_add，使得bufferevent能工作 
int bufferevent_enable(struct bufferevent *bufev, short event); 
禁用 bufferevent 上的 event 类型的事件
int bufferevent_disable(struct bufferevent *bufev, short event); 
设置bufferevent读/写事件的超时 
void bufferevent_settimeout(struct bufferevent *bufev, int timeout_read, int timeout_write);
 XXXX Should non-socket bufferevents support this?
int bufferevent_base_set(struct event_base *base, struct bufferevent *bufev); 

用来创建一个evbuffer
struct evbuffer * evbuffer_new(void); void evbuffer_free(struct evbuffer *buf); 
Adds data to an event buffer
将数据插入到evbuffer中,在链表的尾部添加数据                                                       
1. 该链表为空，即这是第一次插入数据。这是最简单的，直接把新建的evbuffer_chain插入到链表中，通过调用evbuffer_chain_insert。       
2. 链表的最后一个节点(即evbuffer_chain)还有一些空余的空间，放得下本次要插入的数据。此时直接把数据追加到最后一个节点即可。        
3. 链表的最后一个节点并不能放得下本次要插入的数据，那么就需要把本次要插入的数据分开由两个evbuffer_chain存放
成功时返回0,失败时返回-1 
int evbuffer_add(struct evbuffer *buf, const void *data, size_t size); 
将 inbuf 中的所有数据移动到 outbuf 末尾,成功时返回0,失败时返回-1 
int evbuffer_add_buffer(struct evbuffer *dst, struct evbuffer *src); 
按照fmt格式把数据添加到evbuffer中 
int evbuffer_add_printf(struct evbuffer *buf, const char *fmt, ...); 
添加格式化的数据到 buf 末尾
int evbuffer_add_vprintf(struct evbuffer *buf, const char *fmt, va_list ap); 
移除len字节的buf数据
void evbuffer_drain(struct evbuffer *buf, size_t size);
把buffer所有数据写入到socket fd中，并清空 buffer 的内容    
int evbuffer_write(struct evbuffer *buf, int fd); 
// 从一个socket中读取至多 howmuch 字节到 evbuffer 末尾 
// 成功时函数返回读取的字节数,0表示 EOF,失败时返回-1  
int evbuffer_read(struct evbuffer *buf, int fd, int size); 
在缓冲区中搜索字符串的首次出现,返回其指针
unsigned char * evbuffer_find(struct evbuffer *buf, const unsigned char *data, size_t size); 
从 evbuffer 前面取出一行 
char * evbuffer_readline(struct evbuffer *buf); 

evbuffer(Evbuffer基本操作){
struct evbuffer *evbuffer_new (void);
void evbuffer_free (struct evbuffer *buf);
创建/销毁evbuffer

int evbuffer_enable_locking (struct evbuffer *buf, void *lock);
void evbuffer_lock (struct evbuffer *buf);
void evbuffer_unlock (struct evbuffer *buf);
第一个函数，参数locking传入的参数是一个锁。可以传入NULL，让evbffer自动创建一个锁。

size_t evbuffer_get_length (const struct evbuffer *buf);
size_t evbuffer_get_continous_space (const struct evbuffer *buf);
第一个函数，获取当前evbuffer的总数据长度。第二个函数，由于数据在evbuffer的内存中并不是连续保存的，这里返回第一个chunk的大小。
}

evbuffer(操作evbuffer中的帧){
int evbuffer_add (struct evbuffer *buf, const void *data, size_t data_len);
int evbuffer_add_printf (struct evbuffer *buf, const char *fmt);
int evbuffer_add_vprintf(struct evbuffer *buf, const char *fmt, va_list ap);
直接往evbuffer的末尾添加数据

int evbuffer_expand (struct evbuffer *buf, size_t data_len);
扩展ev_buffer的预申请内存

int evbuffer_add_buffer (struct evbuffer *dst, struct evbuffer *src);
int evbuffer_rename_buffer (struct evubffer *src, struct evbuffer *dst, size_t data_len);
两个函数都是"move"操作，也就是说会删除src的指定内容。

int evbuffer_prepend (struct evbuffer *buf, const void *data, size_t size);
int evbuffer_prepend_buffer (struct evbuffer *dst, struct evbuffer *src);
这两个函数是往evbuffer的头部插入数据

unsigned char *evbuffer_pullup (struct evbuffer *buf, ev_ssize_t size);
将指定长度的数据存入到evbuffer的第一个chunk中。如果size为-1，则表示全部。

int evbuffer_drain (struct evbuffer *buf, size_t len);
int evbuffer_remove (struct evbuffer *buf, void *data, size_t data_len);
从evbuffer的头部放走指定长度的数据，第二个函数可以顺带读出来。
}

evbuffer(基于字符串行的输入){
很多文件都是一行一行存储的(比如文本)，一下函数可以用来一行一行地读取输入(ASCII)。读取之前要指定行尾的格式。
enum evbuffer_eol_style {
    EVBUFFER_EOL_ANY,            // 任意数量的\r和\n
    EVBUFFER_EOL_CRLF,           // \r或者\r\n
    EVBUFFER_EOL_CRLF_STRICT,    // \r\n
    EVBUFFER_EOL_LF,             // \n
    EVBUFFER_EOL_NUL             // \0
};
char *evbuffer_readln (struct evbuffer *buffer,
                       size_t *n_read_out,
                       enum evbuffer_eol_style eol_style);
}
evbuffer(在evbuffer里面搜索){
Evbuffer使用一个结构体来配置搜索功能，其中pos表示position，如下：

struct evbuffer_ptr {
    ev_ssize_t pos;
    struct {/* internal fields */} _internal;
};
struct evbuffer_ptr evbuffer_search (struct evbuffer *buffer,
                                     const char *what,
                                     size_t len,
                                     const struct evbuffer_ptr *start);
struct evbuffer_ptr evbuffer_search_range (struct evbuffer *buffer,
                                           const char *what,
                                           size_t len,
                                           const struct evbuffer_ptr *start,
                                           const struct evbuffer_ptr *end);
struct evbuffer_ptr evbuffer_search_eol (struct evbuffer_ptr *buffer,
                                         struct evbuffer_ptr *start,
                                         size_t *eol_len_out,
                                         enum evbuffer_eol_style eol_style);

第一个参数是搜索在evbuffer中与"what"参数相同的数据并且返回。如果参数start不为空，则会从start中所指定的位置开始搜索。
　　第二个函数的不同是指定了一个搜索范围；第三个函数类似于evbuffer_readln，但是不复制，只是返回结果而已。

enum evbuffer_ptr_how {
    EVBUFFER_PTR_SET,
    EVBUFFER_PTR_ADD,
};
int evbuffer_ptr_set (struct evbuffer *buffer,
                      struct evbuffer_ptr *pos,
                      size_t position,
                      enum evbuffer_ptr_how how);

修改evbuffer中的evbuffer_ptr。
}
evbuffer(检查数据但是不复制出来){
sruct aevbuffer_iovec {
    void *iov_base;
    size_t iov_len;
};
int evbuffer_peak (struct evbuffer *buffer,
                   ev_size_t len,
                   struct evbuffer_ptr *start_atm
                   struct evbuffer_iovec *vec_out,
                   int n_vec);

这个函数给予一个struct evbuffer_iovec数组，并且用n_vec制定长度，从evbuffer中得到的具体数据块的信息，这样就可以直接读取了。
如果start_at非空，则直接从制定的位置读起。
}
evbuffer(直接向evbuffer添加数据){
int evbuffer_reserve_space (struct evbuffer *buf,
                            ev_size_t size,
                            struct evbuffer_iovec *vec,
                            int n_vecs);
int evbuffer_commit_space (struct evbuffer *buf,
                           struct evbuffer_iovec *vec,
                           int n_vecs);

这个函数与peak类似，不同的是使用这个组合，可以直接修改evbuffer里面的值。
如果是多线程的情况下，注意要在reserve之前加锁、commit之后解锁。
}
evbuffer(使用evbuffer对网络I/O进行读写){
int evbuffer_write (struct evbuffer *buffer, evutil_socket_t fd);
int evbuffer_write_almost (struct evbuffer *buffer, evutil_socket_t fd, ev_ssize_t howmuch);
int evubffer_read (struct evbuffer *buffer, evutil_socket_t fd, ev_ssize_t howmuch);

evbuffer_write等同于evbuffer_write_almost中的howmuch参数指定为-1。
}
evbuffer(Evbuffer的回调函数){
struct evbuffer_cb_info {
    size_t orig_size;
    size_t n_added;
    size_t n_deleted;
};
typedef void (*evbuffer_cb_func)(struct evbuffer *buffer,
                                 const struct evbuffer_cb_info *info,
                                 void *arg);
                                 
struct evbuffer_cb_func;
struct evbuffer_cb_func *evbuffer_add_cb (struct evbuffer *buffer,
                                           evbuffer_cb_func cb,
                                           void *cbarg);

当evbuffer有操作时，会调用callback，返回entry，则可以用来在后续的函数中引用这个callback。

int evbuffer_remove_cb_entry (struct evbuffer *buffer, struct evbuffer_cb_func *ent);
int evbuffer_remove_cb (struct evbuffer *buffer, evbuffer_cb_func cb, void *cbarg);

这两个函数用于删除callback

int evbuffer_defer_callbacks (struct evbuffer *buffer, struct event_base *base);

Evbuffer的callback也可以放在event loop里面，这两个函数就是将callback进行defer的函数
}
evbuffer(为基于evbuffer的I/O减少数据复制){
基于evbuffer经常会有数据复制，但是很多大负荷的服务器要尽量减少这些操作，此时就需要以下函数：

typedef void (*evbuffer_ref_cleanup_cb) (const void *data, size_t datalen, void *extra);
int evbuffer_add_reference (struct evbuffer *outbuf, 
                            const void *data, 
                            size_t datalen, 
                            evbufferref_cleanup_cb cleanupfn, 
                            void *extra);

这个函数通过引用想evbuffer添加一段void *数据并且指定其长度。这段数据必须持续保持有效，直到evbuffer调用callback为止。
}
evbuffer之间的复制
int evbuffer_add_buffer_reference (struct evbuffer *outbuf, struct evbuffer *inbuf);

暂时冻结evbuffer
int evbuffer_freeze (struct evbuffer *buf, int at_front);
int evbuffer_unfreeze (struct evbuffer *buf, int at_front);

buffer(evbuffer和bufferevent的关系){
    evbuffer是一个缓冲区，用户可以向evbuffer添加数据，evbuffer和bufferevent经常一起使用，
或者说bufferevent使用了evbuffer，bufferevent有两个evbuffer缓冲，还有event。
    说明bufferevent是一个带有缓冲区的I/O。可以使用它们！用户可以通过bufferevent相关的函数
往evbuffer缓冲区中添加需要发送的内容，内部机制可以保证发送。当有数据在bufferevent上的套接字
上时，数据被读入到bufferevent内部的evbuffer缓冲区！
    这样一来，用户程序需要交互的就是使用bufferevent相关函数想bufferevent内部的两个evbuffer
(一个为读缓冲，一个为写缓冲)写数据/取数据，发送和接受都是bufferevent内部实现的。当然内部的
发送和读取都是非阻塞的！！
    其中evbuffer并没有显示的使用malloc在堆区申请空间，而是使用了内核为每个套接字在栈上分配
的事件，在这个空间不够时，再申请空间存放数据，使用函数evbuffer_expand()函数。具体的步骤是
怎么回事呢？(这里分析的是libevent-1.4.12-stable)

一、首先申请bufferevent
    使用bufferevent_new函数申请一个struct bufferevent.首先是malloc了一些结构体，然后调用了
两个重量级的函数，event_set，这个函数被调用两次，分别对应bufferevent中的ev_read和ev_write。
这个函数是干什么的，在不久以前的某个时刻也注重分析了，就是让某一个套接字初始化给具体的event,
并且初始化这个event所要关注的事件和事件处理函数，这么一来，bufferevent中的两个event被初始化了！
暂且不说注册的两个函数(bufferevent_readcb bufferevent_writecb)，这也是重量级的。
    然后调用函数bufferevent_setcb函数，这个函数注册层的回调函数，这函数处理了从evbuffer中
读取数据后的相应处理(怎么处理就是用户层的事情了)

二、调用bufferevent_enable函数
    这个函数中同样调用了一个以前的重量级函数event_add(),这个函数可以理解为将某个event添加到
event_base中，这样这个套接字就可以被处理，等到有数据到达就会被触发。其实到目前为止，已经可以
结束了，上下的就是自己写bufferevent_setcb函数中注册的两个函数了。
    整天看着两步，再对比以前使用libevent的流程，之前多一个event_init全局初始化，然后多一个
event_dispatch()函数，也就是说，这个bufferevent知识多了两个evbuffer，然后对event_set函数和
event_add函数进行再次封装！

三、bufferevent_readcb()
    这个函数是在buffer_new函数中别event_set函数调用的，event_set也就是对传递给的event参数做
相应的初始化，但是bufferevent_readcb函数的具体内容是什么呢？
    咱们这里不考虑什么读/写的标准，都是默认值。在这个函数中调用了evbuffer_read函数，这个函数
可以直接调用了系统调用read(),,读取的函数就是直接调用bufferevent_add函数继续关注这个event

四、bufferevent_write()函数
    其实和上面的那个函数类似，调用了evbuffer_write函数，这个函数总调用了write函数，然后调用
bufferevent_add函数继续关注这个事件
这是使用bufferevent的整个过程！！
其实想要知道libevent是怎么使用evbuffer，还需要知道是怎么调用的！


2 回调和水位
    每个bufferevent有两个数据相关的回调：一个读取回调和一个写入回调。默认情况下，从底层传输端口
读取了任意量的数据之后会调用读取回调；输出缓冲区中足够量的数据被清空到底层传输端口后写入回调会
被调用。通过调整bufferevent的读取和写入"水位(watermarks)"可以覆盖这些函数的默认行为。

每个bufferevent有四个水位：
1. 读取低水位：读取操作使得输入缓冲区的数据量在此级别或者更高时，读取回调将被调用。
    默认值为0，所以每个读取操作都会导致读取回调被调用。
2. 读取高水位：输入缓冲区中的数据量达到此级别后，bufferevent将停止读取，直到输入
    缓冲区中足够量的数据被抽取，使得数据量低于此级别。默认值是无限，所以永远不会因为输入缓冲区的大小而停止读取。
3. 写入低水位：写入操作使得输出缓冲区的数据量达到或者低于此级别时，写入回调将被调用。
    默认值是0，所以只有输出缓冲区空的时候才会调用写入回调。
4. 写入高水位：bufferevent没有直接使用这个水位。它在bufferevent用作另外一个bufferevent的
    底层传输端口时有特殊意义。请看后面关于过滤型bufferevent的介绍。

bufferevent也有"错误"或者"事件"回调，用于向应用通知非面向数据的事件，如连接已经关闭或者发生错误。定义了下列事件标志：
l BEV_EVENT_READING：读取操作时发生某事件，具体是哪种事件请看其他标志。
l BEV_EVENT_WRITING：写入操作时发生某事件，具体是哪种事件请看其他标志。
l BEV_EVENT_ERROR：操作时发生错误。关于错误的更多信息，请调用EVUTIL_SOCKET_ERROR()。
l BEV_EVENT_TIMEOUT：发生超时。
l BEV_EVENT_EOF：遇到文件结束指示。
l BEV_EVENT_CONNECTED：请求的连接过程已经完成。

上述标志由2.0.2-alpha版新引入。
3 延迟回调
    默认情况下，bufferevent的回调在相应的条件发生时立即被执行。(evbuffer的回调也是这样的，
随后会介绍)在依赖关系复杂的情况下，这种立即调用会制造麻烦。比如说，假如某个回调在evbuffer
 A空的时候向其中移入数据，而另一个回调在evbuffer A满的时候从中取出数据。这些调用都是在栈上
 发生的，在依赖关系足够复杂的时候，有栈溢出的风险。
要解决此问题，可以请求bufferevent(或者evbuffer)延迟其回调。条件满足时，延迟回调不会立即调用，
而是在event_loop()调用中被排队，然后在通常的事件回调之后执行。

(延迟回调由libevent 2.0.1-alpha版引入)
}

server(tcp){ listener.c         服务器端socket管理
             bufferevent.c       bufferevent管理
             和 test-fdleak.c    测试程序
1. 创建一个监听器
申请一个socket，然后对之进行一些有关非阻塞、重用、保持连接的处理、绑定到特定的IP和端口            
base: 所属的event_base对象,
evconnlistener_cb: 监听回调函数,                                                                  
ptr: 回调函数的参数,
flags: 标志(如 LEV_OPT_REUSEABLE|LEV_OPT_CLOSE_ON_FREE)                                           
backlog: 监听的个数,                                                                              
sa: 要绑定到的地址,                                                                               
socklen: 地址长度
struct evconnlistener *
evconnlistener_new_bind(struct event_base *base, evconnlistener_cb cb,                               
    void *ptr, unsigned flags, int backlog, const struct sockaddr *sa,                               
    int socklen)
    
创建一个监听器.
base: 所属的event_base对象,
evconnlistener_cb: 新连接到达时的回调,如果 cb 为 NULL,则监听器是禁用的,直到设置了回调函数为止
ptr: 传递给回调函数的参数,
flags: 标志(如 LEV_OPT_REUSEABLE|LEV_OPT_CLOSE_ON_FREE),
backlog: 监听的个数,
fd: 注意是已经将套接字绑定到要监听的端口的fd
struct evconnlistener *
evconnlistener_new(struct event_base *base,
    evconnlistener_cb cb, void *ptr, unsigned flags, int backlog,
    evutil_socket_t fd)

2. 新建基于bufferevent的客户端
struct event_base *base = evconnlistener_get_base(listener);
struct bufferevent *bev = bufferevent_socket_new(base, sock,BEV_OPT_CLOSE_ON_FREE);

3. 注册read,event回调函数
bufferevent_setcb(bev, server_read_cb, NULL, server_event_cb, NULL);
bufferevent_enable(bev, EV_READ|EV_WRITE);

4. 获取当前evbuffer长度，然后对bufferevent读写
while (evbuffer_get_length(bufferevent_get_input(bev))) {
    unsigned char tmp;
    bufferevent_read(bev, &tmp, 1);
    bufferevent_write(bev, &tmp, 1);
} 

5. 如果EOF|ERROR 则退出；释放bev
if (events & BEV_EVENT_ERROR) {
    my_perror("Error from bufferevent");
    exit(1);
} else if (events & (BEV_EVENT_EOF | BEV_EVENT_ERROR)) {
    bufferevent_free(bev);
}
fd = evconnlistener_get_fd(listener); 获取 struct evconnlistener *listener; 关联fd
}
client(TCP){ bufferevent_sock.c  客户端socket管理
             bufferevent.c       bufferevent管理
             和 test-fdleak.c    测试程序
1. 创建bufferevent封装的socket
struct bufferevent *bev = bufferevent_socket_new(base, -1, BEV_OPT_CLOSE_ON_FREE);
2. 设置read和event回调函数
bufferevent_setcb(bev, client_read_cb, NULL, client_event_cb, NULL);
3. 连接
if (bufferevent_socket_connect(bev, (struct sockaddr *)&saddr, sizeof(saddr)) < 0){}

4. 读取
struct event_base *base = bufferevent_get_base(bev); 
bufferevent_read(bev, &tmp, 1);

5. if (events & BEV_EVENT_CONNECTED) 连接成功事件 -> bufferevent_enable(bev, EV_READ); 

6. bufferevent_write(bev, &tmp, 1); 写入
}


test(test实例说明){
test-init: libevent库调用; 头包含库连接测试
test-eof:  非持久性, 超时读, 追加超时读；读结束测试；        栈上ev，
                                   读      | 超时        回调函数, 超时时间
           event_set(&ev, pair[1], EV_READ | EV_TIMEOUT, read_cb, &ev); 
           
test-weof: 非持久性，阻塞等待写，追加阻塞等待写；写结束测试；栈上ev，
test-time: 定时器设置；添加；删除；追加；                    堆上ev集合.
test-fdleak: 基于bufferevent和evbuffer 的服务器端-客户机测试；
             以下是 bufferevent_setcb(bev, client_read_cb, NULL, client_event_cb, NULL); 中client_event_cb可能接收到消息
             BEV_EVENT_READING    读取操作时发生某事件,具体是哪种事件请看其他标志
             BEV_EVENT_WRITING    写入操作时发生某事件,具体是哪种事件请看其他标志
             BEV_EVENT_EOF        遇到文件结束指示
             BEV_EVENT_ERROR      操作时发生错误。关于错误的更多信息,请调用EVUTIL_SOCKET_ERROR()
             BEV_EVENT_TIMEOUT    发生超时
             BEV_EVENT_CONNECTED  请求的连接过程已经完成
             详细见： bufferevent(使用基于socket的bufferevent)
test-changelist 定时器设置， 添加，删除定时器事件；持久性阻塞等待写；添加，删除监听事件。
test-ratelim [-v] [-n INT] [-d INT] [-c INT] [-g INT] [-t INT] # 速率控制
Pushes bytes through a number of possibly rate-limited connections, and
displays average throughput.
  -n INT: Number of connections to open (default: 30)
  -d INT: Duration of the test in seconds (default: 5 sec)
  -c INT: Connection-rate limit applied to each connection in bytes per second
           (default: None.)
  -g INT: Group-rate limit applied to sum of all usage in bytes per second
           (default: None.)
  -G INT: drain INT bytes from the group limit every tick. (default: 0)
  -t INT: Granularity of timing, in milliseconds (default: 1000 msec)
简略说明event_add和event_new对event_base的影响。
test-dumpevents:  0： 非持久性，阻塞等待，可写。
                  1： 持久性，超时等待，可读
                  2： 持久性，超时等待，可写    优化超时
                  3： 非持久性，超时等待，可读  优化超时
                  4:  非持久性，优化超时
                  5:  非持久性，优化超时
                  6:  非持久性，超时回调
                  7:  持久性，优化超时
                  8:  持久性，优化超时
                  9:  持久性，超时回调
                  12: 信号注册
bench: 对一次性，非阻塞读写测试；详细见 event_base_loop() 说明
}

regress(){
export EVENT_DEBUG_MODE=1
export EVENT_DEBUG_LOGGING_ALL=1

./regress --help
Options are: [--verbose|--quiet|--terse] [--no-fork]
  Specify tests by name, or using a prefix ending with '..'
  To skip a test, prefix its name with a colon.
  To enable a disabled test, prefix its name with a plus.
  Use --list-tests for a list of tests.
  
./regress --list-tests # 枚举测试项
./regress thread/basic # 执行指定测试项
./regress main/methods --verbose
./regress main/version --verbose

./regress main/methods 后端获取与设置
./regress main/version 版本获取
./regress main/base_features 边沿触发支持判断
./regress main/base_environ  后端获取与设置
}

sample(说明而不知如何测试){
dns-example        # 
hello-world        # 简单服务器端 nc 192.168.10.109 9995
https-client       # 
le-proxy           # 
lt-hello-world     # 
time-test          # ./time-test -p 为EV_PERSIST， 否则循环添加超时消息
event-read-fifo    # 
http-connect       # 
http-server        # 
lt-dns-example     # 
signal-test        # 接收SIGINT信号，然后处理
echo               # echo -n "GET / HTTP/1.0\r\n\r\n" | nc 192.168.10.109 9876
connect-test       # nc -l 127.0.0.1 8088 << EOF
HELLO
EOF
}

1. 定义宏和功能关系     event-config.h <- config.h(make-event-config.sed) <- config.h.in(autoheader)
2. 定义宏功能开闭       configure
3. 根据宏开关使用宏功能 util.h
src(event-config.h){ 宏定义来自configure文件  # 宏开关
util.h文件宏定义往往来自event-config.h文件中. # 使用宏
event-config.h文件文件的宏。                  # 宏与功能
从宏的名字来看，其指明了是否有这个头文件。有时还会指明是否有某个函数。
event-config.h这个文件定义的宏指明了所在的系统有哪些可用的头文件、函数和一些配置。

# ./configure --disable-thread-support
}
# event-config.h 是一个自动生成文件，文件内容来源于 config.h的内容，见Makefile.am
make-event-config.sed
sed -f src/make-event-config.sed < config.h > include/event2/event-config.h
# config.h 由 configure 命令使用 config.h.in 生成
# config.h.in 由 configure.ac 使用 autoheader 生成

1. 通过头文件命名 log-internal.h 确定这些函数不能被外部使用
2. 通过设置回调函数， 确定内部日志可以输出的级别和流方向
log4pp、log4xx 重量级日志模块
3. 函数功能和命名
3.1 event_log   默认的输出到前端 demo作用
3.2 event_logv_ v(va_list 序列) _(内部函数)
3.3 event_msgx(无错误) 和 event_msg(系统接口错误errno) 
3.4 级别 exit err warn msg debug
3.5 event_sock_warn 模块级别错误
4. 错误处理
致命发生错误，默认行为是终止程序，用户也是可以用libevent定制自己的错误处理函数。
src(log.c){  log-internal.h  模块日志的管理策略 以及 在初始化前配置
void event_err(int eval, const char *fmt, ...);
void event_warn(const char *fmt, ...);
void event_sock_err(int eval, evutil_socket_t sock, const char *fmt, ...);
void event_sock_warn(evutil_socket_t sock, const char *fmt, ...);
 
void event_errx(int eval, const char *fmt, ...);
void event_warnx(const char *fmt, ...);
void event_msgx(const char *fmt, ...);
void _event_debugx(const char *fmt, ...);
这些函数都是声明在log-internal.h文件中。所以用户并不能使用之，这些函数都是libevent内部使用的。

event_warn和event_warnx的区别是_warn_helper函数的第二个参数分别是strerror(errno)和NULL。
event_warnx("Far too many %s (%d)", "wombats", 99);
}

1. 在运行时设置 malloc realloc和free函数，     libevent
2. 在链接时 链接到 不同的内存管理库(redis)     redis
3. 封装 malloc realloc和free，捕获内存管理异常 libmonit
src(mm-internal.h){ --disable-malloc-replacement -> _EVENT_DISABLE_MM_REPLACEMENT这个宏 -> event-config.h ->mm-internal.h文件
event.c
void event_set_mem_functions(void *(*malloc_fn)(size_t sz),
                             void *(*realloc_fn)(void *ptr, size_t sz),
                             void (*free_fn)(void *ptr))
    用户就是通过调用event_set_mem_functions函数来定制自己的内存分配函数。虽然这个函数不做任何的检查，
但还是有一点要注意。这个三个指针，要么全设为NULL(恢复默认状态)，要么全部都非NULL。
}

src(thread.h){
开启多线程：
    libevent默认是不开启多线程的，也没有锁、条件变量这些东西。这点和前面博客说到的"没有定制就用Libevent默认提供"，有所不同。
只有当你调用了evthread_use_windows_threads()或者evthread_use_pthreads()或者调用evthread_set_lock_callbacks函数定制自己的
多线程、锁、条件变量才会开启多线程功能。

thread.h文件只提供了定制线程的接口，并没有提供使用线程接口。
    如果用户为libevent开启了多线程，那么libevent里面的函数就会变成线程安全的。此时主线程在使用event_base_dispatch，
别的线程是可以线程安全地使用event_add把一个event添加到主线程的event_base中。
}


src(ht-internal.h){
//ht-internal.h文件
#ifdef HT_CACHE_HASH_VALUES
#define HT_ENTRY(type)                          \
  struct {                                      \
    struct type *hte_next;                      \
    unsigned hte_hash;                          \
  }
#else
#define HT_ENTRY(type)                          \
  struct {                                      \
    struct type *hte_next;                      \
  }
#endif
    可以看到，如果定义了HT_CACHE_HASH_VALUES宏，那么就会多一个hte_hash变量。从宏的名字来看，这是一个cache。不错，变量hte_hash就是
用来存储前面的hashsocket的返回值。当第一次计算得到后，就存放到hte_hash变量中。以后需要用到(会经常用到)，就直接向这个变量要即可，无需再次
计算hashsocket函数。如果没有这个变量，那么需要用到这个值，都要调用hashsocket函数计算一次。这一点从后面的代码可以看到。
}
struct evhttp * evhttp_new(struct event_base *base); 
int evhttp_bind_socket(struct evhttp *http, const char *address, unsigned short port); 
void evhttp_free(struct evhttp *http); 
int (*event_sigcb)(void); 
volatile sig_atomic_t event_gotsig;