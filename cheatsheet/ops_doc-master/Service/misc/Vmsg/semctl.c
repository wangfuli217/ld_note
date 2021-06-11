#include <linux/sem.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#define SEM_PATH "/unix/my_sem"
#define max_tries 3 
int semid;
int main(){
	int flag1,flag2,key,i,init_ok,tmperrno;
	struct semid_ds sem_info;
	struct seminfo sem_info2;
	union semun arg;       //union semun： 请参考附录2
	struct sembuf askfor_res, free_res;
	flag1=IPC_CREAT|IPC_EXCL|00666;
	flag2=IPC_CREAT|00666;
	key=ftok(SEM_PATH,'a');
	//error handling for ftok here;
	init_ok=0;
	semid=semget(key,1,flag1);
	//create a semaphore set that only includes one semphore.
	if(semid<0){
		tmperrno=errno;
		perror("semget");
		if(tmperrno==EEXIST){
			//errno is undefined after a successful library call( including perror call) 
			//so it is saved  in tmperrno.
			semid=semget(key,1,flag2);
			//flag2 只包含了IPC_CREAT标志, 参数nsems(这里为1)必须与原来的信号灯数目一致
			arg.buf=&sem_info;
			for(i=0; i<max_tries; i++) {
				if(semctl(semid, 0, IPC_STAT, arg)==-1){  
					perror("semctl error"); i=max_tries;}
				else
				{ 
					if(arg.buf->sem_otime!=0) { 
						i=max_tries;  init_ok=1;
					} else   
						sleep(1);  
				}
			}
			if(!init_ok){
				// do some initializing, here we assume that the first process that creates the sem
				//  will finish initialize the sem and run semop in max_tries*1 seconds. else it will  
				// not run semop any more.
				arg.val=1;
				if(semctl(semid,0,SETVAL,arg)==-1) perror("semctl setval error");
			} 
		}
		else
		{perror("semget error, process exit");  exit(1);  }
	}
	else //semid>=0; do some initializing   
	{
		arg.val=1;
		if(semctl(semid,0,SETVAL,arg)==-1)
			perror("semctl setval error");
	}
	//get some information about the semaphore and the limit of semaphore in redhat8.0
	arg.buf=&sem_info;
	if(semctl(semid, 0, IPC_STAT, arg)==-1)
		perror("semctl IPC STAT");    
	printf("owner's uid is %d\n",   arg.buf->sem_perm.uid);
	printf("owner's gid is %d\n",   arg.buf->sem_perm.gid);
	printf("creater's uid is %d\n",   arg.buf->sem_perm.cuid);
	printf("creater's gid is %d\n",   arg.buf->sem_perm.cgid);
	arg.__buf=&sem_info2;
	if(semctl(semid,0,IPC_INFO,arg)==-1)
		perror("semctl IPC_INFO");
	printf("the number of entries in semaphore map is %d \n",  arg.__buf->semmap);
	printf("max number of semaphore identifiers is %d \n",    arg.__buf->semmni);
	printf("mas number of semaphores in system is %d \n",   arg.__buf->semmns);
	printf("the number of undo structures system wide is %d \n",  arg.__buf->semmnu);
	printf("max number of semaphores per semid is %d \n",   arg.__buf->semmsl);
	printf("max number of ops per semop call is %d \n",  arg.__buf->semopm);
	printf("max number of undo entries per process is %d \n",  arg.__buf->semume);
	printf("the sizeof of struct sem_undo is %d \n",  arg.__buf->semusz);
	printf("the maximum semaphore value is %d \n",  arg.__buf->semvmx);

	//now ask for available resource:  
	askfor_res.sem_num=0;
	askfor_res.sem_op=-1;
	askfor_res.sem_flg=SEM_UNDO;    

	if(semop(semid,&askfor_res,1)==-1)//ask for resource
		perror("semop error");

	sleep(3); 
	//do some handling on the sharing resource here, just sleep on it 3 seconds
	printf("now free the resource\n");  

	//now free resource  
	free_res.sem_num=0;
	free_res.sem_op=1;
	free_res.sem_flg=SEM_UNDO;
	if(semop(semid,&free_res,1)==-1)//free the resource.
		if(errno==EIDRM)
			printf("the semaphore set was removed\n");
	//you can comment out the codes below to compile a different version:      
	if(semctl(semid, 0, IPC_RMID)==-1)
		perror("semctl IPC_RMID");
	else 
		printf("remove sem ok\n");
}
