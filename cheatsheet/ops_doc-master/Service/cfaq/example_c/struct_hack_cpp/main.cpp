#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <new>

typedef struct {
	int a;
	char b[]; // char b[0] 也可以
}StructHack_t;

int main(int argc, char **argv)
{
	StructHack_t* p = static_cast<StructHack_t*>(operator new(sizeof(StructHack_t) + sizeof(char) * 10));
	
	strcpy(p->b, "hello");
	
	printf("StructHack_t: %d\n", sizeof(StructHack_t));
	printf("B: %s\n", p->b);
	printf("P-Size: %d\n", sizeof(*p));
	
	system("pause");
	
	return 0;
}
