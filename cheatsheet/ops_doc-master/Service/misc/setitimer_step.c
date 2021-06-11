#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/time.h>
#include<signal.h>
#include<sys/types.h>
void fa(int signo){
    printf("random\n");
}
int main(){
    //设置对信号SIGALRM进行自定义处理
    if(SIG_ERR==signal(SIGALRM,fa))
        perror("signal"),exit(-1);
    struct itimerval timer;
    //设置间隔时间
    timer.it_interval.tv_sec=2;
    timer.it_interval.tv_usec=300000;
    //设置启动时间
    timer.it_value.tv_sec=5;
    timer.it_value.tv_usec=0;
    int res=setitimer(ITIMER_REAL,&timer,NULL);
    if(-1==res)
        perror("setitimer"),exit(-1);
    getchar();
    itimer.it_value.tv_sec=0;
    setitimer(ITIMER_REAL,&timer,NULL); //没有错误处理
    while(1);
    return 0;
}