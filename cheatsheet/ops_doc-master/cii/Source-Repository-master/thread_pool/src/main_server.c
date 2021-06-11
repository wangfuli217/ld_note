#include "typedef.h"
#include <stdlib.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "semi_generic_llist.h"
#include "semi_generic_lqueue.h"
#include "parser.h"
#include "thread_pool.h"
#include "debug.h"


/* Information in database */
int myInfoEqual(void* x,void* y){
	return !strcmp(((info_t*)x)->name,((info_t*)y)->name)&&!strcmp(((info_t*)x)->passwd,((info_t*)y)->passwd);
}

int myInfoFree(PtNode_t node){
	free(node->dataAddr);
	free(node);
	return 0;
}

int myInfoShow(PtNode_t node){
	printf("name:%s\n",((info_t*)node)->name);
	printf("passwd:%s\n",((info_t*)node)->passwd);
	return 0;

}

/* Service routine */


void* sev(void* parg){
	arg_t* arg=(arg_t*)parg;
	while(1){
		if(0 == recv(arg->sockfd,arg->buf,sizeof(arg->buf),0)){
			return NULL;
		}
		printf("rev:%s\n",arg->buf);
		cmd_parser(arg->L,arg->buf,arg->sockfd);
	}
	free(arg);
}

int myTaskFree(PtNode_t node){
	free((task_t*)node->dataAddr);
	free(node);
}

int myTaskShow(PtNode_t node){
	return 0;
}

int main(int argc, const char *argv[])
{
	/* Open database */
	PtLList_t L=create_llist(sizeof(info_t),myInfoFree,myInfoShow,myInfoEqual);//,myFree);
	load_llist_from_file(L,DATABASE);

	/* Create thread pool */
	create_pool(sizeof(task_t),myTaskFree,myTaskShow);


	/* Create listenfd */
	int listenfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1 == listenfd)
		err("socket");
	
	/* Prepare address */
	struct sockaddr_in serAddr={0};
	serAddr.sin_family=AF_INET;
	serAddr.sin_port=htons(8888);
	serAddr.sin_addr.s_addr=inet_addr("127.0.0.1");
	int len=sizeof(serAddr);

	int on=1;
	int ret = setsockopt(listenfd,SOL_SOCKET,SO_REUSEADDR,&on,sizeof(on));
	if(-1 == ret)
		err("setsockopt");

	
	/* Bind address and listenfd */
	ret = bind(listenfd,(struct sockaddr*)&serAddr,len);
	if(-1 == ret)
		err("bind");

	ret=listen(listenfd,100);
	if(-1==ret)
		err("listen");

	printf("server has powered on\n");


	while(1){
		struct sockaddr_in cliAddr_1;
		socklen_t cliLen_1=sizeof(cliAddr_1);
		int sockfd_1=accept(listenfd,(struct sockaddr*)&cliAddr_1,&cliLen_1);
		if(-1 == sockfd_1)
			err("accept");
		printf("%s is connected\n",inet_ntoa(cliAddr_1.sin_addr));

		arg_t* arg_1=(arg_t*)malloc(sizeof(arg_t));	
		arg_1->sockfd=sockfd_1;
		arg_1->L=L;

		pool_add_task(sev,(void*)arg_1);
	}
	pause();
}































