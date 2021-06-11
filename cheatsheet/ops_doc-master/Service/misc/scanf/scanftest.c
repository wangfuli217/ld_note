/*************************************************************************
	> File Name: scanftest.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Thu 05 May 2016 11:03:51 AM CST
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>

int main( int argc, char *argv)
{
	char *buff = "+COPS: 0,2,\"46001\",2\n";
	char buf[4][64];
	int nread = sscanf(buff,"+COPS: %*[0-9],%*[0-9],\"%[0-9]\",%*[0-9]",buf[0],buf[1],buf[2],buf[3]);
	printf("%d,%s,%s,%s,%s\n",nread,buf[0],buf[1],buf[2],buf[3]);
	return 0;
}
