#include <stdio.h>
#include "message.h"

int 
main(int argc, char **argv)
{
	message_init((message_map_t**)&::messages);
	
	return 0;
}
