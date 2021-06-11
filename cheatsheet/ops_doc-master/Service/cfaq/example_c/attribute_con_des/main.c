#include <stdio.h>
#include <stdlib.h>

__attribute__((constructor(1)))
void pre_main_1()
{
	printf("%s \n", __func__);
}

__attribute__((constructor(2)))
void pre_main_2()
{
	printf("%s \n", __func__);
}


__attribute__((destructor(1)))
void fin_main_1()
{
	printf("%s \n", __func__);
	
	system("pause");
}

__attribute__((destructor(2)))
void fin_main_2() 
{
	printf("%s \n", __func__);
	
	system("pause");
} 

int main(int argc, char **argv)
{
	system("pause");
	
	return 0;
}
