#include "firebert.h"
#include "util.h"

int
main(int argc, char **argv) {
	int c = 0;
	int e = 1;
	struct timeval del = { 0, 500 * 1000 };

	while((c = getopt(argc, argv, "ht:")) != -1) {
		switch(c) { 
		case 't':
			settime(optarg, &del);
			break;
		case 'h':
		default:
			fmt_eprint(	"touchwait <file>\n"				   
					"sleep until mtime on <file> changes\n");
			exit(1);
		}
	}

	argc -= optind;
	argv += optind;

	if(argc) { 
		int fd = 0;
		if((fd = open(argv[0], O_RDONLY)) >= 0) {
			time_t orig = file_last_modified(fd);
			unsigned long delay = (del.tv_sec * 1000000) + del.tv_usec;

			while(file_last_modified(fd) == orig) 
				usleep(delay);

			e = 0;
		} else {
			fmt_eprint("cannot open \"%s\": %s\n", argv[0], strerror(errno));
		}
	}
	
	exit(e);
}
