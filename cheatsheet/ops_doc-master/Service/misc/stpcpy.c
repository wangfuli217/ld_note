
#define _GNU_SOURCE
#include <string.h>
#include <stdio.h>

int
main(void)
{
    char buffer[20];
    char *to = buffer;

    to = stpcpy(to, "foo");
    to = stpcpy(to, "bar");
    printf("%s\n", buffer);
}
