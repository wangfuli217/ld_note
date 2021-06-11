#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void foo(int y) {  
    int *x = new int;  
    printf("y=%d\n", y);  
}  
int main(void) {
    int y;
    int *z = (int*) malloc(8);
    char *q = new char[4];
    char *p = (char*) malloc(4);
    write( 1 /* stdout */, p, 4);
    q[4] = 'x';                 // MAGIC overrun 16     foo(y);
    free(z);
    *z = 100;
    delete p;
    memcpy(q, q+1, 3);
    delete q;
    delete q;   // delete value twice 23 }
}

// g++ -g –o test test.cc
// valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./test