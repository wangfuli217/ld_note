/*  Based on Gregory Pietsch's getopt code, modified to add higher level functions and integrate to llib.
    Gregory added to the LICENSE file.
*/

#ifndef GETOPT_H
#define GETOPT_H

#include "utils.h"  /* for begin_decl*/

BEGIN_DECLS

#define no_argument          0
#define required_argument    1
#define optional_argument    2

#define getopt_none			 0
#define getopt_int			 1
#define getopt_double		 2
#define getopt_string		 3

#define getopt_unspecified	 0
#define	getopt_specified	 1

#define getopt_extraneous   '?'
#define getopt_missingpar   ':'
#define getopt_notnumber    '&'
#define getopt_endchars     '*'
#define getopt_overunderflow '>'


/* struct option: The type of long option */
struct option
{
    char *name;                   /* the name of the long option */
    int has_arg;                  /* one of the above macros */
    int *flag;                    /* determines if getopt_long() returns a
                                   * value for a long option; if it is
                                   * non-NULL, 0 is returned as a function
                                   * value and the value of val is stored in
                                   * the area pointed to by flag.  Otherwise,
                                   * val is returned. */
    int val;                      /* determines the value to return if flag is
                                   * NULL. */
    char *help;					  /* help display on the line of the option */
    char *param_name;			  /* name to use for the parameter */
    int type;					  /* expected type for the parameter */
    void* value;				  /* pointer to a location where to store the parameter value */
    int* specified;				  /* pointer to a location where to store 0 if option wasn't specified on command line, 1 if it was*/
};

/* externally-defined variables */
extern char*	optarg;
extern int		optind;
extern int		opterr;
extern int		optopt;

extern int		opterrorcodes[256]; /* Used by getopt_parse, Contains a list of all the error code encountered while parsing the options*/
extern char		opterrorshorts[256]; /* Used by getopt_parse, Contains a list of all the optinos with errors encountered while parsing the options*/

/* replicates getopt functionality for backward compatibility sake*/
int getopt (int argc, char **argv, const char *optstring);
int getopt_long (int argc, char **argv, const char *shortopts, const struct option *longopts, int *longind);
int getopt_long_only (int argc, char **argv, const char *shortopts, const struct option *longopts, int *longind);

/* prints out usage text getting data from the augmented option structure */
void getopt_usage(const char* progname, char *short_desc, char *pre_options, char *post_options, const struct option *longopts);

/*  Uses longopts to define which options are accepted, parses them and stores them in the value and specified field.
    Displays an usage message is -h or --help is specified. Returns a negative number for error, display an error string
    and fills out the opterrorcodes and opterrorshorts with the error code in getopt_long format and the short code for the option.
    As getopt_long, it leaves the remaining parameters (i.e. files) in argv starting at optind.
*/
int  getopt_parse(int argc, char **argv, struct option *longopts, char *short_desc, char *pre_options, char *post_options);

END_DECLS

#endif /* GETOPT_H */
