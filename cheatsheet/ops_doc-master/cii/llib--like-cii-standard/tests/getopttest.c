#include <stddef.h>
#include <string.h>

#include "getopt.h"
#include "test.h"

static int length = -1, breadth = -1, perimeter = -1;
static int area_spec = 0, perimeter_spec = 0;
static double dbl = 0;

static struct option long_options[] = {
    {"area",      no_argument,       NULL,  'a' , "calculate the area","", getopt_none, NULL ,&area_spec},
    {"perimeter", optional_argument, NULL,  'p' , "this is the perimeter", "P",getopt_int, &perimeter, &perimeter_spec},
    {"length",    required_argument, NULL,  'l' , "length is important", "L", getopt_int, &length, NULL},
    {"breadth",   required_argument, NULL,  'b' , "breadth as well", "B", getopt_int, &breadth, NULL},
    {"dbl",       required_argument, NULL,  'd' , "an happy double", "B", getopt_double, &dbl,NULL},
    {NULL,        no_argument,       NULL,  0, "", "", getopt_none, NULL, NULL   }
};

void parse_argv(char** pargv, int* pargc, char* cline, int max_args) {
    char *p2;

    *pargc = 0;
    p2 = strtok(cline, " ");

    while (p2 && *pargc < max_args) {
        pargv[(*pargc)++] = p2;
        p2 = strtok(0, " ");
      }
}

static
void clear_vars() {
    length = -1, breadth = -1, perimeter = -1;
    area_spec = 0, perimeter_spec = 0;
    optind = 0; dbl = 0;
}

static
unsigned parse_vars(char** pargv, int* pargc, char* cline, char* cmsg) {
    clear_vars();
    strcpy(cline, cmsg);
    parse_argv(pargv, pargc, cline, 64);
    return getopt_parse(*pargc, pargv, long_options, "", "", "");
}

unsigned test_getopt_parse() {
    int argc;
    char* argv[64];
    char cline[256];
    int r;

    r = parse_vars(argv, &argc, cline, "calculator -l 10 -b 11");
    test_assert(r >=0 && length == 10 && breadth == 11 && perimeter_spec == getopt_unspecified
                && area_spec == getopt_unspecified);

    r = parse_vars(argv, &argc, cline, "calculator -l 10 -b 11 -a -p");
    test_assert(r >=0 && length == 10 && breadth == 11 && perimeter_spec == getopt_specified
                && area_spec == getopt_specified && perimeter == -1);

    r = parse_vars(argv, &argc, cline, "calculator -l 10 -b 11 -a -p=12");
    test_assert(r >=0 && length == 10 && breadth == 11 && perimeter_spec == getopt_specified
                && area_spec == getopt_specified && perimeter == 12);

    opterr = 0; /* don't emit error message*/
    r = parse_vars(argv, &argc, cline, "calculator -k -b 11 -a -p=12 -z");
    test_assert(r < 0 && perimeter_spec == getopt_specified
                && area_spec == getopt_specified && perimeter == 12
                && opterrorcodes[0] == getopt_extraneous && opterrorcodes[1] == getopt_extraneous);

    r = parse_vars(argv, &argc, cline, "calculator -b 11 -a -p=12 -l");
    test_assert(r < 0 && perimeter_spec == getopt_specified
                && area_spec == getopt_specified && perimeter == 12
                && opterrorcodes[0] == getopt_missingpar);

    r = parse_vars(argv, &argc, cline, "calculator -l a -b 11 -a -p=12");
    test_assert(r < 0 && perimeter_spec == getopt_specified
                && area_spec == getopt_specified && perimeter == 12
                && opterrorcodes[0] == getopt_notnumber);

    r = parse_vars(argv, &argc, cline, "calculator -l -b 11 -a -p=12 -d=23.4");
    test_assert(r < 0 && breadth == 11 && perimeter_spec == getopt_specified
                && area_spec == getopt_specified && perimeter == 12
                && opterrorcodes[0] == getopt_notnumber
                && dbl < 23.5 && dbl > 23.2);

    r = parse_vars(argv, &argc, cline, "calculator -l -b 11 -a -p=12 -d=23.a");
    test_assert(r < 0 && breadth == 11 && perimeter_spec == getopt_specified
                && area_spec == getopt_specified && perimeter == 12
                && opterrorcodes[0] == getopt_notnumber
                && opterrorcodes[1] == getopt_endchars
                && opterrorshorts[0] == 'l' && opterrorshorts[1] == 'd');

    return TEST_SUCCESS;
}

