#include  "lja_hash_func.h"

unsigned long lja_hash_scatt(const char *str, int len, unsigned long size)
{
	int i;
	unsigned long index = 0;
	for(i=0; i<len; i++){
		index = (index << 1) + lja_scatt[(unsigned char)str[i]];
	}
	return index & (size-1);
}
