#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
	char aa[] = "hello world";
	strtok(aa, " ");
	printf("aa: %s\n", aa);
	return 0;
}
