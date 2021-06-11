#include<stdio.h>
#include<stdlib.h>
#include<string.h>
//每条航班信息结构
typedef struct
{
	int id;
	char begin[10];
	char end[10];
	char time[15];
	int num;
}info;
//链表的每个结点
typedef struct node
{
	info data;
	struct node *next;
	struct node *pre;
}node;
//链表
typedef struct
{
	node *head;
	node *tail;
}list;
//函数声明
void ShowHome(void);
int GetChoice(void);
void SysInit(list *);
void Stop(void);
void Read(list *);
void AddInfo(list *);
void Fflush(void);
void BrowseInfo(const list *);
void Exit(list *);
void Save(list *);
void DelInfo(list *);
void FindInfo(list *);

int main(void)       //主函数
{
	list li={};
	int choice=0;
	Read(&li);
	while(1)
	{
		system("clear");
		ShowHome();
		choice=GetChoice();
		if(1==choice)
			SysInit(&li);
		else if(2==choice)
			AddInfo(&li);
		else if(3==choice)
			DelInfo(&li);
		else if(4==choice)
			BrowseInfo(&li);
		else if(5==choice)
			FindInfo(&li);
		else if(9==choice)
			Save(&li);
		else if(0==choice)
			Exit(&li);
	}
	return 0;
}
void FindInfo(list *p_l)   //查找某条航班信息(根据航班号)
{
	node *p_t=p_l->head;
	int id=0,f=0;
	printf("请输入想要查找的航班的id:");
	scanf("%d",&id);
	Fflush();
	while(p_t)
	{
		if(p_t->data.id==id)
		{
			f=1;
			printf("\t出发时间\t航班号\t\t起始站\t\t终点站\t\t剩余票数\n\n");
			printf("%18s %13d %17s %17s %16d\n",p_t->data.time,p_t->data.id,p_t->data.begin,p_t->data.end,p_t->data.num);
		}
		p_t=p_t->next;	
	}
	p_t=NULL;
	if(!f)
		printf("无此航班\n");
	Stop();
}
void DelInfo(list *p_l)   //删除某条航班信息(根据航班号)
{
	int id=0,count=0;
	node *p_t=p_l->head;
	node *p_temp=NULL;
	printf("输入想要删除的航班的航班号:");
	scanf("%d",&id);
	Fflush();
	while(p_t)
	{
		if(p_t->data.id==id)
			{
				if(p_t->pre)
					p_t->pre->next=p_t->next;
				if(p_t->next)
					p_t->next->pre=p_t->pre;
				if(p_t==p_l->head)
					p_l->head=p_t->next;
				if(p_t==p_l->tail)
					p_l->tail=p_t;
				 p_temp=p_t->next;
				free(p_t);
				p_t=NULL;
				count++;
			}
		if(p_t)
			p_t=p_t->next;
		else
			p_t=p_temp;
	}
	if(!count)
		printf("无此航班\n");
	else
		printf("%d条已删除\n",count);
	p_t=p_temp=NULL;
	Stop();
}
void Save(list *p_l)  //保存退出
{
	FILE *p_f=fopen("info.bin","w");
	node *p_t=p_l->head;
	while(p_t)
	{
		fwrite(&p_t->data,sizeof(info),1,p_f);
		p_t=p_t->next;
	}
	fclose(p_f);
	p_f=NULL;
	p_t=NULL;
	Exit(p_l);
}
void Exit(list *p_l)	//不保存退出
{
	node *p_t=p_l->head;
	while(p_t)
	{
		p_l->head=p_l->head->next;
		free(p_t);
		p_t=p_l->head;
	}
	p_l->head=p_l->tail=NULL;
	exit(0);
}
void BrowseInfo(const list *p_l)    //浏览链表内的航班信息
{
	if(!p_l->head)
	{
		printf("没有任何航班信息存在\n");
		Stop();
	}
	else
	{
		node *p_t=p_l->head;
		printf("\t出发时间\t航班号\t\t起始站\t\t终点站\t\t剩余票数\n\n");
		while(p_t)
		{
			printf("%18s %13d %17s %17s %16d\n",p_t->data.time,p_t->data.id,p_t->data.begin,p_t->data.end,p_t->data.num);
			p_t=p_t->next;
		}
		p_t=NULL;
		printf("\n");
		Stop();
	}
}
void Fflush(void)		//清空缓冲区
{
	scanf("%*[^\n]");
	scanf("%*c");
}

void AddInfo(list *p_l) //添加航班信息
{
	int i=0;
	info temp={};
	printf("请输入航班号:");
	scanf("%d",&temp.id);
	Fflush();
	printf("请输入起始站:");
	fgets(temp.begin,10,stdin);
	if(strlen(temp.begin)==9&&temp.begin[8]!='\n')
		Fflush();
	printf("请输入终点站:");
	fgets(temp.end,10,stdin);
	if(strlen(temp.end)==9&&temp.end[8]!='\n')
		Fflush();
	printf("请输入出发时间(类似 周一 09:00)");
	fgets(temp.time,15,stdin);
	if(strlen(temp.time)==14&&temp.time[13]!='\n')
		Fflush();
	printf("请输入票数:");
	scanf("%d",&temp.num);
	Fflush();
	for(i=9;i>=0;i--)
		if(temp.begin[i]=='\n')
		{
			temp.begin[i]='\0';
			break;
		}
	for(i=9;i>=0;i--)
		if(temp.end[i]=='\n')
		{
			temp.end[i]='\0';
			break;
		}
	for(i=14;i>=0;i--)
		if(temp.time[i]=='\n')
		{
			temp.time[i]='\0';
			break;
		}
	node *p=(node *)malloc(sizeof(node));
	p->data=temp;
	p->next=NULL;
	if(!p_l->head&&!p_l->tail)
	{
		p_l->head=p_l->tail=p;
		p->pre=NULL;
	}
	else
	{
		p_l->tail->next=p;
		p->pre=p_l->tail;
		p_l->tail=p;
	}
	p=NULL;
}
void Read(list *p_l)  //将文件里的内容读到链表里
{
	FILE *p_file=fopen("info.bin","r");
	info temp={};
	if(!p_file)
	{
		printf("航班信息文件不存在,已自动初始化\n");
		SysInit(p_l);
		p_file=fopen("info.bin","r");
		Stop();
	}
	while(fread(&temp,sizeof(info),1,p_file))
	{
		node *p=(node *)malloc(sizeof(node));
		p->data=temp;
		p->next=NULL;
		if(!p_l->head&&!p_l->tail)
			{
				p_l->head=p_l->tail=p;
				p->pre=NULL;
			}
		else
		{
			p_l->tail->next=p;
			p->pre=p_l->tail;
			p_l->tail=p;
		}
		p=NULL;
	}
	fclose(p_file);
	p_file=NULL;
}
void Stop(void)   //暂停,输入回车继续
{
	printf("按回车键继续\n");
	getchar();
}
void SysInit(list *p_l)   //初始化
{
	FILE *p_file=fopen("info.bin","w");
	if(!p_file)
		printf("初始化失败,请重新初始化\n");
	fclose(p_file);
	p_file=NULL;
	node *p_t=p_l->head;
	while(p_t)
	{
		p_l->head=p_l->head->next;
		free(p_t);
		p_t=p_l->head;
	}
	p_l->head=p_l->tail=p_t=NULL;
}
int GetChoice(void)   //选择功能
{
	int choice=0;
	printf("请输入选择的功能:");
	scanf("%d",&choice);
	Fflush();
	return choice;
}
void ShowHome(void)			//显示主页
{
	system("clear");
	printf("***************************************************************\n");
	printf("\t\t1.系统初始化(会删除所有航班信息并新建航班文件)\n");
	printf("\t\t2.增加航班信息\n");
	printf("\t\t3.删除航班信息\n");
	printf("\t\t4.浏览航班信息\n");
	printf("\t\t5.查找航班信息\n");
	printf("\t\t6.按航班号排序\n");
	printf("\t\t7.订票系统\n");
	printf("\t\t8.退票系统\n");
	printf("\t\t9.保存并退出\n");
	printf("\t\t0.退出不保存\n");
	printf("***************************************************************\n");
}
