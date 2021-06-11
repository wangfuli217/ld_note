#include <schead.h>
#include <sclog.h>
#include <cjson.h>

// ���� cjson ����
int main_cjson_write(int argc, char* argv[])
{
	//ע��ȴ�����
	INIT_PAUSE();

	//������־��¼����
	sl_start();

	// ����json ��
	char jstr[] = "{\n\"name\": \"Jack (\\\"Bee\\\") Nimble\", \n\"format\": {\"type\":[1, 3, 4, 5.66], \n\"height\":     1080, \n\"interlace\":  false}\n}";

	printf("Դ�봮 :\n %s\n", jstr);

	// ������ json ����
	cjson_t root = cjson_parse(jstr);
	if (root == NULL) {
		puts("jstr ����ʧ��! �����˳���....");
		exit(EXIT_FAILURE);
	}

	//����򵥲����������
	char* njstr = cjson_print(root);

	if (njstr == NULL) {
		puts("�������ʧ��,�����˳���!");
		cjson_delete(&root);
		exit(EXIT_FAILURE);
	}

	//�Ϸ���Χֱ����� ����
	printf("������ :\n %s\n", njstr);

	//��������Ҫ�ͷ�
	free(njstr);

	//������ һ��Ҫע���ͷŲ���
	cjson_delete(&root);


	//��һ������ ����ڴ�ֵ
	printf("d = %d\n", (int)strlen("{\"name\":\"Jack (\\\"Bee\\\") Nimble\",\"format\":{\"type\":[1,3,4,5.660000],\"height\":1080,\"interlace\":false}}"));

	return 0;
}