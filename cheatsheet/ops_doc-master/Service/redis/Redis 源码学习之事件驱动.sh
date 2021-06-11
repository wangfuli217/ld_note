http://blog.jobbole.com/111425/

int main(int argc,char **argv) 
{
    while(true) {
        // 等待事件到来:wait4Event();
        // 处理事件:processEvent()
    }
}

# aeEventLoop是Redis中事件驱动模型的核心，封装了整个事件循环，其中每个字段解释如下
typedef struct aeEventLoop {
    int maxfd;   #maxfd:已经接受的最大的文件描述符。
    int setsize; #setsize:当前循环中所能容纳的文件描述符的数量。
    long long timeEventNextId; #timeEventNextId:下一个时间事件的ID.
    time_t lastTime;     #上一次被访问的时间，用来检测系统时钟是否被修改。
    aeFileEvent *events; #指向保存所有注册的事件的数组首地址。
    aeFiredEvent *fired; #保存所有已经买被触发的事件的数组首地址。
    aeTimeEvent *timeEventHead; #Redis用一个链表来存储所有的时间事件，timeEventHead是指向这个链表的首节点指针。
    int stop; #停止整个事件循环
    void *apidata;#指针，指向epoll结构。
    aeBeforeSleepProc *beforesleep; #函数指针。每次实现循环的时候，在阻塞直到时间到来之前，会先调用这个函数。
} aeEventLoop;

aeFileEvent和aeTimeEvent，aeFiredEvent

其中mask表示文件事件类型掩码，可以是AE_READABLE表示是可读事件，AE_WRITABLE为可写事件。aeFileProc是函数指针。
typedef struct aeFileEvent {
    int mask; /* one of AE_(READABLE|WRITABLE) */
    aeFileProc *rfileProc; // 函数指针，写事件处理
    aeFileProc *wfileProc; // 函数指针，读事件处理
    void *clientData; // 具体的数据
} aeFileEvent;

/* Time event structure */
typedef struct aeTimeEvent {
    long long id; // 事件ID
    long when_sec; // 事件触发的时间:s
    long when_ms; // 事件触发的时间:ms
    aeTimeProc *timeProc; // 函数指针
    aeEventFinalizerProc *finalizerProc; // 函数指针:在对应的aeTieEvent节点被删除前调用，可以理解为aeTimeEvent的析构函数
    void *clientData; // 指针，指向具体的数据 
    struct aeTimeEvent *next; // 指向下一个时间事件指针
} aeTimeEvent;

# aeFiredEvent结构表示一个已经被触发的事件:fd表示事件发生在哪个文件描述符上面，mask用来表示具体事件的类型。
typedef struct aeFiredEvent {
    int fd; // 事件被触发的文件描述符
    int mask; // 被触发事件的掩码，表示被触发事件的类型
} aeFiredEvent;

aeApiState
#Redis底层采用IO多路复用技术实现高并发，具体实现可以采用kqueue、select、epoll等技术。对于Linux来说，epoll的性能要优于select，所以以epoll为例来进行分析。
typedef struct aeApiState {
    int epfd;
    struct epoll_event *events;
} aeApiState;
#aeApiState封装了跟epoll相关的数据，epfd保存epoll_create()返回的文件描述符。

redis(具体实现细节)
{
事件循环启动:aeMain()

事件驱动的启动代码位于ae.c的aeMain()函数中，代码如下:
void aeMain(aeEventLoop *eventLoop) {
    eventLoop->stop = 0;
    while (!eventLoop->stop) {
        if (eventLoop->beforesleep != NULL)
            eventLoop->beforesleep(eventLoop);
        aeProcessEvents(eventLoop, AE_ALL_EVENTS);
    }
}

从aeMain()方法中可以看到，整个事件驱动是在一个while()循环中不停地执行aeProcessEvents()方法，在这个方法中执行从客户端发送过来的请求。



初始化:aeCreateEventLoop()

aeEventLoop的初始化是在aeCreateEventLoop()方法中进行的，这个方法是在server.c中的initServer()中调用的。实现如下:

aeEventLoop *aeCreateEventLoop(int setsize) {
    aeEventLoop *eventLoop;
    int i;
    if ((eventLoop = zmalloc(sizeof(*eventLoop))) == NULL) goto err;
    eventLoop->events = zmalloc(sizeof(aeFileEvent)*setsize);
    eventLoop->fired = zmalloc(sizeof(aeFiredEvent)*setsize);
    if (eventLoop->events == NULL || eventLoop->fired == NULL) goto err;
    eventLoop->setsize = setsize;
    eventLoop->lastTime = time(NULL);
    eventLoop->timeEventHead = NULL;
    eventLoop->timeEventNextId = 0;
    eventLoop->stop = 0;
    eventLoop->maxfd = -1;
    eventLoop->beforesleep = NULL;
    // 调用aeApiCreate()初始化epoll相关的数据
    if (aeApiCreate(eventLoop) == -1) goto err;
    /* Events with mask == AE_NONE are not set. So let us initialize the
     * vector with it. */
    for (i = 0; i < setsize; i++)
        /**
         * 把每个刚新建的aeFileEvent.mask设置为AE_NONE
         * 这点是必须的
         */
        eventLoop->events[i].mask = AE_NONE;
    return eventLoop;
 
err:
    if (eventLoop) {
        zfree(eventLoop->events);
        zfree(eventLoop->fired);
        zfree(eventLoop);
    }
    return NULL;
}

在这个方法中主要就是给aeEventLoop对象分配内存然后并进行初始化。其中关键的地方有：
}