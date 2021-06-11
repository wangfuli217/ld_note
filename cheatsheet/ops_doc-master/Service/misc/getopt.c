#include <unistd.h>
/*  Parsing Command Line Options */
int
main(int argc, char *argv[ ])
{
    int c;
    int bflg, aflg, errflg;
    char *ifile;
    char *ofile;
    extern char *optarg;
    extern int optind, optopt;
    . . .
    while ((c = getopt(argc, argv, ":abf:o:")) != -1) {
        switch(c) {
        case ’a’:
            if (bflg)
                errflg++;
            else
                aflg++;
            break;
        case ’b’:
            if (aflg)
                errflg++;
            else {
                bflg++;
                bproc();
            }
            break;
        case ’f’:
            ifile = optarg;
            break;
        case ’o’:
            ofile = optarg;
            break;
            case ’:’:       /* -f or -o without operand */
                    fprintf(stderr,
                            "Option -%c requires an operand\n", optopt);
                    errflg++;
                                                      break;
        case ’?’:
                    fprintf(stderr,
                            "Unrecognized option: -%c\n", optopt);
            errflg++;
        }
    }
    if (errflg) {
        fprintf(stderr, "usage: . . . ");
        exit(2);
    }
    for ( ; optind < argc; optind++) {
        if (access(argv[optind], R_OK)) {
    . . .
}
/*
cmd -ao arg path path
cmd -a -o arg path path
cmd -o arg -a path path
cmd -a -o arg -- path path
cmd -a -oarg path path
cmd -aoarg path path
*/