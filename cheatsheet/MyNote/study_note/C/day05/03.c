#include<stdio.h>
int main()
{
	for(int chicken=0;chicken<=40;chicken++)
		for(int rabit=40-chicken;;)
		{
			if(2*chicken+4*rabit==100)
				printf("有%d个兔子\n",rabit);
			break;
		}
	return 0;
}
