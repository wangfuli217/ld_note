#include<stdio.h>
/*int arr[100]={0};
int Fb(int num)
{
	if(num==0||num==1) 
	{
		return 1;
	}
	if(!arr[num-2])
		arr[num-2]=Fb(num-2);
	if(!arr[num-1])
		arr[num-1]=Fb(num-1);
	return arr[num-2]+arr[num-1];
}*/
int main()
{
	int num=0;
	int num1=1,num2=1;
	int i=0;
	scanf("%d",&num);
	for(i=2;i<=num;i++)
	{
		num2+=num1;
		num1=num2-num1;
	}
	printf("%d\n",num2);
	return 0;
}
