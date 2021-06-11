#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>

#include <linux/ioctl.h> /* needed for the _IOW etc stuff used later */

/*
 * Ioctl definitions
 */

/* Use 'k' as magic number */
#define SCULL_IOC_MAGIC  'k'
/* Please use a different 8-bit number in your code */

#define SCULL_IOCRESET    _IO(SCULL_IOC_MAGIC, 0)

/*
 * S means "Set" through a ptr,
 * T means "Tell" directly with the argument value
 * G means "Get": reply by setting through a pointer
 * Q means "Query": response is on the return value
 * X means "eXchange": switch G and S atomically
 * H means "sHift": switch T and Q atomically
 */
#define SCULL_IOCSQUANTUM _IOW(SCULL_IOC_MAGIC,  1, int)
#define SCULL_IOCSQSET    _IOW(SCULL_IOC_MAGIC,  2, int)
#define SCULL_IOCTQUANTUM _IO(SCULL_IOC_MAGIC,   3)
#define SCULL_IOCTQSET    _IO(SCULL_IOC_MAGIC,   4)
#define SCULL_IOCGQUANTUM _IOR(SCULL_IOC_MAGIC,  5, int)
#define SCULL_IOCGQSET    _IOR(SCULL_IOC_MAGIC,  6, int)
#define SCULL_IOCQQUANTUM _IO(SCULL_IOC_MAGIC,   7)
#define SCULL_IOCQQSET    _IO(SCULL_IOC_MAGIC,   8)
#define SCULL_IOCXQUANTUM _IOWR(SCULL_IOC_MAGIC, 9, int)
#define SCULL_IOCXQSET    _IOWR(SCULL_IOC_MAGIC,10, int)
#define SCULL_IOCHQUANTUM _IO(SCULL_IOC_MAGIC,  11)
#define SCULL_IOCHQSET    _IO(SCULL_IOC_MAGIC,  12)

int main()
{
	char bufWrite[20]={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19};
	char bufRead[20]={0};
	int sculltest;
	int count,i,j;
	int quantum,qset;
/******************************************************************************/	
	if ((sculltest = open("/dev/scull0", O_RDWR )) < 0){
		 printf("open error! \n"); 
		exit(1);
	}
	printf("open scull ! \n");
	//ioctl操作
	quantum = 10;
	if ( ioctl( sculltest , SCULL_IOCSQUANTUM , &quantum ) < 0) 	{
		 printf("ioctl SCULL_IOCSQUANTUM error! \n"); 
		exit(1);
	}
	printf("SCULL_IOCSQUANTUM-SCULL_IOCQQUANTUM : scull_quantum=%d \n", ioctl( sculltest , SCULL_IOCQQUANTUM , NULL ) );

	if ( ioctl( sculltest , SCULL_IOCTQUANTUM , 6 ) < 0) 	 {
		 printf("ioctl SCULL_IOCTQUANTUM error! \n"); 
		exit(1);
	}	
	if ( ioctl( sculltest , SCULL_IOCGQUANTUM , &quantum ) < 0)  	  {
		 printf("ioctl SCULL_IOCGQUANTUM error! \n"); 
		exit(1);
	}
	printf("SCULL_IOCTQUANTUM-SCULL_IOCGQUANTUM : scull_quantum=%d \n", quantum);

	quantum = 10;
	if ( ioctl( sculltest , SCULL_IOCXQUANTUM , &quantum ) < 0) 	{
		 printf("ioctl SCULL_IOCXQUANTUM error! \n"); 
		exit(1);
	}

	printf("SCULL_IOCXQUANTUM : scull_quantum=%d --> %d\n" , quantum , ioctl( sculltest , SCULL_IOCQQUANTUM , NULL ) );

	printf("SCULL_IOCHQUANTUM : scull_quantum=%d --> %d\n" , ioctl( sculltest , SCULL_IOCHQUANTUM , 6 ) , ioctl( sculltest , SCULL_IOCQQUANTUM , NULL ) );

	printf("scull_quantum=%d  scull_qset=%d \n" , ioctl( sculltest , SCULL_IOCQQUANTUM , NULL ) , ioctl( sculltest , SCULL_IOCQQSET , NULL ) );
	close(sculltest);
	printf("close scull ! \n"
			"--------cut here--------\n");
	if ((sculltest = open("/dev/scull0", O_RDWR )) < 0){
		 printf("open error! \n"); 
		exit(1);
	}
	printf("open scull ! \n");
	//读写操作
	for ( i=20 ; i>0 ; i-=count){  
		if ((count=write(sculltest , &bufWrite[20-i] , i)) != i) 
			printf("write error! writed=%d remain=%d\n",count,i-count);
		else   printf("write ok! writed=%d \n",count);
	}
	
	if((count = lseek(sculltest , -20 , SEEK_END)) != 0)	printf("llseek error! count=%d \n", count);
	printf("lseek scull  SEEK_END-20-->0 ! \n");
	
	for ( i=20; i>0 ; i-=count){  
		if ((count=read(sculltest , &bufRead[20-i] , i)) != i) 
			printf("read error! readed=%d remain=%d\n",count,i-count);
		else   printf("read ok! readed=%d \n",count);
	}
	for(i=0;i<5;i++){
		for(j=0;j<4;j++)
			printf("[%d]=%d\t",i*4+j,bufRead[i*4+j]);
		printf("\n"); 
	}
	
/******************************************************************************/		
	
	//ioctl-reset操作
	if ( ioctl( sculltest , SCULL_IOCRESET , NULL ) < 0) 	{
		 printf("ioctl SCULL_IOCRESET error! \n"); 
		exit(1);
	}
	printf("SCULL_IOCRESET \n" );
	printf("scull_quantum=%d  scull_qset=%d \n" , ioctl( sculltest , SCULL_IOCQQUANTUM , NULL ) , ioctl( sculltest , SCULL_IOCQQSET , NULL ) );
	close(sculltest);
	printf("close scull ! \n"
			"--------cut here--------\n");
	if ((sculltest = open("/dev/scull0", O_RDWR )) < 0){
		 printf("open error! \n"); 
		exit(1);
	}
	printf("open scull ! \n");
	//读写操作
	for ( i=20 ; i>0 ; i-=count){  
		if ((count=write(sculltest , &bufWrite[20-i] , i)) != i) 
			printf("write error! writed=%d remain=%d\n",count,i-count);
		else   printf("write ok! writed=%d \n",count);
	}
	
	if((count = lseek(sculltest , -20 , SEEK_END)) != 0)	printf("llseek error! count=%d \n", count);
	printf("lseek scull  SEEK_END-20-->0 ! \n");
	
	for ( i=20; i>0 ; i-=count){  
		if ((count=read(sculltest , &bufRead[20-i] , i)) != i) 
			printf("read error! readed=%d remain=%d\n",count,i-count);
		else   printf("read ok! readed=%d \n",count);
	}
	for(i=0;i<5;i++){
		for(j=0;j<4;j++)
			printf("[%d]=%d\t",i*4+j,bufRead[i*4+j]);
		printf("\n"); 
	}
	
	close(sculltest);
	printf("close scull ! \n");

	exit(0);
}
