#include<stdio.h>
#define MAX 1000
int main(void)
{
	int ss[1001]={},s[500]={};
	int i=0,j=0,m=0;
	for(i=2;i<1001;i++)
	{
		if(!ss[i])  s[m++]=i;
		for(j=0;j<m&&s[j]*i<=1000;j++)
		{
			ss[s[j]*i]=1;
			if(i%s[j]==0)
				break;
		}
	}
	for(i=0;i<m;i++)
		printf("%d ",s[i]);
	printf("%d\n",m);
	return 0;
}
