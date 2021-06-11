#include "firebert.h"
#include "util.h"
#include "httputils.h"

int
main(int argc, char **argv) { 
	u_char *bp = NULL;
	size_t bl = 0;
	
	argv++;
	if((bp = read_file_or_args(argv, &bl))) { 
		bl = http_dehexify(bp);
		fwrite(bp, bl, 1, stdout);
	}

	exit(0);
}
