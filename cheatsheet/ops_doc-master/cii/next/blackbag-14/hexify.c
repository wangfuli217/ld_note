#include "firebert.h"
#include "util.h"

int
main(int argc, char **argv) {
	size_t l = 0;
	u_char *buf = NULL;

	if(argv[1] && !strcmp(argv[1], "-h")) {
		fmt_eprint("cat | hexify [+] ; # convert binary stdin to ASCII hex stdout\n");
		exit(1);
	}

	if((buf = read_desc(fileno(stdin), &l))) { 
		if(argv[1] && argv[1][0] == '+') {
			int i = 0;
			char *s = shexify(buf, l);
			int l = strlen(s);

			while(i < l) {
				fputc(s[i++], stdout);
				fputc(s[i++], stdout);
				fputc(' ', stdout);
				if(!(i % 16)) {
					fputc(' ', stdout);			
					fputc(' ', stdout);			
					fputc(' ', stdout);			
				}

				if(!(i % 32)) {
					fputc('\\', stdout);
					fputc('\n', stdout);
				}
			}

			fputc('\n', stdout);
		} else 
			fputs(shexify(buf, l), stdout);
	}

	exit(0);
}
