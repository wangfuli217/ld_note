#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/epoll.h>
#include <sys/time.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>

#define SERVER_OK       0
#define SERVER_FAILURE  -1
#define SERVER_BACKLOG  20
#define SERVER_PORT     11025
#define MAX_ARRAY_SIZE  1024
#define MAX_EVENTS      30

//将套接字设置为非阻塞模式
int setNonBlock(int sockfd)
{
    int opts;

    opts = fcntl(sockfd, F_GETFL);
    if(SERVER_FAILURE == opts)
    {
        perror("fcntl() F_GETFL");
        printf("fcntl() F_GETFL failed!!! errno=%d\n", errno);
        return SERVER_FAILURE;
    }

    opts |= O_NONBLOCK;
    opts = fcntl(sockfd, F_SETFL, opts);
    if(SERVER_FAILURE == opts)
    {
        perror("fcntl() F_SETFL");
        printf("fcntl() F_SETFL failed!!! errno=%d\n", errno);
        return SERVER_FAILURE;
    }

    return SERVER_OK;
}

int main(int argc, char**argv)
{
    struct sockaddr_in tServerAddr, tClientAddr;
    socklen_t nAddrLen = 0;
    int nRet = 0;
    int nListenFd = 0;
    int nConnFd = 0;
    char achBuff[MAX_ARRAY_SIZE+1] = {0};
    char achIp[30] = {0};
    int nPort = 0;
    int nClientCnt = 0;
    int nEpFd = 0;
    struct epoll_event tEv, tEvents[30]; 
    int on = 1;

    nListenFd = socket(AF_INET, SOCK_STREAM, 0);
    if(SERVER_FAILURE == nListenFd)
    {
        perror("socket()");
        printf("socket() failed!!! errno=%d\n", errno);
        return SERVER_FAILURE;
    }

    nRet = setsockopt(nListenFd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(int));
    if(SERVER_FAILURE == nRet)
    {
        perror("setsockopt()");
        printf("setsockopt() failed!!! error=%d\n", errno);
        return SERVER_FAILURE;
    }
    assert(0 == nRet);


    nRet = setNonBlock(nListenFd);
    if(SERVER_FAILURE == nRet)
    {
        printf("setNonBlock() nListenFd failed!!!\n");
        return SERVER_FAILURE;
    }

    memset(&tServerAddr, 0, sizeof(tServerAddr));
    tServerAddr.sin_family = AF_INET;
    tServerAddr.sin_port = htons(SERVER_PORT);
    tServerAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    nAddrLen = sizeof(tServerAddr);

    nRet = bind(nListenFd, (struct sockaddr*)&tServerAddr, nAddrLen);
    if(SERVER_FAILURE == nRet)
    {
        perror("bind()");
        printf("bind() failed!!! errno=%d\n", errno);
        return SERVER_FAILURE;
    }
    assert(SERVER_OK == nRet);

    nRet = listen(nListenFd, SERVER_BACKLOG);
    if(SERVER_FAILURE == nRet)
    {
        perror("listen()");
        printf("listen() failed!!! errno=%d\n", errno);
        return SERVER_FAILURE;
    }
    assert(SERVER_OK == nRet);

    printf("listening......\n");

    nEpFd = epoll_create(MAX_EVENTS);
    if(SERVER_FAILURE == nEpFd)
    {
        perror("epoll_create()");
        printf("epoll_create() failed!!! errno=%d\n", errno);
        return SERVER_FAILURE;
    }

    //设置监听套接字的epoll事件为读事件，并设置为边沿触发
    tEv.data.fd = nListenFd; 
    tEv.events = EPOLLIN | EPOLLET;

    nRet = epoll_ctl(nEpFd, EPOLL_CTL_ADD, nListenFd, &tEv);    //将监听套接字加入到epoll监控事件
    if(SERVER_FAILURE == nRet)
    {
        perror("epoll_ctl()");
        printf("epoll_ctl() Add nListenFd failed!!! errno=%d\n", errno);
        return SERVER_FAILURE;
    }
    assert(SERVER_OK == nRet);

    for(;;)
    {
        int nFds = epoll_wait(nEpFd, tEvents, MAX_EVENTS, -1);  //超时时间为-1，表示永久阻塞直到有可读写的套接字事件上来
        if(SERVER_FAILURE == nFds)
        {
            perror("epoll_wait()");
            printf("epoll_wait() failed!!! errno=%d\n", errno);
            continue;
        }

        for(int i=0; i<nFds; i++)
        {
            nAddrLen = sizeof(tClientAddr);
            int nFd = tEvents[i].data.fd;
            
            if(nFd == nListenFd)    //有客户端连接事件上来
            {
                while( (nConnFd = accept(nListenFd, (struct sockaddr*)&tClientAddr, &nAddrLen)) > 0)
                {
                    nClientCnt++;
                    printf("Now client's num:%d\n", nClientCnt);
                    nPort = ntohs(tClientAddr.sin_port);
                    inet_ntop(AF_INET, &tClientAddr.sin_addr, achIp, sizeof achIp);
                    printf("New connection: Client's IP[%s]:[%d]\n", achIp, nPort);

                    nRet = setNonBlock(nConnFd);
                    if(SERVER_FAILURE == nRet)
                    {
                        printf("setNonBlock() nConnFd failed!!!\n");
                        continue;
                    }

                    tEv.data.fd = nConnFd;
                    tEv.events = EPOLLIN | EPOLLET;
                    nRet = epoll_ctl(nEpFd, EPOLL_CTL_ADD, nConnFd, &tEv);
                    if(SERVER_FAILURE == nRet)
                    {
                        perror("epoll_ctl()");
                        printf("epoll_ctl() Add nConnFd failed!!! errno=%d\n", errno);
                        continue;
                    }
                    assert(SERVER_OK == nRet);
                }

                if(SERVER_FAILURE == nConnFd)
                {
                    if(errno!=EINTR && errno!=EAGAIN || errno!=ECONNABORTED)
                    {
                        perror("accept()");
                        printf("accept() failed!!! errno=%d\n", errno);
                        continue;
                    }   
                }
                continue;
            }

            nRet = getpeername(nFd, (struct sockaddr*)&tClientAddr, &nAddrLen);
            if(SERVER_FAILURE == nRet)
            {
                perror("getpeername()");
                printf("getpeername() errno=%d\n", errno);
                continue;
            }
            nPort = ntohs(tClientAddr.sin_port);
            inet_ntop(AF_INET, &tClientAddr.sin_addr, achIp, sizeof achIp);
            
            if(tEvents[i].events & EPOLLIN)   //可读事件
            {
                int nOffset = 0;
                memset(achBuff, 0, sizeof(achBuff));
                /*
                while( (nRet=read(nFd, achBuff+nOffset, MAX_ARRAY_SIZE)) > 0)
                {
                    nOffset += nRet;
                }
                */
                nRet = read(nFd, achBuff, MAX_ARRAY_SIZE);
                if(SERVER_FAILURE == nRet)
                {
                    if(errno == EAGAIN)
                        continue;
                    perror("read(nFd)");
                }
                else if(0 == nRet)
                {
                    printf("Socket closed by Client's IP[%s]:PORT[%d] buf:%s\n", achIp, nPort, achBuff);
                    tEv.data.fd = nFd;
                    tEv.events = EPOLLIN | EPOLLET;
                    nRet = epoll_ctl(nEpFd, EPOLL_CTL_DEL, nFd, &tEv);
                    if(SERVER_FAILURE == nRet)
                    {
                        perror("epoll_ctl()");
                        printf("epoll_ctl() Add nConnFd failed!!! errno=%d\n", errno);
                        continue;
                    }
                    assert(SERVER_OK == nRet);
                    nClientCnt--;
                    close(nFd);
                    continue;
                }
                
                printf("recv from Client's IP[%s]:PORT[%d] buf:%s\n", achIp, nPort, achBuff);
                
                tEv.data.fd = nFd;
                tEv.events = EPOLLOUT | EPOLLET;
                nRet = epoll_ctl(nEpFd, EPOLL_CTL_MOD, nFd, &tEv);
                if(SERVER_FAILURE == nRet)
                {
                    perror("epoll_ctl()");
                    printf("epoll_ctl() Add nConnFd failed!!! errno=%d\n", errno);
                    continue;
                }
                assert(SERVER_OK == nRet);

            }
            else if(tEvents[i].events & EPOLLOUT)   //可写事件
            {
                memset(achBuff, 0, sizeof(achBuff));
                strcpy(achBuff, "hello world! By Epoll");
                nRet = write(nFd, achBuff, strlen(achBuff));

                printf("nRet=%d, strlen(achBuff)=%lu\n", nRet, strlen(achBuff));
                printf("send to Client's IP[%s]:PORT[%d] buf:%s\n", achIp, nPort, achBuff);
                
                tEv.data.fd = nFd;
                tEv.events = EPOLLIN | EPOLLET;
                nRet = epoll_ctl(nEpFd, EPOLL_CTL_MOD, nFd, &tEv);
                if(SERVER_FAILURE == nRet)
                {
                    perror("epoll_ctl()");
                    printf("epoll_ctl() Add nConnFd failed!!! errno=%d\n", errno);
                    continue;
                }
                assert(SERVER_OK == nRet);
             }
            else
            {
                printf("Accidents!!! error\n");
            }
        }   
    }
    
    close(nListenFd);

    return 0;
}
