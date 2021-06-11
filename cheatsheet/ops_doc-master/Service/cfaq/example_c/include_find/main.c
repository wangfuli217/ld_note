#include "stdio.h" /* 先去给定目录查询 -I，再到标准路径中查询 */
#include <stdlib.h> /* 先去标准路径查询，再去给定目录查询 -I */
#include <def.h>

int main(int argc, char **argv)
{
	printf("hello world\n");
	version();
	return 0;
}
