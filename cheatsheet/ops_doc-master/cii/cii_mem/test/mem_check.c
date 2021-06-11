#include <tools-util.h>

int main()
{
	char * addr = malloc(0);
	int len = 4;
	int i;

	TIME_SPEND(lambda(void, (int loop){ \
		for (i=0; i< loop; i++)\
		{\
			check_mem(addr, len, MEM_TYPE_WRITE | MEM_TYPE_HEAP);\
		}\
	})(100000));
	
	return 0;
}
