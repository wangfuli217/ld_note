#include <stdio.h>
#include <stdlib.h>

void fun()
{
	unsigned int a = 2013;

	int b = -2;

	int c = 0;

	
	//while(a + b > 0) { //这里 a + b 的结果会转化为 unsigned int, 所以 a + b 的结果为负数时，采用unsigned int 表示就是大于0的，这里无限执行
	while ((int)(a + b) > 0) { //结果集转换为int类型后就能按照默认的意图执行
		a = a + b;
		
		c++;
	}
	
	printf("%d\n", c);
}

int main(int argc, char **argv)
{
	fun();
	
	unsigned long a = 1;
	unsigned long b = 4294967290;
	
	if (((long)a - (long)b) > 0) {
		printf("a > b\n");
	} else {
		printf("a < b\n");
	}
	
	system("pause");
	
	return 0;
}
