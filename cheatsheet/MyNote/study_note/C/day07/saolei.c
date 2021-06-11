#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main()
{
	int map[10][10]={};
	int i=0,j=0,row=0,col=0;
	int delta[8][2]={-1,-1,-1,0,-1,1,0,-1,0,1,1,-1,1,0,1,1};
	int count=0;
	srand(time(0));
	//获得十个地雷的坐标
	for(i=0;i<10;i++)
	{
biaoqian:	row=rand()%10;
			col=rand()%10;
			if(!map[row][col])
				map[row][col]=-1;
			else
				goto biaoqian;
	}
	//将每个地雷周围的8个位置处理一遍
	for(row=0;row<=9;row++)
		for(col=0;col<=9;col++)
		{
			if(map[row][col]!=-1)
				continue;
			for(i=0;i<8;i++)
			{
				int newrow=row+delta[i][0];
				int newcol=col+delta[i][1];
				if(newrow>=0&&newrow<=9&&newcol>=0&&newcol<=9)
				{
					if(map[newrow][newcol]!=-1)
						map[newrow][newcol]++;
				}
			}

		}
	//打印出图
	for(i=0;i<10;i++)
	{
		for(j=0;j<10;j++)
			if(map[i][j]==-1) 
				printf("X ");
			else if(map[i][j]>0)
				printf("%d ",map[i][j]);
			else printf("* ");
		printf("\n");
	}
	return 0;
}
