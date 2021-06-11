#include<stdio.h>
int main()
{
	char s[10];
	fgets(s,10,stdin);
//	scanf("%*[^\n]");   //第一句
//	scanf("%*c");		//第二句
	scanf("%*[^\n]%*c"); //第三句
	getchar();
	printf("end\n");
	return 0;
}
