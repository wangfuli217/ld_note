#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <unistd.h>
#include  <arpa/inet.h>
int s;//socket
//typedef enum//定义bool类型,c语言中没有bool类型
//{
//    false,
//    true
//}bool;

bool init (const char* addr, const short port)
{
    struct sockaddr_in servaddr;

    s = socket(AF_INET, SOCK_STREAM, 0);
    if(-1 == s)
        return false;

    int rep = 1;
    if ( 0 != ::setsockopt( s, SOL_SOCKET, SO_REUSEADDR, &rep, sizeof(rep) ))
    {
        return false;
    }

    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    if(inet_pton(AF_INET, addr, &servaddr.sin_addr) < 0)
        return false;
    servaddr.sin_port = htons(port);
    if(bind(s, (struct sockaddr*)&servaddr, sizeof(servaddr)) == -1)
    {
        printf("port is in use\n");
        return false;
    }
    if(listen(s, 10) == -1)
        return false;

    printf("init success! listen port %d\n", port);
    return true;
}

void do_cycle()
{
    int connect_fd;
    char rcvbuf[102400];
    char sndbuf[102400];
    pid_t pid = getpid();

    while(true)
    {
        if((connect_fd = accept(s, (struct sockaddr*)NULL, NULL)) == -1)
        {
            printf("accept socket error\n");
            continue;
        }
        printf("accept()\n");
        recv(connect_fd, rcvbuf, 102400, 0);
//        snprintf(sndbuf, 102400, "HTTP/1.1 200 OK\r\n\r\n<html><head><title>hello</title></head><body>process id: %d</body></html>", pid);
        snprintf(sndbuf, 102400,"%d", pid);
        send(connect_fd, sndbuf, strlen(sndbuf), 0);
        close(connect_fd);
    }
}

void loop_cycle(int process_num)
{
    int i, j;
    pid_t pid;
    pid_t sub_ids[process_num];
    char killstr[1024];
    char ch;
    if(1 == process_num)
        do_cycle();
    else
    for (i = 0; i < process_num; i++)
    {
        pid = fork();
        if(pid < 0)
        {
            printf("fork error\n");
            for(j = 0; j < i; j++)
            {
                snprintf(killstr, 1024, "kill -9 %d", sub_ids[j]);
                system(killstr);
            }

            return;
        }
        if(pid == 0)
            do_cycle();
        if(pid > 0)
            sub_ids[i] = pid;
    }
    while(true)
    {
        scanf("%c", &ch);
        if(ch == 'q')
        {
            for(j = 0; j < process_num; j++)
            {
                snprintf(killstr, 1024, "kill -9 %d", sub_ids[j]);
                system(killstr);
            }
            close(s);
            break;
        }
    }
}

#define SERV_PORT 6000
int main(int argc, char* args[])
{
    int port, pro_num;

    port = SERV_PORT;
    pro_num = 10;
    if(!init("0.0.0.0", port))
        return 0;
//    sleep(60);
    loop_cycle(pro_num);
    return 0;
}
