#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
int main()
{
	char bufWrite[20]={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19};
	char bufRead[20]={0};
	int sculltest;
	int count,i,j;
	
	if ((sculltest = open("/dev/scull0", O_WRONLY )) < 0){
		 printf("open error! \n"); 
		exit(1);
	}
	
	for ( i=20 ; i>0 ; i-=count){  
		if ((count=write(sculltest , &bufWrite[20-i] , i)) != i) 
			printf("write error! writed=%d remain=%d\n",count,i-count);
		else   printf("write ok! writed=%d \n",count);
	}
	close(sculltest);


	sculltest = open("/dev/scull0",O_RDONLY );
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
	exit(0);
}
