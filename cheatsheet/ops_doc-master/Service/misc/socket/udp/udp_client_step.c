//udp/ip client
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>  //close()
#include<sys/types.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<netinet/in.h>
int main(){
    int sockfd=socket(AF_INET,SOCK_DGRAM,0);
    if(-1==sockfd)
        perror("socket"),exit(-1);
    printf("create socket succesfully\n");
    struct sockaddr_in addr;
    addr.sin_family=AF_INET;
    addr.sin_port=htons(8888);
    addr.sin_addr.s_addr=inet_addr("176.43.11.211");    //这个是server的地址, 虽然没有connect, which means 不能通过socket找到这个地址, 但是我们还是知道这个地址的, sendto()是可以直接用的

    int res=sendto(sockfd,"hello",sizeof("hello"),0,(struct sockaddr*)&addr,sizeof(addr));
    if(-1==res)
        perror("sendto"),exit(-1);
    printf("data sent size:%d\n",res);
    char buf[100]={0};
    res=recv(sockfd,buf,sizeof(buf),0);
    if(-1==res)
        perror("recv"),exit(-1);
    printf("data received from server:%s\n",buf);
    res=close(sockfd);
    if(-1==res)
        perror("close"),exit(-1);

    return 0;
}