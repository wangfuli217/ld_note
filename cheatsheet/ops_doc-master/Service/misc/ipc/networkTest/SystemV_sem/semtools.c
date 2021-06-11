/*************************************************************************
	> File Name: semtools.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Fri 04 Mar 2016 12:12:36 AM CST
 ************************************************************************/

#include "SystemVSem.h"
int main(int argc ,char * argv[])
{
	
	int opt;
	int semid;
	key_t sem_key;
	int reslt;
	struct semid_ds ds_buf;
	while((opt = getopt(argc,argv,"c:d:s:")) != -1)
	{
		switch(opt)
		{
			case 'c':
				sem_key = atoi(optarg);
				semid = sem_create(sem_key,1,0666);
				fprintf(stdout,"%s","created  success\n");
				break;
			case 'd':
				sem_key = atoi(optarg);
				semid = sem_open(sem_key,0666);
				sem_del(semid);
				fprintf(stdout,"%s","deleted success\n");
				break;
			case 's':
				sem_key = atoi(optarg);
				semid = sem_open(sem_key,0666);
				sem_get_stat(semid,&ds_buf);
				fprintf(stdout,"__key = %d, uid = %d, mode = %o\n",ds_buf.sem_perm.__key,ds_buf.sem_perm.uid,ds_buf.sem_perm.mode);

				break;
			default:
				ERR_EXIT("error argvs \n");

		}
	}
	return 0;
}
