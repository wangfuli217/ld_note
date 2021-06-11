#include "lib.h"

/*--------------------------------------------------*/
//其实下面的声明最好放在一个头文件中
/*--------------------------------------------------*/

#define NULL  	((void*)0)
extern void bill ( char *arg );
extern void fred( int arg );

int main( void )
{
	char *p = NULL;
    	bill( "Hello World" );

	 bill( " " );
	 
	 bill(p);
    	exit(0);
}
