#include <stdio.h>
#include <stdlib.h>

struct A {
    int i;
} __attribute__((aligned(1)));

struct B {
    struct A a;
};

int main() {
    struct B b;

    printf("size: %d\n", sizeof b);

    return 0;
}
