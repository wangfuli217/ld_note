#include <stdio.h>
#include <stdlib.h>

char*
my_strcpy(char* dest, const char* src)
{
    while ((*dest++ = *src++)) {
        printf("d: %c\n", *dest);
    }
    
    return dest;
}


int main(int argc, char **argv)
{
	char src = "hello";
    char dest[10] = {0};
    
    my_strcpy(dest, src);
    
    printf("DEST: %s\n", dest);
    
    system("pause");
	return 0;
}
