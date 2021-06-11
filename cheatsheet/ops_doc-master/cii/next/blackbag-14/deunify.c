#include "firebert.h"
#include "util.h"
#include "strutil.h"

int
main(int argc, char **argv) {
	u_char *buf = NULL;
	size_t l = 0;

	if(argv[1] && !strcmp(argv[1], "-h")) {
		fmt_eprint(	"deunify <data> ; # or:\n"
				"\tcat | deunify\n"
				"\n"
				"\tconvert binary UTF16LE to ASCII w/ HTML entities\n");
		exit(1);
	}

	if(argv[1]) {
		buf = (u_char*) copy_argv(&argv[1]);
		l = strlen((char*) buf);
	} else {
		buf = read_desc(fileno(stdin), &l);
	}

	if(buf) {
		size_t len = l * 4;
		char *out = malloc(len);
		unicode2asc(out, buf, &buf[l + 1], &len);
		fwrite(out, len, 1, stdout);
	}

	exit(0);
}
