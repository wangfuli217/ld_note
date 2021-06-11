#include <scconf.h>
#include <scatom.h>
#include <tree.h>
#include <tstring.h>
#include <sclog.h>

//�򵥶������ṹ
struct dict {
	_TREE_HEAD;
	char* key;
	char* value;
};

// ������������, kv �� [ abc\012345 ]�����Ľṹ
static void* __dict_new(tstring tstr)
{
	char* ptr; //��ʱ�õı���
	struct dict* nd = malloc(sizeof(struct dict) + sizeof(char)*(tstr->len+1));
	if (NULL == nd) {
		SL_NOTICE("malloc struct dict is error!");
		exit(EXIT_FAILURE);
	}

	nd->__tn.lc = NULL;
	nd->__tn.rc = NULL;
	// �����, ʣ�µľ����˸�, 1% ,������,
	nd->key = ptr = (char*)nd + sizeof(struct dict);
	memcpy(ptr, tstr->str, tstr->len + 1);
	while (*ptr++)
		;
	nd->value = ptr;

	return nd;
}

// ��ʼ���
static inline int __dict_acmp(tstring tstr, struct dict* rnode)
{
	return strcmp(tstr->str, rnode->key);
}
//���Һ�ɾ��
static inline int __dict_gdcmp(const char* lstr, struct dict* rnode)
{
	return strcmp(lstr, rnode->key);
}

//ɾ������
static inline void __dict_del(void* arg)
{
	free(arg);
}

//ǰϷ̫��,��û�н���, ����ǰϷ̫����,��� ...
static tree_t __tds; //�����ֵ� Ĭ��ֵΪNULL
//Ĭ�ϵ� __tds ���ٺ���
static inline void __tds_destroy(void)
{
	tree_destroy(&__tds);
}

static int __lock; //�����õ�,Ĭ��ֵΪ 0 

static void __analysis_start(FILE* txt, tree_t* proot)
{
	char c, n;
	TSTRING_CREATE(tstr);

	//���ﴦ���ȡ����
	while ((c = fgetc(txt)) != EOF) {
		//1.0 �������հ��ַ�
		while (c != EOF && isspace(c))
			c = fgetc(txt);
		//2.0 ���������һ���ַ����� '$'
		if (c != '$') { //����һ�ж�ȡ���
			while (c != EOF && c != '\n')
				c = fgetc(txt);
			continue;
		}
		//2.1 ��һ���ַ��� $ �Ϸ��ַ�, ��ͷ�����ǿո�,����Ҳ��ȡ���
		if ((c = fgetc(txt)) != EOF && isspace(c)) {
			while (c != EOF && c != '\n')
				c = fgetc(txt);
			continue;
		}
		//��ʼ��¼��
		tstr.len = 0;

		//3.0 �ҵ���һ���Ⱥ� 
		while (c != EOF && c != '=') {
			if(!isspace(c))
				tstring_append(&tstr, c);
			c = fgetc(txt);
		}
		if (c != '=') //��Ч�Ľ���ֱ�ӽ���
			break;

		c = '\0';
		//4.0 �ҵ� ��һ�� "
		while (c != EOF && c != '\"') {
			if (!isspace(c))
				tstring_append(&tstr, c);
			c = fgetc(txt);
		}
		if (c != '\"') //��Ч�Ľ���ֱ�ӽ���
			break;

		//4.1 Ѱ�ҵڶ����Ⱥ�
		for (n = c; (c = fgetc(txt)) != EOF; n = c) {
			if (c == '\"' && n != '\\')
				break;
			tstring_append(&tstr, c);
		}
		if (c != '\"') //��Ч�Ľ���ֱ�ӽ���
			break;

		//������ǺϷ��ַ���,��ʼ��� ��, 
		tree_add(proot, &tstr);

		//����ȡ����ĩβ
		while (c != EOF && c != '\n')
			c = fgetc(txt);
		if (c != '\n')
			break;
	}

	TSTRING_DESTROY(tstr);
}

/*
* ����������ö�ȡ����,��������Ҳ��
*/
void 
sc_start(void)
{
	FILE* txt = fopen(_STR_SCCONF_PATH, "r");
	if (NULL == txt) {
		SL_NOTICE("fopen " _STR_SCCONF_PATH " r is error!");
		return;
	}

	ATOM_LOCK(__lock);
	//���ͷ� ��� __tds, ���__tds�ڴ�ͬ��������
	__tds_destroy();
	//����ײ��,�ڴ治����ֱ���˳���
	__tds = tree_create(__dict_new, __dict_acmp, __dict_gdcmp, __dict_del);

	//�����ǽ�����ȡ������
	__analysis_start(txt, &__tds);

	ATOM_UNLOCK(__lock);

	fclose(txt);
}

/*
* ��ȡ������Ӧ����ֵ,ͨ��key
* key		: ����������
*			: ���ض�Ӧ�ļ�ֵ,���û�з���NULL,����ӡ��־
*/
inline const char* 
sc_get(const char* key)
{
	struct dict* kv;
	if ((!key) || (!*key) || !(kv = tree_get(__tds, key, NULL)))
		return NULL;

	return kv->value;
}