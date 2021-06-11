#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <sys/types.h>

int 
main(int argc, char **argv) {
	int i = 0;
	int X[256];
	int j = 0;

	memset(X, 0, 256 * sizeof i);
// a certain sick pride ensues
#define X(x)  X[(int) #x [0]] = 0x##x;
	X(0); X(1); X(2); X(3); X(4); X(5); X(6);
	X(7); X(8); X(9); X(A); X(B); X(C); X(D);
	X(E); X(F); X(a); X(b); X(c); X(d); X(e); X(f);

	argv++;

	if(argv[1] && !strcmp(argv[1], "-h")) {
		fmt_eprint(	"binhex <hexbytes> ; # write binary to stdout\n");
		exit(1);
	}

	if(argc > 1) {
		while(argc > 1) {
			char *cp = argv[i++], *np = NULL;

			for(np = cp; *np; np++) {
				if(isxdigit(*np)) {
					int v = X[(int) *np];
					if((np - cp) % 2) {
						j |= v;
						fputc(j, stdout);
						j = 0;
					} else {
						j |= v<<4;
					}
				} else
					cp++;
			}
	
			argc--;
		}
	} else {
		/* slop slop slop
		 */
		int c = 0, cnt = 0;
		while((c = getc(stdin)) != -1) {
			cnt += 1;

			if(isxdigit(c)) { 
				int v = X[c];
				if(!(cnt % 2)) {
					j |= v;
					fputc(j, stdout);
					j = 0;
				} else {
					j |= v<<4;
				}
			}				
		}
	}

	exit(0);
}
