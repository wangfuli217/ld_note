#ifndef _DEBUG_
#define _DEBUG_

#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>

#ifdef DEBUG
	#define debug(arg...)  printf(arg)
#else
	#define debug(arg...)
#endif

#define errsys(str...) do{\
			fprintf(stderr, str);\
			fprintf(stderr, ": %s\n", strerror(errno));\
			exit(-1); \
			}while(0)

#endif
