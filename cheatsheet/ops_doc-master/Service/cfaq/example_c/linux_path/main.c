#include <stdio.h>
#include <libgen.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	char path[] = "/usr/local/lib/libjemalloc.so";
	
	printf("dirname: %s\n", dirname(path));
	printf("basename: %s\n", basename(path));
	
	system("pause");
	
	return 0;
}
