extern char *optarg;
extern int optind;

main(int argc, char *argv[])
{
	int aflag = 0;
	char *bval = NULL;
	int c;

	while((c = getopt(argc, argv, "ab:")) != -1)
		switch(c) {
		case 'a':
			aflag = 1;
			printf("-a seen\n");
			break;

		case 'b':
			bval = optarg;
			printf("-b seen (\"%s\")\n", bval);
			break;
	}

	if(optind >= argc) {
		/* no filename arguments; process stdin */
		printf("processing standard input\n");
	} else {
		/* process filename arguments */

		for(; optind < argc; optind++) {
			FILE *ifp = fopen(argv[optind], "r");
			if(ifp == NULL) {
				fprintf(stderr, "can't open %s: %s\n",
					argv[optind], strerror(errno));
				continue;
			}

			printf("processing %s\n", argv[optind]);

			fclose(ifp);
		}
	}

	return 0;
}