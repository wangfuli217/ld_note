#include<unistd.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/sem.h>
#include<signal.h>
#include<stdio.h>
#include<stdlib.h>
int main(){
    //get key
    key_t key=ftok(".",200);
    if(-1==key)
        perror("ftok"),exit(-1);
    printf("key=%d\n",key);
    //create sem
    int semid=semget(key,0,0);
    if(-1==semid)
        perror("semget"),exit(-1);
    printf("semid=%d\n",semid);
    //creat 10 children to take the shared resource
    int i=0;
    for(i=0;i<10;i++){      //创建10个进程, 当然,需要只给parent或child单独fork(), 否则就是2^10个进程
        pid_t pid=fork();
        if(-1==pid)
            perror("fork"),exit(-1);
        if(0==pid){

            struct sembuf buf;      //准备占用资源, sem_op-1
            buf.sem_num=0;      //信号量集下标
            buf.sem_op=-1;      //信号量-1
            buf.sem_flg=0;      //操作标志
            int res=semop(semid,&buf,1/*结构体变量的个数*/);
            if(-1==res)
                perror("semop"),exit(-1);

            sleep(20);          //模拟正在占用共享资源

            buf.sem_op=1;       //占用完了, sem_op+1
            res=semop(semid,&buf,1);
            if(-1==res)
                perror("semop"),exit(-1);

            exit(0);                //终止子进程, 自然也就跳出了循环,防止再fork()
        //  break;
        }
    }   
    return 0;
}
//出现抢占的效果, 还没有全部释放完毕的时候就有进程抢到了已经释放的进程