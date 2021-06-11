#include <stdio.h>
#include <string>
#include <stdlib.h>

using namespace std;

int 
main(int argc, char **argv)
{
	string str1 = "hello world";
	string str2 = str1;


	printf ("Sharing the memory:\n");
	printf ("\tstr1's address: %p\n", str1.c_str() );
	printf ("\tstr2's address: %p\n", str2.c_str() );
	printf("\tstr1[0]: %p\n", &str1[0]); /* 这里cow的机制已经开始生效，str1这里已经开始进行copy */

	str1[1]='q';
	str2[1]='w';

	printf ("After Copy-On-Write:\n");
	printf ("\tstr1's address: %p\n", str1.c_str() );
	printf ("\tstr2's address: %p\n", str2.c_str() );

	system("pause");
	
	return 0;
}
