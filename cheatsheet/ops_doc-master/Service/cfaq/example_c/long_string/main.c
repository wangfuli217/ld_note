#include <stdio.h>

int main(int argc, char **argv)
{
	char str[] = "hello"
				 "world";
				 
	char str2[] = "hello \
				  chenbo";
	
	char str3[] = "helloe " \
				  "chenbo";
	
	printf("str: %s\n", str);
	printf("str2: %s\n", str2);
	printf("str3: %s\n", str3);
	return 0;
}
