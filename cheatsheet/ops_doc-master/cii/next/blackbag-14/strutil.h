#ifndef LIB_STRUTIL_H
#define LIB_STRUTIL_H

/* The universal "create a string of all remaining args" function. 
 */
char	*copy_argv(char **argv);

/*
 * Create an argument vector from a string, deals w/ quoted strings.
 * Modifies the input string.  Returns argc in the second argument.
 */
char	**parse_argv(char *, int *);

/* Escape ' w/in a string for insertion into SQL */
void	 sanitize_string(char *, char *, int);

/*
 * Separate a string by delim.  Multiple occurrences of characters within
 * delim will be skipped over.
 */
char	*strnsep(char **strp, char *delim);

/* fast effective string hash 
 */
unsigned long strash(char *str);

const char *strint(int val);

#endif
