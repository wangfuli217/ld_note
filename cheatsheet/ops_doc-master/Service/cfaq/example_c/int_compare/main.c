#include <stdio.h>
#include <assert.h>

int 
main(int argc, char **argv)
{
	//assert(-1 < 1U); // fails
	//assert((long)-1 < 1U); //success
	assert((short)-1 < (unsigned short)1U); //success
	assert(-1 < (unsigned long)1U);
}
