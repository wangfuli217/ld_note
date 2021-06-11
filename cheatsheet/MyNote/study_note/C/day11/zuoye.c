#include<stdio.h>
#define ATOC(c) (c)=((c)>='A'&&(c)<='Z'?(c)+'a'-'A':(c)-'a'+'A')
int main()
{
	char ch=0;
	printf("请输入一个字符:");
	scanf("%c",&ch);
	ATOC(ch);
	printf("%c\n",ch);
	return 0;
}
