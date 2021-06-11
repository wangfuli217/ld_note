#include <iostream>
#include <sys/select.h>
#include <sys/socket.h>
#include <unistd.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string>
#include <string.h>
#include <event.h>
using namespace std;

#define BUF_SIZE 1024

/**
 * 连接到server端，如果成功，返回fd，如果失败返回-1
 */
int connectServer(char* ip, int port){
    int fd = socket( AF_INET, SOCK_STREAM, 0 );
    cout<<"fd= "<<fd<<endl;
    if(-1 == fd){
        cout<<"Error, connectServer() quit"<<endl;
        return -1;
    }
    struct sockaddr_in remote_addr; //服务器端网络地址结构体
    memset(&remote_addr,0,sizeof(remote_addr)); //数据初始化--清零
    remote_addr.sin_family=AF_INET; //设置为IP通信
    remote_addr.sin_addr.s_addr=inet_addr(ip);//服务器IP地址
    remote_addr.sin_port=htons(port); //服务器端口号
    int con_result = connect(fd, (struct sockaddr*) &remote_addr, sizeof(struct sockaddr));
    if(con_result < 0){
        cout<<"Connect Error!"<<endl;
        close(fd);
        return -1;
    }
    cout<<"con_result="<<con_result<<endl;
    return fd;
}

void on_read(int sock, short event, void* arg)
{
    char* buffer = new char[BUF_SIZE];
    memset(buffer, 0, sizeof(char)*BUF_SIZE);
    //--本来应该用while一直循环，但由于用了libevent，只在可以读的时候才触发on_read(),故不必用while了
    int size = read(sock, buffer, BUF_SIZE);
    if(0 == size){//说明socket关闭
        cout<<"read size is 0 for socket:"<<sock<<endl;
        struct event* read_ev = (struct event*)arg;
        if(NULL != read_ev){
            event_del(read_ev);
            free(read_ev);
        }
        close(sock);
        return;
    }
    cout<<"Received from server---"<<buffer<<endl;
    delete[]buffer;
}

int main() {
    cout << "main started" << endl; // prints Hello World!!!
#if 0
    cout << "Please input server IP:"<<endl;
    char ip[16];
    cin >> ip;
    cout << "Please input port:"<<endl;
    int port;
    cin >> port;
#else
    char ip[16] = "127.0.0.1";
    int port = 8000;
#endif
    cout << "ServerIP is "<<ip<<" ,port="<<port<<endl;
    int socket_fd = connectServer(ip, port);
    cout << "socket_fd="<<socket_fd<<endl;

    struct event_base* base = event_base_new();
    struct event* read_ev = (struct event*)malloc(sizeof(struct event));//发生读事件后，从socket中取出数据
    event_set(read_ev, socket_fd, EV_READ|EV_PERSIST, on_read, read_ev);
    event_base_set(base, read_ev);
    event_add(read_ev, NULL);

    //--------------------------
    char buffer[BUF_SIZE];
    bool isBreak = false;
    while(!isBreak){
        cout << "Input your data to server(\'q\' or \"quit\" to exit)"<<endl;
        cin >> buffer;
        if(strcmp("q", buffer)==0 || strcmp("quit", buffer)==0){
            isBreak=true;
            close(socket_fd);
            break;
        }
        cout << "Your input is "<<buffer<<endl;
        int write_num = write(socket_fd, buffer, strlen(buffer));
        cout << write_num <<" characters written"<<endl;
        sleep(2);
    }
    cout<<"main finished"<<endl;

    event_base_dispatch(base);
    //--------------
    event_base_free(base);
    return 0;
}
