#include<stdio.h>
void HanNuoTa(int num,char begin,char middle,char end)
{
	if(num==1) 
	{
		printf("%d:%c --> %c\n",num,begin,end);
		return;
	}
	HanNuoTa(num-1,begin,end,middle);
	printf("%d:%c --> %c\n",num,begin,end);
	HanNuoTa(num-1,middle,begin,end);
}
int main()
{
	int num=0;
	printf("请输入盘子的个数:");
	scanf("%d",&num);
	HanNuoTa(num,'A','B','C');
	return 0;
}
