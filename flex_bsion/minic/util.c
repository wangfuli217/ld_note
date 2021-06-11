/*	
*	util.c(1.2)	10:13:01	97/12/10 	
*
*	Utility functions.
*/

#include	<stdio.h>	/* for fprintf() and friends */

#include	"util.h"

/* aborts on failure */
void	*fmalloc(size_t s)
{
void	*ptr = malloc(s);
if (!ptr) {
	fprintf(stderr,"Out of memory in fmalloc(%d)\n",s);
	exit(1);
	}
return ptr;
}

