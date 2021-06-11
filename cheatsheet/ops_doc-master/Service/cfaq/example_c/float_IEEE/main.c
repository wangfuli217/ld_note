#include <stdio.h>
#include <stdlib.h>

void test1();
void test2();
void test3();
void test4();

int main(int argc, char* argv[])
{
	test1();
	test2();
	test3();
	test4();

	system("pause");

	return 0;
}

void test1()
{
	float x = 0.0f;
	float y = 0.0f;

	x= 1.0f / y;

	if ( x == x )
		printf("yes\n");
	else
		printf("no\n");
}

void test2()
{
	float x = 0.0f;
	float y = 0.0f;

	float temp = 1.0f / y;
	x = temp - temp;

	if ( x == x )
		printf("yes\n");
	else
		printf("no\n");
}

void test3()
{
	float x = 0.0f;
	float y = 0.0f;

	float temp = 1.0f / y;
	x = temp + temp;

	if ( x == x )
		printf("yes\n");
	else
		printf("no\n");
}

void test4()
{
	float x = 0.0f;

	x= x / x;

	if ( x == x )
		printf("yes\n");
	else
		printf("no\n");
}

/*
浮点数有一个特性：
设B为无穷大，S为无穷小，NaN为无效数, a为正实数
B + B = B
B - B = NaN
B * B = B
B / B = NaN
B / a = B
B / 0 = B
0 / 0 = NaN

同理可见S

两在原则：
1. 任何包含NaN的算术表达式，结果为NaN
2. 任何包含NaN的布尔表达式，结果为假。

*/
