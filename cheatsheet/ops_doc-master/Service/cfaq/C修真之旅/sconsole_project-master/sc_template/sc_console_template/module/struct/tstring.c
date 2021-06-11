#include <tstring.h>
#include <sclog.h>

/*
* ��Ҫ����jshash ���ؼ�����hashֵ
* ����ͻ���� 80% ���һ�����, ��Ҫ����NULL
*/
unsigned 
str_hash(const char* str)
{
	unsigned i, h = (unsigned)strlen(str), sp = (h >> 5) + 1;
	unsigned char* ptr = (unsigned char*)str;

	for (i = h; i >= sp; i -= sp)
		h ^= ((h<<5) + (h>>2) + ptr[i-1]);

	return h ? h : 1;
}

/*
 * ���Ǹ������ִ�Сд�ıȽϺ���
 * ls		: ��߱Ƚ��ַ���
 * rs		: �ұ߱Ƚ��ַ���
 *			: ���� ls>rs => >0 ; ls = rs => 0 ; ls<rs => <0
 */
int 
str_icmp(const char* ls, const char* rs)
{
	int l, r;
	if(!ls || !rs)
		return (int)(ls - rs);
	
	do {
		if((l=*ls++)>='a' && l<='z')
			l -= 'a' - 'A';
		if((r=*rs++)>='a' && r<='z')
			r -= 'a' - 'A';
	} while(l && l==r);
	
	return l-r;
}

/*
* ��������� �� strdup ����ʵ��, ����֮����Ҫfree
* str		: �����Ƶ�Դ������
*			: ���� ���ƺ�Ĵ�����
*/
char* 
str_dup(const char* str)
{
	size_t len; 
	char* nstr;
	DEBUG_CODE({
		if (NULL == str) {
			SL_WARNING("check is NULL == str!!");
			return NULL;
		}
	});

	len = sizeof(char) * (strlen(str) + 1);
	if (!(nstr = malloc(len))) {
		SL_FATAL("malloc is error! len = %d.", len);
		return NULL;
	}
	// ���������
	return memcpy(nstr, str, len);
}

//------------------------------------------------���ı��ַ�����������----------------------------------

/*
* tstring �Ĵ�������, �����str����һ�� tstring�ṹ���ַ���
*
* str : ���������ַ���
*
* ret : ���ش����õ��ַ���,�������ʧ�ܷ���NULL
*/
tstring 
tstring_create(const char* str)
{
	tstring tstr = calloc(1, sizeof(struct tstring));
	if (NULL == tstr) {
		SL_NOTICE("calloc is sizeof struct tstring error!");
		return NULL;
	}
	tstring_appends(tstr, str);

	return tstr;
}

/*
* tstring ��ȫ���ٺ���
* tstr : ָ��tsting�ַ���ָ������ָ��
*/
void tstring_destroy(tstring* tstr)
{
	if (tstr && *tstr) { //չ������
		free((*tstr)->str);
		free(*tstr);
		*tstr = NULL;
	}
}

//�ı��ַ��������Ķ���ֵ
#define _INT_TSTRING (32)

//�򵥷��亯��,����һ��������ڴ��, len > size��ʱ������������
static int __tstring_realloc(tstring tstr, int len)
{
	int size = tstr->size;
	for (size = size < _INT_TSTRING ? _INT_TSTRING : size; size < len; size <<= 1)
		;
	//�����ڴ�
	char *nstr = realloc(tstr->str, size);
	if (NULL == nstr) {
		SL_NOTICE("realloc(tstr->str:0x%p, size:%d) is error!", tstr->str, size);
		return _RT_EM;
	}
	tstr->str = nstr;
	tstr->size = size;
	return _RT_OK;
}

/*
*  ����ı��ַ���tstr����� һ���ַ�c
* tstr : ���ַ�������
* c : ����ӵ��ַ�
* ret : ����״̬�� �� schead �� _RT_EM ���
*/
int tstring_append(tstring tstr, int c)
{
	//������ȫ���
	int len = tstr->len + 2; // c + '\0' ��lenָֻ�� �ַ���strlen����

	//��Ҫ�����ڴ����,Ψһ��ʧ
	if ((len > tstr->size) && (_RT_EM == __tstring_realloc(tstr, len)))
			return _RT_EM;

	tstr->len = --len;
	tstr->str[len - 1] = c;
	tstr->str[len] = '\0';

	return _RT_OK;
}

/*
*  ����ı��������ֻ���ַ���
* tstr : �ı���
* str : ����ӵ��زĴ�
* ret : ����״̬����Ҫ�� _RT_EP _RT_EM
*/
int tstring_appends(tstring tstr, const char* str)
{
	int len;
	if (!tstr || !str || !*str) {
		SL_NOTICE("check param '!tstr || !str || !*str'");
		return _RT_EP;
	}

	len = tstr->len + (int)strlen(str) + 1;
	if ((len > tstr->size) && (_RT_EM == __tstring_realloc(tstr, len)))
		return _RT_EM;

	//���︴������
	strcpy(tstr->str + tstr->len, str);
	tstr->len = len - 1;

	return _RT_OK;
}

//------------------------------------------------���ļ���������----------------------------------

/*
* �򵥵��ļ�������,���ȡ�������ļ����ݷ���,ʧ�ܷ���NULL.
* ��Ҫ�º�ʹ�� tstring_destroy(&ret); ��������ַ�������
* path : �ļ�·��
* ret : ���ش����õ��ַ�������,����NULL��ʾ��ȡʧ��
*/
tstring file_malloc_readend(const char* path)
{
	int c;
	tstring tstr;
	FILE* txt = fopen(path, "r");
	if (NULL == txt) {
		SL_NOTICE("fopen r path = '%s' error!", path);
		return NULL;
	}

	//���ﴴ���ļ�����,����ʧ��ֱ�ӷ���
	if ((tstr = tstring_create(NULL)) == NULL) {
		fclose(txt);
		return NULL;
	}

	//�����ȡ�ı�����
	while ((c = fgetc(txt))!=EOF)
		if (_RT_OK != tstring_append(tstr, c)){ //�����˾�ֱ�������Ѿ����ڵ�����
			tstring_destroy(&tstr);
			break;
		}

	fclose(txt);//����Ҫ�����˾�Ҫ�ͷ�,�����������صľ��bug
	return tstr;
}

/*
* �ļ�д��,û�к�˵��,�᷵�� _RT_EP _RT_EM _RT_OK
* path : �ļ�·��
* str : ��д����ַ���
* ret : ����д��Ľ��
*/
int file_writes(const char* path, const char* str)
{
	FILE* txt;
	//����������
	if (!path || !str) {
		SL_NOTICE("check is '!path || !str'");
		return _RT_EP;
	}

	if ((txt = fopen(path, "w")) == NULL) {
		SL_NOTICE("fopen w path = '%s' error!", path);
		return _RT_EF;
	}

	//����д����Ϣ
	fputs(str, txt);

	fclose(txt);
	return _RT_OK;
}

/*
* �ļ�׷������, ���str��ͬ
* path : �ļ�·��
* str : ��׷�ӵ��ļ���ͬ
*     : ����ֵ,��Ҫ�� _RT_EP _RT_EM _RT_OK ��Щ״̬
*/
int 
file_append(const char* path, const char* str)
{
	FILE* txt;
	//����������
	if (!path || !str) {
		SL_NOTICE("check is '!path || !str'");
		return _RT_EP;
	}
	if ((txt = fopen(path, "a")) == NULL) {
		SL_NOTICE("fopen a path = '%s' error!", path);
		return _RT_EF;
	}
	//����д����Ϣ
	fputs(str, txt);

	fclose(txt);
	return _RT_OK;
}

/*
* ����tstr������,�õ�char* ����,��Ҫ�Լ�free�ͷ�
* tstr	: ��������ַ���
*		: ���ط���õ��ַ����׵�ַ
*/
char* 
tstring_mallocstr(tstring tstr)
{
	char* str;
	if (!tstr || tstr->len <= 0) {
		SL_NOTICE("params is check '!tstr || tstr->len <= 0' error!");
		return NULL;
	}
	if ((str = malloc(tstr->len + 1)) == NULL){
		SL_NOTICE("malloc %d+1 run is error!",tstr->len);
		return NULL;
	}

	
	//����Ϳ��Ը�����,��������һ�ַ�ʽ
	return memcpy(str, tstr->str, tstr->len + 1);
}
