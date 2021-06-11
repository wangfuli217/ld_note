#include<stdio.h>
#include<stdlib.h>
#define ROW 10
#define COL	20
typedef struct
{
	int row,col;
}pt;
void showmap(const pt *,const pt *,const pt *);
void GetSnake(pt *,pt *);
void GetApple(pt *,const pt*,const pt*);
void MoveSnake(pt*,pt*,pt*);
int main()
{
	pt head={},tail={},apple={};
	srand(time(0));
	GetSnake(&head,&tail);
	GetApple(&apple,&head,&tail);
	while(1)
	{
		showmap(&head,&tail,&apple);
		MoveSnake(&head,&tail,&apple);
	}
	return 0;
}
void GetSnake(pt *p_head,pt *p_tail)          //获取蛇的位置
{
	p_head->row=rand()%ROW;
	p_head->col=rand()%COL;
	int del[4][2]={-1,0,0,-1,0,1,1,0};
	while(1)	
	{
		int temp=rand()%4;
		p_tail->row=del[temp][0]+p_head->row;
		p_tail->col=del[temp][1]+p_head->col;
		if(p_tail->row<0||p_tail->row>ROW)
			continue;
		if(p_tail->col<0||p_tail->col>COL)
			continue;
		break;
	}
}
void GetApple(pt *p_apple,const pt *p_head,const pt *p_tail)						//获取苹果位置
{
	while(1)
	{
		p_apple->row=rand()%ROW;
		p_apple->col=rand()%COL;
		if(p_apple->row==p_head->row&&p_apple->col==p_head->col||p_apple->row==p_tail->row&&p_apple->col==p_tail->col)
			continue;
		break;
	}
}
void showmap(const pt *p_head,const pt *p_tail,const pt *p_apple)				//显示地图
{
	int i=0,j=0;
	system("clear");
	printf("\n\n\n\n\n");
	for(i=0;i<COL+2;i++)
		printf("*");
	printf("\n");
	for(i=0;i<ROW;i++) 
	{ 
		printf("*");
		for(j=0;j<COL;j++)
			if(i==p_head->row&&j==p_head->col)
				printf("+");
			else if(i==p_tail->row&&j==p_tail->col)
				printf("-");
			else if(i==p_apple->row&&j==p_apple->col)
				printf("@");
			else
				printf(" ");
		printf("*");
		printf("\n");
	}
	for(i=0;i<COL+2;i++)
		printf("*");
	printf("\n\n\n\n");
}
void MoveSnake(pt *p_head,pt *p_tail,pt *p_apple)      //移动蛇并返回苹果有没有被吃掉（0没吃掉，1被吃掉了）
{
	int del[4][3]={p_head->row-1,p_head->col,p_tail->row,
				   p_head->row+1,p_head->col,p_tail->row,
				   p_head->col-1,p_head->row,p_tail->col,
				   p_head->col+1,p_head->row,p_tail->col};
	int temp=0,count=1,direc=-1;
	printf("请输入蛇的移动方向(0向上,1向下,2向左,3向右):");
dir:scanf("%d",&direc);
	scanf("%*[^\n]");
	scanf("%*c");
	if(direc<0||direc>3)
	{
		printf("输入的方向不存在,请重新输入:");
		goto dir;
	}
	if(direc<2)
		temp=ROW;
	else 
		temp=COL;
	if(del[direc][0]<0||del[direc][0]>temp-1||del[direc][0]==del[direc][2])
		return;
	p_tail->row=p_head->row;
	p_tail->col=p_head->col;
	if(direc>1)			
	{
		p_head->col=del[direc][0];
		temp=1;
		count=-1;
	}
	else
	{
		temp=0;
		p_head->row=del[direc][0];
	}
	if(del[direc][temp]==p_apple->row&&del[direc][temp+count]==p_apple->col)
		GetApple(p_apple,p_head,p_tail);
}
