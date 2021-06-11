#include "firebert.h"
#include "util.h"

// ------------------------------------------------------------ 

static void
_usage(void) { 
	fmt_eprint(	"shf -f <file> [flags] <count> ; # or:\n"
			"\tcat | shf [flags] <count>\n"
			"\t-x\t\t\toverwrite file\n"
			"\t-o\t<file>\t\twrite output here\n"
			"\t-c\t\t\twrite from end\n"			
			"\t-f\t<file>\t\tread from here\n"
			"\n"
			"shf strips bytes off the front or end of its input\n");

}

// ------------------------------------------------------------ 

int
main(int argc, char **argv) {
	size_t bl = 0;
	u_char *buf = NULL;
	char *file = NULL;
	int c = 0;
	int shf = 1;
	int dir = 0;
	int cap = 0;
	int inplace = 0;
	FILE *out = stdout;

	while((c = getopt(argc, argv, "o:cf:xh")) != -1) {
		switch(c) {
		case 'x':
			inplace = 1;
			break;

		case 'o':
			if(!(out = fopen(optarg, "w"))) {
				perror("fopen output");
				exit(1);
			}
			break;

		case 'c':
			cap = 1;
			break;

		case 'f':
			file = optarg;
			break;

		case 'h':
		default:
			_usage();
			exit(1);
		}
	}

	if(inplace && file && !cap) { 
		static char buf[1024], *nfile = NULL;
		fmt_sfmt(buf, 1024, "%s.%d", file, getpid());
		if(rename(file, buf) >= 0) {
			if((out = fopen(file, "w"))) {
				nfile = buf;
			}
		}
			
		if(nfile) file = nfile;
		else {
			perror("swap files");
			exit(1);
		}
	} else if(inplace) {
		fmt_eprint("provide filename to shift in place\n");
		exit(1);
	}

	argc -= optind;
	argv += optind;

	if(argv[0]) {
		char *shfs = argv[0];
		if(shfs[0] == '+') {
			dir = 0;
			shfs++;
		} else if(shfs[0] == '-' || shfs[0] == 'e') {
			dir = 1;
			shfs++;
		}

		shf = strtoul(shfs, NULL, 0);
	}

	if((buf = read_file_or_stdin(file, &bl))) {
		u_char *bp = buf, *ep = &buf[bl];		

		if(!cap) { 	      		
			if(!dir) 
				bp += shf;
			else
				ep -= shf;

			if(bp < ep && ep > bp)
				fwrite(bp, (size_t)(ep - bp), 1, out);
		} else {
			if(!dir && (&bp[shf] < ep)) {
				fwrite(bp, shf, 1, out);
			} else if(dir && ((ep - shf) > bp)) {
				fwrite((ep - shf), shf, 1, out);
			}			       	     
		}
	}

	if(inplace) 
		unlink(file);

	fclose(out);
	exit(0);
}
