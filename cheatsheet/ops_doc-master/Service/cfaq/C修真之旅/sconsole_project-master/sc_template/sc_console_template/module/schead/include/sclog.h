#ifndef _H_SCLOG
#define _H_SCLOG

//-------------------------------------------------------------------------------------------|
// ��һ���� ���õĲ�����
//-------------------------------------------------------------------------------------------|

//
//������־�з�,��Ҫ�õ������������crontab , �����´����Լ�дһ��������.
#define _INT_LITTLE				(64)		//����ʱ���IP����
#define _INT_LOG				(1024<<3)	//���8k��־

#define _STR_SCLOG_PATH			"log"		//��־���·��Ŀ¼,�������Ҫ��Ҫ���ó�""
#define _STR_SCLOG_LOG			"sc.log"	//��ͨlog��־ DEBUG,INFO,NOTICE,WARNING,FATAL�������
#define _STR_SCLOG_WFLOG		"sc.log.wf"	//����Ƚϸߵ���־��� FATAL��WARNING

/**
*	fstr : Ϊ��ʶ�� ���� _STR_SCLOG_FATAL, ������˫�����������Ĵ�
** 
** ƴ��һ�� printf �����ʽ��
**/
#define SCLOG_PUTS(fstr)	\
	"%s][" fstr "][%s:%d:%s][logid:%u][reqip:%s][mod:%s]"

#define _STR_SCLOG_FATAL		"FATAL"	    //����,���ʹ��
#define _STR_SCLOG_WARNING		"WARNING"	//����,ǰ��ʹ�ô���,�����	
#define _STR_SCLOG_NOTICE		"NOTICE"	//ϵͳʹ��,һ����һ���������,ʹ�������־
#define _STR_SCLOG_INFO			"INFO"		//��ͨ����־��ӡ
#define _STR_SCLOG_TRACE		"TRACE"
#define _STR_SCLOG_DEBUG		"DEBUG"	    //�����õ���־��ӡ,�ڷ�������Щ��־�ᱻ�����

/**
*	fstr : ֻ���� _STR_SCLOG_* ��ͷ�ĺ�
**	fmt	 : ������""�������ĺ�.��������ĸ�ʽ��
**	...  : ��ӳfmt������
**	
**  ƴ������ʹ�õĺ�,Ϊsl_printf ����һ��ģ��,�������һ����,��Window \n��ʾ CRLF, Unix����LF
**/
#define SCLOG_PRINTF(fstr, fmt, ...) \
	sl_printf(SCLOG_PUTS(fstr) fmt "\n", sl_get_times(), __FILE__, __LINE__, __func__, \
		sl_get_logid(), sl_get_reqip(), sl_get_mod(), ##__VA_ARGS__)


/**
*	FATAL... ��־��ӡ��
**	fmt	: ����ĸ�ʽ��,��Ҫ""��������
**	...	: ����Ĳ���,������fmt
**/
#define SL_FATAL(fmt, ...)	  SCLOG_PRINTF(_STR_SCLOG_FATAL, fmt, ##__VA_ARGS__)
#define SL_WARNING(fmt, ...) SCLOG_PRINTF(_STR_SCLOG_WARNING, fmt, ##__VA_ARGS__)
#define SL_NOTICE(fmt, ...)   SCLOG_PRINTF(_STR_SCLOG_NOTICE, fmt, ##__VA_ARGS__)
#define SL_INFO(fmt, ...)     SCLOG_PRINTF(_STR_SCLOG_INFO, fmt, ##__VA_ARGS__)

// ����״̬��,�ر�SL_DEBUG ��,��Ҫ���±���,û�иĳ�����ʱ���ж�,��������ҪΧ�Ƶ������ֶ������
#if defined(_DEBUG)
#	define SL_TRACE(fmt, ...)    SCLOG_PRINTF(_STR_SCLOG_TRACE, fmt, ##__VA_ARGS__)
#	define SL_DEBUG(fmt, ...)    SCLOG_PRINTF(_STR_SCLOG_DEBUG, fmt, ##__VA_ARGS__)
#else
#	define SL_TRACE(fmt, ...)    (void)0x123	/* �����ѵ�����123*/
#	define SL_DEBUG(fmt, ...)	 (void)0xa91	/* ������ */
#endif

//-------------------------------------------------------------------------------------------|
// �ڶ����� ����־��Ϣ�������get��set,������������Ϣ���ʵ��
//-------------------------------------------------------------------------------------------|


/**
*	�̵߳�˽�����ݳ�ʼ��
**
** mod   : ��ǰ�߳�����
** reqip : �����ip 
** return :	_RT_OK ��ʾ����,_RF_EM�ڴ�������
**/
extern int sl_pecific_init(const char* mod, const char* reqip);

/**
*	���������̼߳�ʱʱ��
**	�������� _RT_OK, _RT_EM��ʾ�ڴ�û�з���
**/
int sl_set_timev(void);

/**
*	��ȡ��־��Ϣ���Ψһ��logid
**/
unsigned sl_get_logid(void);

/**
*	��ȡ��־��Ϣ�������ip��,����NULL��ʾû�г�ʼ��
**/
const char* sl_get_reqip(void);

/**
*	��ȡ��־��Ϣ���ʱ�䴮,����NULL��ʾû�г�ʼ��
**/
const char* sl_get_times(void);

/**
*	��ȡ��־��Ϣ�������,����NULL��ʾû�г�ʼ��
**/
const char* sl_get_mod(void);



//-------------------------------------------------------------------------------------------|
// �������� ����־ϵͳ������������ӿڲ���
//-------------------------------------------------------------------------------------------|

/**
*	��־ϵͳ�״�ʹ�ó�ʼ��,�ҶԶ�ӳ��־�ļ�·��,����ָ��·��
**����ֵ����� schead.h �ж���Ĵ�������
**/
extern int sl_start(void);

/**
*		���������ϣ����ʹ��,��һ���ڲ��޶�������־�������.�Ƽ�ʹ����Ӧ�ĺ�
**��ӡ��Ӧ�������־����ӳ���ļ���.
**	
**	format		: ������""���������ĺ�,��ͷ������ [FALTAL:%s]��˴���
**				[WARNING:%s]ǰ�˴���, [NOTICE:%s]ϵͳʹ��, [INFO:%s]��ͨ��Ϣ,
**				[DEBUG:%s] ����������
**
** return	: ����������ݳ���
**/
int sl_printf(const char* format, ...);

#endif // !_H_SCLOG