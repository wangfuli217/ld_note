#include <stdlib.h>
#include <stdio.h>
#include "debug.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "protocol.h"
#include "parser_client.h"
#include <string.h>
#include<linux/tcp.h>
#define  ONLINE  1
#define  OFFLINE  0
char g_filename[100] = {0};
int logflag = OFFLINE;
int g_transferflag = 0;
char g_filedir[100] = "./localfiles/";
int main(int argc, char **argv)
{
#if 0	
	if(3 != argc)
	{
		printf("Usage: %s <IP> <PORT>\n", argv[0]);
		return -1;
	}
#endif
	int sockfd = socket(AF_INET, SOCK_STREAM, 0); // 
	if(-1 == sockfd)
		syserr("socket");
 	int enable = 1;
#if 1
     if (-1 == setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, (void*)&enable, sizeof(enable)))
	 {
		 syserr("setsockopt");

	 }
#endif 
	struct sockaddr_in serveraddr = {0};
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_port = htons(8888);
	serveraddr.sin_addr.s_addr = inet_addr("192.168.0.116");//IPv4
	int len = sizeof serveraddr;

	if(-1 == connect(sockfd, (struct sockaddr*)&serveraddr, len))
		syserr("connect");
	print_helpinfo();
	datainfo_t data = {0};	
	pack_t  head = {0};
	while(1)
	{
		printf("\nclient> ");
		fflush(stdout);
        char buf[BUFSIZE] = {0};
		gets(buf);
		deprint("%s\n", buf);
		if (-1 == parse_cmdline(buf, &data, &head))
		{
			continue;
		}
		int buflen = 0; 
	   deprint("%s\n", (char *)&head );
	    deprint("begin to pack.....\n");
	  pack(&data, &head, buf, &buflen);
	  deprint("buflen:%d  buf:%s\n", buflen,  buf);

	detohex(buf, buflen); 
	struct file *p = (struct file *)&buf[sizeof(pack_t)];
	deprint(" **************************   %s \n", p->fileName);	
	p++;
	deprint(" **************************   %s \n", p->fileName);	
	
	// send chat
	  int ret = 0;

	 
	  if (-1 == (ret =  send(sockfd, buf, buflen, 0)))
	  {
		  syserr("send");
	  }
      deprint("send %d\n", ret);
 	  datainfo_t usrdata = {0};
	  memcpy(&usrdata.usr, &buf[sizeof(pack_t)], sizeof(struct usr));
	// read chat
	   ret = 0;
	   if(1== g_transferflag) 
	   {
		   if(-1 == (ret = recv(sockfd, buf,  BUFSIZE, MSG_WAITALL)))
		   {
			   syserr("recv");
		   }
	   }
	   else
	   {
		   if(-1 == (ret = recv(sockfd, buf,  BUFSIZE, 0)))
		   {
			   syserr("recv");
		   }


	   }
      deprint("ret =  %d\n", ret);
	detohex(buf, ret);
	// unpack  buf  and sendback data;
	  unpack(buf, sockfd);
	}
	close(sockfd);
}

