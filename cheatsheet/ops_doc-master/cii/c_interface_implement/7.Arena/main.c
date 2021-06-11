#include <stdio.h>
#include "arena.h"

int main(void)
{
	struct Arena_T *arena = Arena_new();
	
	char *p1 = (char *)Arena_alloc(arena,1,__FILE__,__LINE__);
	char *p2 = (char *)Arena_alloc(arena,1,__FILE__,__LINE__);
	char *p3 = (char *)Arena_alloc(arena,1,__FILE__,__LINE__);
	
	printf("0x%x\n",p1);
	printf("0x%x\n",p2);
	printf("0x%x\n",p3);
	
	Arena_dispose(&arena);
	
	return 0;
}

