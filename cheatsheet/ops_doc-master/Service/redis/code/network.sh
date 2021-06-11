1. 多路复用IO框架提供两部分接口，一部分接口用于注册IO事件，一部分用于注册读写处理、连接管理函数。
   注册IO事件接口注册驱动读写处理、连接管理。读写处理、连接管理状态变迁通过注册IO事件实现。
2. 读事件：正常情况下，注册IO读事件，驱动读处理，在读处理中注册IO读事件。读事件总是注册接收数据的。
3. 写事件：正常情况下，有数据需要发送，注册写事件，数据发送完毕后，重新检测是否有数据需要发送。写事件是由数据驱动的。
4. 连接管理是读写意外的影响：读事件出错或写事件出错，直接会导致连接管理函数被调用，处理连接问题。
5. libevent.h libev.h ac.h属于粘合层，声明并创建了redisLibeventEvents、redisLibevEvents、redisAeEvents对象，封装了读写IO事件和
   读写注册数据处理函数。对象的初始化由redisLibeventAttach、redisLibevAttach、redisLibevAttach完成。该函数将连接关联的数据处理对象和
   多路IO事件处理对象关联起来。

详细见: redis-3.0-annotated-unstable\deps\hiredis\README.md 
6. 发送数据
reply = redisCommand(context, "SET foo bar");
reply = redisCommand(context, "SET foo %s", value);
reply = redisCommand(context, "SET foo %b", value, valuelen);
reply = redisCommand(context, "SET key:%s %s", myid, value);
7.接收数据
REDIS_REPLY_STATUS      reply->str;reply->len
REDIS_REPLY_ERROR       reply->str;reply->len
REDIS_REPLY_INTEGER     reply->integer
REDIS_REPLY_NIL         no data to access.
REDIS_REPLY_STRING      reply->str;reply->len
REDIS_REPLY_ARRAY       reply->elements; reply->element[..index..]
8. 释放连接
redisFree(redisContext *c);

9 读写交互流程
版本1[见example.c Aof.c Cluster.c Db.c Redis-cli.c Sentinel.c等文件 ]
    redisReply *reply;
    redisAppendCommand(context,"SET foo bar");
    redisAppendCommand(context,"GET foo");
    redisGetReply(context,&reply); // reply for SET
    freeReplyObject(reply);
    redisGetReply(context,&reply); // reply for GET
    freeReplyObject(reply);
版本2[Redis-cli.c Test.c]
    reply = redisCommand(context,"SUBSCRIBE foo");
    freeReplyObject(reply);
    while(redisGetReply(context,&reply) == REDIS_OK) {
        // consume message
        freeReplyObject(reply);
    }

客户端的函数都统一在redisvFormatCommand函数上。 

redisvFormatCommand()
{
异步发送：
int redisvAsyncCommand(redisAsyncContext *ac, redisCallbackFn *fn, void *privdata, const char *format, va_list ap)
仅仅格式化：
int redisFormatCommand(char **target, const char *format, ...) 
    va_list ap;
    int len;
    va_start(ap,format);
    len = redisvFormatCommand(target,format,ap);
    va_end(ap);
添加到缓冲区：
int redisvAppendCommand(redisContext *c, const char *format, va_list ap) 


redisCommand
    redisvCommand
        redisvAppendCommand
}


libevent(libevent.h example-libevent.c)                                                                      
{
example-libevent.c

typedef struct redisLibeventEvents { 粘合层数据结构
    redisAsyncContext *context;      与连接关联的数据处理对象
    struct event rev, wev;           与event_add和event_del关联的事件数据
} redisLibeventEvents;

接口封装(在redisLibeventReadEvent和redisLibeventWriteEvent以后通过以下函数，修改该socket的监听状态)
    粘合层数据处理函数
    封装层                     libevent库注册接口                         功能描述
redisLibeventAddRead         event_add(&e->rev,NULL);                    读监听增加
redisLibeventDelRead         event_del(&e->rev);                         读监听删除
redisLibeventAddWrite        event_add(&e->wev,NULL);                    写监听增加
redisLibeventDelWrite        event_del(&e->wev);                         写监听删除
redisLibeventCleanup         event_del(&e->rev); event_del(&e->wev);     读监听删除，写监听删除


接口注册(读写事件的处理函数，在事件发生以后调用)
    读写事件处理函数                     读写事件处理函数注册
redisLibeventReadEvent     event_set(&e->rev,c->fd,EV_READ,redisLibeventReadEvent,e);   redisAsyncHandleRead     注册读请求
redisLibeventWriteEvent    event_set(&e->wev,c->fd,EV_WRITE,redisLibeventWriteEvent,e)  redisLibeventWriteEvent  注册写请求
                           event_base_set(base,&e->rev);                                                         绑定读请求到base
                           event_base_set(base,&e->wev);                                                         绑定写请求到base

static int redisLibeventAttach(redisAsyncContext *ac, struct event_base *base);
redisLibeventAttach：libevent和redis之间数据结构之间关联函数。
1. 将libevent接口封装给redis使用。redisAsyncContext获得libevent接口的封转函数
2. 将redis接口注册给libevent使用。base获得redis注册的读写注册函数。

                           
初始化流程：
struct event_base *base = event_base_new();                                          创建连接
redisAsyncContext *c = redisAsyncConnect("127.0.0.1", 6379);                         创建多路复用IO框架
if (c->err) {                                                                        判断TCP连接是否建立成功否
    printf("Error: %s\n", c->errstr);
    // handle error
}
redisLibeventAttach(c,base);                                                         将连接注册到多路复用框架
redisAsyncSetConnectCallback(c,connectCallback);                                     注册连接建立函数
redisAsyncSetDisconnectCallback(c,disconnectCallback);                               注册连接注销函数
redisAsyncCommand(c, NULL, NULL, "SET key %b", argv[argc-1], strlen(argv[argc-1]));  连接发送消息
redisAsyncCommand(c, getCallback, (char*)"end-1", "GET key");                        连接接收消息
event_base_dispatch(base);                                                           多路复用框架执行

base在流程中的作用；c在流程中的作用.
}

libev(libev.h example-libev.c)
{
example-libev.c

typedef struct redisLibevEvents {    粘合层数据结构
    redisAsyncContext *context;      与连接关联的数据处理对象
    struct ev_loop *loop;            多路IO管理框架对象
    int reading, writing;            读写注册表示
    ev_io rev, wev;                  与ev_io_start和ev_io_stop关联的事件数据
} redisLibevEvents;

    粘合层数据处理函数
    封装层                     libev库注册接口                                  功能描述
redisLibevAddRead        ev_io_start(EV_A_ &e->rev);                            读监听增加
redisLibevDelRead        ev_io_stop(EV_A_ &e->rev);                             读监听删除
redisLibevAddWrite       ev_io_start(EV_A_ &e->wev);                            写监听增加
redisLibevDelWrite       ev_io_stop(EV_A_ &e->wev);                             写监听删除
redisLibevCleanup        ev_io_stop(EV_A_ &e->wev);ev_io_stop(EV_A_ &e->rev);   读监听删除，写监听删除

接口注册(读写事件的处理函数，在事件发生以后调用)
    读写事件处理函数                     读写事件处理函数注册
redisLibevReadEvent       ev_io_init(&e->rev,redisLibevReadEvent,c->fd,EV_READ);        redisAsyncHandleRead
redisLibevWriteEvent      ev_io_init(&e->wev,redisLibevWriteEvent,c->fd,EV_WRITE);      redisAsyncHandleWrite

static int redisLibevAttach(EV_P_ redisAsyncContext *ac) 
redisLibevAttach：libev和redis之间数据结构之间关联函数。
1. 将libev接口封装给redis使用。redisAsyncContext获得libevent接口的封转函数
2. 将redis接口注册给libev使用。base获得redis注册的读写注册函数。

redisAsyncSetConnectCallback(c,connectCallback);         注册连接建立函数 [会探测当前socket连接是否建立]
redisAsyncSetDisconnectCallback(c,disconnectCallback);   注册连接断链函数

初始化流程：
redisAsyncContext *c = redisAsyncConnect("127.0.0.1", 6379);                         创建连接
if (c->err) {                                                                        判断TCP连接是否建立成功否
    printf("Error: %s\n", c->errstr);
    // handle error
}
redisLibevAttach(EV_DEFAULT_ c);                                                     将连接注册到多路复用框架
redisAsyncSetConnectCallback(c,connectCallback);                                     注册连接建立函数
redisAsyncSetDisconnectCallback(c,disconnectCallback);                               注册连接注销函数
redisAsyncCommand(c, NULL, NULL, "SET key %b", argv[argc-1], strlen(argv[argc-1]));  连接发送消息
redisAsyncCommand(c, getCallback, (char*)"end-1", "GET key");                        连接接收消息
ev_loop(EV_DEFAULT_ 0);                                                              多路复用框架执行
                                                                                     
}

redis(ae.h example-ae.c)
{
example-ae.c

typedef struct redisAeEvents {      粘合层数据结构
    redisAsyncContext *context;     与连接关联的数据处理对象
    aeEventLoop *loop;              多路IO管理框架对象
    int fd;                         文件描述符
    int reading, writing;           读写事件表示
} redisAeEvents;

    粘合层数据处理函数
    封装层                     libev库注册接口                                          功能描述
redisAeAddRead        aeCreateFileEvent(loop,e->fd,AE_READABLE,redisAeReadEvent,e);     读监听增加
redisAeDelRead        aeDeleteFileEvent(loop,e->fd,AE_READABLE);                        读监听删除
redisAeAddWrite       aeCreateFileEvent(loop,e->fd,AE_WRITABLE,redisAeWriteEvent,e);    写监听增加
redisAeDelWrite       aeDeleteFileEvent(loop,e->fd,AE_WRITABLE);                        写监听删除
redisAeCleanup        redisAeDelRead(privdata);redisAeDelWrite(privdata);               读监听删除，写监听删除

static int redisAeAttach(aeEventLoop *loop, redisAsyncContext *ac)
redisAeAttach：ae和redis之间数据结构之间关联函数。
1. 将ae接口封装给redis使用。redisAsyncContext获得ae接口的封转函数
2. 将redis接口注册给ae使用。ae获得redis注册的读写注册函数。

redisAsyncSetConnectCallback(c,connectCallback);         注册连接建立函数 [会探测当前socket连接是否建立]
redisAsyncSetDisconnectCallback(c,disconnectCallback);   注册连接断链函数

初始化流程：
redisAsyncContext *c = redisAsyncConnect("127.0.0.1", 6379);                        创建连接
if (c->err) {                                                                        判断TCP连接是否建立成功否
    printf("Error: %s\n", c->errstr);
    // handle error
}
loop = aeCreateEventLoop();                                                         创建多路复用IO框架
redisAeAttach(loop, c);                                                             将连接注册到多路复用框架
redisAsyncSetConnectCallback(c,connectCallback);                                    注册连接建立函数
redisAsyncSetDisconnectCallback(c,disconnectCallback);                              注册连接注销函数
redisAsyncCommand(c, NULL, NULL, "SET key %b", argv[argc-1], strlen(argv[argc-1])); 连接发送消息
redisAsyncCommand(c, getCallback, (char*)"end-1", "GET key");                       连接接收消息
aeMain(loop);                                                                       多路复用框架执行

}


async(用以兼容libevent和libev的封装层 async.h)
{

}