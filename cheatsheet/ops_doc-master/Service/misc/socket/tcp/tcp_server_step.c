/创建server, 用多进程同时响应多个client的请求, 当client发来 “bye”的时候断开连接, 按下Ctrl+C关闭服务器
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>      //省略了几个头文件
int sockfd; //全局变量

void fa(int signo){
    printf("closing server...\n");
    sleep(3);
    int res=close(sockfd);
    if(-1==res)
        perror("close"),exit(-1);
    printf("server closed\n");
    exit(0);
}
int main(){
    //1.创建socket    socket()
    int sockfd=socket(AF_INET,SOCK_STREAM,0);
    if(-1==sockfd)
        perror("socket"),exit(-1);
    printf("creat socket success\n");

    //2.准备通信地址(服务器地址)，使用结构体类型
    struct sockaddr_in addr={0};    //要初始化为0
    addr.sin_family=AF_INET;
    addr.sin_port=htons(8888);
    addr.sin_addr.s_addr=inet_addr("176.43.11.211");                //client也用这个server的地址

    //3.绑定socket和通信地址，使用bind()
    int res=bind(sockfd, (struct sockaddr*)&addr,sizeof(addr));         //client用connect
    if(-1==res)
        perror("bind"),exit(-1);
    printf("bind success\n");
    
    //4.生成侦听socket:   listening socket  listen()                    //client可没有这一步
    res=listen(sockfd,100);
    if(-1==res)
        perror("listen"),exit(-1);
    printf("listen success\n");
    //set SIGINT
    printf("Press ctrl+c to close server\n");
    if(SIG_ERR==signal(SIGINT,fa))      //整个程序，包括第一个while(1)是通过信号处理终止的
        perror("signal"),exit(-1);
 
    while(1){   //只要有client接入就创建新进程与之通信
        struct sockaddr_in recv_addr;
        socklen_t len=sizeof(recv_addr);
        int CnnSockfd=accept(sockfd,(struct sockaddr*)&recv_addr,&len);     
            //如果侦听队列里面有client就accept(), 否则就在这阻塞着，不继续执行，除非遇到Ctrl+C终止整个进程
        if(-1==CnnSockfd)
            perror("accept"),exit(-1);
        char *ip=inet_ntoa(recv_addr.sin_addr);
        printf("client:%s linked\n",ip);
        
        pid_t pid=fork();
        if(-1==pid)
            perror("fork()"),exit(-1);
        if(0==pid){
            if(SIG_ERR==signal(SIGINT,SIG_DFL))
                perror("signal"),exit(-1);
            //每个child处理一个client，所以已经不需要listening socket了，可以把它关了
            //如果不关子进程也会有一个listenfd，会和父进程一起抢，不应该
            res=close(sockfd);  
            if(-1==res)
                perror("close"),exit(-1);
            while(1){           //只要client发数据就处理，除非遇到 “bye”
                char buf[100]={0};
                res=recv(CnnSockfd,buf,sizeof(buf),0);
                if(-1==res)
                    perror("recv"),exit(-1);
                printf("client%s,data sent:%s\n",ip,buf);
                if(!strcmp(buf,"bye")){     //遇到“bye”就不再待命，break掉准备断开连接
                    printf("client%s has been unlinked\n",ip);
                    break;
                }
                res=send(CnnSockfd,"I received!",12,0);
                if(-1==res)
                    perror("send"),exit(-1);
            }
            res=close(CnnSockfd);           //断开连接即close(相应的connected socket)
            if(-1== res)
                perror("close"),exit(-1);
            exit(0);                        //断开了连接了，就可以exit子进程了
        }
        res=close(CnnSockfd);   //
        if(-1==res)
            perror("close"),exit(-1);
    }
    return 0;
}