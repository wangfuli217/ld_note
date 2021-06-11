#include<stdio.h>
#include<stdlib.h>
int main(void)
{
	FILE *pf=fopen("a.txt","wb");
	if(pf==NULL)
		perror("fopen"),exit(-1);
	int i=0;
	for(i=1;i<=1000000;i++)
		fwrite(&i,sizeof(int),1,pf);
	fclose(pf);
	return 0;
}
