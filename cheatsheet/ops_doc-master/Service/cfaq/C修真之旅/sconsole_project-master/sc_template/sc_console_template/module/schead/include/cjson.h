#ifndef _H_CJSON
#define _H_CJSON

// json �м����������Ͷ��� , ����C���� ���ѵ��ǿ�����Դ��,������api����, ������ҵ����
#define _CJSON_FALSE	(0)
#define _CJSON_TRUE		(1)
#define _CJSON_NULL		(2)
#define _CJSON_NUMBER	(3)
#define _CJSON_STRING	(4)
#define _CJSON_ARRAY	(5)
#define _CJSON_OBJECT	(6)

#define _CJSON_ISREF	(256)		//set ʱ������������þͲ��ͷ���
#define _CJSON_ISCONST	(512)		//setʱ����, �����const char* �Ͳ��ͷ���

struct cjson {
	struct cjson *next, *prev;
	struct cjson *child; // type == _CJSON_ARRAY or type == _CJSON_OBJECT ��ô child �Ͳ�Ϊ��

	int type;
	char *key;	// json�����ǿ�� key���� 	
	char *vs;	// type == _CJSON_STRING, ��һ���ַ��� 	
	double vd;  // type == _CJSON_NUMBER, ��һ��numֵ, ((int)c->vd) ת��int �� bool
};

//����cjson_t json����
typedef struct cjson* cjson_t;

/*
 * �����,Э�����ǵõ� int ֵ �� bool ֵ 
 * 
 * item : �������Ŀ��cjson_t���
 */
#define cjson_getint(item) \
	((int)((item)->vd))

/*
 *  ɾ��json������  
 * c		: ���ͷ�json_t������
 */
extern void cjson_delete(cjson_t* pc);

/*
 * ��json�ַ����������ؽ�����Ľ��
 * jstr		: ���������ַ���
 */
extern cjson_t cjson_parse(const char* jstr);

/*
 * ���� item��ǰ���� next һֱѰ�ҵ� NULL, ���ظ���
 *�Ƽ�������ʹ��
 * array	: �������cjson_t�������
 *			: ������������г���
 */
extern int cjson_getlen(cjson_t array);

/*
 * ���������õ���������ж���
 * array	: �������
 * idx		: ���ҵ����� ���� [0,cjson_getlen(array)) ��Χ��
 *			: ���ز��ҵ��ĵ�ǰ����
 */
extern cjson_t cjson_getarray(cjson_t array, int idx);

/*
 * ����key�õ�������� ��Ӧλ�õ�ֵ
 * object	: �����������ֵ
 * key		: Ѱ�ҵ�key
 *			: ���� ���� cjson_t ����
 */
extern cjson_t cjson_getobject(cjson_t object, const char* key);


// --------------------------------- ������ cjson ������ֵĴ������ -----------------------------------------

/*
 *  �����ǽ� cjson_t item ת�����ַ�������,��Ҫ�Լ�free 
 * item		: cjson�ľ�����
 *			: �������ɵ�item��json������
 */
extern char* cjson_print(cjson_t item);

// --------------------------------- ������ cjson ������ֵĸ������� -----------------------------------------

/*
 * ����һ��bool�Ķ��� b==0��ʾfalse,������true, ��Ҫ�Լ��ͷ� cjson_delete
 * b		: bool ֵ ����� _Bool
 *			: ���� �����õ�json ����
 */
extern cjson_t cjson_newnull();
extern cjson_t cjson_newbool(int b);
extern cjson_t cjson_newnumber(double vd);
extern cjson_t cjson_newstring(const char* vs);
extern cjson_t cjson_newarray(void);
extern cjson_t cjson_newobject(void);

/*
 * ��������,���� ��ӳ���͵����� cjson����
 *Ŀǰ֧�� _CJSON_NULL _CJSON_BOOL/FALSE or TRUE , _CJSON_NUMBER, _CJSON_STRING
 * NULL => array ����NULL, FALSE ʹ��char[],Ҳ���Դ���NULL, NUMBER ֻ����double, string ֻ����char**
 * type		: ����Ŀǰ֧�� ���漸������
 * array	: ����ԭʼ����
 * len		: ������Ԫ�س���
 *			: ���ش������������
 */
extern cjson_t cjson_newtypearray(int type, const void* array, int len);

/*
 * �� jstr�� ����Ҫ�������ַ�����ȥ��
 * jstr		: �������json��
 *			: ����ѹ�����json������
 */
extern char* cjson_mini(char* jstr);

/*
 *	��json�ļ�������json���ݷ���. ��Ҫ�Լ����� cjson_delete
 * jpath	: json��·��
 *			: ���ش���õ�cjson_t ����,ʧ�ܷ���NULL
 */
extern cjson_t cjson_dofile(char* jpath);

/*
 * ��array�з����idx������������.
 * array	: �������json_t ��������
 * idx		: ��������
 *			: ���ط����json_t����
 */
extern cjson_t cjson_detacharray(cjson_t array, int idx);

/*
 * ��object json �з��� key �����ȥ
 * object	: ������Ķ�����������
 * key		: �����ļ�
 *			: ���ط���� object�� key����json_t
 */
extern cjson_t cjson_detachobject(cjson_t object, const char* key);

#endif // !_H_CJSON
