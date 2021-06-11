//使用信号量集实现进程间的通信
#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<unistd.h>
#include<sys/ipc.h>
#include<sys/sem.h>
#include<signal.h>
int semid;
void fa(int signo)
{
	printf("正在删除信号量集,请稍后...\n");
	sleep(2);
	int res=semctl(semid,0,IPC_RMID);
	if(res==-1)
		perror("semctl"),exit(-1);
	printf("删除信号量集成功\n");
	exit(0);
}
int main(void)
{
	//获取key值,使用ftok函数
	key_t key=ftok(".",200);
	if(-1==key)
		perror("ftok"),exit(-1);
	printf("key=%#x\n",key);
	//创建信号量集,使用semget函数
	semid=semget(key,1,IPC_CREAT|IPC_EXCL|0644);
	if(-1==semid)
		perror("semget"),exit(-1);
	printf("semid=%d\n",semid);
	//初始化信号量集,使用semctl函数
	int res=semctl(semid,0/*信号量集的下标*/,SETVAL,5/*初始值*/);
	if(-1==res)
		perror("semctl"),exit(-1);
	printf("信号量集初始化完毕\n");
	//删除信号量集,使用信号2处理
	printf("删除信号量集,请按ctrl+c\n");
	signal(2,fa);
	while(1);
	return 0;
}
