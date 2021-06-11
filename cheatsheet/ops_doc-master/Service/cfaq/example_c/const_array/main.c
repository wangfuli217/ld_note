#include <stdio.h>
#include <stdlib.h>

/* 对于值类型 下面的两种定义都是同义的 */
const int temp_a[] = {1, 2}; 
int const temp_b[] = {1, 2};

/* 对于指针类型 两种定义不同义，第二种定义不能重新给数组赋值 */
const char* temp_c[] = {"hello", "world"};
char* const temp_d[] = {"hello", "world"};



int main(int argc, char **argv)
{
	
//	temp_b[0] = 3;
//	temp_a[0] = 3;
    
    temp_c[0] = "hhhh";
    temp_c[1] = (const char*)malloc(10);
    temp_d[0] = "hhhh";
	
	printf("hello world\n");
	return 0;
}
