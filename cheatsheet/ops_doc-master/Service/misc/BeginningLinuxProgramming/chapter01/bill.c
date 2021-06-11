#include <stdio.h>
#include "Lib.h"

void bill ( char *arg )
{
	//if(NULL==arg)
	if (arg == NULL )
	{
		printf( "arg is NULL\n" );
		return ;
	}
	
    printf( "bill: you passed %s\n", arg );
}
