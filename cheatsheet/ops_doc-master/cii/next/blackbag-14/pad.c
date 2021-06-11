#include "firebert.h"
#include "util.h"

int
main(int argc, char **argv) {
	int c = 0;
	int chr = 0;
	int pto = 4;
	size_t bl = 0;
	u_char *buf = NULL;

	while((c = getopt(argc, argv, "ch:")) != -1) {
		switch(c) {
		case 'c':
			chr = strtol(optarg, NULL, 0);
			break;

		default:
			fmt_eprint("echo foo | pad [-c asciicode] [count (def 4)]\n");
			exit(1);
		}
	}

	argc -= optind;
	argv += optind;

	if(argc)
		pto = strtoul(argv[0], NULL, 0);

	if((buf = read_desc(fileno(stdin), &bl))) {
		size_t np = pto - (bl % pto);

		fwrite(buf, bl, 1, stdout);
	

		if(bl % pto) 
			while(np--)
				fputc(chr, stdout); 
	}

	exit(0);
}
