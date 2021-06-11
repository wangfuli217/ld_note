#include "firebert.h"
#include "util.h"
#include "httputils.h"

char *
http_hexify(u_char *bp, size_t l) { 
	stringvec_t *s = fmt_start(l);
	
	while(l) { 
		if(isalnum(*bp)) { 
			fmt_build(s, 5, "%c", *bp);
		} else {
			fmt_build(s, 5, "%%%.2X", *bp);
		}
	
		l--;
		bp++;
	}

	return(fmt_convert(&s));
}

/* ------------------------------------------------------------ */

int
main(int argc, char **argv) { 
	u_char *bp = NULL;
	size_t bl = 0;

	argv++;
	if((bp = read_file_or_args(argv, &bl))) { 
		char *cp = http_hexify(bp, bl);
		fputs(cp, stdout);
	}

	exit(0);
}
