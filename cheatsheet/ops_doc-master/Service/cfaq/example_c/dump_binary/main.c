#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#ifndef PRINT_1
#define PRINT_1 printf("1")
#endif 
#ifndef PRINT_0
#define PRINT_0 printf("0")
#endif

#ifndef PRINT_SPACE
#define PRINT_SPACE printf(" ")
#endif

#ifndef PRINT_LF
#define PRINT_LF printf("\n")
#endif


static inline
void dump_binary(const char* b, unsigned int l) 
{
	for (unsigned int i = 0; i < l; i++) {
		for (unsigned int j = 0; j < 8; j++) {
			if ((*(b + i) << j) & 0x80 ) {
				PRINT_1;
			} else {
				PRINT_0;
			}
		}
		
		PRINT_SPACE;
	}
	
	PRINT_LF;
}


int main(int argc, char *argv[])
{
	char a[] = "123456";

	dump_binary(a, 6);
	
	
	system("pause");
	
	return 0;
}
