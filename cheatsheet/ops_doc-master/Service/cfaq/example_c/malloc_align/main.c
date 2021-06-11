/*
 * 根据宏定义可推算在32位系统中MINSIZE为16字节，在64位系统中MINSIZE一般为32字节。从request2size还可以知道，
 * 如果是64位系统，申请内存为1~24字节时，系统内存消耗32字节，当申请内存为25字节时，系统内存消耗48字节。 
 * 如果是32位系统，申请内存为1~12字节时，系统内存消耗16字节，当申请内存为13字节时，系统内存消耗24字节。 
 * 32位系统按照8字节递增, 64位系统按照16字节递增
 * 
 * */
#include<stdio.h>
#include<stdlib.h>

int main()
{
	char * p1;
	char * p2;
	int i = 1;
	
	printf("%d\n",sizeof(char *));
	
	for(;i<100;i++) {
		p1=NULL;
		p2=NULL;
		
		p1=(char *)malloc(i*sizeof(char));
		p2=(char *)malloc(1*sizeof(char));
		printf("i=%d     %d\n",i,(p2-p1));
	}

	getchar();
}