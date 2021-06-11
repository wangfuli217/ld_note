#include <stdio.h>
#include <stdlib.h>

int 
GetValue()
{
	return (void)0, 1;
}


/* (void)0 就是啥也不做，编译忽略, 不能做为右值 */
int 
main(int argc, char **argv)
{
	int i = GetValue();
	
	//int j = (void)0;
	
	printf("i: %d\n", i);
	
	system("pause");
	
	return 0;
}
