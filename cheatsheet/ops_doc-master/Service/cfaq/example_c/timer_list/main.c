#include "timer.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int 
main(int argc, char **argv)
{
	unsigned long timers[10];
	
	for  (int i = 0; i < 10; i++) {
		//printf("timer: 0x%p\n", timer_start(0, NULL, &i, sizeof i, false));
		timer_start(1, NULL, &i, sizeof i, false);
	}
	
	// while(1) {
		// printf("sleep 1 sec\n");
		// sleep(1);
		// timer_run();
	// }
	
	// for (int i = 0; i < 10; i++) {
		// timer_stop(timers[i]);
	// }
	while (1) {
		timer_run();
	}
	
	//timer_list_del();
	
	system("pause");	
	return 0;
}
