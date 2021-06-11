#include<stdio.h>
void print(const int *p_num)
{
	int i=0;
	for(i=0;i<10;i++)
		printf("%d ",*(p_num+i));
	printf("\n");
}
int main()
{
	int a[10]={1,2,3,4,5,6,7,8,9,10};
	print( a);
	return  0;
}
