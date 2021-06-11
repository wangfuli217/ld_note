#include <stdio.h>
#include <stdlib.h>

static void
pause()
{
#ifndef PAUSE 	
#define PAUSE system("pause") //宏定义是全局的
#endif
	PAUSE;
}

int main(int argc, char **argv)
{
	int temp[] = {1, 2, 3, 4, 5};
	
	char temp_2[] = "hello";
	
	char* temp_3 = "hello";
	
	printf("sizeof: %d\n", sizeof temp);
	
	printf("siezof: %d\n", sizeof temp_2);
	printf("strlen: %z\n", strlen(temp_2));
	
	
	printf("siezof: %d\n", sizeof temp_3);
	printf("strlen: %d\n", strlen(temp_3));
	
	PAUSE;
}
