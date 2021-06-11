#include "typedef.h"
#include <signal.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "semi_generic_llist.h"
#include "parser.h"
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <sys/un.h>
#include <unistd.h>
#include "debug.h"


#define FDBUF_SIZE 10
#define PROSTAT_SIZE 5
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

typedef struct{
	pid_t pid;
	int stat;	//-1闲1忙
	int sockfdPa;
}ProStat_t;

/* Create a process status table */
ProStat_t proStat[PROSTAT_SIZE];

/* Create a fd table */
int fdBuf[FDBUF_SIZE];	//-1闲


/* Return indice of the first sleep process or the pid according to flag */
int search_prostat(int flag){	//flag为pid找pid的脚标，-1找第一个闲的脚标
	int i=0;
	for(;i<PROSTAT_SIZE;i++){
		if(-1==flag && -1==proStat[i].stat){
			return i;
		}else if(-1!=flag && flag == proStat[i].pid){
			return i;
		}
	}
	return -1;
}

/* Return indice of the first fd according flag */
int search_fdbuf(int flag){	//flag为1找第一个忙的，-1找第一个闲的
	int i=0;
	for(;i<FDBUF_SIZE;i++){
		if(-1==flag && -1==fdBuf[i]){
			return i;
		}else if(1==flag && -1!=fdBuf[i]){
			return i;
		}
	}
	return -1;
}

/* Add task to pool */
void pool_add_task(int sockfd,int flag,int pid){

	int toPid;	
	if(0!=flag||-1!=(toPid=search_prostat(-1))){	//脚标为topid进程闲着

		struct iovec v = {"", 1};

		struct cmsghdr *cmsg = malloc(CMSG_SPACE(sizeof(int)));
		cmsg->cmsg_len = CMSG_SPACE(sizeof(int));
		cmsg->cmsg_level = SOL_SOCKET;
		cmsg->cmsg_type = SCM_RIGHTS;
		*(&cmsg->cmsg_type+1) = sockfd;

		struct msghdr msg = {0};
		msg.msg_name = NULL;
		msg.msg_namelen = 0;
		msg.msg_iov = &v;
		msg.msg_iovlen = 1;
		msg.msg_control = cmsg;
		msg.msg_controllen = CMSG_SPACE(sizeof(int));	

		if(0!=pid){
			sendmsg(proStat[toPid].sockfdPa,&msg,0); //to pid==pos
			err("sendmsg");
			return;
		}
		sendmsg(proStat[toPid].sockfdPa,&msg,0); //to pid==pos
		err("sendmsg");

		int i=search_prostat(toPid);
		proStat[i].stat=1;	//busy

	}else{
		int firstN1=search_fdbuf(-1);
		fdBuf[firstN1]=sockfd;
	}
}

/* Service in child */
int do_task(){
	int ret=0;
	/* Prepare socket */
	int socktmp=socket(AF_UNIX,SOCK_STREAM,0);
	struct sockaddr_un myaddr = {0};
	myaddr.sun_family = AF_UNIX;
	char sockname[17]={0};
	sprintf(sockname,"%d",getpid());
	//strcpy(myaddr.sun_path, "./3840");
	strcpy(myaddr.sun_path, sockname);
	debug("child pid:%d:%s:strlen:%d\n",getpid(),myaddr.sun_path,strlen(myaddr.sun_path));
	int len = sizeof myaddr;
	//unlink(sockname);
	if(-1 == bind(socktmp, (struct sockaddr*)&myaddr, len))	//bind会创建不存在的本地socket文件，所以先运行的执行bind
		err("bind");
while(1);
	/* Receive cmd */
	char c;
	struct iovec v = {&c, 1}; 
	//	struct iovec v = {"", 1}; 

	struct cmsghdr *cmsg = malloc(CMSG_SPACE(sizeof(int)));
	cmsg->cmsg_len = CMSG_SPACE(sizeof(int));
	cmsg->cmsg_level = SOL_SOCKET;
	cmsg->cmsg_type = SCM_RIGHTS;

	struct msghdr msg = {0};
	msg.msg_name = NULL;
	msg.msg_namelen = 0;
	msg.msg_iov = &v; 
	msg.msg_iovlen = 1;
	msg.msg_control = cmsg;
	msg.msg_controllen = CMSG_SPACE(sizeof(int)); 


	char buf[100]={0};
	/* Service */
	while(1){
#if 1
		if(-1 == recvmsg(socktmp, &msg, 0))
			err("recvmsg");
		debug("child pid:%d:here\n",getpid());

		int fd = *(&cmsg->cmsg_type+1);

		printf("子进程收到的是fd = %d\n", fd);
		int ret=0;
		if(0==(ret=recv(fd,buf,sizeof(buf),0))){
			kill(getppid(),SIGUSR1);
			return 0;
		}
		printf("recv:%s\n",buf);
#endif
	}
}

#if 0

iginfo_t {

	int      si_signo;    /* Signal number */
	int      si_errno;    /* An errno value */
	int      si_code;     /* Signal code */
	int      si_trapno;   /* Trap number that caused
							 hardware-generated signal
							 (unused on most architectures) */
	pid_t    si_pid;      /* Sending process ID */
	uid_t    si_uid;      /* Real user ID of sending process */
	int      si_status;   /* Exit value or signal */
	clock_t  si_utime;    /* User time consumed */
	clock_t  si_stime;    /* System time consumed */
	sigval_t si_value;    /* Signal value */
	int      si_int;      /* POSIX.1b signal */
	void    *si_ptr;      /* POSIX.1b signal */
	int      si_overrun;  /* Timer overrun count; POSIX.1b timers */
	int      si_timerid;  /* Timer ID; POSIX.1b timers */
	void    *si_addr;     /* Memory location which caused fault */
	long     si_band;     /* Band event (was int in
							 glibc 2.3.2 and earlier) */
	int      si_fd;       /* File descriptor */
	short    si_addr_lsb; /* Least significant bit of address
							 (since kernel 2.6.32) */
}

#endif





/* Signal handler */
#if 0
struct sigaction {

	void     (*sa_handler)(int);
	void     (*sa_sigaction)(int, siginfo_t *, void *);
	sigset_t   sa_mask;
	int        sa_flags;
	void     (*sa_restorer)(void);
}
#endif 
void handler(int signum,siginfo_t* siginfo,void* p){
	/* Get pid sending signal */
	int pid=siginfo->si_pid;
	/* Search fdBuf */
	int pos=0;
	if(-1!=(pos=search_fdbuf(1))){
		//sendmsg(sockfd,pid);
		pool_add_task(fdBuf[pos],1,pid)	;
		fdBuf[pos]=-1;
		return;
	}else {
		/* modify pid stat table */
		int i=search_prostat(pid);
		proStat[i].stat=-1;
	}

}

int main(int argc, const char *argv[])
{
	/* Initialize fd table */
	int i=0;
	for(i=0;i<FDBUF_SIZE;i++){
		fdBuf[i]=-1;
	}
	/* Open database */
	PtLList_t L=create_llist(sizeof(info_t),myInfoFree,myInfoShow,myInfoEqual);//,myFree);
	load_llist_from_file(L,DATABASE);

	/* Create process pool */
	for(i=0;i<PROSTAT_SIZE;i++){
		debug("i:%d\n",i);
		pid_t pid=fork();
		if(0==pid){
			/* Service */
			do_task();
			exit(-1);
		}

#if 1	
		int socktmp=socket(AF_UNIX,SOCK_STREAM,0);
		struct sockaddr_un myaddr = {0};
		myaddr.sun_family = AF_UNIX;
		char sockname[100]={0};
		sprintf(sockname,"%d",pid);
		strcpy(myaddr.sun_path, sockname);
		//strcpy(myaddr.sun_path, "./9020");
		int len = sizeof myaddr;

		proStat[i].pid=pid;	
		proStat[i].stat=-1;
		proStat[i].sockfdPa=socktmp;
		debug("main:%s:strlen:%d\n",myaddr.sun_path,strlen(myaddr.sun_path));
	sleep(1);
		if(-1 == connect(socktmp, (struct sockaddr*)&myaddr, len)){	
			err("connect");	
		}
#endif 
	}

	/* Create listenfd */
	int listenfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1 == listenfd)
		err("socket");
	debug("pid[%d]\n",getpid());

	/* Prepare address */
	struct sockaddr_in serAddr={0};
	serAddr.sin_family=AF_INET;
	serAddr.sin_port=htons(8888);
	serAddr.sin_addr.s_addr=inet_addr("127.0.0.1");
	//int len=sizeof(serAddr);
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

	/* Signal handler */
#if 0
	struct sigaction {

		void     (*sa_handler)(int);
		void     (*sa_sigaction)(int, siginfo_t *, void *);
		sigset_t   sa_mask;
		int        sa_flags;
		void     (*sa_restorer)(void);
	}
#endif 
	struct sigaction act;
	act.sa_sigaction=handler;
	act.sa_flags=SA_SIGINFO;
	sigaction(SIGUSR1,&act,NULL);
		debug("before accept in server");

	/* Zombie collector */
	//signal(SIGCHLD,do_zombie);
	while(1){
		struct sockaddr_in cliAddr;
		int  cliLen=sizeof(cliAddr);
		int sockfd=accept(listenfd,(struct sockaddr*)&cliAddr,&cliLen);
		debug("after accept in server");
		if(-1 == sockfd)
			err("accept");
		printf("%s is connected\n",inet_ntoa(cliAddr.sin_addr));

		pool_add_task(sockfd,0,0);
	}
	pause();
}

