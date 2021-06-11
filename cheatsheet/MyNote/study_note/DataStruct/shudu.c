#include<stdio.h>
int shudu[9][9]={};		//输入的数独
int data[9][9];			//每个小九宫格中可以填入的数字
typedef struct
{
	int line;
	int row;
	int pos;
	int data;
}node;
node stack[81];    //建立栈
void get_shudu(void)               //获得输入的数独
{
	int i=0,j=0;
	char ch=0;
	printf("输入一个数独(空位用0或空格表示):\n");
	for(i=0;i<9;i++)
		for(j=0;j<9;j++)
		{
			data[i][j]=j+1;
get:		ch=getchar();
			if(ch=='\n')
				goto get;
			if(ch==' ') 
				ch='0';
			shudu[i][j]=ch-'0';
		}
}
void get_data(void)             //每个小九宫格中可以填入的数字
{
	int i=0,j=0;
	for(i=0;i<9;i++)
		for(j=0;j<9;j++)
			data[i][j]=j+1;
	for(i=0;i<9;i++)
		for(j=0;j<9;j++)
			if(shudu[i][j]!=0)
				data[i/3*3+j/3][shudu[i][j]-1]=0;
}
int checkend(void)				//检查九宫格是否正确,正确返回0,否则返回-1
{
	int i=0,j=0,sum=0,sum1=0;
	for(i=0;i<9;i++)
	{
		sum=sum1=0;
		for(j=0;j<9;j++)
		{
			sum+=shudu[i][j];
			sum1+=shudu[j][i];
		}
		if(sum!=45||sum1!=45)
			return -1;
	}
	return 0;
}
int find_next_data(int *line,int *row)      //寻找九宫格内可以用来填入的下一个数字,返回0代表九宫格完成并且正确,1代表找到下一个数字,－1代表没有找到
{
	if(*row>8)
	{
		*row=0;
		(*line)++;
	}
	if(*line>8)
	{
		if(!checkend())
			return 0;
		return -1;
	}
	while(data[*line][*row]==0)
	{
		if(*row<8)
			(*row)++;
		else
		{
			*row=0;
			(*line)++;
		}
		if(*line>8)
		{
			if(!checkend())
				return 0;
			return -1;
		}
	}
	return 1;
}
void print()   //打印九宫格
{
	int i=0,j=0;
	printf("\n\n");
	for(i=0;i<9;i++)
	{
		for(j=0;j<9;j++)
			printf("%d ",shudu[i][j]);
		printf("\n");
	}
	printf("\n\n");
}
int check_line_col(int x,int y,int num)       //判断某个数是否与所在行和列有重复,有重复返回-1,没有重复返回0
{
	int i=0;
	for(i=0;i<9;i++)
		if(shudu[x][i]==num||shudu[i][y]==num)
			return -1;
	return 0;
}
int data_can_push(int line,int row,int *pos)    //判断某个数是否可以入栈,可以则返回0,否则返回-1
{
	int start=0;
	int x=line/3*3;
	int y=line%3*3;
	for(start=*pos;start<10;start++)
	{
		if(shudu[x+(start-1)/3][y+(start-1)%3]!=0)
			continue;
		if(check_line_col(x+(start-1)/3,y+(start-1)%3,data[line][row])!=0)
			continue;
		else
		{
			*pos=start;
			return 0;
		}
	}
	return -1;
}
void push(int *top,int line,int *row,int *pos)    //压栈
{
	int x=line/3*3+(*pos-1)/3;
	int y=line%3*3+(*pos-1)%3;
	shudu[x][y]=data[line][*row];
	stack[*top].line=line;
	stack[*top].row=*row;
	stack[*top].pos=*pos;
	stack[*top].data=shudu[x][y];
	*top+=1;
	*row+=1;
	*pos=1;
}
void pop(int *top,int *line,int *row,int *pos)    //出栈
{
	*top-=1;
	*line=stack[*top].line;
	*row=stack[*top].row;
	*pos=stack[*top].pos;
	int x=*line/3*3+(*pos-1)/3;
	int y=*line%3*3+(*pos-1)%3;
	shudu[x][y]=0;
	*pos+=1;
}
int main(void)
{
	int line=0,row=0,pos=1;     //某个数的位置
	int state=0,end=0;          //判断条件
	int top=0;					//记录栈顶位置
	get_shudu();
	get_data();
	while(end!=1)
	{
		state=find_next_data(&line,&row);
		if(state==0)
		{
			print();
			end=1;
		}
		else if(state==-1)
		{
			printf("无解\n");
			end=1;
		}
		else
		{
			state=data_can_push(line,row,&pos);
			if(state==0)
			{
				push(&top,line,&row,&pos);
			}
			else
			{
				pop(&top,&line,&row,&pos);
			}
		}
	}
	return 0;
}
