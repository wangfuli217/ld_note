#include "firebert.h"
#include "util.h"

int
main(int argc, char **argv) {
	size_t l = 0;
	char *b = NULL;

	if(argv[1]) { 
		fmt_eprint("cat | dedump ; # convert hexdump -C ASCII stdin to binary stdout\n");
		exit(1);
	}

	if((b = (char*) read_desc(fileno(stdin), &l))) { 
		u_char *o = unhexdump(b, &l);

		fwrite(o, l, 1, stdout);
	}

	exit(0);
}
