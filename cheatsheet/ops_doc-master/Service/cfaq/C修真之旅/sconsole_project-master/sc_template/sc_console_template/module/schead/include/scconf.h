#ifndef _H_SCCONF
#define _H_SCCONF

/**
 *  �����������ļ���ȡ�ӿ�,
 * д����,��ȡ����,��Ҫ���ÿ�ʼ��ָ��·�� _STR_SCPATH
 */
#define _STR_SCCONF_PATH "module/schead/config/config.ini"

/*
 * ����������ö�ȡ����,��������Ҳ��
 */
extern void sc_start(void);

/*
 * ��ȡ������Ӧ����ֵ,ͨ��key
 * key		: ����������
 *			: ���ض�Ӧ�ļ�ֵ,���û�з���NULL,����ӡ��־
 */
extern const char* sc_get(const char* key);

#endif // !_H_SCCONF