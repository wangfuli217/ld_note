#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <errno.h>

#define BUFLEN 255
int main(int argc, char **argv)
{
struct sockaddr_in peeraddr;
struct in_addr ia;
int sockfd;
char recmsg[BUFLEN + 1];
unsigned int socklen, n;
struct hostent *group;
struct ip_mreq mreq;

/* 创建 socket 用于UDP通讯 */
sockfd = socket(AF_INET, SOCK_DGRAM, 0);
if (sockfd < 0) {
printf("socket creating err in udptalk\n");
exit(1);
}

/* 设置要加入组播的地址 */
bzero(&mreq, sizeof(struct ip_mreq));
if (argv[1]) {
if ((group = gethostbyname(argv[1])) == (struct hostent *) 0) {
perror("gethostbyname");
exit(errno);
}
} else {
printf
("you should give me a group address, 224.0.0.0-239.255.255.255\n");
exit(errno);
}

bcopy((void *) group->h_addr, (void *) &ia, group->h_length);
/* 设置组地址 */
bcopy(&ia, &mreq.imr_multiaddr.s_addr, sizeof(struct in_addr));

/* 设置发送组播消息的源主机的地址信息 */
mreq.imr_interface.s_addr = htonl(INADDR_ANY);

/* 把本机加入组播地址，即本机网卡作为组播成员，只有加入组才能收到组播消息 */
if (setsockopt
(sockfd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq,
sizeof(struct ip_mreq)) == -1) {
perror("setsockopt");
exit(-1);
}

socklen = sizeof(struct sockaddr_in);
memset(&peeraddr, 0, socklen);
peeraddr.sin_family = AF_INET;
if (argv[2])
peeraddr.sin_port = htons(atoi(argv[2]));
else
peeraddr.sin_port = htons(7838);
if (argv[1]) {
if (inet_pton(AF_INET, argv[1], &peeraddr.sin_addr) <= 0) {
printf("Wrong dest IP address!\n");
exit(0);
}
} else {
printf("no group address given, 224.0.0.0-239.255.255.255\n");
exit(errno);
}

/* 绑定自己的端口和IP信息到socket上 */
if (bind
(sockfd, (struct sockaddr *) &peeraddr,
sizeof(struct sockaddr_in)) == -1) {
printf("Bind error\n");
exit(0);
}

/* 循环接收网络上来的组播消息 */
for (;;) {
bzero(recmsg, BUFLEN + 1);
n = recvfrom(sockfd, recmsg, BUFLEN, 0,
(struct sockaddr *) &peeraddr, &socklen);
if (n < 0) {
printf("recvfrom err in udptalk!\n");
exit(4);
} else {
/* 成功接收到数据报 */
recmsg[n] = 0;
printf("peer:%s", recmsg);
}
}
}

/*
编译程序用下列命令：
gcc -Wall mcastclient.c -o mcastclient
gcc -Wall mcastserver.c -o mcastserver
运行程序用如下命令：
./mcastserver 230.1.1.1 7838
客户端程序运行命令为：
./mcastclient 230.1.1.1 7838 192.168.100.1 12345
*/