#include <stdio.h>
#include <stdlib.h>

int main(void)
{

    printf("Compiled: " __DATE__ " at " __TIME__ "\n");
    printf("This is line %d of file %s\n", __LINE__, __FILE__);
	printf("-GCC VERSION  : %s\n",__VERSION__);
    printf("hello world\n");
    exit(0);
}
