#include<stdio.h>
#include<unistd.h>
int main(){
	char s[] = "zhang    zhao    feng    ";
	int j=0,i=0;
	while(1){
		for(i=0;i<25;i++)
		{
			printf("%c",s[j++%25]);
			fflush(stdout);
		}
		j++;
		j%=25;
		printf("\r");
		usleep(200000);
	}
	return 0;
}
