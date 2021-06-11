#include <stdio.h>
#include <stdlib.h>
#include "xp.h"

int main(void)
{
	
	char mul_1[1] = {22};
	char mul_2[1] = {43};
	char *res = calloc(1,1);
	char ch;
	
	XP_mul(res,1,(Xp)mul_1,1,(Xp)mul_2);
	ch = *res;
	
	printf("%c%c%c\n",(ch/100) + '0', (ch%100/10) + '0', (ch%10)+'0');
	
	return 0;
}

