#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int 
is_number(const char* str)
{
	int sz;
	
	if (str == NULL) return -1;
	
	sz = strlen(str);
	
	for (int i = 0; i < sz; i++) {
		if (*(str + i) >= '0' && *(str + i) <= '9') {
			continue;
		} else {
			return -1;
		}
	}
	
	return 0;
}


int 
main(int argc, char **argv)
{
	char temp[] = "232323232a3";
	
	printf("is_number: %d\n", is_number(temp));
	
	system("pause");
	return 0;
}
