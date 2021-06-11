/************************************************************************* 
 *  > File Name: client_server.c > Author: liujizhou > Mail: jizhouyou@126.com 
	> Created Time: Wed 16 Mar 2016 01:50:48 PM CST
 ************************************************************************/

#include "cs_p2p.h"
ssize_t readline(int fd,void *buf,size_t len)
{
	ssize_t ret;
	size_t nread;
	size_t nleft = len;
	size_t i=0;
	char *bufptr = (char *)buf;
	while(1)
	{
		ret = recv_peek(fd,bufptr,nleft);
		if(ret <= 0)
		{
			return ret;
		}
		nread = ret;
		for(i=0;i<nread;i++)
		{
			if(bufptr[i] == '\n')//一行结束
			{
				ret = read(fd,bufptr,i+1);
				if(ret != i+1)
				{
					return -1;
				}
				return ret;
			}
		}
		nleft -= nread;//读取的nread长度中无'\n'字符,行未结束
		ret = read(fd,bufptr,nread);

		if(ret != nread)
		{
			exit(EXIT_FAILURE);
		}
		bufptr += nread;

	}
	return -1;

}
ssize_t recv_peek(int fd,void *buf,size_t len)
{
	ssize_t ret;
	while(1)
	{
		 ret = recv(fd,buf,len,MSG_PEEK);
		if(ret == -1 && errno == EINTR)
		{
			return -1;
		}
		return ret;
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

