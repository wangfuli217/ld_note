#include <stdio.h>

/*
 * 正确的输出应该是1234，但是这里输出了858993459。因为atof在stdlib.h中声明，
 * 而我们没有包含这个头文件，程序编译使用原型是 int atof(const char *nptr); 
 * 
 * */

int main() { 
	printf("%d\n", (int) atof("1234.3"));
	
	ecc("Hello World"); // 这里没有定义ecc，gcc会报不能连接的错误
	
	return 0; 
}
