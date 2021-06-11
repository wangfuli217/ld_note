//udp/ip server 五步走
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
int main(){
    //1. 创建socket
    int sockfd=socket(AF_INET,SOCK_DGRAM,0);
    if(-1==sockfd)
        perror("socket"),exit(-1);
    
    //2. 准备通信地址
    struct sockaddr_in addr;
    addr.sin_family=AF_INET;
    addr.sin_port=htons(8888);
    addr.sin_addr.s_addr=inet_addr("176.43.11.211");

    //3. 绑定socket和通信地址
    int res=bind(sockfd,(struct sockaddr*)&addr,sizeof(addr));
    if(-1==res)
        perror("bind"),exit(-1);
    printf("bind success\n");

    //4. 进行通信
    char buf[100]={0};
    struct sockaddr_in recv_addr;       //为使用recvfrom得到client地址做准备, 最终为sendto()做准备
    socklen_t len=sizeof(recv_addr);
    res=recvfrom(sockfd,buf,sizeof(buf),0,(struct sockaddr*)&recv_addr,&len);
    if(-1==res)
        perror("recvfrom"),exit(-1);

    char* ip=inet_ntoa(recv_addr.sin_addr);             //将recvfrom获得client地址转换成点分十进制字符串
    printf("data received from client :%s is:%d\n",ip,res); 

    res=sendto(sockfd,"I received",sizeof("I received"),0,(struct sockaddr*)&recv_addr,len);//使用recvfrom获得的client地址
    if(-1==res)
        perror("sendto"),exit(-1);

    //5. 关闭socket
    res=close(sockfd);
    if(-1==res)
        perror("close"),exit(-1);
    printf("close success\n");
        
    return 0;
}