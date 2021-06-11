#include<stdio.h>
int main()
{
	int one=0,two=0,five=0;
	for(one=0;one<=10;one++)
		for(two=0;two<=5;two++)
			for(five=0;five<=2;five++)
				if(one+two*2+five*5==10)
					printf("%d个1元,%d个2元,%d个5元\n",one,two,five);
	return 0;
}
