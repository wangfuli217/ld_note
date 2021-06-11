关键字：main函数参数  文件拷贝.c

数据结构算法 ：指针  结构体  动态分配内存  函数

/*编写一个程序的顺序，先把程序的各个模块考虑好，之后把函数名称定好，
  定好需要的指针形参，定好是否需要返回值，
  定好结构体变量
  然后按整个程序的思路假设各个函数已经写好，把main函数写好
  之后在填充各个函数的内部实现功能 */
/*像贪吃蛇这个程序，需要判断苹果和蛇是否重叠写一个函数之后返回特定数值判断是否重叠
  根据这个数值 在主函数里做相应的处理，重叠的话就再init_apple*/
例子
#include<stdio,h>
typedef struct{
	int row,col;
}pt;

typedef struct{
	pt head,tail;
}snake;

void init_snake(snake *p_snake)
{
	
}

void init_apple(pt *p_apple)
{
	
}

void move_snake(snake *p_snake)
{
	
}

int overlap(const pt *p_apple,const snake *p_snake)
{
		
}

void show_map(const pt *p_apple,const snake *p_snake)
{

}
int main()
{
	snake snk={0};
	pt apple={0};
	init_apple(&apple);
	init_snake(&snk);
	while(1)
	{	
		if(overlap(&apple,&snk))
			init_apple(&apple);
		else
			break;
	}
	show_map(&apple,&snk);
	while(1)
	{
		move_snake(&snk);
		while(1)
		{
			if(overlap(&apple,&snk))
				init_apple(&apple);
			else
				break;
		}
		show_map(&apple,&snk);
	}
	return 0;
}




/*贪吃蛇 
	非常好的教程 函数独立性强 函数内容只写和函数名有关的内容 
	这种实现依赖的就是指针来操作的 指针做形参 变量也是可以的 关键是要条理清晰
		

	按照你程序中都需要哪些板块来先划分函数，然后在划分的函数内部就只用考虑函数功能了，就不会想着其他函数了。 */
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#define APPLE '@'
#define SNAKE_HEAD '+'
#define SNAKE_TAIL '-'

typedef struct{
	int row,col;
}pt;

typedef struct{
	pt head,tail;
}snake;

enum{ABOVE,BELOW,LEFT,RIGHT};
enum{NOOVERLAP,OVERLAP};

void init_snake(snake *p_snake)
{
	p_snake->head.row=rand()%(SIZE-2)+1;
	p_snake->head.col=rand()%(SIZE-2)+1;
	p_snake->tail=p_snake->head;
	switch(rand()%4)
	{
		case ABOVE:
			p_snake->tail.row--;
			break;
		case BELOW:
			p_snake->tail.row++;
			break;
		case LEFT:
			p_snake->tail.col--;
			break;
		case RIGHT:
			p_snake->tail.col++;
			break;
	}
}

void init_apple(pt *p_apple)
{
	p_apple->row=rand()%SIZE;
	p_apple->col=rand()%SIZE;
}

void move_snake(snake *p_snake)
{
	pt tmp={0};
	int direction=0;
	printf("请输入代表方向的数字，%d代表上，%d代表下，%d代表左，%d代表右：",ABOVE,BELOW,LEFT,RIGHT);
	scanf("%d",&direction);
	if(direction<0||direction>3)
		return;
	tmp=p_snake->head;
	switch(direction)
	{
		case ABOVE:
			tmp.row--;
			break;
		case BELOW:
			tmp.row++;
			break;
		case LEFT:
			tmp.col--;
			break;
		case RIGHT:
			tmp.col++;
			break;
	}
	if(tmp.row<0||tmp.row>=SIZE)
		return;
	if(tmp.col<0||tmp.col>=SIZE)
		return;
	if(tmp.row==p_snake->tail.row && tmp.col==p_snake->tail.col)
		return;
	p_snake->tail=p_snake->head;
	p_snake->head=tmp;
}

int overlap(const pt *p_apple,const snake *p_snake)
{
	if(p_apple->row==p_snake->head.row && p_apple->col==p_snake->head.col)
		return OVERLAP;
	else if(p_apple->row==p_snake->tail.row && p_apple->col==p_snake->head.col)
		return OVERLAP;
	else 
		return NOOVERLAP;
}

void show_map(const pt *p_apple,const snake *p_snake)
{
	int row=0,col=0;
	for(row=0;row<=SIZE-1;row++)
	{
		for(col=0;col<=SIZE-1;col++)
		{
			if(row==p_apple->row && col==p_apple->col)
				printf("%c",APPLE);
			else if(row==p_snake->head.row && col==p_snake->head.col)
				printf("%c",SNAKE_HEAD);
			else if(row==p_snake->tail.row && col==p_snake->tail.col)
				printf("%c",SNAKE_TAIL);
			else
				printf(" ");
		}
	  	printf("\n");
	}

}
int main()
{
	snake snk={0};
	pt apple={0};
	init_apple(&apple);
	init_snake(&snk);
	while(1)
	{	
		if(overlap(&apple,&snk))
			init_apple(&apple);
		else
			break;
	}
	show_map(&apple,&snk);
	while(1)
	{
		move_snake(&snk);
		while(1)
		{
			if(overlap(&apple,&snk))
				init_apple(&apple);
			else
				break;
		}
		show_map(&apple,&snk);
	}
	return 0;
}




/*编写程序实现文件拷贝功能
	程序必须可以按如下方式使用
		./a.out 文件路径1  文件路径2   */
#include<stdio.h>
int main(int argc,char *argv[])
{
	char buf[100]={0};
	int size=0;
	FILE *p_src=NULL,*p_dest=NULL;
	p_src=fopen(*(argv+1),"rb"); //打开原始文件  argv0是./a.out
	if(!p_src)    //这个fopen 第一个参数文件路径 要是文件名加"" 
			//	要是地址不用加""
	{
		printf("原始文件打开失败\n");
		return 0;
	}
	p_dest=fopen(*(argv+2),"wb");
	if(!p_dest)
	{
		printf("新文件打开失败\n");
		fclose(p_src);
		p_src=NULL;
		return 0;       //新文件失败 要关闭原始文件
	}
	while(1)
	{
		size=fread(buf,sizeof(char),100,p_src);
		if(!size)   // 不能从原始文件获得任何数据
			break;
		fwrite(buf,sizeof(char),size,p_dest);
	}

	fclose(p_src);
	p_src=NULL;
	fclose(p_dest);
	p_dest=NULL;
	return 0;
}
