#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <stdint.h>

#define CHAR_BITS sizeof(unsigned char) * 8 
#define BUFFER_SIZE CHAR_BITS + 1

void bprintf(const unsigned char i)
{
	char buffer[BUFFER_SIZE] = {0};
	unsigned char temp = i;

	for(int j = 0; j < CHAR_BITS; j++) {
		if (temp & 0x1) {
			buffer[CHAR_BITS -1 - j] = '1';	
		} else {
			buffer[CHAR_BITS -1 - j] = '0';
		}
		
		temp >>= 1;
	}

	printf("binary: %s\n", buffer);
}

unsigned char ReverseBitsInByte(unsigned char v)
{
    return (v * 0x0202020202ULL & 0x010884422010ULL) % 1023;
}

unsigned char ReverseBitsObvious(unsigned char v)
{
    unsigned char r = v;
    int s = sizeof(v) * CHAR_BIT - 1;
    for (v >>= 1; v; v >>= 1) {
        r <<= 1; r |= v & 1; s--;
    }
    return r << s;
}


#define R2(n)     n,     n + 2*64,     n + 1*64,     n + 3*64
#define R4(n) R2(n), R2(n + 2*16), R2(n + 1*16), R2(n + 3*16)
#define R6(n) R4(n), R4(n + 2*4 ), R4(n + 1*4 ), R4(n + 3*4 )

static const unsigned char BitReverseTable256[256] =
{
    R6(0), R6(2), R6(1), R6(3)
};

unsigned char ReverseBitsLookupTable(unsigned char v)
{
    return BitReverseTable256[v];
}


unsigned char ReverseBits4ops64bit(unsigned char v)
{
    return ((v * 0x80200802ULL) & 0x0884422110ULL) * 0x0101010101ULL >> 32;
}

unsigned char ReverseBits7ops32bit(unsigned char v)
{
    return ((v * 0x0802LU & 0x22110LU) | 
            (v * 0x8020LU & 0x88440LU)) * 0x10101LU >> 16;
}

unsigned char ReverseBits5logNOps(unsigned char v)
{
    v = ((v >> 1) & 0x55) | ((v & 0x55) << 1);
    v = ((v >> 2) & 0x33) | ((v & 0x33) << 2);
    v = ((v >> 4) & 0x0F) | ((v & 0x0F) << 4);
    return v;
}


unsigned char ReverseBitsRBIT(unsigned char v)
{
	uint32_t input = v;
	uint32_t output;
	__asm__("rbit %0, %1\n" : "=r"(output) : "r"(input));
	return output >> 24;
}

int main(int argc, char **argv)
{
	bprintf(ReverseBitsInByte(1));
	bprintf(ReverseBitsObvious(1));
	bprintf(ReverseBitsLookupTable(1));
	bprintf(ReverseBits4ops64bit(1));
	bprintf(ReverseBits7ops32bit(1));
	bprintf(ReverseBits5logNOps(1));
	
	int i = 99;
	
	
	
	system("pause");
	
	return 0;
}

//http://corner.squareup.com/2013/07/reversing-bits-on-arm.html

/*	ReverseBitsLookupTable... 10.058261ns per function call
    ReverseBitsRBIT...        10.123462ns per function call
    ReverseBits7ops32bit...   17.453080ns per function call
    ReverseBits5logNOps...    20.054218ns per function call
    ReverseBits4ops64bit...   21.203815ns per function call
    ReverseBitsObvious...     65.809257ns per function call
    ReverseBits3ops64bit...  509.621657ns per function call*/
