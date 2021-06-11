#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int main()
{
	char score[50];
	char score1[5];
	float sum=0.f;
	while(1)
	{
		scanf("%s",score1);
		if(atof(score1)<0)
			break;
		sum+=atof(score1);
		sprintf(score1,"%g%c",atof(score1),',');
		strcat(score,score1);
	}
	score[strlen(score)-1]='\0';
	printf("%s\n",score);
	printf("和为:%g\n",sum);
	return 0;
}
