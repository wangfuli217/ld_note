#include <stdio.h>

void 
print_pointer(const char* p1, const char* p2) 
__attribute__((nonnull(1, 2))) __attribute__((nothrow));

int main(int argc, char **argv)
{
	print_pointer(NULL, NULL);
	
	return 0;
}

void 
print_pointer(const char* p1, const char* p2) 
{
	
}
