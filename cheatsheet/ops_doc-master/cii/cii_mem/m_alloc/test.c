#include <stdio.h>
#include "m_alloc.h"

int malloc_size[] = {
	1,10,100,1000,10000,100000,1024,8199
};

char * free_poll[10];

int main(int argc, char * argv)
{
	struct mem_tail request_mem;
	char * mem_addr_1;
	char * mem_addr_2;
	int i;
	int j;

	m_init("m_alloc_test");
	for (i=0; i< 10000000; i++)
	{
		mem_addr_1 = m_alloc(128000, &request_mem);
		printf("offset: %d\n", request_mem.addr_offset);
	}
	m_free(mem_addr_1);
	return 0;
}

