#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char*
strcpy3(char *dest, const char *src) 
{
	const char *end = src;
	char *p = dest;
	
	while (*end) {
		end++;
	}
	
	end++;
	
	printf("sub: %d\n", end - src);
	
	while ((long *)src + 1 <= (long *)end) {
		*(long *)dest++ = *(long *)src++;
	}
		
	while (src <= end) {
		*dest++ = *src++;
	}

	return p;
}

char *
strcpy4(char* dest, const char* src) 
{
	const char *end = src;
	char *p = dest;
	
	while (*end++);
	
	printf("sub: %d\n", end - src);
	
	while ((long *)src + 1 <= (long *)end) { //每次复制8个字节
		*(long *)dest++ = *(long *)src++;
	}
		
	while (*dest++ = *src++); //复制不是8个字节倍数的部分
	
	*(dest + 1) = 0;

	return p;
}

int main(int argc, char **argv)
{
	char* src = "hello world";
	char dest[100] = {0};
	
	strcpy3(dest, src);
	printf("dest: %s\n", dest);
	memset(dest, 0, sizeof dest);
	
	strcpy4(dest, src);
	printf("dest: %s\n", dest);
	
	system("pause");
	return 0;
}
