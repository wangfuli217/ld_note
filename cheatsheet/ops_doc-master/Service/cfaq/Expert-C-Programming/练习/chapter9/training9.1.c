#include <stdio.h>
#include <string.h>

int main()
{
    char my_array[10];
    char *my_ptr;
    my_ptr = my_array;
    strcpy(my_array, "hello");
    printf("%s %s",my_ptr,my_array);
    return 0;
}
