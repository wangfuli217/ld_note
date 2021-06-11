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
void split(char *pc);										//折分一条单词

void split(char *pc)										//折分一条单词
{
	char name[20]={},tran[70]={};
	int i=0,j=0;
	for(i=0;pc[i]!=' '&&pc[i]!='\t';i++)
		name[i]=pc[i];
	name[i]='\0';
	for(;pc[i]==' '||pc[i]=='\t';i++);
	for(;pc[i]!='\0';i++)
		tran[j++]=pc[i];
	tran[j]='\0';
	printf("%s\t\t\t\t%s\n",name,tran);
}
//void insert_data(List *pl,Node *pn)						//将某个结点具体插入对应的链表
//{
//	if(pl->head==NULL)
//	{
//		pl->head=pl->tail=pn;
//		return;
//	}
//	pl->tail->next=pn;
//	pn->pri=pl->tail;
//	pl->tail=pn;
//	printf("%s\n",pl->tail->data.tran);
//}
//Node* create_node(const char *name,const char *tran)		   //创建新节点
//{
//	Node *pn=(Node *)malloc(sizeof(Node));
//	pn->next=NULL;
//	pn->pri=NULL;
//	strcpy(pn->data.name,name);
//	strcpy(pn->data.tran,tran);
//	return pn;
//}
//void insert(List *pl,const char *name,const char *tran)          //插入节点
//{
//	Node *pn=create_node(name,tran);
//	int index=pn->data.name[0];
//	if(index>='a'&&index<='z')
//		index-='a';
//	else if(index>='A'&&index<='Z')
//		index-='A';
//	printf("%d ",index);
//	insert_data(&pl[index],pn);
//}
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
			split(word);
			i=0;
		}
		else
			word[i++]=ch;
	}
//				insert(pl,name,tran);
	fclose(pf);
	pf=NULL;
}
int main(void)
{
	List list[26]={};
	read(list);
	return 0;
}
