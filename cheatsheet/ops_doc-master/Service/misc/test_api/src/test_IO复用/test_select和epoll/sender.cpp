#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include  <arpa/inet.h>
#include <sys/select.h>

#define MAXLINE 1024
#define SERV_PORT 6000

//!> ע����������stdin����������server���͹���
//!> ������client��Ҳ����Ҫselect���д����
void send_and_recv(int connfd) {
    FILE * fp = stdin;
    int lens;
    char send[MAXLINE];
    char recv[MAXLINE];
    fd_set rset;
    FD_ZERO(&rset);
    int maxfd = (fileno(fp) > connfd ? fileno(fp) : connfd + 1);
    //!> �������������ֵ
    int n;

    while (1) {
        FD_SET(fileno(fp), &rset);
        FD_SET(connfd, &rset);            //!> ע�ⲻҪ��rset�����Ǽ򵥵�һ������
        //!> ע������ʵ�ǿ��԰���һ���׽��ֵ�Ŷ��
        //!> �൱���Ƿ�װ�����飡ÿ�ζ�Ҫ���µ�Ŷ��

        if (select(maxfd, &rset, NULL, NULL, NULL) == -1) {
            printf("Client Select Error..\n");
            exit (EXIT_FAILURE);
        }

        //!> if ���ӿ�����Ϣ
        if (FD_ISSET(connfd, &rset)) //!> if ���Ӷ˿�����Ϣ
                {
            printf("client get from server ...\n");
            memset(recv, 0, sizeof(recv));
            n = read(connfd, recv, MAXLINE);
            if (n == 0) {
                printf("Recv ok...\n");
                break;
            } else if (n == -1) {
                printf("Recv error...\n");
                break;
            } else {
                lens = strlen(recv);
                recv[lens] = '\0';
                //!> д��stdout
                write(STDOUT_FILENO, recv, MAXLINE);
                printf("\n");
            }

        }

        //!> if ��stdin����
        if (FD_ISSET(fileno(fp), &rset))   //!> if ������
                {
            //!> printf("client stdin ...\n");

            memset(send, 0, sizeof(send));
            if (fgets(send, MAXLINE, fp) == NULL) {
                printf("End...\n");
                exit (EXIT_FAILURE);
            } else {
                //!>if( str )
                lens = strlen(send);
                send[lens - 1] = '\0';        //!> ��һ��ԭ���ǲ�Ҫ�س��ַ�
                //!> ����ֵ����һ���ǳ���Ҫ��Ŷ����������������
                if (strcmp(send, "q") == 0) {
                    printf("Bye..\n");
                    return;
                }

                printf("Client send : %s\n", send);
                write(connfd, send, strlen(send));
            }
        }

    }

}

int main(int argc, char ** argv) {
    //!> char * SERV_IP = "10.30.97.188";
    char buf[MAXLINE];
    int connfd;
    struct sockaddr_in servaddr;

    if (argc != 2) {
        printf("Input server ip !\n");
        exit (EXIT_FAILURE);
    }

    //!> �����׽���
    if ((connfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        printf("Socket Error...\n", errno);
        exit (EXIT_FAILURE);
    }

    //!> �׽�����Ϣ
    bzero(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(SERV_PORT);
    inet_pton(AF_INET, argv[1], &servaddr.sin_addr);

    //!> ����server
    if (connect(connfd, (struct sockaddr *) &servaddr, sizeof(servaddr)) < 0) {
        printf("Connect error..\n");
        exit (EXIT_FAILURE);
    }
    /*else
     {
     printf("Connet ok..\n");
     }*/

    //!>
    //!> send and recv
    send_and_recv(connfd);

    //!>

    close(connfd);
    printf("Exit\n");

    return 0;
}
