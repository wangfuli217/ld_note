#include <stdio.h>
#include <stdlib.h>

#define ALIAS(n) __attribute__((alias(#n)))

void
show()
{
    printf("%s%s", __func__, __FILE__);
}

void ALIAS(show) 
show_a();

int main(int argc, char **argv)
{
   
    show_a();
    
    system("pause");
	return 0;
}
