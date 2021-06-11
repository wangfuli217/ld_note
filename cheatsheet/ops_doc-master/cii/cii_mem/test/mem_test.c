#include <tools-util.h>


int main()
{
	mem_t * mem;
	//char * input = malloc(123);
	char * test_data = malloc(123);
	mem = mem_new_with_pointer(test_data, 11);
	print("mem_type: %x", mem->mem_type);
	//mem_put(mem, input, 123);
	mem_delete(&mem);
	while(1)
	{
		sleep(10);
	}
	return 0;
}
