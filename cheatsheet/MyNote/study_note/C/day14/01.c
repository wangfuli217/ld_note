/*
   回调函数演示
   */
#include<stdio.h>
#include<stdlib.h>
enum {LARGER,EQUAL,LESS};
int compare(const int *p_num,const int *p_num1)
{
	if(*p_num>*p_num1)
		return LARGER;
	else if(*p_num==*p_num1)
		return EQUAL;
	else
		return LESS;
}
int compare1(const int *p_num,const int *p_num1)
{
	return 2-compare(p_num,p_num1);
}
int compare2(const void *p_num,const void *p_num1)
{
	return *(int *)p_num>*(int *)p_num1;
}
void bubble(int *p_num,int size,int (*p_compare)(const int*,const int*))
{
	int num=0,num1=0;
	int tmp=0;
	for(num=0;num<size-1;num++)   //冒泡排序
		for(num1=0;num1<size-1-num;num1++)
			if(compare(p_num+num1,p_num+num1+1)==LARGER)
			{
				tmp=*(p_num+num1);
				*(p_num+num1)=*(p_num+num1+1);
				*(p_num+num1+1)=tmp;
			}
}
int main()
{
	int arr[]={4,2,8,3,1,3,7};
	int num=0,num1=0;
	int tmp=0;
/*	for(num=0;num<6;num++)   //选择排序
		for(num1=num+1;num1<7;num1++)
			if(arr[num]>arr[num1])
			{
				tmp=arr[num];
				arr[num]=arr[num1];
				arr[num1]=tmp;
			}*/
/*	bubble(arr,7,compare);*/
	qsort(arr,7,sizeof(arr[0]),compare2);
	for(num=0;num<7;num++)
		printf("%d ",arr[num]);
	printf("\n");
	return 0;
}
