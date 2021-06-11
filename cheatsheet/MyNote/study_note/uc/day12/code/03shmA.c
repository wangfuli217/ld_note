//使用共享内存实现进程间的通信
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/shm.h>
#include<signal.h>
int shmid;
void fa(int signo)
{
	int res=shmctl(shmid,IPC_RMID,NULL);
	if(res==-1)
		perror("shmctl"),exit(-1);
	printf("删除共享内存成功\n");
	exit(0);
}
int main(void)
{
	//获取key值,使用ftok函数
	key_t key=ftok(".",150);
	if(-1==key)
		perror("ftok"),exit(-1);
	printf("key=%#x\n",key);
	//创建共享内存,使用shmget函数
	shmid=shmget(key,4,IPC_CREAT|IPC_EXCL|0644);
	if(-1==shmid)
		perror("shmget"),exit(-1);
	printf("shmid=%d\n",shmid);
	//挂接共享内存,使用shmat函数
	void *p=shmat(shmid,NULL,0);
	if((void*)-1==p)
		perror("shmat"),exit(-1);
	printf("挂接共享内存成功\n");
	//使用共享内存
	*(int *)p=100;
	//脱接共享内存,使用shmdt函数
	int res=shmdt(p);
	if(-1==res)
		perror("shmdt"),exit(-1);
	printf("脱接成功\n");
	//如果不再使用共享内存,使用shmctl函数删除共享内存
	printf("删除共享内存请按ctrl+c\n");
	signal(2,fa);
	while(1);
	return 0;
}
