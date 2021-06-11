#include <stdio.h>
#include <stdlib.h>

int main()
{
    int size;
    char *dynamic;
    char input[10];
    printf("Please enter size of array: ");
    size = atoi(fgets(input, 7, stdin));
    dynamic = (char *)malloc(size);
    dynamic[0] = 'a';
    dynamic[size - 1] = 'z';
    printf("dynamic[0]:%c dynamic[%d]:%c",dynamic[0],(size-1),dynamic[size-1]);
    free(dynamic);

}
