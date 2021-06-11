#include <stdio.h>
#include <stdint.h>

static char* 
EncodeVarint32(char* dst, uint32_t v) 
{
	// Operate on characters as unsigneds
	unsigned char* ptr = (unsigned char*)dst;
	static const int B = 128;
	if (v < (1<<7)) {
		*(ptr++) = v;
	} else if (v < (1<<14)) {
		*(ptr++) = v | B;
		printf("%x\n", v | B);
		*(ptr++) = v>>7;
		printf("%x\n", v>>7);
	} else if (v < (1<<21)) {
		*(ptr++) = v | B;
		*(ptr++) = (v>>7) | B;
		*(ptr++) = v>>14;
	} else if (v < (1<<28)) {
		*(ptr++) = v | B;
		*(ptr++) = (v>>7) | B;
		*(ptr++) = (v>>14) | B;
		*(ptr++) = v>>21;
	} else {
		*(ptr++) = v | B;
		*(ptr++) = (v>>7) | B;
		*(ptr++) = (v>>14) | B;
		*(ptr++) = (v>>21) | B;
		*(ptr++) = v>>28;
	}
	
	return (char*)ptr;
}

const char* 
GetVarint32PtrFallback(const char* p,
                       const char* limit,
                       uint32_t* value) 
{
	uint32_t result = 0;
	for (uint32_t shift = 0; shift <= 28 && p < limit; shift += 7) {
		uint32_t byte = *((const unsigned char*)p);
		p++;
		if (byte & 128) {
			// More bytes are present
			result |= ((byte & 127) << shift);
		} else {
			result |= (byte << shift);
			*value = result;
			return (const char*)p;
		}
	}
	
	return NULL;
}


inline static const char* 
GetVarint32Ptr(const char* p,
               const char* limit,
               uint32_t* value) 
{
	if (p < limit) {
		uint32_t result = *((const unsigned char*)p);
		if ((result & 128) == 0) {
			*value = result;
			return p + 1;
		}
	}
	
	return GetVarint32PtrFallback(p, limit, value);
}




int 
main(int argc, char **argv)
{
	uint32_t i = 129;
	
	char temp[5] = {0};
	
	EncodeVarint32(temp, i);
	
	for (int j = 0; j < 5; j++) {
		printf("temp[%d]: %d\n", j, temp[j]);
	}
	
	uint32_t r = 0;
	
	GetVarint32Ptr(temp, temp + 1, &r);
	
	printf("r: %u\n", r);
	
	system("pause");
	
	return 0;
}
