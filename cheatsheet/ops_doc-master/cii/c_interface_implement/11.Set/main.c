#include <stdio.h>
#include <stdlib.h>
#include "set.h"
#include "mem.h"

// word��ʼ
int start(int c)
{
	return isalpha(c);
}

//word����
int rest(int c)
{
	return isalpha(c) || c == '_' || c == '.' ;
}

void keyFree(const void *key, void **value)
{
	FREE(*value);
}

int compare(const void *x, const void *y)
{
	return strcmp(*(char **)x, *(char **)y);
}


int main(void)
{
	
	
	return 0;
}


