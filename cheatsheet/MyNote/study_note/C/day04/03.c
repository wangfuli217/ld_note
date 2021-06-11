#include<stdio.h>
int main()
{
	int season=0;
	printf("请输入代表季节的数字:");
	scanf("%d",&season);
	switch(season)
	{
		case 0 : printf("春天\n");break;
		case 1 : printf("夏天\n");break;
		case 2 : printf("秋天\n");break;
		case 3 : printf("冬天\n");break;
		default: printf("不认识的数字\n");break;
	}
	return 0;
}
