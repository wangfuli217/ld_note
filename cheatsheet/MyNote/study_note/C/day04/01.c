#include<stdio.h>
int main()
{
	int gender=0,height=0,weight=0;
	printf("请输入性别(0是女，1是男)，身高(cm)和体重（kg):");
	scanf("%d%d%d",&gender,&height,&weight);
	if(gender&&height-weight<105)
		printf("超重的男人\n");
	else if(!gender&&height-weight<110)
		printf("超重的女人\n");
	else
		printf("不超重的\n");
	return 0;
}
