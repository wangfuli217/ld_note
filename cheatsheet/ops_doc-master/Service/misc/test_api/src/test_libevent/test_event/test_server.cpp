#include <iostream>
#include <sys/select.h>
#include <sys/socket.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <stdio.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string>
#include <string.h>
#include <event.h>
#include <stdlib.h>
using namespace std;

#define SERVER_IP "127.0.0.1"
#define SERVER_PORT 8000
#define BUF_SIZE 1024

struct sock_ev_write{//用户写事件完成后的销毁，在on_write()中执行
    struct event* write_ev;
    char* buffer;
};
struct sock_ev {//用于读事件终止（socket断开）后的销毁
    struct event_base* base;//因为socket断掉后，读事件的loop要终止，所以要有base指针
    struct event* read_ev;
};

static struct event_base* base;
/**
 * 销毁写事件用到的结构体
 */
void destroy_sock_ev_write(struct sock_ev_write* sock_ev_write_struct){
    if(NULL != sock_ev_write_struct){
//        event_del(sock_ev_write_struct->write_ev);//因为写事件没用EV_PERSIST，故不用event_del
        if(NULL != sock_ev_write_struct->write_ev){
            free(sock_ev_write_struct->write_ev);
        }
        if(NULL != sock_ev_write_struct->buffer){
            delete[]sock_ev_write_struct->buffer;
        }
        free(sock_ev_write_struct);
    }
}


/**
 * 读事件结束后，用于销毁相应的资源
 */
void destroy_sock_ev(struct sock_ev* sock_ev_struct){
    if(NULL == sock_ev_struct){
        return;
    }
    event_del(sock_ev_struct->read_ev);
    event_base_loopexit(sock_ev_struct->base, NULL);//停止loop循环
    if(NULL != sock_ev_struct->read_ev){
        free(sock_ev_struct->read_ev);
    }
    event_base_free(sock_ev_struct->base);
//    destroy_sock_ev_write(sock_ev_struct->sock_ev_write_struct);
    free(sock_ev_struct);
}
int getSocket(){
    int fd =socket( AF_INET, SOCK_STREAM, 0 );
    if(-1 == fd){
        cout<<"Error, fd is -1"<<endl;
    }
    return fd;
}

void on_write(int sock, short event, void* arg)
{
    cout<<"on_write() called, sock="<<sock<<endl;
    if(NULL == arg){
        cout<<"Error! void* arg is NULL in on_write()"<<endl;
        return;
    }
    struct sock_ev_write* sock_ev_write_struct = (struct sock_ev_write*)arg;

    char buffer[BUF_SIZE];
    sprintf(buffer, "fd=%d, received[%s]", sock, sock_ev_write_struct->buffer);
//    int write_num0 = write(sock, sock_ev_write_struct->buffer, strlen(sock_ev_write_struct->buffer));
//    int write_num = write(sock, sock_ev_write_struct->buffer, strlen(sock_ev_write_struct->buffer));
    cout<<"on_write() received = "<< sock_ev_write_struct->buffer <<endl;
    int write_num = write(sock, buffer, strlen(buffer));
    destroy_sock_ev_write(sock_ev_write_struct);
    cout<<"on_write() finished, sock="<<sock<<endl;
}

void on_read(int sock, short event, void* arg)
{
    cout<<"on_read() called, sock="<<sock<<endl;
    if(NULL == arg){
        return;
    }
    struct sock_ev* event_struct = (struct sock_ev*) arg;//获取传进来的参数
    char* buffer = new char[BUF_SIZE];
    memset(buffer, 0, sizeof(char)*BUF_SIZE);
    //--本来应该用while一直循环，但由于用了libevent，只在可以读的时候才触发on_read(),故不必用while了
    int size = read(sock, buffer, BUF_SIZE);
    if(0 == size){//说明socket关闭
        cout<<"read size is 0 for socket:"<<sock<<endl;
        destroy_sock_ev(event_struct);
        close(sock);
        return;
    }
    struct sock_ev_write* sock_ev_write_struct = (struct sock_ev_write*)malloc(sizeof(struct sock_ev_write));
    sock_ev_write_struct->buffer = buffer;
    struct event* write_ev = (struct event*)malloc(sizeof(struct event));//发生写事件（也就是只要socket缓冲区可写）时，就将反馈数据通过socket写回客户端
    sock_ev_write_struct->write_ev = write_ev;
    event_set(write_ev, sock, EV_WRITE, on_write, sock_ev_write_struct);
    event_base_set(event_struct->base, write_ev);
    event_add(write_ev, NULL);
    cout<<"on_read() finished, sock="<<sock<<endl;
}

/**
 * 每当有新连接连到server时，就通过libevent调用此函数。
 *    每个连接对应一个新线程
 */
void on_accept(int sock, short event, void* arg)
{
    struct sockaddr_in remote_addr;
    int sin_size=sizeof(struct sockaddr_in);
    int new_fd = accept(sock,  (struct sockaddr*) &remote_addr, (socklen_t*)&sin_size);
    if(new_fd < 0){
        cout<<"Accept error in on_accept()"<<endl;
        return;
    }
    cout<<"new_fd accepted is "<<new_fd<<endl;

    char* buffer = new char[BUF_SIZE];
    while(1)
    {
        memset(buffer, 0, sizeof(char)*BUF_SIZE);
        //--本来应该用while一直循环，但由于用了libevent，只在可以读的时候才触发on_read(),故不必用while了
        int size = read(new_fd, buffer, BUF_SIZE);
        if(0 == size){//说明socket关闭
            cout<<"read size is 0 for socket:"<<new_fd<<endl;
            close(new_fd);
            return;
        }
        cout<<"read = "<< buffer <<endl;
        int write_num = write(new_fd, buffer, strlen(buffer));
        cout<<"write = "<< buffer <<endl;
    }

    cout<<"on_accept() finished for fd="<<new_fd<<endl;
}

int main(){
    int fd = getSocket();
    if(fd<0){
        cout<<"Error in main(), fd<0"<<endl;
    }
    cout<<"main() fd="<<fd<<endl;
    //----为服务器主线程绑定ip和port------------------------------
    struct sockaddr_in local_addr; //服务器端网络地址结构体
    memset(&local_addr,0,sizeof(local_addr)); //数据初始化--清零
    local_addr.sin_family=AF_INET; //设置为IP通信
#if 0
    local_addr.sin_addr.s_addr=inet_addr(SERVER_IP);//服务器IP地址
#else
    local_addr.sin_addr.s_addr=htonl(0);//服务器IP地址
#endif
    local_addr.sin_port=htons(SERVER_PORT); //服务器端口号
    int bind_result = bind(fd, (struct sockaddr*) &local_addr, sizeof(struct sockaddr));
    if(bind_result < 0){
        cout<<"Bind Error in main()"<<endl;
        return -1;
    }
    cout<<"bind_result="<<bind_result<<endl;
    listen(fd, 10);
    //-----设置libevent事件，每当socket出现可读事件，就调用on_accept()------------
    base = event_base_new();
    struct event listen_ev;
    event_set(&listen_ev, fd, EV_READ|EV_PERSIST, on_accept, NULL);
    event_base_set(base, &listen_ev);
    event_add(&listen_ev, NULL);
    event_base_dispatch(base);

    //------以下语句理论上是不会走到的---------------------------
    cout<<"event_base_dispatch() in main() finished"<<endl;
    //----销毁资源-------------
    event_del(&listen_ev);
    event_base_free(base);
    cout<<"main() finished"<<endl;
}
