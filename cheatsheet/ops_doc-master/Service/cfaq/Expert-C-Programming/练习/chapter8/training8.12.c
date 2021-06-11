#include <stdio.h>
extern int printf(const char*, ...);
void *f = (void*)printf;

int main()
{
    (*(int(*)(const char*, ...))f)("Bite my shorts.Also my chars and ints\n");
}
