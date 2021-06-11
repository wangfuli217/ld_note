#include "time.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"

#define P 0.5
#define MAXLEVEL 4

//定义skip list 结点的结构
typedef struct sn {
	int value;
    struct sn ** forward; //数组指针用来保存各层指向后序的指针
}SkipNode;


//定义skip list 的结构

typedef struct {
    SkipNode* header;
    int level;
} SkipList;

SkipNode* CreateNode(int level, int value) 
{

//创建结点

//入口参数：level，结点的所在层次；value，结点值；

//出口参数：创建结点的指针 

    SkipNode* sn = ( SkipNode* )malloc( sizeof ( SkipNode ) );

    sn->forward = (SkipNode **)calloc ( level + 1, sizeof( SkipNode * ) ); //sn->forward[i] don't malloc 

    sn->value = value;

    return sn;
}

SkipList* CreateSkipList() 
{
	SkipList* SL = (SkipList*)malloc(sizeof(SkipList));
	
	SL->header = CreateNode(MAXLEVEL, 0);
	
	SL->level = 0;
	
	return SL;
}

float frand() {

//返回随机数

//入口参数：空

//出口参数：浮点型随机数（0到1）

	return (float) rand() / RAND_MAX;
}

int random_level() {

//随机产生结点所插入的层次；

//入口参数：空；

//出口参数：随机产生结点的层次；
	static int first = 1;

    	int lvl = 0;

	if(first) {
		//Seed Random Generator
		
		srand( (unsigned)time( NULL ));
		
		first = 0;
	}

//产生一个0到1的随机数
	while(frand() < P && lvl < MAXLEVEL-1)
		lvl++;
	return lvl;
} 

int SkipListLength(SkipList* SL,int level)
{
//求SkipList长度；

//入口参数：SkipList指针,*SL;层数,level；

//出口参数：空；

	int length = 0;
	
	SkipNode*p = SL->header->forward[level];

	while(p != NULL)
	{
	
		length++;
		
		p = p->forward[level];
	
	}

	return length;
}

int SkipListEmpty(SkipList *SL)
{
//判断SkipList是否为空；

//入口参数：SkipList指针,*SL;

//出口参数：成功标志:1 成功，0 失败；

	if(SL->header->forward[0] == NULL)
		return 1;
	else
		return 0;
}

void PrintSkipList(SkipList* SL,int level) 
{

//输出skip list；

//入口参数：SkipList指针,*SL;层数,level；

//出口参数：空；

	SkipNode* p = SL->header->forward[level];
	
	printf("{");
	
	while(p != NULL) {
	
		printf("%d", p->value);
		
		p = p->forward[level];
		
		if(p != NULL)//控制最后一个元素之后输出的 ","
		
		printf(",");
	
	}    

	printf("}");

}

void insert(SkipList* SL, int value) 
{

    //SkipList插入操作
    //入口参数：SkipList指针,*SL;插入节点的值，value;
    //出口参数：空；

	int i;
	
	int lvl;
	
	SkipNode* p = SL->header;
	
	SkipNode* newnode;
	
	SkipNode* update[MAXLEVEL + 1];
	
	//清空指针数组update[]；
	
	for(i = 0;i< MAXLEVEL + 1;i++)	
	{
	    update[i] = NULL;
	}
	
	//Find and record updates
	
	//寻找每层的插入点并将找的指针放入update[]中；
	
	for(i = SL->level; i >= 0; i--) 
	{
		while(p->forward[i] != NULL && p->forward[i]->value < value) 
		{
			p = p->forward[i];
		}
	
		update[i] = p; 
	}
	
	p = p->forward[0];
	
	if(p == NULL || p->value != value) 
	{        
		lvl = random_level();
	
	        //如果新插入结点的层次高于所有结点的层次，更新update[]层次
	
		if(lvl > SL->level) 
		{
			for(i = SL->level + 1; i <= lvl; i++) 
			{
				update[i] = SL->header;
			}
			
			SL->level = lvl;
		}
       		
       		 //插入新的结点
		newnode = CreateNode(lvl, value);

		for(i = 0; i <= lvl; i++) 
		{
			newnode->forward[i] = update[i]->forward[i];
			update[i]->forward[i] = newnode;
		}
    	}

}

int Search(SkipList* SL, int Searchvalue) 
{
//SkipList查找操作

//入口参数：SkipList指针,*SL;所要查询的值，value;

//出口参数：成功标志:1 成功，0 失败；

	int i;

    SkipNode* p = SL->header;

    //查找结点

	for(i = SL->level; i >= 0; i--) 
	{
		while(p->forward[i] != NULL && p->forward[i]->value < Searchvalue) 
		{
			p = p->forward[i];//指向查找结点的前一个数

		}

	}

	p = p->forward[0];//指向查找的结点

	if(p != NULL && p->value == Searchvalue)
		return 1;
	
	return 0;   
}

void deletenode(SkipList* SL, int value) 
{//SkipList删除操作

//入口参数：SkipList指针,*SL;所要查询的值，value;

//出口参数：成功标志:1 成功，0 失败

	int i;

    SkipNode* p =SL->header;

    SkipNode* update[MAXLEVEL + 1];

   //清空指针数组update[]；

for(i = 0;i< MAXLEVEL + 1;i++)

{

update[i] = NULL;

}

//查找所要删除的结点及其前向指针；

   for(i = SL->level; i >= 0; i--) 

   {

        while(p->forward[i] != NULL && p->forward[i]->value < value) 
        {
            p = p->forward[i];
        }

        update[i] = p; 
    }

    p = p->forward[0];//指向删除结点

    if(p->value == value) 
    {//删除结点
        for(i = 0; i <= SL->level; i++) 
        {
            if(update[i]->forward[i] != p)
            break;
            
            update[i]->forward[i] = p->forward[i];
        }

        free(p);

    //降低skiplist的层次

    while(SL->level > 0 && SL->header->forward[SL->level] == NULL)
        SL->level--;
    }

}

void Formhead()
{

    printf("\t+============================================================+\n");

    printf("\t|                        SkipList                            |\n");

    printf("\t+============================================================+\n");

}

int main()
{
    SkipList* SL = CreateSkipList();

    SkipList* SLt = CreateSkipList();

    int temp,Enumber = 0;

    Formhead();//打印表头

    FILE *fp;

    //读取文件中的数据

    if((fp=fopen("shuju.txt","r"))==NULL)
    {
        printf ("cannot open file\n");
    }
    else
    {
        while(!feof(fp))
        {
            fscanf(fp,"%d ",&temp);
            insert(SL,temp);   
            Enumber++;
        }
    }

    fclose(fp);

    printf("\tload data from file and create SkipList:  \n");

    //======================================验证插入操作

    for(int i = MAXLEVEL-1;i>= 0;i-- )
    {

        printf("The %d level : ",i);

        PrintSkipList(SL,i);

        printf("      lenth : ");

        printf("  %d  ",SkipListLength(SL,i));

        printf("\n");
    }

    printf("\n");
    
    //=======================================验证查询操作

    if(Search(SL,2))
        printf("2 is in this SkipList\n");
    else
        printf("2 is not in this SkipList\n");

//=======================================验证删除操作
    printf("After delete 2:\n");

    printf("\n");

    deletenode(SL, 2);

    for(int i = MAXLEVEL-1;i>= 0;i-- )
    {
        printf("The %d level : ",i);

        PrintSkipList(SL,i);

        printf("  %d  ",SkipListLength(SL,i));

        printf("\n");
    }

    insert(SL,2);

    for(int i = MAXLEVEL-1;i>= 0;i-- )
    {
        printf("The %d level : ",i);

        PrintSkipList(SL,i);

        printf("  %d  ",SkipListLength(SL,i));

        printf("\n");
    }
	
	int i = 0;
	
	scanf("%d", i);
	
    return 0;
}