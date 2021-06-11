#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <float.h>
#include <limits.h>

#include "assert.h"
#include "getopt.h"
#include "str.h"
#include "mem.h"

#pragma warning (disable:4244)

/* types */
typedef enum GETOPT_ORDERING_T
{
    PERMUTE,
    RETURN_IN_ORDER,
    REQUIRE_ORDER
} GETOPT_ORDERING_T;

/* globally-defined variables */
char *optarg = NULL;
int optind = 0;
int opterr = 1;
int optopt = '?';

/* functions */

/* reverse_argv_elements:  reverses num elements starting at argv */
static void
reverse_argv_elements (char **argv, int num)
{
    int i;
    char *tmp;

    for (i = 0; i < (num >> 1); i++)
    {
        tmp = argv[i];
        argv[i] = argv[num - i - 1];
        argv[num - i - 1] = tmp;
    }
}

/* permute: swap two blocks of argv-elements given their lengths */
static void
permute (char **argv, int len1, int len2)
{
    reverse_argv_elements (argv, len1);
    reverse_argv_elements (argv, len1 + len2);
    reverse_argv_elements (argv, len2);
}

/* is_option: is this argv-element an option or the end of the option list? */
static int
is_option (char *argv_element, int only)
{
    return ((argv_element == NULL)
            || (argv_element[0] == '-') || (only && argv_element[0] == '+'));
}

/* getopt_internal:  the function that does all the dirty work */
static int
getopt_internal (int argc, char **argv, const char *shortopts,
        const struct option *longopts, int *longind, int only)
{
    GETOPT_ORDERING_T ordering = PERMUTE;
    static int optwhere = 0;
    size_t permute_from = 0;
    int num_nonopts = 0;
    int optindex = 0;
    size_t match_chars = 0;
    char *possible_arg = NULL;
    int longopt_match = -1;
    int has_arg = -1;
    char *cp = NULL;
    int arg_next = 0;

    /* first, deal with silly parameters and easy stuff */
    if (argc == 0 || argv == NULL || (shortopts == NULL && longopts == NULL))
        return (optopt = '?');
    if (optind >= argc || argv[optind] == NULL)
        return EOF;
    if (strcmp (argv[optind], "--") == 0)
    {
        optind++;
        return EOF;
    }
    /* if this is our first time through */
    if (optind == 0)
        optind = optwhere = 1;

    /* define ordering */
    if (shortopts != NULL && (*shortopts == '-' || *shortopts == '+'))
    {
        ordering = (*shortopts == '-') ? RETURN_IN_ORDER : REQUIRE_ORDER;
        shortopts++;
    }
    else
        ordering = (getenv ("POSIXLY_CORRECT") != NULL) ? REQUIRE_ORDER : PERMUTE;

    /*
     * based on ordering, find our next option, if we're at the beginning of
     * one
     */
    if (optwhere == 1)
    {
        switch (ordering)
        {
            case PERMUTE:
                permute_from = (size_t)optind;
                num_nonopts = 0;
                while (optind < argc && !is_option (argv[optind], only))
                {
                    optind++;
                    num_nonopts++;
                }
                if (optind >= argc || argv[optind] == NULL)
                {
                    /* no more options */
                    optind = (int)permute_from;
                    return EOF;
                }
                else if (strcmp (argv[optind], "--") == 0)
                {
                    /* no more options, but have to get `--' out of the way */
                    permute (argv + permute_from, num_nonopts, 1);
                    optind = (int)permute_from + 1;
                    return EOF;
                }
                break;
            case RETURN_IN_ORDER:
                if (!is_option (argv[optind], only))
                {
                    optarg = argv[optind++];
                    return (optopt = 1);
                }
                break;
            case REQUIRE_ORDER:
                if (!is_option (argv[optind], only))
                    return EOF;
                break;
            default:
                assert(0);
        }
    }
    /* we've got an option, so parse it */

    /* first, is it a long option? */
    if (longopts != NULL
            && (memcmp (argv[optind], "--", 2) == 0
                || (only && argv[optind][0] == '+')) && optwhere == 1)
    {
        /* handle long options */
        if (memcmp (argv[optind], "--", 2) == 0)
            optwhere = 2;
        longopt_match = -1;
        possible_arg = strchr (argv[optind] + optwhere, '=');
        if (possible_arg == NULL)
        {
            /* no =, so next argv might be arg */
            match_chars = strlen (argv[optind]);
            possible_arg = argv[optind] + match_chars;
            match_chars = match_chars - (size_t)optwhere;
        }
        else
            match_chars = (size_t)((possible_arg - argv[optind]) - optwhere);
        for (optindex = 0; longopts[optindex].name != NULL; optindex++)
        {
            if (memcmp (argv[optind] + optwhere,
                        longopts[optindex].name, match_chars) == 0)
            {
                /* do we have an exact match? */
                if (match_chars == (size_t) (strlen (longopts[optindex].name)))
                {
                    longopt_match = optindex;
                    break;
                }
                /* do any characters match? */
                else
                {
                    if (longopt_match < 0)
                        longopt_match = optindex;
                    else
                    {
                        /* we have ambiguous options */
                        if (opterr)
                            fprintf (stderr, "%s: option `%s' is ambiguous "
                                    "(could be `--%s' or `--%s')\n",
                                    argv[0],
                                    argv[optind],
                                    longopts[longopt_match].name,
                                    longopts[optindex].name);
                        return (optopt = '?');
                    }
                }
            }
        }
        if (longopt_match >= 0)
            has_arg = longopts[longopt_match].has_arg;
    }
    /* if we didn't find a long option, is it a short option? */
    if (longopt_match < 0 && shortopts != NULL)
    {
        cp = strchr (shortopts, argv[optind][optwhere]);
        if (cp == NULL)
        {
            /* couldn't find option in shortopts */
            if (opterr)
                fprintf (stderr,
                        "%s: invalid option -- `-%c'\n",
                        argv[0], argv[optind][optwhere]);
            optwhere++;
            if (argv[optind][optwhere] == '\0')
            {
                optind++;
                optwhere = 1;
            }
            return (optopt = '?');
        }
        has_arg = ((cp[1] == ':')
                ? ((cp[2] == ':') ? optional_argument : required_argument) : no_argument);
        possible_arg = argv[optind] + optwhere + 1;
        optopt = *cp;
    }
    /* get argument and reset optwhere */
    arg_next = 0;
    switch (has_arg)
    {
        case optional_argument:
            if (*possible_arg == '=')
                possible_arg++;
            if (*possible_arg != '\0')
            {
                optarg = possible_arg;
                optwhere = 1;
            }
            else
                optarg = NULL;
            break;
        case required_argument:
            if (*possible_arg == '=')
                possible_arg++;
            if (*possible_arg != '\0')
            {
                optarg = possible_arg;
                optwhere = 1;
            }
            else if (optind + 1 >= argc)
            {
                if (opterr)
                {
                    fprintf (stderr, "%s: argument required for option `", argv[0]);
                    if (longopt_match >= 0)
                        fprintf (stderr, "--%s'\n", longopts[longopt_match].name);
                    else
                        fprintf (stderr, "-%c'\n", *cp);
                }
                optind++;
                return (optopt = ':');
            }
            else
            {
                optarg = argv[optind + 1];
                arg_next = 1;
                optwhere = 1;
            }
            break;
        case no_argument:
            if (longopt_match < 0)
            {
                optwhere++;
                if (argv[optind][optwhere] == '\0')
                    optwhere = 1;
            }
            else
                optwhere = 1;
            optarg = NULL;
            break;
        default:
            assert(0);
    }

    /* do we have to permute or otherwise modify optind? */
    if (ordering == PERMUTE && optwhere == 1 && num_nonopts != 0)
    {
        permute (argv + permute_from, num_nonopts, 1 + arg_next);
        optind = (int)permute_from + 1 + arg_next;
    }
    else if (optwhere == 1)
        optind = optind + 1 + arg_next;

    /* finally return */
    if (longopt_match >= 0)
    {
        if (longind != NULL)
            *longind = longopt_match;
        if (longopts[longopt_match].flag != NULL)
        {
            *(longopts[longopt_match].flag) = longopts[longopt_match].val;
            return 0;
        }
        else
            return longopts[longopt_match].val;
    }
    else
        return optopt;
}

int
getopt (int argc, char **argv, const char *optstring)
{
    return getopt_internal (argc, argv, optstring, NULL, NULL, 0);
}

int
getopt_long (int argc, char **argv, const char *shortopts,
        const struct option *longopts, int *longind)
{
    return getopt_internal (argc, argv, shortopts, longopts, longind, 0);
}

int
getopt_long_only (int argc, char **argv, const char *shortopts,
        const struct option *longopts, int *longind)
{
    return getopt_internal (argc, argv, shortopts, longopts, longind, 1);
}

static void
print_option(const struct option* opt) {
    const char* help	= opt->help ? opt->help : "";
    const char* par	= opt->param_name ? opt->param_name : "P";
    char* buf;

    buf = Str_asprintf("%s=%s", opt->name,par);

    if(opt->has_arg == no_argument) {
        fprintf(stderr, "\t-%c, --%-25s %s\n", opt->val, opt->name, help);
    } else if(opt->has_arg == optional_argument) {
        fprintf(stderr, "\t-%c, --%-25s %s\n", opt->val, buf, help);
    } else if(opt->has_arg == required_argument) {
        fprintf(stderr, "\t-%c, --%-25s %s\n", opt->val, buf, help);
    } else fprintf(stderr, "No info on this parameter");

    FREE(buf);
}

int		opterrorcodes[256];
char	opterrorshorts[256];

void
getopt_usage(const char* progname, char *short_desc, char *pre_options, char *post_options, const struct option *longopts) {
    const char * pre_options1     = pre_options ? pre_options : "";
    const char * post_options1    = post_options ? post_options : "";
    const char * short_desc1      = short_desc ? short_desc : "";
    assert(longopts);


    fprintf(stderr, "Usage: ");
    if(progname != NULL)
        fprintf(stderr, "\t%s [OPTION] %s\n", progname, short_desc1);

    fprintf(stderr, pre_options1);
    fprintf(stderr, "Options:\n");

    while(longopts->name != NULL) {
        print_option(longopts);
        longopts++;
    }
    fprintf(stderr, post_options1);
}

#define ERROR_G	-1
#define SUCCESS_G  0

int getopt_parse(int argc, char **argv, struct option *longopts, char *short_desc, char *pre_options, char *post_options) {
    char shortopts[255]; /* Don't support more than 255 options */
    char* p = shortopts;
    struct option* lp = longopts;
    int long_index = 0;
    int opt = 0;
    unsigned int err_index = 0;
    const char* progname = argv[0] ? argv[0] : "Program";

    assert(longopts);

    if(argc > 255) {
        fprintf(stderr, "The program supports at most 255 options");
        abort();
    }

    *p = 'h';
    p++;
    /* craft the correct shortopts string*/
    while(lp->name != NULL && (p - shortopts) < 255) {
        if(lp->val != '\0') {
            *p = (char)lp->val;
            p++;
            if(lp->has_arg == required_argument) {
                *p = ':';
                p++;
            }
            if(lp->has_arg == optional_argument) {
                *p = ':';
                p++;
                *p = ':';
                p++;
            }
        }
        lp++;
    }
    *p = '\0';

#define OPTSPEC if(lp->specified != NULL) *(lp->specified) = getopt_specified

    memset(opterrorcodes, 0, 256);
    memset(opterrorshorts, '\0', 256);

    while ((opt = getopt_long(argc, argv, shortopts, longopts, &long_index )) != EOF) {

        if(opt == ':' || opt == '?') { /* manage error cases */
            if(err_index < 256) {
                opterrorcodes[err_index]	= opt;
                opterrorshorts[err_index]	= (char) optopt;
                err_index++;
            }
        } else {

            if(opt == 'h') {
                getopt_usage(progname, short_desc, pre_options, post_options, longopts);
                return ERROR_G;
            }

            /* search for the correct option*/
            lp = longopts;
            while (lp->name != NULL) {
                if(lp->val == opt) { /* found the option */
                    if(lp->has_arg == required_argument || lp->has_arg == optional_argument) {
                        /* manage arguments */
                        if(lp->has_arg == optional_argument && optarg == NULL) {
                            OPTSPEC;
                            break; /* processed option*/
                        }
                        if(lp->type == getopt_string) {
                            OPTSPEC;
                            lp->value = optarg;
                        } else if(lp->type == getopt_int) {
                            char* end;
                            char errchar = ' ';
                            const long sl = strtol(optarg, &end, 10);

                            errno = 0;

                            if(end == optarg) errchar = getopt_notnumber;
                            else if('\0' != *end) errchar = getopt_endchars;
                            else if((LONG_MIN == sl || LONG_MAX == sl) && ERANGE == errno) errchar = getopt_overunderflow;
                            else if(sl > INT_MAX) errchar = getopt_overunderflow;
                            else if(sl < INT_MIN) errchar = getopt_overunderflow;
                            else {
                                OPTSPEC;
                                *((int*)lp->value) = (int)sl;
                            }
                            if(errchar != ' ') {
                                if(opterr) fprintf(stderr, "%s: argument not a valid integer for option `-%c'\n", progname, opt);
                                if(err_index < 256) {
                                    opterrorshorts[err_index] = (char)opt;
                                    opterrorcodes[err_index++] = errchar;
                                }
                                if(errchar != getopt_endchars) optind --;                            }
                        } else if(lp->type == getopt_double) {
                            char* end;
                            char errchar = ' ';
                            const double sl = strtod(optarg, &end);

                            errno = 0;

                            if(end == optarg) errchar = getopt_notnumber;
                            else if('\0' != *end) errchar = getopt_endchars;
                            else if((DBL_MIN >= sl || DBL_MAX <= sl) && ERANGE == errno) errchar = getopt_overunderflow;
                            else {
                                OPTSPEC;
                                *((double*)lp->value) = (double)sl;
                            }
                            if(errchar != ' ') {
                                if(opterr) fprintf(stderr, "%s: argument not a valid floating point number for option `-%c'\n", progname, opt);
                                if(err_index < 256) {
                                    opterrorshorts[err_index] = (char)opt;
                                    opterrorcodes[err_index++] = errchar;
                                }
                                if(errchar != getopt_endchars) optind --;
                            }
                        } else {
                            assert(0); /* wrong specification for argument type */
                            return ERROR_G;
                        }
                    } else if(lp->has_arg == no_argument) { /* parameter without an argument */
                        OPTSPEC;
                        break; /* processed option*/
                    } else {
                        assert(0); /* wrong argument type*/
                        return ERROR_G;
                    }

                    break; /*exit while stmt as found the option*/
                }

                lp++;
            }
        }
    }
    return err_index == 0 ? SUCCESS_G : ERROR_G;
}


