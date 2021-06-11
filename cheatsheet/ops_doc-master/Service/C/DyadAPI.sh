dyad(总结)
{
1. 围绕着事件和状态进行编程；事件关联回调处理函数；连接状态和TCP状态触发事件被回调。
2. dyad_Stream为网络连接对象；dyad_Event为事件触发对象；Listener为事件监听对象；
   dyad_Stream;stream_xxxx管理流相关的操作；    dyad_Event：事件的创建和回调   Listener使用动态数组关联事件监听(回调函数)
               stream_destroy                   createEvent                    Vec(T)
               stream_emitEvent                 stream_emitEvent               vec_unpack(v)
               stream_error                     updateTickTimer                vec_init(v)
               stream_initAddress               updateStreamTimeouts           vec_deinit(v)
               stream_setSocketNonBlocking                                     vec_clear(v)
               stream_setSocket                                                vec_push(v, val)
               stream_initSocket                                               vec_splice(v, start, count)
               stream_hasListenerForEvent                                      vec_expand
               stream_handleReceivedData
               stream_acceptPendingConnections
               stream_flushWriteBuffer
               
3. SelectSet为select管理对象；
              select_has
              select_add
              select_zero
              select_grow
              select_deinit
4. 将多个事件关联到不同的网络连接上；将多个网络连接关联到select；
   SelectSet对应多个dyad_Stream；dyad_Stream对应多个Listener;Listener处理一个或多个dyad_Event.
相比于moosefs和dnsmasq而言，增加业务还需要增加一层，方可以将业务分割到不同的模块中；业务与事件关联；
moosefs和dnsmasq是基于socket处理网络数据业务的；dyad是基于事件处理网络数据业务的。

相比于redis而言， dyad不能多实例，而redis提供的可以多实例；且redis提供了多种多IO处理内核机制。
   
核心价值在于：轻量级别；跨平台。丰富的事件。
              
}

void dyad_init(void)
void dyad_update(void)
void dyad_shutdown(void)
const char *dyad_getVersion(void)
double dyad_getTime(void)
int dyad_getStreamCount(void)
void dyad_setUpdateTimeout(double seconds)
void dyad_setTickInterval(double seconds)              ?
dyad_PanicCallback dyad_atPanic(dyad_PanicCallback func)?


dyad_Stream* dyad_newStream(void)
int dyad_listen(dyad_Stream *stream, int port)
int dyad_listenEx(dyad_Stream *stream, const char *host, int port, int backlog)
int dyad_connect(dyad_Stream *stream, const char *host, int port)
void dyad_addListener(dyad_Stream *stream, int event, dyad_Callback callback, void *udata)
void dyad_removeListener(dyad_Stream *stream, int event, dyad_Callback callback, void *udata)
void dyad_removeAllListeners(dyad_Stream *stream, int event)

void dyad_write(dyad_Stream *stream, const void *data, int size)
void dyad_writef(dyad_Stream *stream, const char *fmt, ...)
%% %s %f %g %d %i %c %x %X %p %r %b
void dyad_vwritef(dyad_Stream stream, const char *fmt, va_list args)
void dyad_end(dyad_Stream *stream)
void dyad_close(dyad_Stream *stream)

void dyad_setTimeout(dyad_Stream *stream, double seconds)
void dyad_setNoDelay(dyad_Stream *stream, int opt)

int dyad_getState(dyad_Stream *stream)
const char *dyad_getAddress(dyad_Stream *stream)
int dyad_getPort(dyad_Stream *stream)

int dyad_getBytesReceived(dyad_Stream *stream)
int dyad_getBytesSent(dyad_Stream *stream)
dyad_Socket dyad_getSocket(dyad_Stream *stream)


Events()
{
DYAD_EVENT_DESTROY    dyad_Stream内存对象和socket对象释放；
DYAD_EVENT_ACCEPT     dyad_Stream内存对象和socket对象创建；
DYAD_EVENT_LISTEN     dyad_Stream:socket对象创建；调用listen成功。
DYAD_EVENT_CONNECT    dyad_Stream:socket连接主动连接对方成功
DYAD_EVENT_CLOSE      dyad_Stream:socket对象释放；
DYAD_EVENT_READY      dyad_Stream:发送队列内数据发送完毕
DYAD_EVENT_DATA       dyad_Stream:接收到要进行处理的数据。
DYAD_EVENT_LINE       dyad_Stream:接收到以\n结尾的数据。数据中由行结尾。
DYAD_EVENT_ERROR      系统调用失败或者网络连接失败的情况
DYAD_EVENT_TIMEOUT    网络连接长时间无数据收发
DYAD_EVENT_TICK       每次select处理函数
}

States()
{
DYAD_STATE_CLOSED       此时socket已经为无效值，
DYAD_STATE_CLOSING      调用close函数，socket为无效值，
DYAD_STATE_CONNECTING   调用connect函数，socket还为连接完成
DYAD_STATE_CONNECTED    调用connect函数，socket已经连接完成
DYAD_STATE_LISTENING    调用listen函数，socket还为监听完成，
}

Types(dyad_Socket){}
Types(dyad_Stream){}
Types(dyad_Event)
{

}

Types(dyad_Callback)
{

}
Types(dyad_PanicCallback)
{

}

