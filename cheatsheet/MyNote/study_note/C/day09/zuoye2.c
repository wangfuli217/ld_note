#include<stdio.h>
int main()
{
	int a[10]={1,2,3,4,5,6,7,8,9,10},*p_head=a,*p_tail=a+9;
	int tmp=0;
	for(;p_tail-p_head>=1;p_head++,p_tail--)
	{
		tmp=*p_head;
		*p_head=*p_tail;
		*p_tail=tmp;
	}
	for(p_head=a,p_tail=a+10;p_head!=p_tail;p_head++)
		printf("%d ",*p_head);
	printf("\n");
	return 0;
}
