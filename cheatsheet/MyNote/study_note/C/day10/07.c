#include<stdio.h>
int strlen(const char *str)
{
	int i=0;
	for(i=0;*(str+i)!='\0';i++);
	return i;
}
int main()
{
	//char arr[]="1234slkdf";
	printf("%d\n",strlen("abcdefl"));
	return 0;
}
