#include <stdio.h>
#include <string.h>
char string[] = "this is a test";	/* not char *; see Q 16.6 */
char *p;
for(p = strtok(string, " \t\n"); p != NULL;
			p = strtok(NULL, " \t\n"))
	printf("\"%s\"\n", p);

As an alternative, here is a routine I use for building an argv all at once:

#include <ctype.h>

int makeargv(char *string, char *argv[], int argvsize)
{
	char *p = string;
	int  i;
	int argc = 0;

	for(i = 0; i < argvsize; i++) {
		/* skip leading whitespace */
		while(isspace(*p))
			p++;

		if(*p != '\0')
			argv[argc++] = p;
		else {
			argv[argc] = 0;
			break;
		}

		/* scan over arg */
		while(*p != '\0' && !isspace(*p))
			p++;
		/* terminate arg: */
		if(*p != '\0' && i < argvsize-1)
			*p++ = '\0';
	}

	return argc;
}

Calling makeargv is straightforward:

	char *av[10];
	int i, ac = makeargv(string, av, 10);
	for(i = 0; i < ac; i++)
		printf("\"%s\"\n", av[i]);
    
    
#include <stdio.h> 
#include <string.h> 
char string[] = "this\thas\t\tmissing\tfield"; 
char *p = string; 
while(1) { /* break in middle */ 
char *p2 = strchr(p, '\t'); 
if(p2 != NULL) 
    *p2 = '\0'; 
    printf("\"%s\"\n", p); 
if(p2 == NULL) 
    break; 
    p = p2 + 1; 
}

