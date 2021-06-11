#include "impl.h"
#include <assert.h>

void*
memcpy2(void* dest, const void* src, size_t len)
{
	assert( dest != NULL && src != NULL);
	
	char* to = (char*)dest;
	char* from = (char*)src;

	assert((to > from + len - 1) || ( from > to + len - 1));//判断是否重叠内存区域
	
	for(unsigned int i = 0; i < len; i++)
	{
		*(to + i) = *(from + i); 
	}
	
	return dest;
}

char*
strcpy2(char* dest, const char* src)
{
	assert((dest != NULL) && (src != NULL));
	
	while((*dest++ = *src++) != '\0');
	
	return dest;
}