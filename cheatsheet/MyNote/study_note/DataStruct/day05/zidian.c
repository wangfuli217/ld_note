#include<stdio.h>
#include<stdlib.h>
#include<string.h>
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
	int cnt;
}Tree;
void read(Tree *pt);         //将文件里的内容读入树中
void stop(void);				//暂停
Word *split(char *pc);		//折分单词和释义
Node *create_node(Word *pw);	//创建新结点
Word *create_word(char *word,char *decl);     //创建新的单词空间
void insert_node(Tree *pt,Node *pn);       //插入新节点
void insert(Node **root,Node *pn);        //递归插入树
void inorder_data(Tree *pt);					//中序遍历
void inorder(Node *p);                    //递归中序遍历
void showhome(Tree *pt);				//显示功能
void find_word(Tree *pt,char *pc);			//查找单词与释义
void find(Node *pt,char *pc,int *f);		//查找

int main(void)
{
	Tree tree={};			//建立树
	read(&tree);			//把文件里的所有单词和解释读入树中
	while(1)
	{
		showhome(&tree);
	}
	return 0;
}
void find_word(Tree *pt,char *pc)			//查找单词与释义
{
	int f=0;
	printf("\n\n");
	find(pt->root,pc,&f);
	if(0==f)
		printf("对不起,没有这个词的翻译\n\n");
	printf("\n\n");
	stop();
	return;
}
void find(Node *pt,char *pc,int *f)		//查找
{
	if(pt)
	{
		find(pt->left,pc,f);
		if(strstr(pt->data->word,pc)||strstr(pt->data->decl,pc))
		{
			if(strcmp(pt->data->word,pc)==0)
				printf("\033[31m%-50s%s\033[0m\n",pt->data->word,pt->data->decl);
			else
				printf("%-50s%s\n",pt->data->word,pt->data->decl);
			*f=1;
		}
		find(pt->right,pc,f);
	}
}
void showhome(Tree *pt)							//显示功能
{
	char word[20]={};
	int i=0;
	system("clear");
	printf("请输入单词或中文(0结束):\n");
	fgets(word,20,stdin);
	if(word[0]=='0')
		exit(0);
	if(strlen(word)==19&&word[18]!='\n')
	{
		scanf("%*[^\n]");
		scanf("%*c");
	}
	for(i=19;i>=0;i--)
		if(word[i]=='\n')
		{
			word[i]='\0';
			break;
		}
	find_word(pt,word);
}
void inorder(Node *p)                    //递归中序遍历
{
	if(p)
	{
		inorder(p->left);
		printf("%s   %s\n",p->data->word,p->data->decl);
		inorder(p->right);
	}
}
void inorder_data(Tree *pt)					//中序遍历
{
	if(pt->root==NULL)
		return;
	inorder(pt->root);
}
void insert(Node **root,Node *pn)        //递归插入树
{
	if(*root==NULL)
	{
		*root=pn;
		return;
	}
	if(pn->data->word[0]<(*root)->data->word[0])
		insert(&((*root)->left),pn);
	else
		insert(&((*root)->right),pn);
}
void insert_node(Tree *pt,Node *pn)       //插入新节点
{
	insert(&(pt->root),pn);
	pt->cnt++;
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
		if(pc[i]!=' '&&pc[i]!='\t') 
			word[i]=pc[i];
		else
			break;
	word[i]='\0';
	for(;pc[i]!='\0';i++)
		if(pc[i]==' '||pc[i]=='\t')
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
void stop(void)				//暂停
{
	printf("按回车键继续\n");
	getchar();
}
