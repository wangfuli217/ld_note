#include <schead.h>
#include <scconf.h>

// д����,��������,һ����
int main_scconf(int argc, char* argv[])
{
	const char* value;
	sc_start();

	//�򵥲��� ���ö�ȡ����
	value = sc_get("heoo");
	puts(value);

	value = sc_get("heoo2");
	if (value)
		puts(value);
	else
		puts("heoo2������");

	value = sc_get("yexu");
	puts(value);

	value = sc_get("end");
	puts(value);

	system("pause");
	return 0;
}