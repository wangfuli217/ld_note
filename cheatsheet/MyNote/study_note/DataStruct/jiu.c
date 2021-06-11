#include<stdio.h>
#define MAXSTACKLENGTH 81

int jiu[9][9];
int data[][9]=
	{{1,2,3,4,5,6,7,8,9},
	 {1,2,3,4,5,6,7,8,9},
	 {1,2,3,4,5,6,7,8,9},
	 {1,2,3,4,5,6,7,8,9},
	 {1,2,3,4,5,6,7,8,9},
	 {1,2,3,4,5,6,7,8,9},
	 {1,2,3,4,5,6,7,8,9},
	 {1,2,3,4,5,6,7,8,9},
	 {1,2,3,4,5,6,7,8,9}};
typedef struct
{
	int xpos;
	int ypos;
	int jiupos;
	int num;
}node;
node stack[MAXSTACKLENGTH];
void find_data(void)
{
	int i,j;
	int x,y;
	for(i=0;i<9;i++)
		for(j=0;j<9;j++)
			if(jiu[i][j]!=0)
			{
				x=(i/3)*3+j/3;
				y=jiu[i][j]-1;
				data[x][y]=0;
			}
}
void print(int ptr[9][9])
{
	int i,j;
	for(i=0;i<9;i++)
		for(j=0;j<9;j++)
		{
			printf("%d",ptr[i][j]);
			if(j==8)
				printf("\n");
		}
}
int checkend(void)
{
	int i,j,sum;
	for(i=0;i<9;i++)
	{
		sum=0;
		for(j=0;j<9;j++)
			sum+=jiu[i][j];
		if(sum!=45)
			return -1;
	}
	for(j=0;j<9;j++)
	{
		sum=0;
		for(i=0;i<9;i++)
			sum+=jiu[i][j];
		if(sum!=45)
			return -1;
	}
	return 0;
}
int findnextdata(int m,int n,int *x,int *y)
{
	int state=0;
	if(n>8)
	{
		n=0;
		m++;
	}
	if(m>8)
	{
		state=checkend();
		if(state!=0)
			return -1;
		else
			return 1;
	}
	while(data[m][n]==0)
	{
		if(n<8)
			n++;
		else
		{
			n=0;
			m++;
			if(m>8)
			{
				state=checkend();
				if(state!=0)
					return -1;
				else
					return 1;
			}
		}
	}
	*x=m;
	*y=n;
	return 0;
}
int checkline(int m,int n,int num)
{
	int i;
	for(i=0;i<9;i++)
		if(jiu[m][i]==num)
			return -1;
	for(i=0;i<9;i++)
		if(jiu[i][n]==num)
			return -1;
	return 0;
}
int checkcanpush(int m,int n,int *pos)
{
	int start=*pos;
	int i,temp1,temp2,temp3,temp4;
	int num;
	temp1=(m/3)*3;
	temp2=(m%3)*3;
	num=data[m][n];
	for(i=start;i<10;i++)
	{
		temp3=temp1+(start-1)/3;
		temp4=temp2+(start-1)%3;
		if(jiu[temp3][temp4]!=0)
		{
			start++;
			continue;
		}
		if(checkline(temp3,temp4,num)!=0)
		{
			start++;
			continue;
		}
		else
		{
			*pos=start;
			return 0;
		}
	}
	return -1;
}
int push(int *top,int x,int y,int jiupos,int num)
{
	if(*top>=MAXSTACKLENGTH)
	{
		printf("栈用完了\n");
		return -1;
	}
	else
	{
		(*top)++;
		stack[*top].xpos=x;
		stack[*top].ypos=y;
		stack[*top].jiupos=jiupos;
		stack[*top].num=num;
		return 0;
	}
}
int pop(int *top,int *xpos,int *ypos,int *jiupos,int *num)
{
	if(*top==-1)
		return -1;
	else
	{
		*xpos=stack[*top].xpos;
		*ypos=stack[*top].ypos;
		*jiupos=stack[*top].jiupos;
		*num=stack[*top].num;
		(*top)--;
		return 0;
	}
}
int main(void)
{
	int end=0;
	int line=0;
	int row=0;
	int top=-1;
	int pos=1;
	int state=0;
	int num;
	int i,j;
	for(i=0;i<9;i++)
		for(j=0;j<9;j++)
			scanf("%d",&jiu[i][j]);
	find_data();
	while(end!=1)
	{
		state=findnextdata(line,row,&line,&row);
		if(state==0)
		{
			state=checkcanpush(line,row,&pos);
			if(state==0)
			{
				state=push(&top,line,row,pos,data[line][row]);
				if(state==0)
				{
					jiu[line/3*3+(pos-1)/3][line%3*3+(pos-1)%3]=data[line][row];
					row++;
					pos=1;
				}
				else
					end=1;
			}
			else
			{
				state=pop(&top,&line,&row,&pos,&num);
				if(state==0)
				{
					jiu[line/3*3+(pos-1)/3][line%3*3+(pos-1)%3]=0;
					pos++;
				}
				else
					end=1;
			}
		}
		else if(state==1)
		{
			printf("\n");
			print(jiu);
			end=1;
		}
		else
		{
			printf("无解\n");
			end=1;
		}
	}
	return 0;
}


