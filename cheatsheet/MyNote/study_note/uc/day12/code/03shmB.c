#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/shm.h>
#include<sys/ipc.h>

int main(void)
{
	key_t key=ftok(".",150);
	if(key==-1)
		perror("ftok"),exit(-1);
	int shmid=shmget(key,4,0);
	if(shmid==-1)
		perror("shmget"),exit(-1);
	printf("shmid=%d\n",shmid);
	void *p=shmat(shmid,NULL,0);
	if((void*)-1==p)
		perror("shmat"),exit(-1);
	printf("挂接共享内存成功\n");
	printf("共享内存里的内容是:%d\n",*(int*)p);
	int res=shmdt(p);
	if(res==-1)
		perror("shmdt"),exit(-1);
	printf("脱接成功\n");
	return 0;
}
