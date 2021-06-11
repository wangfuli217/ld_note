#ifndef _H_TSTRING
#define _H_TSTRING

#include <schead.h>

//------------------------------------------------���ַ�����������----------------------------------

/*
 * ��Ҫ����jshash ���ؼ�����hashֵ
 * ����ͻ���� 80% ���һ�����, ��Ҫ����NULL
 */
extern unsigned str_hash(const char* str);

/*
 * ���Ǹ������ִ�Сд�ıȽϺ���
 * ls		: ��߱Ƚ��ַ���
 * rs		: �ұ߱Ƚ��ַ���
 *			: ���� ls>rs => >0 ; ls = rs => 0 ; ls<rs => <0
 */
extern int str_icmp(const char* ls, const char* rs);

/*
 * ��������� �� strdup ����ʵ��, ����֮����Ҫfree 
 * str		: �����Ƶ�Դ������
 *			: ���� ���ƺ�Ĵ�����
 */
extern char* str_dup(const char* str);

//------------------------------------------------���ı��ַ�����������----------------------------------

#ifndef _STRUCT_TSTRING
#define _STRUCT_TSTRING
//���ַ����ṹ,�������ı��ַ�������tstring
struct tstring {
	char* str;		//�ַ���ʵ�ʱ��������
	int len;		//��ǰ�ַ�����С
	int size;		//�ַ��ش�С
};
typedef struct  tstring* tstring;
#endif // !_STRUCT_TSTRING

//�ı���ջ�ϴ�������,��������Щ������,��������
#define TSTRING_CREATE(var) \
	struct tstring var = { NULL, 0, 0}
#define TSTRING_DESTROY(var) \
	free(var.str)

/*
 * tstring �Ĵ�������, �����str����һ�� tstring�ṹ���ַ���
 * 
 * str : ���������ַ���
 * 
 * ret : ���ش����õ��ַ���,�������ʧ�ܷ���NULL
 */
extern tstring tstring_create(const char* str);

/*
 * tstring ��ȫ���ٺ���
 * tstr : ָ��tsting�ַ���ָ������ָ��
 */
extern void tstring_destroy(tstring* tstr);

/*
 *  ����ı��ַ���tstr����� һ���ַ�c
 * tstr : ���ַ�������
 * c : ����ӵ��ַ�
 * ret : ����״̬�� �� schead �� _RT_EB ���
 */
extern int tstring_append(tstring tstr, int c);

/*
 *  ����ı��������ֻ���ַ��� 
 * tstr : �ı���
 * str : ����ӵ��زĴ�
 * ret : ����״̬����Ҫ�� _RT_EP _RT_EM
 */
extern int tstring_appends(tstring tstr, const char* str);

/*
 * ����tstr������,�õ�char* ����,��Ҫ�Լ�free�ͷ�
 *������Ҫ���tstring �ַ���ֻ��Ҫ ���� len = 0.�Ϳ�����
 * tstr	: ��������ַ���
 *		: ���ط���õ��ַ����׵�ַ
 */
extern char* tstring_mallocstr(tstring tstr);

//------------------------------------------------���ļ���������----------------------------------

/*
 * �򵥵��ļ�������,���ȡ�������ļ����ݷ���,ʧ�ܷ���NULL.
 * ��Ҫ�º�ʹ�� tstring_destroy(&ret); ��������ַ�������
 * path : �ļ�·��
 * ret : ���ش����õ��ַ�������,����NULL��ʾ��ȡʧ��
 */
extern tstring file_malloc_readend(const char* path);

/*
 * �ļ�д��,û�к�˵��,�᷵�� _RT_EP _RT_EM _RT_OK
 * path : �ļ�·��
 * str : ��д����ַ���
 * ret : ����д��Ľ��
 */
extern int file_writes(const char* path, const char* str);

/*
 * �ļ�׷������, ���str��ͬ
 * path : �ļ�·��
 * str : ��׷�ӵ��ļ���ͬ
 *     : ����ֵ,��Ҫ�� _RT_EP _RT_EM _RT_OK ��Щ״̬
 */
extern int file_append(const char* path, const char* str);

#endif // !_H_TSTRING