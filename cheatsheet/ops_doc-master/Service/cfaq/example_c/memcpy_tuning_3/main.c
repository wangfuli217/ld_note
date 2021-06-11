#include <stdio.h>
#include <stdint.h>

#define cast(t, v) 			(t)(v)
#define cast_int(v) 		(int)(v)
#define cast_uint64(v) 		(uint64_t)(v)

#define ZBYTE_TO_UINT64(p)	(*(uint64_t*)(p))

#define ZEN_TEST_FAST_COPY(dst,src,sz)  {						\
    char *_cpy_dst = dst; 										\
    const  char *_cpy_src = src; 								\
    size_t _cpy_size = sz;										\
    do 															\
	{ 															\
		ZBYTE_TO_UINT64(_cpy_dst) = ZBYTE_TO_UINT64(_cpy_src); 	\
		_cpy_dst += sizeof(uint64_t); 							\
		_cpy_src += sizeof(uint64_t); 							\
	}while( _cpy_size > sizeof(uint64_t) && (_cpy_size -= sizeof(uint64_t))); \
}



int main(int argc, char **argv)
{
	char* src1 = "hello world";
	char dest[10] = {0};
	
	printf("len: %d\n", strlen(dest));
	
	ZEN_TEST_FAST_COPY(dest, src1, strlen(dest));
	
	printf("len: %d\n", strlen(dest));
	printf("Dest: %s\n", dest);
	
	system("pause");
	
	return 0;
}
