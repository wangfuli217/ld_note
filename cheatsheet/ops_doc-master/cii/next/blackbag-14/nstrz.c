#include "firebert.h"
#include "strutil.h"
#include "util.h"
#include "bfmt.h"

int
main(int argc, char **argv) {
	int hbo = 0;
	int nul = 0;
	int hw = 0;
	int c;

	while((c = getopt(argc, argv, "shz")) != -1) {
		switch(c) {
		case 's':
			hw = 1;
			break;
		case 'h':
			hbo = 1;
			break;
		case 'z':
			nul = 1;
			break;
		default:
			fprintf(stderr, "nstrz [-z] [-h] args");
			exit(1);	
		}

	}
	
	argv += optind;


	{
		char *buf = copy_argv(argv);
		if(buf) {
			u_int32_t r = 0;

			if(!hw) {
				u_int32_t l = strlen(buf) + nul;
 				r = l;
				if(hbo) { l = swp32(l); }
				atomicio(write, fileno(stdout), (void*)&l, 4);
			} else {
				u_int16_t l = strlen(buf) + nul;
				 r = l;
				if(hbo) { l = swp16(l); }
				atomicio(write, fileno(stdout), (void*)&l, 2);
			}			

			atomicio(write, fileno(stdout), buf, r);		
		}

	}

	exit(0);
}
