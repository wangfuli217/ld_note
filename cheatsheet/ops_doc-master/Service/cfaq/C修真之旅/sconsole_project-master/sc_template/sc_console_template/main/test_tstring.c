#include <tstring.h>


/*
 * ���Ա���
 * ���� �ַ���ģ��,����ͨ��
 *
 * ϣ��, VS�ܶ�C�и����֧��
 */
int main_tstring(int argc, char* argv[])
{
	//���ڶ��� �����ڴ�
	tstring tstr = tstring_create("123");
	printf("str:%s, len:%d, size:%d.\n", tstr->str, tstr->len, tstr->size);

	tstring_append(tstr, 'A');
	printf("str:%s, len:%d, size:%d.\n", tstr->str, tstr->len, tstr->size);
	tstring_appends(tstr, "11111111111111111111111111111111111111111111111111111111111112���������\"���");
	printf("str:%s, len:%d, size:%d.\n", tstr->str, tstr->len, tstr->size);

	tstring_destroy(&tstr);

	//��ջ�ϲ���
	TSTRING_CREATE(ts);
	tstring_append(&ts, 'w');
	printf("str:%s, len:%d, size:%d.\n", ts.str, ts.len, ts.size);
	tstring_appends(&ts, "AN,but WAI!");
	printf("str:%s, len:%d, size:%d.\n", ts.str, ts.len, ts.size);
	TSTRING_DESTROY(ts);

	system("pause");
	return 0;
}