#include <unistd.h>
#include <stdio.h>
/* Checking Options and Arguments */
...
int c;
char *filename;
extern char *optarg;
extern int optind, optopt, opterr;
...
while ((c = getopt(argc, argv, ":abf:")) != -1) {
    switch(c) {
    case ’a’:
        printf("a is set\n");
        break;
    case ’b’:
        printf("b is set\n");
        break;
    case ’f’:
        filename = optarg;
        printf("filename is %s\n", filename);
        break;
    case ’:’:
        printf("-%c without filename\n", optopt);
        break;
    case ’?’:
        printf("unknown arg %c\n", optopt);
        break;
    }
}