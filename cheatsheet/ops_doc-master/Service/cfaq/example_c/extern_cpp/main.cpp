#include "f1.h"
#include "foo.h"
#include "fn.h"
#include <stdio.h>

//extern unsigned int aaa; //上include头文件的时候，使用这种方式，必须加extern

void show_ccc();

extern int ccc; // 必须声明 必须要extern

int main(int argc, char **argv)
{
	printf("aaa: %u\n", aaa); // aaa 必须引用声明的头文件或者在引用的源文件中声明才可以使用
	
	show_var(aaa); 
	show_var_2(aaa);
	
	bbb = 9999999;
	
	show_me();
	
	show_ccc();
	
	ccc = 50000;
	return 0;
}