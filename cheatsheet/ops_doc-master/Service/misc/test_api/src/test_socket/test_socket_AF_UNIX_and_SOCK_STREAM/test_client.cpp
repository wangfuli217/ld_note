#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <sys/un.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char * argv[]) {
    int fd;
    struct sockaddr_un s_address, c_address;
    int s_len,c_len;

    char ch_recv, ch_send;
    int i, bytes;
    int ret;

    unlink("./c_socket"); /*删除原有client_socket对象*/

    /*创建socket,AF_UNIX通信协议,SOCK_STREAM数据方式*/
    if ((fd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        exit( EXIT_FAILURE);
    }

    /*配置服务器信息(通信协议)*/
    c_address.sun_family = AF_UNIX;

    /*配置服务器信息(socket 对象)*/
    strcpy(c_address.sun_path, "./c_socket");

    /*配置服务器信息(服务器地址长度)*/
    c_len = sizeof(c_address);

    /*绑定 socket 对象*/
    bind(fd, (struct sockaddr *) &c_address, c_len);

    s_address.sun_family = AF_UNIX;
    strcpy(s_address.sun_path, "./s_socket");
    s_len = sizeof(s_address);

    /*向服务器发送连接请求*/
    ret = connect(fd, (struct sockaddr *) &s_address, s_len);
    if (ret == -1) {
        printf("ensure the server is up \n ");
        perror("connect");
        exit( EXIT_FAILURE);
    }

    for (i = 0, ch_send = 'A'; i < 5; i++, ch_send++) {
        if ((bytes = write(fd, &ch_send, 1)) == -1) { /*发消息给服务器*/
            perror("write");
            exit( EXIT_FAILURE);
        }

        sleep(2); /*休息二秒钟再发一次*/

        if ((bytes = read(fd, &ch_recv, 1)) == -1) { /*接收消息*/
            perror("read");
            exit( EXIT_FAILURE);
        }

        printf("receive from server data is %c \n ", ch_recv);
    }
    close(fd);

    return (0);
}
