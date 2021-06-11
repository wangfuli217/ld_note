#include "func.h"
#include <stdio.h>

#define func_cb(x) func_cb_r(x)

int main(int argc, char **argv)
{
	(func_cb)(1); //这里添加括号是防止进行宏替换，就是实际调用func_cb　函数　而不是进行宏替换，这里编译不通过
	return 0;
}
