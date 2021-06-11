:q//进程中的内存区域划分
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int i1=10;				//全局区
int i2=20;				//全局区
int i3;					//BSS段
const int i4=40;			//只读常量区

void fn(int i5)			//栈区
{
	int i6=60;			//栈区
	static int i7=70;	//全局区
	const int i8=80;		//栈区
	int *p1=(int *)malloc(4);	//p1指向堆区,p1本身在栈区
	int *p2=(int *)malloc(4);	//p2指向堆区,p2本身在栈区
	char *str="good";			//str指向只读常量区
	char strs[]="good";		   //strs在栈区
	printf("只读常量区:&i4=%p\n",&i4);
	printf("只读常量区:str=%p\n",str);
	printf("-----------------------\n");
	printf("全局区:&i1=%p\n",&i1);
	printf("全局区:&i2=%p\n",&i2);
	printf("全局区:&i7=%p\n",&i7);
	printf("-----------------------\n");
	printf("BSS段:&i3=%p\n",&i3);
	printf("-----------------------\n");
	printf("堆区:p1=%p\n",p1);
	printf("堆区:p2=%p\n",p2);
	printf("-----------------------\n");
	printf("栈区:&i5=%p\n",&i5);
	printf("栈区:&i6=%p\n",&i6);
	printf("栈区:&i8=%p\n",&i8);
	printf("栈区:strs=%p\n",strs);
}
int main(void)
{
	printf("代码区:fn=%p\n",fn);
	printf("-----------------------\n");
	fn(3);
	return 0;
}
