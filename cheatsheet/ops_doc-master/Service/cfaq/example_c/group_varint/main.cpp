#include <stdio.h>
#include <stdlib.h>
#include "gvarint.h"

int
main(int argc, char* argv[])
{
	uint32_t i, r;
	
	i = 300;
	r = 0;
	
	char buff[32] = {0};
	
	group_varint_encode_uint32(&i, (uint8_t*)buff);
	
	group_varint_decode_uint32((uint8_t*)buff, &r);
	
	printf("r: %lu\n", r);
	
	
	system("pause");
	
	return 0;
}