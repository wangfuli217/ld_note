#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

class A {
public:
    A() {}
    ~A() {}
};

class A1 {
public:
    A1() {}
    ~A1() {}
private:
    int i;
};

class A2 {
public:

    A2() {}
    ~A2() {}
public:
    int get_i() { return i; }
private:
    int i;
};

int main(int argc, char **argv)
{
	printf("sizeof A: %zu\n", sizeof(A));
    printf("sizeof A1: %zu\n", sizeof(A1));
    printf("sizeof A2: %zu\n", sizeof(A2));
    
    system("pause");
    
	return 0;
}
