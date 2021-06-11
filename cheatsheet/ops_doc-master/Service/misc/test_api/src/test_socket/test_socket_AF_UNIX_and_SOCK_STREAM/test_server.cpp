#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <sys/un.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char * argv[]) {
    int s_fd, c_fd;
    int s_len, c_len;
    struct sockaddr_un s_addr,c_addr; /*声明一个UNIX域套接字结构*/
    int i, bytes;
    char ch_send, ch_recv;


    unlink("./s_socket"); /*删除原有server_socket对象*/

    /*创建 socket, 通信协议为AF_UNIX, SCK_STREAM 数据方式*/
    s_fd = socket(AF_UNIX, SOCK_STREAM, 0);

    /*配置服务器信息(通信协议)*/
    s_addr.sun_family = AF_UNIX;

    /*配置服务器信息(socket 对象)*/
    strcpy(s_addr.sun_path, "./s_socket");

    /*配置服务器信息(服务器地址长度)*/
    s_len = sizeof(s_addr);

    /*绑定 socket 对象*/
    bind(s_fd, (struct sockaddr *) &s_addr, s_len);

    /*监听网络,队列数为5*/
    listen(s_fd, 5);
    printf("Server is waiting for client connect... \n ");
    c_len = sizeof(c_addr);

    /*接受客户端请求; 第2个参数用来存储客户端地址; 第3个参数用来存储客户端地址的大小*/
    /*建立(返回)一个到客户端的文件描述符,用以对客户端的读写操作*/
    c_fd = accept(s_fd, (struct sockaddr *) &s_addr,
            (socklen_t *) &c_len);
    if (c_fd == -1) {
        perror("accept");
        exit( EXIT_FAILURE);
    }
    printf("The server is waiting for client data... \n ");

    for (i = 0, ch_send = '1'; i < 5; i++, ch_send++) {
        if ((bytes = read(c_fd, &ch_recv, 1)) == -1) {
            perror("read");
            exit( EXIT_FAILURE);
        }
        printf("The character receiver from client is %c \n ", ch_recv);
        sleep(1);
        if ((bytes = write(c_fd, &ch_send, 1)) == -1) {
            perror("read");
            exit( EXIT_FAILURE);
        }
    }

    close(c_fd);

    unlink("server socket");
}
