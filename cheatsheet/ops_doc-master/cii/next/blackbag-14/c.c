#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int 
main(int argc, char **argv) {
	int rep = 1,
	    i = 0, 
	    s = 0;


	if(argv[1] && argv[2]) {	
		rep = strtoul(argv[1], NULL, 0);
	
		for(i = 0; i < rep; i++) 
			fwrite(argv[2], s ? s : (s = strlen(argv[2])), 1, stdout);
	
	} else {
		fprintf(stderr, "c 100 A ; # print 100 A's\n");
	}

	exit(0);
}
