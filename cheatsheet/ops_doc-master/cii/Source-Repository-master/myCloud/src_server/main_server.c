#include "typedef.h"
#include "protocol.h"
#include <stdlib.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>
#include "semi_generic_lqueue.h"
#include "parser_server.h"
#include "thread_pool.h"
#include "debug.h"
#include <unistd.h>
#include <sqlite3.h>
#include <linux/tcp.h>

char repo[100]="./repo/";

/* Service routine */
void* sev(void* parg){
	int i=1,num=0,sum=0,isdata=0,isup=0,islist=0,upfd=-1,dnfd=-1,ret=0,size=0;
	arg_t* arg=(arg_t*)parg;
	char buf[sizeof(arg->buf)]={0}; 	//msg to send
	char tmp[sizeof(arg->buf)-sizeof(pack_t)]={0};	//msg body to send
	char sevname[20]={0};
	while(1){
		ret= recv(arg->sockfd,arg->buf,sizeof(arg->buf),0);
		detohex(arg->buf,sizeof(arg->buf));
		deprint("recvLen:%d",ret);
		if(-1==ret){
			syserr("recv");
			return NULL;
		}
		if(0==isdata){
			pack_t*  recvpack=(pack_t*)(arg->buf);
				if(SIGNUP==recvpack->cmd){
					struct usr* recvdata=(struct usr*)(arg->buf+(sizeof(pack_t)));
					deprint("%s:%s",recvdata->name,recvdata->passwd);
					ret=signup_parser(arg->db,recvdata->name,recvdata->passwd);	
					if(SUCCESS==ret){
						recvpack->status=SUCCESS;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}else if(USR_EXIST==ret){
						recvpack->status=USR_EXIST;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}
				}else if(LOGIN==recvpack->cmd){
					struct usr* recvdata=(struct usr*)(arg->buf+(sizeof(pack_t)));
					deprint("status:%c",recvpack->status);
					deprint("%p",arg->db);
					ret=login_parser(arg->db,recvdata->name,recvdata->passwd,sevname);
					if(NO_USR==ret){
						recvpack->status=NO_USR;
						deprint("status:%c",recvpack->status);
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}else if(ERR_PASSWD==ret){
						recvpack->status=ERR_PASSWD;
						deprint("status:%c",recvpack->status);
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}else{
						deprint("status:%c",recvpack->status);
						num=send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
						deprint("login:%d",num);
						printf("\n%s is login\n",sevname);
						printf("administor cmd>> ");fflush(stdout);
					}
				}else if(UPLOAD==recvpack->cmd){
					struct file* recvdata=(struct file*)(arg->buf+(sizeof(pack_t)));
					deprint("before parser:%s %d",recvdata->fileName,recvdata->fileSize);
					ret=upload_parser(arg->db,sevname,recvdata,&upfd);
					printf("\n%s is uploading %s\n",sevname,recvdata->fileName);
					printf("administor cmd>> ");fflush(stdout);
					if(FILE_EXIST==ret){
						recvpack->status=FILE_EXIST;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}else if(PREUPLOAD==ret) {
						isdata=1;
						isup=1;
						size=recvdata->fileSize;
						recvpack->status=PREUPLOAD;	
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}

				}else if(DOWNLOAD==recvpack->cmd){
					struct file* recvdata=(struct file*)(arg->buf+(sizeof(pack_t)));
					size=0;
					ret=dnload_parser(arg->db,sevname,recvdata,&dnfd,&size);
					printf("\n%s is downloading %s\n",sevname,recvdata->fileName);
					printf("administor cmd>> ");fflush(stdout);
					if(NOSUCHFILE==ret){
						recvpack->status=NOSUCHFILE;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}else if(PREDOWNLOAD==ret) {
						recvpack->status=PREDOWNLOAD;
						recvdata->fileSize=size;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
#ifdef DEBUG
						sum=0;
#endif 
						while(1){
							deprint("dnfd:%d",dnfd);
							if(-1==(ret=read(dnfd,buf,sizeof(buf)))){
								perror("read");
							}

							if(0==ret){
								close(dnfd);
								dnfd=-1;
								break;
							}
							ret=send(arg->sockfd,buf,ret,0);
							if(-1==ret){
								perror("write");
							}
#ifdef DEBUG
							sum+=ret;
							deprint("DOWNLOAD:ret:%d sum:%d",ret,sum);
#endif 
						}
					}
				}else if(LIST==recvpack->cmd){
					struct file sendlistArr[1000]={0};
					int itemNum=0;
					ret=list_parser(arg->db,sevname,sendlistArr,&itemNum);
					if(EMPTY==ret){
						recvpack->status=EMPTY;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}else if(PREDOWNLOAD==ret){		//列表非空
						recvpack->status=PREDOWNLOAD;
						recvpack->len=itemNum;
						num=send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
						deprint("%d",num);
						deprint("begin to transfer list");
						i=1;
						while(itemNum--){
							memcpy(buf,&sendlistArr[i],sizeof(struct file));
							num=send(arg->sockfd,buf,sizeof(struct file),0);
							deprint("num=%d",num);
							deprint("i:%d",i);
							i++;
							deprint("itemNum:%d",itemNum);
						}
					}
				}else if(QUIT==recvpack->cmd){
					if(-1!=upfd){
						close(upfd);					
					}
					if(-1!=dnfd){
						close(dnfd);
					}
					deprint("begin sleep");
					num=send(arg->sockfd,recvpack,sizeof(pack_t),0);
					deprint("QUIT:%d",num);
					close(arg->sockfd);
					break;
				}else if(DELETE==recvpack->cmd){
					struct file* recvdata=(struct file*)(arg->buf+(sizeof(pack_t)));
					ret=del_parser(arg->db,sevname,recvdata);
					if(NOSUCHFILE==ret){
						recvpack->status=NOSUCHFILE;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}else if(SUCCESS==ret){
						recvpack->status=SUCCESS;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}
				}else if(RENAME==recvpack->cmd){
					struct file* oldfile=(struct file*)(arg->buf+(sizeof(pack_t)));
					deprint("%s %d",oldfile->fileName,oldfile->fileSize);
					struct file* newfile=(struct file*)(arg->buf+(sizeof(pack_t))+sizeof(struct file));
					deprint("%s %d",newfile->fileName,newfile->fileSize);
					ret=rename_parser(arg->db,sevname,oldfile,newfile);
					if(NOSUCHFILE==ret){
						recvpack->status=NOSUCHFILE;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}else if(SUCCESS==ret){
						recvpack->status=SUCCESS;
						send(arg->sockfd,arg->buf,sizeof(arg->buf),0);
					}
				}else{
					deprint("Unknown CMD");
				}
		}else if(1==isdata){	//isdata==1
			if(1==isup){
				num=write(upfd,arg->buf,ret);
				if(-1==num){
					perror("write");
				}					
				sum+=num;
				if(sum==size){
					close(upfd);
					upfd=-1;
					isdata=0;
					isup=0;
					sum=0;
					num=0;
					size=0;
				}
			}
		}
	}
	free(arg);
}

int myTaskFree(PtNode_t node){
	free((task_t*)node->dataAddr);
	free(node);
	return 0;
}

int myTaskShow(PtNode_t node){
	return 0;
}


void * serverCMD(void* argcmd){
	CMDArg_t* argu=(CMDArg_t*)argcmd;
	char cmd[100]={0};
	char* needle;
	while(1){
		printf("administor cmd>> ");fflush(stdout);
		fgets(cmd,sizeof(cmd),stdin);
		deprint("%s",cmd);
		needle=strstr(cmd,"\n");
		*needle='\0';
		serverCMDParser(argu->db,cmd);
	}
}
int main(int argc, const char *argv[])
{
	/* Open database */
	sqlite3* db;
	deprint("%p",db);
	//deprint("%s\n",strcat(repo,"my.db"));
	char tmp[sizeof(repo)]={0};
	strcpy(tmp,repo);
	if(sqlite3_open(strcat(tmp,"my.db"),&db)!=SQLITE_OK)
		syserr("sqlite3_open");


	/* Create thread pool */
	create_pool(sizeof(task_t),myTaskFree,myTaskShow);

	/* Create listenfd */
	int listenfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1 == listenfd)
		syserr("socket");

	/* Prepare address */
	struct sockaddr_in serAddr={0};
	serAddr.sin_family=AF_INET;
	serAddr.sin_port=htons(8888);
	serAddr.sin_addr.s_addr=INADDR_ANY;//inet_addr("192.168.0.116");
	int len=sizeof(serAddr);

	int on=1;
	int ret = setsockopt(listenfd,SOL_SOCKET,SO_REUSEADDR,&on,sizeof(on));
	if(-1 == ret)
		syserr("setsockopt");

	/* Bind address and listenfd */
	ret = bind(listenfd,(struct sockaddr*)&serAddr,len);
		if(-1 == ret)
			syserr("bind");

		ret=listen(listenfd,100);
		if(-1==ret)
			syserr("listen");

		printf("\nserver has powered on\n");

		/* Create monitor thread */
		CMDArg_t argcmd;
		argcmd.db=db;
		pthread_t moThread;
		pthread_create(&moThread,NULL,serverCMD,&argcmd);

		while(1){
			struct sockaddr_in cliAddr;
			socklen_t cliLen=sizeof(cliAddr);
			int sockfd=accept(listenfd,(struct sockaddr*)&cliAddr,&cliLen);
#if 1
			int enable=1;
			int ret = setsockopt(sockfd,IPPROTO_TCP,TCP_NODELAY,(void*)&enable,sizeof(enable));
			if(-1 == ret)
				syserr("setsockopt");
#endif 
			if(-1 == sockfd)
				syserr("accept");
			printf("\n%s is connected\n",inet_ntoa(cliAddr.sin_addr));
			printf("administor cmd>> ");fflush(stdout);

			arg_t* arg=(arg_t*)malloc(sizeof(arg_t));	
			arg->sockfd=sockfd;
			arg->db=db;

			pool_add_task(sev,(void*)arg);
		}
		pause();
	}

