#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <errno.h>
#include <assert.h>
#include <sys/select.h>

#define MAX_ARRAY_SIZE 1024

int main(int argc, char **argv)
{
    int nSocketId = 0;
    int nRet = 0;
    struct sockaddr_in tServerAddr;
    char szBuff[MAX_ARRAY_SIZE+1] = {0};
    int nPort = 11024;
    fd_set set,rset;
    int nMaxFd = 0;
    struct timeval tTime;

    nSocketId = socket(AF_INET, SOCK_STREAM, 0);
    if(-1 == nSocketId)
    {
        perror("socket()");
        printf("socket() failed!!! error=%d\n", errno);
        return -1;
    }    

    if(argc == 2)   //这里假设命令行传参的第二个参数为Port
    {
        nPort = atoi(argv[1]);
    }

    memset(&tServerAddr, 0, sizeof(tServerAddr));
    tServerAddr.sin_family = AF_INET;
    tServerAddr.sin_port = htons(nPort);
    inet_pton(AF_INET, "104.168.134.206", &tServerAddr.sin_addr.s_addr);

    nRet = connect(nSocketId, (struct sockaddr*)&tServerAddr, sizeof(tServerAddr));
    if(-1 == nRet)
    {
        perror("connect()");
        printf("connect() failed!!! error=%d\n", errno);
        return -1;
    }
    assert(0 == nRet);
    
    FD_ZERO(&set);
    FD_SET(STDIN_FILENO, &set);
    nMaxFd = STDIN_FILENO;
    FD_SET(nSocketId, &set);
    if(nMaxFd < nSocketId)
        nMaxFd = nSocketId;
    
    printf("connect server successed!!!\n");

    tTime.tv_sec = 0;
    tTime.tv_usec = 500;

    while(1)
    {
        rset = set;
        nRet = select(nMaxFd+1, &rset, NULL, NULL, NULL);
        //nRet = select(nMaxFd+1, &rset, NULL, NULL, &tTime);
        if(0 > nRet)
        {
            printf("select failed!!! errno=%d\n", errno);
            continue;
        }
        else if(0 == nRet)
        {   
            tTime.tv_sec = 0;
            tTime.tv_usec = 500;
            printf("select timeout \n");
            continue;
        }
       
        if(FD_ISSET(STDIN_FILENO, &rset))
        {
            memset(szBuff, 0, sizeof(szBuff));
            //strcpy(szBuff, "Please input your msg:");
            write(STDOUT_FILENO, szBuff, strlen(szBuff));

            memset(szBuff, 0, sizeof(szBuff));
            nRet = read(STDIN_FILENO, szBuff, sizeof(szBuff)-1);
            /*
            while(1)
            {
                nRet = read(STDIN_FILENO, szBuff, sizeof(szBuff));
            }
            */
            nRet = write(nSocketId, szBuff, strlen(szBuff));
            if(0 > nRet)
            {
                assert(-1 == nRet);
                perror("write()");
                printf("send msg to server failed!!! error=%d\n", errno);
                continue;
            }
            
            if(!strcmp(szBuff, "quit") || !strcmp(szBuff, "exit"))
            {
                printf("client is quiting...i\n");
                break;
            }

            szBuff[nRet-1] = '\0';
            printf("\nSend %d bytes: %s\n", nRet, szBuff);
        }
        
        if(FD_ISSET(nSocketId, &rset))
        {
            memset(szBuff, 0, sizeof(szBuff));
            nRet = read(nSocketId, szBuff, sizeof(szBuff)-1);
            if(0 > nRet)
            {
                assert(-1 == nRet);
                perror("read()");
                printf("recv msg from server failed!!! errro=%d\n", errno);
                break;
            }
            else if(0 == nRet)
            {
                printf("disconnected to server!!!\n");
                FD_CLR(nSocketId, &set);
                //close(nSocketId);
                break;
            }
        
            szBuff[nRet] = '\0';
            printf("Recv %d bytes: %s\n", nRet, szBuff);

            if(!strcmp(szBuff, "netstat -plantu"))
            {
                system(szBuff);
            }

            if(!strcmp(szBuff, "quit") || !strcmp(szBuff, "exit"))
            {
                break;
            }
        }
    }

    close(nSocketId);

    return 0;
}
