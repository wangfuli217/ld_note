/************************************************************************* 
 *  > File Name: client_server.c > Author: liujizhou > Mail: jizhouyou@126.com 
	> Created Time: Wed 16 Mar 2016 01:50:48 PM CST
 ************************************************************************/

#include "cs_p2p.h"
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

