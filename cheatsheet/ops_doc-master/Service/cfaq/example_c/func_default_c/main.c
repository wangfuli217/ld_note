#include <stdio.h>
#include <stdlib.h>

static void
func(unsigned int i = 100);

int main()
{
    printf("Hello world!\n");
    return 0;
}

void
func(unsigned int i)
{
    i = 100;
}
