#include "firebert.h"
#include "util.h"
#include "strutil.h"

int
main(int argc, char **argv) {
	u_char *buf = NULL;
	size_t l = 0;

	if(argv[1] && !strcmp(argv[1], "-h")) {
		fmt_eprint(	"unify <data> ; # or:\n"
				"\tcat | unify\n"
				"\n"
				"\tconvert ASCII, with HTML entities, to UTF16LE\n");
		exit(1);
	}

	if(argv[1]) {
		buf = (u_char*) copy_argv(&argv[1]);
		l = strlen((char*) buf);
	} else {
		buf = read_desc(fileno(stdin), &l);
	}

	if(buf) {
		size_t len = l * 2;
		u_char *out = malloc(len);
		ascii2unicode(out, (char*)buf, &len);
		fwrite(out, len, 1, stdout);
	}

	exit(0);
}
