#include <schead.h>
#include <scconf.h>

// 写完了,又能怎样,一个人
int main_scconf(int argc, char* argv[])
{
	const char* value;
	sc_start();

	//简单测试 配置读取内容
	value = sc_get("heoo");
	puts(value);

	value = sc_get("heoo2");
	if (value)
		puts(value);
	else
		puts("heoo2不存在");

	value = sc_get("yexu");
	puts(value);

	value = sc_get("end");
	puts(value);

	system("pause");
	return 0;
}