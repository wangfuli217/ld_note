#include <stdio.h>
#include <stdlib.h>

namespace macro {
#define __LOG__(fmt, ...) printf(fmt, ##__VA_ARGS__)    
}


int main(int argc, char **argv)
{
	
    __LOG__("hello world\n");
    
    system("pause");
    
	return 0;
}
