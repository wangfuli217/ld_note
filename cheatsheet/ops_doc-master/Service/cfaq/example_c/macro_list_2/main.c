#include <stdio.h>

#define WRITE(type, param) 	\
	int message_write_##type(char* m, type param)
#define READ(type) \
	type message_read_##type(char* m) 

WRITE(int, i);

#define CASE_VALUE(v) case v: \
    printf(#v"\n");           \
    break;

#define SWITCH(v) switch(v) {   \
    CASE_VALUE(1)               \
    CASE_VALUE(2)               \
    CASE_VALUE(3)


int main(int argc, char **argv)
{
	printf("hello world\n");
    
    int ii = 1;
    
    SWITCH(ii) default: break; }
	
	int i = 0;

	return 0;
}
