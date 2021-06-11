#include "mempool.h"
#include <stdio.h>
#include <string.h>

// see mempool.h for the license on this
// mempool demo

void
demoset1() 
{
	printf("Running demoset1\n");
	mempool *mp1 = mempool_create();
	char *str1 = (char *) mempool_malloc(mp1, 128);
	char *str2 = (char *) mempool_malloc(mp1, 128);
	char *str3 = (char *) mempool_malloc(mp1, 128);
	sprintf(str1, "Testing the allocation %d\n", 1);
	sprintf(str2, "Testing the allocation %d\n", 2);
	sprintf(str3, "Testing the allocation %d\n", 3);

	mempool_free(mp1, str2);

	printf("Message in the buffer is: %s", str1);
	printf("Message in the buffer is: %s", str3);

	mempool_clean(mp1);
	free(mp1);
}
 
void
demoset2() 
{
	printf("Running demoset2\n");
	mempool *mp1 = mempool_create();
	mempool *mp2 = mempool_create();
	void *m = mempool_malloc(mp1, 1);
	// this should assert
	m = mempool_realloc(mp1, m, 1024);
	sprintf(m, "Hello world, this dont fit in small strings\n");
	mempool_clean(mp1);
	mempool_clean(mp2);
	free(mp1);
	free(mp2);
}

int
main(int argc, char **argv) 
{
	printf("Hello world!\n");

	demoset1();
	demoset2();

	printf("Bye world!\n");
	
	system("pause");
	
	return 0;
}
