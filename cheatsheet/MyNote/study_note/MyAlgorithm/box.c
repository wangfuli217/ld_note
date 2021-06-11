#include<stdio.h>
#include<stdlib.h>
#include<time.h>

int main()
{
	int px,py; //人的坐标
	int bx,by; //箱子的坐标
	int i,j;
	int direction; //移动方向
	srand(time(0));
	bx = rand() % 8 + 1;
	by = rand() % 8 + 1;
	while(1)
	{
		px = rand() % 10;
		py = rand() % 10;
		if(px!=bx || py!=by)
				break;
	}
	for(i=0;i<10;i++)
			for(j=0;j<10;j++){
					if(i==px&&j==py)
							printf("O");
					else if(i==bx&&j==by)
							printf("X");
					else
							printf("*");
					if(j==9)
							printf("\n");
	}
	while(1){
	printf("请输入人的移动方向:1左，2下，3上，4右:");
	scanf("%d",&direction);
	if(1==direction)
	{
	    if(px==bx&&py-by==1&&by!=0)
		{
				py-=1;
				by-=1;
		}
		else if(py>0)
		{
				if(px==bx&&py-by==1&&by==0);
				else
				py-=1;
				}
	}
	else if(2==direction)
	{
	    if(by==py&&bx-px==1&&bx!=9)
		{
				bx+=1;
				px+=1;
		}
		else if(px<9)
		{
				if(by==py&&bx-px==1&&bx==9);
				else
				px+=1;
		}
	}
	else if(3==direction)
	{
		if(py==by&&px-bx==1&&bx!=0)
		{
				bx-=1;
				px-=1;
		}
		else if(px>0)
		{
				if(py==by&&px-bx==1&&bx==0);
				else
				px-=1;
		}
	}
	else if(4==direction)
	{
			if(px==bx&&by-py==1&&by!=9)
			{
					by+=1;
					py+=1;
			}
			else if(py<9)
			{
					if(px==bx&&by-py==1&&by==9);
					else
					py+=1;
			}
	}
	else 
			printf("您的输入有误！\n");
	for(i=0;i<10;i++)
			for(j=0;j<10;j++)
			{
					if(i==px&&j==py)
							printf("O");
					else if(i==bx&&j==by)
							printf("X");
					else
							printf("*");
					if(9==j)
							printf("\n");
			}
	if(bx==0&&by==9)
	{
			printf("你赢了\n");
			break;
	}
	printf("\n");
}
return 0;
}
	
	
