#include "lib.h"

/*--------------------------------------------------*/
//��ʵ�����������÷���һ��ͷ�ļ���
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
