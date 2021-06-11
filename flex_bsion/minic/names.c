/*	names.c(1.1)	09:25:08	97/12/08
*
*	String pool management.
*/
#include	<stdio.h>	/* for fprintf and friends */
#include	<stdlib.h>	/* for malloc and friends */
#include	<assert.h>	/* for assert(invariant) */
#include	<string.h>	/* for strcmp(), strcpy() */

#include	"names.h"

#define	INCREMENT_SIZE		1000

static	char*	buf		= 0;
static	int	buf_size	= 0;	/* total size of buffer */
static	size_t	buf_avail	= 0;	/* free bytes in buf */
static	char*	next_name	= 0;	/* address available for next string */

#define	INVARIANT	assert(buf+buf_size==next_name+buf_avail); \
			assert(buf_size>=0); \
			assert(buf_avail>=0); \
			assert(next_name>=buf); 
static void
names_grow(size_t size)
{
size_t	next_offset	= next_name - buf;

{ INVARIANT }

buf	= realloc(buf,buf_size+size); /* like malloc() if buf==0 */
if (!buf) {
	fprintf(stderr,"Cannot expand name space (%d bytes)",buf_size+size);
	exit(1);
	}
buf_avail	+= size;
buf_size	+= size;
next_name	= buf+next_offset;

{ INVARIANT }
}

char*
names_insert(char* s)
{
char*	ps;
size_t	l	= strlen(s)+1; /* include trailing '\0' */

{ INVARIANT }

while (l>buf_avail) 
	names_grow(INCREMENT_SIZE);

ps		= strcpy(next_name,s);

buf_avail	-= l;
next_name	+= l;

{ INVARIANT }

return ps;
}

char*
names_find(char *s)
{
char	*pc;

for (pc=buf;(pc!=next_name);pc += strlen(pc)+1)
	if (!strcmp(pc,s))
		return pc;
return 0;
}

char*
names_find_or_add(char *s)
{
char	*pc = names_find(s);

if (!pc)
	pc = names_insert(s);
return pc;
}
