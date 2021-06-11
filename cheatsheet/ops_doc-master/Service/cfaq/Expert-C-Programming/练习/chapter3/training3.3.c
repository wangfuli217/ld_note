#include <stdio.h>

typedef struct foo{int coo;char foo;} foo;

int main()
{
    foo foo1;
    struct foo foo2;
    foo1.foo = 10;
    foo2.foo = 10;
    printf("sizeof(foo) = %d\n",sizeof(foo));
    printf("sizeof(foo1.foo) = %d\n",sizeof(foo1.foo));
    printf("sizeof(foo1) = %d\n",sizeof(foo1));
    printf("sizeof(foo2.foo) = %d\n",sizeof(foo2.foo));
    printf("sizeof(foo2) = %d\n",sizeof(foo2));

}
