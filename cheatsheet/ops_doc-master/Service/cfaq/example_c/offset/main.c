#include <stdio.h>
#include <stdlib.h>


#define offsetof(type, member)      __builtin_offsetof (type, member)
#define offsetof_1(type, member)    (size_t)&(((type*)(0))->member)
struct A {
    int a;
    int b;
};


int main(int argc, char **argv)
{
	struct A a;
    
    printf("offset: %d\n", offsetof(struct A, b));
    printf("offset: %d\n", offsetof_1(struct A, b));
    system("pause");
	return 0;
}
