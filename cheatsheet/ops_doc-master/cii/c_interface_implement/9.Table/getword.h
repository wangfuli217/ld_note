#ifndef _GETWORD_H_
#define _GETWORD_H_

extern int getword(FILE *fp, char *buf, int size, 
				   int first(int c), int rest(int c));

#endif

