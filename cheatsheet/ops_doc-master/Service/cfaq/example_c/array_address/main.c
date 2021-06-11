#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	char temp[10] = {0};
    
    printf("addr of temp: %p\n", temp);
    printf("addr of &temp: %p\n", &temp);
    printf("addr of &temp[0]: %p\n", &temp[0]);
    
    
    system("pause");
	return 0;
}
