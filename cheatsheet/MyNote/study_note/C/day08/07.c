#include<stdio.h>
void DiGui(int num)
{
	if(!num)  return;
	printf("%d ",num);
	DiGui(num-1);
}
int main()
{
	int num=0;
	scanf("%d",&num);
	DiGui(num);
	printf("\n");
	return 0;
}
