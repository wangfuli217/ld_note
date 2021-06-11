#include <schead.h>
#include <sclog.h>
#include <cjson.h>

#define _STR_FILE "firefighting_rule.json"


/**
 * ���� �ǽ��� �����json�ļ�����
 */
int main_json_read(int argc, char* argv[])
{
	INIT_PAUSE();
	// ������־��¼����
	sl_start();

	cjson_t rule = cjson_dofile(_STR_FILE);
	if (NULL == rule)
		CERR_EXIT("cjson_dofile " _STR_FILE " is error!");

	// ���ݺϷ� ���￪ʼ�õ�һ����
	cjson_t firefighting_rule = cjson_detachobject(rule, "firefighting_rule");
	// �õ�����������
	cjson_t key1 = cjson_detachobject(firefighting_rule, "key1");

	//����õ� key1 �������
	char* nkey = cjson_print(key1);
	if (NULL == nkey)
		CERR_EXIT("cjson_print key1 is error!");
	
	// �����ӡ���ݲ��� 
	puts(nkey);
	free(nkey);

	// �ټ򵥲���һ�� 
	cjson_t id = cjson_getobject(key1, "id");
	printf("\nid = %d\n", cjson_getint(id));

	//�õ�������� ����
	cjson_t level_contain = cjson_getobject(key1, "level_contain");
	printf("\ncount(level_contain) = %d\n", cjson_getlen(level_contain));

	cjson_delete(&key1);
	cjson_delete(&firefighting_rule);
	// rule �ͷ�
	cjson_delete(&rule);

	return 0;
}