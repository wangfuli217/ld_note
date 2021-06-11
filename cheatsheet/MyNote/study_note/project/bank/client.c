#include "bank.h"
#include "client.h"
Msg msg;				//正在处理的消息
int msgid1,msgid2;		//两个消息队列的ID
int main(void)
{
	int choice=-1;
	init();
	while(1)
	{
		show();
		choice=getchoice();
		del(choice);
		send_to_msg1();
		recv();
		del_back();
		stop();
	}
	return 0;
}
void print(void)		//打印账户信息
{
	printf("\t账户信息如下\n");
	printf("\t用户: %s\n",msg.acc.name);
	printf("\t账号: %d\n",msg.acc.id);
	printf("\t密码: %s\n",msg.acc.passwd);
	printf("\t余额: %g\n",msg.acc.balance);
}
int login(void)		//登录
{
	printf("\t\t请登录\n");
	printf("\t请输入账户ID: ");
	scanf("%d",&msg.acc.id);
	flush();
	printf("\t请输入账户密码: ");
	fgets(msg.acc.passwd,sizeof(msg.acc.passwd),stdin);
	if(strlen(msg.acc.passwd)==MAX_PASSWD-1&&msg.acc.passwd[MAX_PASSWD-2]!='\n')
		flush();
	else
		msg.acc.passwd[strlen(msg.acc.passwd)-1]='\0';
	msg.msgtype=M_LOGIN;
	send_to_msg1();
	recv();
	del_back();
	if(msg.msgtype==M_LOGIN_SUCC)
		return 0;
	else
		return -1;
}
void tran_acc(void)		//转账
{
	if(!login())
	{
		int id=0;
		printf("请输入对方账号ID: ");
		scanf("%d",&id);
		flush();
		msg.msgtype=M_TRAN;
		msg.acc.id1=id;
		printf("\t请输入转出的金额: ");
		int many=0;
		scanf("%d",&many);
		flush();
		if(many>0&&many<=msg.acc.balance)
			msg.acc.balance-=many;
		else
			msg.msgtype=M_TRAN_FAIL;
	}
	else
		msg.msgtype=M_NULL;
}
void destory_acc(void)		//注销一个账户
{
	if(!login())
	{
		printf("是否确认注销此账户(1确认,0取消): ");
		int choice=-1;
		scanf("%d",&choice);
		flush();
		if(choice==1)
			msg.msgtype=M_DESTORY;
		else
			msg.msgtype=M_DESTORY_FAIL;
	}
	else
		msg.msgtype=M_NULL;
}
void find_acc(void)		//查询
{
	if(!login())
	{
		msg.msgtype=M_FIND_SUCC;
	}
	else
		msg.msgtype=M_NULL;
}
void take_acc(void)		//取款
{
	if(!login())
	{
		printf("请输入取款的金额: ");
		int mony=0;
		scanf("%d",&mony);
		flush();
		if(mony>0&&mony<=msg.acc.balance)
		{
			msg.acc.balance-=mony;
			msg.msgtype=M_TAKE;
		}
		else
			msg.msgtype=M_TAKE_FAIL;
	}
	else
		msg.msgtype=M_NULL;
}
void save_acc(void)		//存款
{
	if(!login())
	{
		printf("请输入存款的金额: ");
		int mony=0;
		scanf("%d",&mony);
		flush();
		if(mony>0)
		{
			msg.msgtype=M_SAVE;
			msg.acc.balance+=mony;
		}
		else
			msg.msgtype=M_SAVE_FAIL;
	}
	else
		msg.msgtype=M_NULL;
}
void stop(void)		//暂停屏幕以便看到输出结果
{
	getchar();
}
void del_back(void)		//处理返回的信息
{
	printf("\n\n");
	switch(msg.msgtype)
	{
		case  M_OPEN_SUCC:
			printf("\t\t开户成功\n");
			print();
			break;
		case M_OPEN_FAIL:
			printf("\t开户失败,请重新尝试\n");
			break;
		case M_DESTORY_SUCC:
			printf("\t注销账户成功\n");
			break;
		case M_DESTORY_FAIL:
			printf("\t账户注销失败,可能是密码不对或账号不存在,请重新尝试\n");
			break;
		case M_LOGIN_SUCC:
			printf("\t登录成功\n");
			break;
		case M_LOGIN_FAIL:
			printf("\t登录失败\n");
			break;
		case M_SAVE_SUCC:
			printf("\t存款成功\n");
			print();
			break;
		case M_SAVE_FAIL:
			printf("\t存款失败\n");
			print();
		case M_TAKE_SUCC:
			printf("\t取款成功\n");
			print();
			break;
		case M_TAKE_FAIL:
			printf("\t取款失败\n");
			print();
			break;
		case M_FIND_SUCC:
			printf("\t查询结果如下\n");
			print();
			break;
		case M_TRAN_SUCC:
			printf("\t转账成功\n");
			break;
		case M_TRAN_FAIL:
			printf("\t转账失败\n");
			break;
		case M_NULL:
			break;
		default:
			break;
	}
	printf("\t");
}
void init(void)			//初始化客户端
{
	key_t key1=ftok(".",1),key2=ftok(".",2);
	int res=msgid1=msgget(key1,0);
	int res1=msgid2=msgget(key2,0);
	if(res==-1||res1==-1)
		printf("服务器没有运行,请先运行服务器\n"),exit(-1);
}
void recv(void)			//从消息队列2接收消息
{
	while(1)
	{
		if(msgrcv(msgid2,&msg,sizeof(Account),0,0)!=-1)
			break;
	}
}
void send_to_msg1(void)		//发送消息到消息队列1
{
	int res=msgsnd(msgid1,&msg,sizeof(Account),0);
	if(-1==res)
		perror("msgsnd"),exit(-1);
}

void show()			//显示功能界面
{
	system("clear");
	printf("\n\n\n");
	printf("\t[1]开户		[2]销户\n");
	printf("\t[3]存款		[4]取款\n");
	printf("\t[5]查询		[6]转账\n");
	printf("\t[0]退出\n");
}
void flush()		//清空缓冲区
{
	scanf("%*[^\n]");
	scanf("%*c");
}
int getchoice()		//得到用户的选择
{
	int choice=-1;
choice:
	printf("\n\t请输入选择的功能: ");
	scanf("%d",&choice);
	flush();
	if(choice<0||choice>6)
	{
		printf("\t您的输入有错误,请重新输入!\n");
		goto choice;
	}
	return choice;
}
void del(int choice)		//处理用户选择
{
	printf("\n\n");
	switch(choice)
	{
		case M_OPEN:
			printf("\t\t开户中\n");
			open_acc();
			break;
		case M_DESTORY:
			printf("\t\t注销中\n");
			destory_acc();
			break;
		case M_SAVE:
			printf("\t\t存款中\n");
			save_acc();
			break;
		case M_TAKE:
			printf("\t\t取款中\n");
			take_acc();
			break;
		case M_FIND:
			printf("\t\t查询中\n");
			find_acc();
			break;
		case M_TRAN:
			printf("\t\t转账中\n");
			tran_acc();
			break;
		case M_EXIT:
			exit(0);
			break;
		default:
			break;
	}
}
void open_acc(void)		//开户功能函数
{
	printf("\t请输入姓名: ");
	fgets(msg.acc.name,sizeof(msg.acc.name),stdin);
	if(strlen(msg.acc.name)==MAX_NAME-1&&msg.acc.name[MAX_NAME-2]!='\n')
		flush();
	else
		msg.acc.name[strlen(msg.acc.name)-1]='\0';
	printf("\t请输入密码: ");
	fgets(msg.acc.passwd,sizeof(msg.acc.passwd),stdin);
	if(strlen(msg.acc.passwd)==MAX_PASSWD-1&&msg.acc.passwd[MAX_PASSWD-2]!='\n')
		flush();
	else
		msg.acc.passwd[strlen(msg.acc.passwd)-1]='\0';
	printf("\t请输入余额: ");
	scanf("%f",&msg.acc.balance);
	flush();
	msg.msgtype=M_OPEN;
}

