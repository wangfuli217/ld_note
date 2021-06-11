#include<stdio.h>
void showmap(int map[17][17])
{
	char ch[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
	int i=0,j=0;
	for(i=0;i<17;i++)
		for(j=0;j<17;j++)
		{
			if(i==0&&j==0) printf(" ");
			else if(i==0) printf("%c",ch[j-1]);
			else if(j==0) printf("%c",ch[i-1]);
			else if(map[i-1][j-1]==1) printf("O");
			else if(map[i-1][j-1]==2) printf("X");
			else printf("*");
			if(j==16) printf("\n");
			else printf(" ");
		}
}
void getrc(char *row,char *col)
{
	int i=0;
	char c=0;
	while(i<2)
	{
		c=getchar();
		if(c==' '||c=='\n') continue;
		i++;
		if(i==1) *row=c;
		if(i==2) *col=c;
	}
	if(*row>=65)  *row-=55;
	if(*col>=65)  *col-=55;
	if(*row>='0'&&*row<='9') *row-='0';
	if(*col>='0'&&*row<='9') *col-='0';
}
int isw(int map[17][17])
{
	int i=0,j=0;
	for(i=1;i<17;i++)
		for(j=1;j<17;j++)
		{
			if(j<=12)
			{
				if((map[i][j]==1||map[i][j]==2)&&map[i][j]==map[i][j+1]&&map[i][j]==map[i][j+2]&&map[i][j]==map[i][j+3]&&map[i][j]==map[i][j+4]) 
					return 1;
			}
			if(i<=12)
			{
				if((map[i][j]==1||map[i][j]==2)&&map[i][j]==map[i+1][j]&&map[i][j]==map[i+2][j]&&map[i][j]==map[i+3][j]&&map[i][j]==map[i+4][j])
					return 1;
			}
			if((map[i][j]==1||map[i][j]==2)&&map[i][j]==map[i+1][j+1]&&map[i][j]==map[i+2][j+2]&&map[i][j]==map[i+3][j+3]&&map[i][j]==map[i+4][j+4])
				return 1;
			if((map[i][j]==1||map[i][j]==2)&&map[i][j]==map[i-1][j-1]&&map[i][j]==map[i-2][j-2]&&map[i][j]==map[i-3][j-3]&&map[i][j]==map[i-4][j-4])
				return 1;
		}
	return 0;
}
int main()
{
	int map[17][17]={{0}};
	char row=0,col=0; //玩家落子位置
	while(1)
	{
		showmap(map);
		if(isw(map))
		{
			printf("玩家二胜利\n");
			break;
		}
		printf("请玩家一落子：");
		while(1)
		{
			getrc(&row,&col);
			if(map[row][col]==0) break;
			else printf("输入的位置处已有棋子,请重新输入\n");
		}
		map[row][col]=1;
		showmap(map);
		if(isw(map))  
		{
			printf("玩家一胜利\n");
			break;
		}
		printf("请玩家二落子：");
		while(1)
		{
			getrc(&row,&col);
			if(map[row][col]==0) break;
			else printf("输入的位置处已有棋子,请重新输入\n");
		}
		map[row][col]=2;
	}
	return 0;
}
