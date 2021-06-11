#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define SERV_PORT 6000

void test_connect()
{
    unsigned short port = SERV_PORT;             // 服务器的端口号
    char *server_ip = "127.0.0.1";       // 服务器ip地址

    int sockfd;
    sockfd = socket(AF_INET, SOCK_STREAM, 0);// 创建通信端点：套接字
    if(sockfd < 0)
    {
        perror("socket");
        exit(-1);
    }

    struct sockaddr_in server_addr;
    bzero(&server_addr,sizeof(server_addr)); // 初始化服务器地址
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    inet_pton(AF_INET, server_ip, &server_addr.sin_addr);

    int err_log = connect(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr));      // 主动连接服务器
    if(err_log != 0)
    {
        perror("connect");
        close(sockfd);
        exit(-1);
    }

//    printf("err_log ========= %d\n", err_log);

    char send_buf[100]="this is for test";
    send(sockfd, send_buf, strlen(send_buf), 0);   // 向服务器发送信息

    int len = recv(sockfd, send_buf, 100, 0);
    send_buf[len] = 0;
    printf("recv info = %s\n", send_buf);
//    system("netstat -an | grep 8000");  // 查看连接状态

   sleep(10);
   len = recv(sockfd, send_buf, 100, 0);
   printf("recv len = %d\n", len);
   close(sockfd);
}

int main(int argc, char *argv[])
{
    pid_t pid;

    for (int i=0;i<10;++i)
    {
        pid = fork();
        if(0 == pid)
        {
            test_connect();     // 1
            break;
        }
    }

    while(1)
        sleep(10);

    return 0;
}
