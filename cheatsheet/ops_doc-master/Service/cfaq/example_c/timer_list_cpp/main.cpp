#include "timer.h"
#include <stdio.h>
#include <stdlib.h>

static void
handle_timeout(void* data)
{
	printf("data: %d\n", *(int*)data);
}

int 
main(int argc, char **argv)
{
	for (int i = 0; i < 10; i++) {
		timer_start(1, handle_timeout, &i, sizeof i);
	}
	
	while(1) {
		timer_run();
	}
	
	//timer_run();
	
	system("pause");
	
	return 0;
}
