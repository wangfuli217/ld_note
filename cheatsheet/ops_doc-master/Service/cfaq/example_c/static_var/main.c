#include "foo.h"
#include <stdio.h>

/*
 A、若全局变量仅在单个C文件中访问，则可以将这个变量修改为静态全局变量，以降低模块间的耦合度；

 B、若全局变量仅由单个函数访问，则可以将这个变量改为该函数的静态局部变量，以降低模块间的耦合度；

 C、设计和使用访问动态全局变量、静态全局变量、静态局部变量的函数时，需要考虑重入问题；
*/


int 
main(int argc, char **argv)
{
	for (unsigned int idx = 0; idx < 10; idx++) {
		foo_var_2();
		foo_var();
	}
	return 0;
}
