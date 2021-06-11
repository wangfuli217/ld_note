#include "firebert.h"
#include "util.h"

int
main(int argc, char **argv) {
	int c = 0;
	int chr = 0;
	int rep = 0xff;	

	while( (c = getopt(argc, argv, "h")) != -1) { 
		switch(c) { 
		case 'h':
		default:
			fmt_eprint("cat | no <chr code> [replacement]\n");
			exit(1);
		}
	}

	argc -= optind;
	argv += optind;

	if(argc) { 
		if(argc > 1) 
			rep = strtoul(argv[1], NULL, 0);
		chr = strtoul(argv[0], NULL, 0);
	}

	while( (c = fgetc(stdin)) != -1) {
		if(c == chr) 
			c = rep;
		fputc(c, stdout);
	}

	exit(0);
}
