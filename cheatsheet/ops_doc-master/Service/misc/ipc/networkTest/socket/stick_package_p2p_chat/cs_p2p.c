/************************************************************************* 
 *  > File Name: client_server.c > Author: liujizhou > Mail: jizhouyou@126.com 
	> Created Time: Wed 16 Mar 2016 01:50:48 PM CST
 ************************************************************************/

#include "cs_p2p.h"

ssize_t readn(int fd,void *recvbuf,size_t len)
{
	char *bufptr = (char *)recvbuf;
	ssize_t nread;
	size_t nleft = len;
	while(nleft > 0)
	{
		if((nread = read(fd,bufptr,len)) == -1)
		{
			if(errno == EINTR)
			{
				continue;
			}
			return -1;
		}
		if(nread == 0)
		{
			return 0;
		}

		nleft -= nread;
		bufptr +=nleft;	
	}
	return len;
	

}
ssize_t writen(int fd, const void *sendbuf,size_t len)
{
	char *bufptr = (char *)sendbuf;
	size_t nleft = len;
	size_t nwritten;
	while(nleft > 0)
	{
		if((nwritten = write(fd,bufptr,nleft)) == -1)
		{//写出错
			if(errno == EINTR)
			{
				continue;
			}
			return -1;
		}
		nleft -= nwritten;
		bufptr += nwritten;
	}

}

int main(int argc , char * argv[])
{
	int rslt;
	int opt;
	int flag=0;
	if(argc != 2) 
	{
		ERR_EXIT("argv error\n");
	}
	while((opt = getopt(argc,argv,"cs")) != -1)
	{
		switch(opt)
		{
			case 'c':
				flag = CLIENT_FLAG;
				break;
			case 's':
				flag = SERVER_FLAG;
				break;
			default:
				printf("error agrv \n");
				break;
		}
	}
	if(flag == SERVER_FLAG)
	{
		server();
	}
	else if(flag == CLIENT_FLAG)
	{
		client();
	}
	
	return 0;
}

