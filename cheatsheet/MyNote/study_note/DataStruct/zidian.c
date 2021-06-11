#include<stdio.h>
#include<stdlib.h>
typedef struct                 //定义存储一个单词和它的解释
{
	char *word;
	char *decl;
}Word;
typedef struct node           //定义一个树结点
{
	Word *data;
	struct node *left;
	struct node *right;
}Node;
typedef struct             //定义树
{
	Node *root;
}Tree;
void read(Tree *pt);         //将文件里的内容读入树中
void stop();				//暂停
Word *split(char *pc);		//折分单词和释义
Node *create_node(Word *pw);	//创建新结点
Word *create_word(char *word,char *decl);     //创建新的单词空间
void insert_node(Tree *pt,Node *pn);       //插入新节点
void insert(Node **root,Node *pn);        //递归插入树

void insert(Node **root,Node *pn)        //递归插入树
{
	if(*root==NULL)
		*root=pn;
	else if((*root)->data->word[0]<=pn->data->word[0])
		*root=(*root)->right;
	else
		*root=(*root)->left;
}
void insert_node(Tree *pt,Node *pn)       //插入新节点
{
	if(pt->root==NULL)
	{
		pt->root=pn;
		return;
	}
	insert(&(pt->root),pn);
}
Node *create_node(Word *pw)	//创建新结点
{
	Node *p=(Node *)malloc(sizeof(Node));
	p->data=pw;
	p->left=NULL;
	p->right=NULL;
	return p;
}
Word *create_word(char *word,char *decl)     //创建新的单词空间
{
	Word *p=(Word *)malloc(sizeof(Word));
	p->word=word;
	p->decl=decl;
	return p;
}
Word *split(char *pc)		//折分单词和释义
{
	int i=0,j=0;
	char *word=(char *)malloc(sizeof(char)*20);
	char *decl=(char *)malloc(sizeof(char)*60);
	for(i=0;pc[i]!='\0';i++)
		if(pc[i]!=' ') 
			word[i]=pc[i];
		else
			break;
	for(;pc[i]!='\0';i++)
		if(pc[i]==' ')
			continue;
		else
			break;
	for(;pc[i]!='\0';i++)
		decl[j++]=pc[i];
	return create_word(word,decl);
}
void read(Tree *pt)         //将文件里的内容读入树中
{
	FILE *p_file=fopen("word.txt","rb");
	if(!p_file)
	{
		printf("没有字典文件\n");
		stop();
		exit(0);
	}
	int i=0;
	char word[70]={},ch=0;
	while(1)
	{
		if(!fread(&ch,sizeof(char),1,p_file))
				break;
		if(ch!='\n')
			word[i++]=ch;
		else
		{
			word[i]='\0';
			insert_node(pt,create_node(split(word)));
			i=0;
		}
	}
	fclose(p_file);
	p_file=NULL;
}
void stop()				//暂停
{
	printf("按回车键继续\n");
	getchar();
}
int main(void)
{
	Tree tree={};			//建立树
	read(&tree);			//把文件里的所有单词和解释读入树中
	return 0;
}
