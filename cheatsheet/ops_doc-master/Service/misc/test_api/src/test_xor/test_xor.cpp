#include <iostream>

using namespace std;

#define MAGIC 0x2145
int main()
{
	int a = 0x3323;

	cout << hex << a << endl;

	//简单加密
	a ^= MAGIC;
	cout << hex << a << endl;

	//简单解密
	a ^= MAGIC;
	cout << hex << a << endl;
	return 0;
}
