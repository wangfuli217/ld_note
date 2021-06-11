/* Example code: an echo server. */
#include <event2/listener.h>
#include <event2/bufferevent.h>
#include <event2/buffer.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <iostream>
#include <sys/socket.h>
#include <pthread.h>
using namespace std;

static void echo_read_cb(struct bufferevent *bev, void *ctx) {
    cout << "echo_read_cb()"<< endl;
    /* 获取bufferevent中的读和写的指针 */
    /* This callback is invoked when there is data to read on bev. */
    struct evbuffer *input = bufferevent_get_input(bev);
    struct evbuffer *output = bufferevent_get_output(bev);

    /* 读取 接收的数据 */
    int input_len = evbuffer_get_length(input);
    char * pbuf = new char[input_len+1];
    cout << "input len = " << input_len << endl;
    sleep(1);
    int nread = bufferevent_read(bev,pbuf,input_len);
    pbuf[nread] = 0;
    cout << "input data = " << pbuf << endl;
#if 0
    /* 发送*/
    const char * w_info = "I have receive the data!\n";
    int nwrite = bufferevent_write(bev, w_info, strlen(w_info));

    /* 把读入的数据全部复制到写内存中 */
    /* Copy all the data from the input buffer to the output buffer. */
    evbuffer_add_buffer(output, input);
#endif
}

static void echo_event_cb(struct bufferevent *bev, short events, void *ctx) {
    cout << "echo_event_cb()"<< endl;
    if (events & BEV_EVENT_CONNECTED)
        puts("connect successfully, we'd do something here, like start reading or writing");
    if (events & BEV_EVENT_ERROR)
        perror("Error from bufferevent");
    if (events & (BEV_EVENT_EOF | BEV_EVENT_ERROR)) {
        bufferevent_free(bev);
    }
}

struct bufferevent *bev;

void * thread1(void *arg)
{
    struct sockaddr_in remote_addr;

    int port = 8000;

    struct event_base *base;
    base = event_base_new(); /* 初始化event_base */
    if (!base) {
        puts("Couldn't open event base");
        return (void *)1;
    }

    bev = bufferevent_socket_new(base, -1,
                          BEV_OPT_CLOSE_ON_FREE
                        | BEV_OPT_DEFER_CALLBACKS
#if 1
                        );
#else
                        | BEV_OPT_THREADSAFE);
#endif

    /* 设置buferevent的回调函数，这里设置了读和事件的回调函数 */
    bufferevent_setcb(bev, echo_read_cb, NULL, echo_event_cb, NULL);

    bufferevent_enable(bev, EV_READ|EV_WRITE);
    int fd = socket( AF_INET, SOCK_STREAM, 0 );
    if(-1 == fd){
        cout<<"Error, connectServer() quit"<<endl;
        return (void *)-1;
    }

    /* 初始化绑定地址 */
    memset(&remote_addr, 0, sizeof(remote_addr));
    remote_addr.sin_family = AF_INET;
    remote_addr.sin_addr.s_addr =
#if 1
    inet_addr("127.0.0.1");
#else
    inet_addr("192.168.43.68");
#endif
    remote_addr.sin_port = htons(port);

#if 0
    bind(fd, (struct sockaddr *)&local, sizeof(local));
#endif

    for(;;)
    {
        int ret = connect(fd, (struct sockaddr*)&remote_addr, sizeof(remote_addr));
        if(0 != ret)
        {
            if(EISCONN == errno)
            {
                break;//success
            }
            else if( EWOULDBLOCK == errno || EAGAIN   == errno ||
                     EINPROGRESS == errno || EALREADY == errno)
            {
                continue;
            }
            else
            {
                perror("Error connect");
                return (void *)-1;
            }
        }
    }

    bufferevent_disable(bev, EV_READ|EV_WRITE);
    bufferevent_setfd(bev, fd);
    bufferevent_enable(bev, EV_READ|EV_WRITE);

    event_base_dispatch(base);

    event_base_free(base);
    return (void *)0;
}

/*
 * 参考VOS_TcpClient.cpp实现
 * */
int main(int argc, char **argv) {

    //一个线程用于dispatch,另一个线程用于bufferevent发送数据
    pthread_t tid;
    pthread_create(&tid, NULL, thread1, NULL);

    //注意：一定要先event_base_dispatch()，调用bufferevent_write才能发送数据。
#if 0
    const char * pd = "hello 11111111111111111111111111";
    int w_ret = bufferevent_write(bev, pd, strlen(pd));
#else
    char buffer[1024];
    bool isBreak = false;
    while(!isBreak){
        cout << "Input your data to server(\'q\' or \"quit\" to exit)"<<endl;
        cin >> buffer;
        if(strcmp("q", buffer)==0 || strcmp("quit", buffer)==0){
            isBreak=true;
            evutil_socket_t tsock = bufferevent_getfd(bev);
            close(tsock);
            break;
        }
        cout << "Your input is "<<buffer<<endl;
        int w_ret = bufferevent_write(bev, buffer, strlen(buffer));
        cout << (w_ret==0?"success":"fault") <<" written"<<endl;
        sleep(2);
    }
    cout<<"main finished"<<endl;
#endif
    while(1)
    {
        sleep(5);
    }

    bufferevent_disable(bev, EV_READ|EV_WRITE);
    evutil_socket_t tsock = bufferevent_getfd(bev);

    if (tsock) close(tsock);
    bufferevent_setfd(bev, -1);
    bufferevent_free(bev);

    return 0;
}
