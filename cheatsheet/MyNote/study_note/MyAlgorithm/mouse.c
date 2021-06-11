/*
   打老鼠
   */
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main()
{
	int count=0,count1=0; //打老鼠的次数,当前已错过的次数
	int row=0,col=0;  //锤子的坐标
	int row1=0,col1=0;//老鼠的坐标
	int i=0,j=0;  
	srand(time(0));
	printf("请输入打老鼠的次数:");
	scanf("%d",&count);
	while(count1<count)
	{
		row1=rand()%3+1; //获取老鼠的坐标
		col1=rand()%3+1;
		count1++; //计数已错过的次数
		printf("请输入锤子的坐标:");
		scanf("%d%d",&row,&col);
		if(row==row1&&col==col1)
		{
			for(i=1;i<4;i++)
				for(j=1;j<4;j++)
				{
					if(i==row&&j==col)
						printf("O");
					else
						printf("*");
					if(j==3)
						printf("\n");
				}
			printf("打中了!错过%d次\n",count1-1);
			break;
		}
		else
		{
			for(i=1;i<4;i++)
				for(j=1;j<4;j++)
				{
					if(i==row&&j==col)
						printf("O");
					else if(i==row1&&j==col1)
						printf("X");
					else 
						printf("*");
					if(j==3)
						printf("\n");
				}
			printf("没打中!错过%d次\n",count1);
		}

	}
	return 0;
}
