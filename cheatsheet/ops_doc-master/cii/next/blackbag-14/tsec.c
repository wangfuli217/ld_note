#include "firebert.h"
#include "util.h"
#include "strutil.h"

// ------------------------------------------------------------ 

static void
_usage(void) {
	fmt_eprint(	"tsec [-t timeout] command\n"
			"\n"
			"tsec runs the specified command with a timeout (in fractional seconds)\n");
}

// ------------------------------------------------------------ 

int
main(int argc, char **argv) { 
	struct timeval del = { 0, 500 * 1000 } ;
	int c = 0;
	int pid = 0;	

	while((c = getopt(argc, argv, "ht:")) != -1) {
		switch(c) { 
		case 't':
			settime(optarg, &del);
			break;
		case 'h':
		default:
			_usage();
			exit(1);
		}
	}

	argc -= optind;
	argv += optind;

	if((pid = fork())) { 
		unsigned long delay = (del.tv_sec * 1000000) + del.tv_usec;
		usleep(delay);
		killpg(pid, 9);
	} else {
		char *cmd = copy_argv(argv);

		if(setpgid(0, getpid()) == -1) {
			perror("setpgid");
			exit(1);
		}

		system(cmd);		
	}

	exit(0);
}
