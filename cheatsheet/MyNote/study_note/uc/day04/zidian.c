#include<stdio.h>
#include<string.h>
#include<stdlib.h>
typedef struct            //一条单词和翻译
{
	char name[15];
	char tran[60];
}Word;
typedef struct Node       //链表中的一个结点
{
	Word data;
	struct Node* next;
	struct Node* pri;
}Node;
typedef struct             //一条链表
{
	Node* head;
	Node* tail;
}List;
void read(List *pl);			//把文件里的内容读到数组链表里
void insert(List *pl,const char *name,const char *tran);					 //插入节点
Node* create_node(const char *name,const char *tran);					    //创建新节点
void insert_data(List *pl,Node *pn);						//将某个结点具体插入对应的链表
void split(List *pl,char *pc);										//折分一条单词
void find(List *);									//显示页面
void stop(void);										//暂停
void find_data(List *pl,char *word,int *flag);					//在对应的链表上查找
void clear(List *pl);										//释放申请的所有内存
void clear_one_list(List *pl);								//清空一条链表

void find_data(List *pl,char *word,int *flag)					//在对应的链表上查找
{
	Node *pn=pl->head;
	while(pn)
	{
		if(strstr(pn->data.name,word))
		{
			if(!strcmp(pn->data.name,word))
				printf("\t\t\033[31m%-50s%s\033[0m\n",pn->data.name,pn->data.tran);
			else
				printf("\t\t%-50s%s\n",pn->data.name,pn->data.tran);
			*flag=1;
		}
		if(strstr(pn->data.tran,word))
		{
			if(!strcmp(strstr(pn->data.tran,".")+1,word))
				printf("\t\t\033[31m%-50s%s\033[0m\n",pn->data.tran,pn->data.name);
			else
				printf("\t\t%-50s%s\n",pn->data.tran,pn->data.name);
			*flag=1;
		}
		pn=pn->next;
	}
	pn=NULL;
}
void stop(void)										//暂停
{
	printf("输入回车继续:");
	getchar();
}
void clear_one_list(List *pl)								//清空一条链表
{
	Node *pn=pl->head;
	while(pn)
	{
		pl->head=pl->head->next;
		free(pn);
		pn=pl->head;
	}
	pl->head=pl->tail=NULL;
	pn=NULL;
}
void clear(List *pl)										//释放申请的所有内存
{
	int i=0;
	for(i=0;i<26;i++)
		clear_one_list(&pl[i]);
}
void find(List *pl)									//显示页面
{
	system("clear");
	char word[20]={};
	int index=0,i=0,flag=0;
	printf("输入要查找的单词或中文(输入0退出):");
	fgets(word,20,stdin);
	if(word[0]=='0')
	{
		clear(pl);
		exit(0);
	}
	if(strlen(word)==19&&word[18]!='\n')
	{
		scanf("%*[^'\n']");
		scanf("%*c");
	}
	if(strlen(word)==1)
		return;
	if(word[strlen(word)-1]=='\n')
		word[strlen(word)-1]='\0';
	if(word[0]>='a'&&word[0]<='z')
	{
		index=word[0]-'a';
		find_data(&pl[index],word,&flag);
		if(!flag)
			printf("\t\t\033[31m对不起,没有相关解释\033[0m\n");
		stop();
		return;
	}
	else if(word[0]>='A'&&word[0]<='Z')
	{
		index=word[0]-'A';
		find_data(&pl[index],word,&flag);
		if(!flag)
			printf("\t\t\033[31m对不起,没有相关解释\033[0m\n");
		stop();
		return;
	}
	for(i=0;i<26;i++)
		find_data(&pl[i],word,&flag);
	if(!flag)
		printf("\t\t\033[31m对不起,没有相关解释\033[0m\n");
	stop();
}
void split(List *pl,char *pc)										//折分一条单词
{
	char name[20]={},tran[70]={};
	int i=0,j=0;
	for(i=0;pc[i]==' '||pc[i]=='\t';i++);
	for(;pc[i]!=' '&&pc[i]!='\t';i++)
		name[i]=pc[i];
	name[i]='\0';
	for(;pc[i]==' '||pc[i]=='\t';i++);
	for(;pc[i]!='\0';i++)
		tran[j++]=pc[i];
	for(j--;tran[j]==' '||tran[j]=='\t';j--);
	tran[++j]='\0';
	insert(pl,name,tran);
}
void insert_data(List *pl,Node *pn)						//将某个结点具体插入对应的链表
{
	if(pl->head==NULL)
	{
		pl->head=pl->tail=pn;
		return;
	}
	pl->tail->next=pn;
	pn->pri=pl->tail;
	pl->tail=pn;
}
Node* create_node(const char *name,const char *tran)		   //创建新节点
{
	Node *pn=(Node *)malloc(sizeof(Node));
	pn->next=NULL;
	pn->pri=NULL;
	strcpy(pn->data.name,name);
	strcpy(pn->data.tran,tran);
	return pn;
}
void insert(List *pl,const char *name,const char *tran)          //插入节点
{
	Node *pn=create_node(name,tran);
	int index=pn->data.name[0];
	if(index>='a'&&index<='z')
		index-='a';
	else if(index>='A'&&index<='Z')
		index-='A';
	insert_data(&pl[index],pn);
}
void read(List *pl)				//把文件里的内容读到数组链表里
{
	FILE *pf=fopen("word.txt","r");
	char ch=0,word[90]={};
	int i=0;
	if(!pf)
		perror("fopen"),exit(-1);
	while(1)
	{
		if(!fread(&ch,sizeof(char),1,pf))
			break;
		if(ch=='\n')
		{
			word[i]='\0';
			split(pl,word);
			i=0;
		}
		else
			word[i++]=ch;
	}
	fclose(pf);
	pf=NULL;
}
int main(void)
{
	List list[26]={};
	read(list);
	while(1)
	{
		find(list);
	}
	return 0;
}
