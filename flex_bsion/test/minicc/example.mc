#include "stdio.h"

int test(int b) {
    int y = 5;

    while(y >= 0) {
        printf("%d", y);
        y = y - 1;
    }
}

int main() {
    test(5);
}