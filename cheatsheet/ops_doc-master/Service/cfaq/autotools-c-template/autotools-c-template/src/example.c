#include <stdio.h>
#include <stdlib.h> // atoi
#include <getopt.h>	// getopt_long
#include <unistd.h>	// getopt_long
#include <signal.h> // signal
#include <assert.h> // assert

#include "config.h"


void help()
{
	char msg[] = 
			"example (v" PACKAGE_VERSION "), an example program built with Autotools\n"
			"\n"
			"usage: example [ -hvd ] [ -i file ] [ --debug | --debug=level ]\n"
			"\n"
			"OPCIONES\n"
			"\n"
			"   -h, --help                    show this help message\n"
			"\n"
			"   -v, --version                 print program's version\n"
			"\n"
			"   -i <file>, --input=<file>     an input file\n"
			"\n"
			"   -d, --debug, --debug=level    debug level\n"
			"\n";
	
	printf("%s", msg);
}


void version()
{
	printf("v" PACKAGE_VERSION "\n");
}


void sigint_handler(int signum)
{
	fprintf(stderr, "SIGINT captured (^C)\n");
}


int main(int argc, char **argv)
{
	int debuglevel = 0;
	char *inputPath = NULL;
	
	signal(SIGINT, sigint_handler);
	
	int longindex;
	const struct option longopts[] = {
			{ "help",			no_argument,		NULL,	'h' },
			{ "version",		no_argument,		NULL,	'v' },
			{ "input",			required_argument,	NULL,	'i' },
			{ "debug",			optional_argument,	NULL,	'd' },
			{ 0, 0, 0, 0 }
	};

	/*
	 Each letter is an option accepted as argument. If followed by ":" it
	 means the option requires an argument. When an option isn't recognize getopt
	 returns '?'. If an option requiring an argument doesn't have it getopt also
	 returns '?', unless optstring[0] was ':'. In that case, getopt returns ':'.
	 */
	char *optstring = ":hvi:d";
	char opt;
	while ((opt = getopt_long(argc, argv, optstring, longopts, &longindex)) != -1) {

		switch (opt) {

		case 'h': // help
			help();
			return EXIT_SUCCESS;
		
		case 'v': // version
			version();
			return EXIT_SUCCESS;

		case 'd': // debug
			if (optarg) {
				debuglevel = atoi(optarg);
			}
			else {
				debuglevel++;
			}
			break;

		case 'i': // input
			inputPath = optarg;
			break;

		case ':':
			fprintf(stderr, "error: '%s' options lacks an argument\n", argv[optind-1]);
			return EXIT_FAILURE;

		case '?':
			fprintf(stderr, "error: '%s' option not recognized\n", argv[optind-1]);
			return EXIT_FAILURE;
		}
	}
	
	printf("running on debuglevel %d, with input file '%s'\n", debuglevel, inputPath);
	
	/* the actual program would start here */
	
	return EXIT_SUCCESS;
}

