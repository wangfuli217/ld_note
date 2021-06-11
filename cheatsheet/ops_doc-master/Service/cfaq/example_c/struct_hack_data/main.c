#include <stdio.h>

#include "def.h"

int main(int argc, char **argv)
{
	slot_list_t *stl = NULL;
	
	__NEW_SLOT_LIST__(stl, 10, 3);
	printf("loop...\n");
	printf("slot list size: %u\n", stl->ssz);
	
	for (unsigned int idx = 0; idx < stl->ssz; idx++) {
		printf("node[%p] size: %u p: %p\n", *(stl->slots + idx), (*(stl->slots + idx))->ssz, (*(stl->slots + idx))->nodes);
	}
	
	return 0;
}
