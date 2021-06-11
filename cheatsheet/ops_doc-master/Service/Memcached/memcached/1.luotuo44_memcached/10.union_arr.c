#include <stdio.h>
union {  
	int cas;  
	char end;  
} data[10];  
int main(int argc, const char *argv[])
{
	data[0].cas = 123;
	data[1].end ='a';
	return 0;
}
