#include "firebert.h"
#include "util.h"

static void 
_usage(void) { 
	fmt_eprint(	"blit [-t port] [-k] <data>\n"
			"or cat | blit\n"
			"\n"
			"blit feeds data to telson\n"
			"\tblit -k disconnects telson\n");
}

// ------------------------------------------------------------ 

int
main(int argc, char **argv) {
	int c = 0;
	int port = 4666;
	int fd = 0;
	int kill = 0;

	while((c = getopt(argc, argv, "kt:?")) != -1) {
		switch(c) {
		case 't':
			port = atoi(optarg);
			break;
		case 'k':
			kill = 1;
			break;
		case '?':
		default:
			_usage();
			exit(1);
		}
       	}

	argc -= optind;
	argv += optind;

	if((fd = cudp("127.0.0.1", port)) >= 0) {
		u_char buf[8192], *bp = buf;
		size_t l = 0;	

		if(kill) {
			atomicio(write, fd, "%DISCO!!", 8);
			exit(1);
		} 

		if(!argc) {
			while((l = fread(bp, 1, 8192, stdin)) != 0) {
				atomicio(write, fd, bp, l);
			}
		} else {
			if((bp = read_file(argv[0], &l))) {
				atomicio(write, fd, bp, l);
			} else {
				log_fatal("can't open \"%s\"", *argv);
			}
		}
	}

	exit(0);
}
