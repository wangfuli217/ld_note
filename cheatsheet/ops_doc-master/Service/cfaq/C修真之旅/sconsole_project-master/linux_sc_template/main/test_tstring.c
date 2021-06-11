#include <tstring.h>

/*
 * 测试报告
 * 关于 字符串模块,测试通过
 *
 * 希望, VS能对C有更多的支持
 */
int main(int argc, char* argv[])
{
	//先在堆上 申请内存
	tstring tstr = tstring_create("123");
	printf("str:%s, len:%d, size:%d.\n", tstr->str, tstr->len, tstr->size);

	tstring_append(tstr, 'A');
	printf("str:%s, len:%d, size:%d.\n", tstr->str, tstr->len, tstr->size);
	tstring_appends(tstr, "11111111111111111111111111111111111111111111111111111111111112你好你好你好\"你好");
	printf("str:%s, len:%d, size:%d.\n", tstr->str, tstr->len, tstr->size);

	tstring_destroy(&tstr);

	//在栈上测试
	TSTRING_CREATE(ts);
	tstring_append(&ts, 'w');
	printf("str:%s, len:%d, size:%d.\n", ts.str, ts.len, ts.size);
	tstring_appends(&ts, "AN,but WAI!");
	printf("str:%s, len:%d, size:%d.\n", ts.str, ts.len, ts.size);
	TSTRING_DESTROY(ts);

	return 0;
}
