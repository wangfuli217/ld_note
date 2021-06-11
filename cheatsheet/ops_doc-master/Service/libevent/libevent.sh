libevent(标准用法)
{
1. 每一个使用libevent的程序，都需要包含头文件，并且需要传递-levent标志给连接器linker。在使用任何库函数之前，需要先调用event_init()
   或者event_base_new()函数执行一次libevent库的初始化。
   
   event_init()        创建共用的多路IO复用框架
   event_base_new()    创建特定的多路IO复用框架
}

libevent(事件通知)
{
2. 对于每一个你想监视的文件描述符，你必须声明一个事件结构并且调用event_set()去初始化结构中的成员。为了激活通知，你需要通过调用
   event_add()将该结构添加到监视事件列表。只要是该事件存活，那么就需要保持该已allocated的事件结构，因此该事件结构需要在堆(heap)
   上申请。最后，需要调用event_dispatch()函数循环和调度事件。
   
   event_set()          初始化event数据对象
   event_add()          将event数据对象添加到base中
   event_dispatch()     执行多路IO复用框架
}
 
libevent(I/O缓冲区)
{
3. libevent提供了一个定期回调事件顶层的抽象。该抽象被称为缓冲事件(buffered event)。缓冲事件提供自动地填充和流掉(drained)的输入和
   输出缓冲区。缓冲时间的用户不再需要直接操作I/O，取而待之的是仅仅从输入缓冲区读，向输出缓冲区写就可以了。
     
4. 一旦通过bufferevent_new()进行了初始化，bufferevent结构就可以通过bufferevent_enable()和bufferevent_disable()重复地使用了。
   作为替代，对一个套接口的读写需要通过调用bufferevent_read()和bufferevent_write()函数来完成。
     
5. 当由于读事件而激活bufferevent时，那么后续将会自动回调读函数从该文件描述符读取数据。写函数将会被回调，无论何时这个输出缓冲区
   空间被耗尽到低于写的下水位(low watemark)，通常该值默认为0。

    bufferevent对象操作函数
    bufferevent_new
    bufferevent_enable()
    bufferevent_disable()
    bufferevent_read()
    bufferevent_write()
}

libevent(定时器)
{
6. libevent通过创建一个定时器来参与到一个经过一定超时时间后的回调事件中。evtimer_set()函数将准备(分配)一个事件结构被用于作为一个
   定时器。为了激活定时器，需要调用evtimer_add()函数。相反，需要调用evtimer_del()函数。

   evtimer_set()
   evtimer_add()
   evtimer_del()
   
}

libevent(超时)
{
7. 除了简单的定时器，libevent可以为文件描述符指定一个超时事件，用于触发经过一段时间后而没有被激活的文件描述符执行相应的操作。
   timeout_set()函数可以为一个超时时间初始化一个事件结构。一旦被初始化成功，那么这个事件必须通过timeout_add()函数激活。为了
   取消一个超时事件，可以调用timeout_del()函数。
   
   timeout_set()
   timeout_add()
   timeout_del()
}
   
libevent(异步DNS解析)   
{
8. libevent提供了一个异步DNS解析器，可用于代替标准的DNS解析器。这些函数可以通过在程序中包含头文件而将其导入。在使用任何解析器函数
   之前，你必须调用evdns_init()函数初始化函数库。为转化一个域名到IP地址，可以调用evdns_resolve_ipv4()函数。为了执行一个反响查询，
   你可以调用evdns_resolve_reverse()函数。所有的这些函数，在查找时都会使用回调的方式而避免阻塞的发生。

   evdns_init()
   evdns_resolve_ipv4()
   evdns_resolve_reverse()
}

libevent(事件驱动的HTTP服务器)
{
9. libevent提供了一个简单的可以嵌入到你的程序中的并能处理HTTP请求的事件驱动HTTP服务器。

10. 为了使用这种能力，你应该在你的程序中包含头文件。你可以通过调用evhttp_new()函数来创建一个服务器。通过evhttp_bind_socket()函数
    添加用于监听的地址和端口。然后，你可以注册一个或多个对到来请求的处理句柄。对于每一个URI可以通过evhttp_set_cb()函数指定一个
    回调。通常，一个回调函数也可以通过evhttp_set_gencb()函数完成注册；如果没有其他的回调已经被注册得到该URI，那么这个回调将会与
    其关联。

    evhttp_new()
    evhttp_bind_socket()
    evhttp_set_cb()
    evhttp_set_gencb()
}

libevent(RPC服务器和客户端框架)
{
libevent提供了一个创建RPC服务器和客户端的编程框架。它将托管所有的编组和解组的数据结构。
}