#include "bank.h"
#include "server.h"
key_t key1,key2;		    //定义两个消息队列的KEY值
int msgid1,msgid2;
Msg msg;					//定义正在处理的消息
	
int main(void)
{
	init();
	atexit(delet);
	while(1)
	{
		recv();
		del();
		send();
	}
}
void send(void)				//将处理完成后的消息发送给消息队列2
{
	msgsnd(msgid2,&msg,sizeof(Account),0);
}
void del(void)				//处理客户端发来的信息
{
	switch(msg.msgtype)
	{
		case M_LOGIN:
			if(!find(&msg.acc))
				msg.msgtype=M_LOGIN_SUCC;
			else
				msg.msgtype=M_LOGIN_FAIL;
			break;
		case M_OPEN:
			msg.acc.id=generator_id();
			msg.acc.stat=STAT_LOGIN;
			if(!write_to_acc(&msg.acc))
				msg.msgtype=M_OPEN_SUCC;
			else
				msg.msgtype=M_OPEN_FAIL;
			break;
		case M_DESTORY:
			if(!re_write_to_acc(&msg.acc,STAT_LOGOUT))
				msg.msgtype=M_DESTORY_SUCC;
			else
				msg.msgtype=M_DESTORY_FAIL;
			break;
		case M_SAVE:
			if(!re_write_to_acc(&msg.acc,M_SAVE))
				msg.msgtype=M_SAVE_SUCC;
			else
				msg.msgtype=M_SAVE_FAIL;
			break;
		case M_TAKE:
			if(!re_write_to_acc(&msg.acc,M_TAKE))
				msg.msgtype=M_TAKE_SUCC;
			else
				msg.msgtype=M_TAKE_FAIL;
			break;
		case M_FIND:
			break;
		case M_TRAN:
			if(!re_write_to_acc(&msg.acc,M_TRAN))
				msg.msgtype=M_TRAN_SUCC;
			else
				msg.msgtype=M_TRAN_FAIL;
			break;
		default:
			break;
	}
}
void delet(void)				//删除消息队列1和2 
{
	int res=msgctl(msgid1,IPC_RMID,NULL);
	int res1=msgctl(msgid2,IPC_RMID,NULL);
	if(res==-1||res1==-1)
		perror("msgctl"),exit(-1);
}
void fa(int signa)			//自定义函数处理信号2
{
	printf("服务器结束运行\n");
	exit(0);
}
void init(void)				//初始化服务器
{
	signal(2,fa);
	printf("服务器开始运行...\n");
	printf("按ctrl+c结束运行\n");
	key1=ftok(".",1);
	key2=ftok(".",2);
	msgid1=msgget(key1,IPC_CREAT|IPC_EXCL|0644);
	msgid2=msgget(key2,IPC_CREAT|IPC_EXCL|0644);
}
void recv(void)				//定义接收函数
{
	while(1)
	{
		if(msgrcv(msgid1,&msg,sizeof(msg.acc),0,0)!=-1)
			break;
	}
}

