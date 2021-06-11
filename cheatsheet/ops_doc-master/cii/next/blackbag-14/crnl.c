#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char **argv) { 
	int c = 0;
	int lst = 0;

	while((c = getc(stdin)) != EOF) { 
		if(c == '\r') { 
			if(!lst) { 
				putc('\r', stdout);
				putc('\n', stdout);
				lst = 1;
			}
		} else if(c == '\n') { 
			if(!lst) { 
				putc('\r', stdout);
				putc('\n', stdout);			
				lst = 1;
			}
		} else {
			lst = 0;
			putc(c, stdout);
		}
	}

	exit(0);
}
