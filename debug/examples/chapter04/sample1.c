#include <stdlib.h>

void func()
{
    int *p = (int*)malloc(sizeof(int)*10);
    p[10]=10;
}

int main(int argc, int *argv[])
{
    func();
    return 0;
}