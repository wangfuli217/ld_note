#include <sclog.h>
#include <schead.h>
#include <scatom.h>
#include <pthread.h>
#include <stdarg.h>

//-------------------------------------------------------------------------------------------|
// �ڶ����� ����־��Ϣ�������get��set,������������Ϣ���ʵ��
//-------------------------------------------------------------------------------------------|

//�߳�˽������ __lkey, __lonceΪ��__lkey�ܹ�������ʼ��
static pthread_key_t __lkey;
static pthread_once_t __lonce = PTHREAD_ONCE_INIT;
static unsigned __logid = 0; //Ĭ�ϵ�ȫ��logid,Ψһ��ʶ

//�ڲ��򵥵��ͷź���,������pthread_key_create ��ֹ�߳���Դй¶
static void __slinfo_destroy(void* slinfo)
{
	//printf("pthread 0x%p:0x%p destroy!\n", pthread_self().p, slinfo);
	free(slinfo);
}

static void __gkey(void)
{
	pthread_key_create(&__lkey, __slinfo_destroy);
}

struct slinfo {
	unsigned		logid;					//�����logid,Ψһid
	char			reqip[_INT_LITTLE];		//����ip
	char			times[_INT_LITTLE];		//��ǰʱ�䴮
	struct timeval	timev;					//����ʱ��,����ֵ,ͳһ�ú���
	char			mod[_INT_LITTLE];		//��ǰ�̵߳�ģ������,���ܳ���_INT_LITTLE - 1
};

/**
*	�̵߳�˽�����ݳ�ʼ��
**
** mod   : ��ǰ�߳�����
** reqip : �����ip
** return :	_RT_OK ��ʾ����,_RF_EM�ڴ�������
**/
int
sl_pecific_init(const char* mod, const char* reqip)
{
	struct slinfo* pl;

	//��֤ __gkeyֻ��ִ��һ��
	pthread_once(&__lonce, __gkey);

	if((pl = pthread_getspecific(__lkey)) == NULL){
		//���¹���
		if ((pl = malloc(sizeof(struct slinfo))) == NULL)
			return _RT_EM;

		//printf("pthread 0x%p:0x%p create!\n", pthread_self().p,pl);
	}

	gettimeofday(&pl->timev, NULL);
	pl->logid = ATOM_ADD_FETCH(__logid, 1); //ԭ������
	strcpy(pl->mod, mod); //����һЩ����
	strcpy(pl->reqip, reqip);
	
	//����˽�б���
	pthread_setspecific(__lkey, pl);

	return _RT_OK;
}

/**
*	���������̼߳�ʱʱ��
**	�������� _RT_OK, _RT_EM��ʾ�ڴ�û�з���
**/
int 
sl_set_timev(void)
{
	struct slinfo* pl = pthread_getspecific(__lkey);
	if (NULL == pl)
		return _RT_EM;
	gettimeofday(&pl->timev, NULL);
	return _RT_OK;
}

/**
*	��ȡ��־��Ϣ���Ψһ��logid
**/
unsigned 
sl_get_logid(void)
{
	struct slinfo* pl = pthread_getspecific(__lkey);
	if (NULL == pl) //����0��ʾû���Ҽ�
		return 0u;
	return pl->logid;
}

/**
*	��ȡ��־��Ϣ�������ip��,����NULL��ʾû�г�ʼ��
**/
const char* 
sl_get_reqip(void)
{
	struct slinfo* pl = pthread_getspecific(__lkey);
	if (NULL == pl) //����NULL��ʾû���Ҽ�
		return NULL;
	return pl->reqip;
}

/**
*	��ȡ��־��Ϣ���ʱ�䴮,����NULL��ʾû�г�ʼ��
**/
const char* 
sl_get_times(void)
{
	struct timeval et; //��¼ʱ��
	unsigned td;

	struct slinfo* pl = pthread_getspecific(__lkey);
	if (NULL == pl) //����NULL��ʾû���Ҽ�
		return NULL;

	gettimeofday(&et, NULL);
	//ͬһ��΢���
	td = 1000000 * (et.tv_sec - pl->timev.tv_sec) + et.tv_usec - pl->timev.tv_usec;
	snprintf(pl->times, LEN(pl->times), "%u", td);

	return pl->times;
}

/**
*	��ȡ��־��Ϣ�������,����NULL��ʾû�г�ʼ��
**/
const char* 
sl_get_mod(void)
{
	struct slinfo* pl = pthread_getspecific(__lkey);
	if (NULL == pl) //����NULL��ʾû���Ҽ�
		return NULL;
	return pl->mod;
}


//-------------------------------------------------------------------------------------------|
// �������� ����־ϵͳ������������ӿڲ���
//-------------------------------------------------------------------------------------------|

//�����ض���� ����Ӧ�� �� "mkdir -p \"" _STR_SCLOG_PATH "\" >" _STR_TOOUT " 2>" _STR_TOERR
#define _STR_TOOUT "__out__"
#define _STR_TOERR "__err__"
#define _STR_LOGID "__lid__" //����logid,�־û�

static struct { //�ڲ��õ�˽�б���
	FILE* log;
	FILE* wf;
	bool isdir;	//��־�Ƿ񴴽���Ŀ¼
} __slmain;

/**
*	��־�ر�ʱ��ִ��,����ӿ�,�رմ򿪵��ļ����
**/
static void __sl_end(void)
{
	FILE* lid;
	void* pl;

	// �ڼ򵥵ط�������ȫ����ֵ��,�ں��ĵط����㷨�Ż��Ĳ����ȹ�
	if (!__slmain.isdir)
		return;

	//���õ�ǰϵͳ���ļ��ṹ��
	fclose(__slmain.log);
	fclose(__slmain.wf);
	BZERO(__slmain);

	//д���ļ�
	lid = fopen(_STR_LOGID, "w");
	if (NULL != lid) {
		fprintf(lid, "%u", __logid);
		fclose(lid);
	}

	//�����ͷ�˽�б���,��ʵ������ �൱��һ���߳��ǲ������!���ǲ�ͬ���������ڵ�
	pl = pthread_getspecific(__lkey);
	__slinfo_destroy(pl);
	pthread_setspecific(__lkey, NULL);
}

/**
*	��־ϵͳ�״�ʹ�ó�ʼ��,�ҶԶ�ӳ��־�ļ�·��,����ָ��·��
**����ֵ����� schead.h �ж���Ĵ�������
**/
int 
sl_start(void)
{
	FILE *lid;

	//����ִֻ��һ��
	if (!__slmain.isdir) {
		__slmain.isdir = true;
		//�ȶ༶����Ŀ¼,���ײ�������ʵ�ֿ�ƽ̨,system����ֵ�Ǻܸ���,Ĭ�ϳɹ�!
		system("mkdir -p \"" _STR_SCLOG_PATH "\" >" _STR_TOOUT " 2>" _STR_TOERR);
		rmdir("-p");
		remove(_STR_TOOUT);
		remove(_STR_TOERR);
	}

	if (NULL == __slmain.log) {
		__slmain.log = fopen(_STR_SCLOG_PATH "/" _STR_SCLOG_LOG, "a+");
		if (NULL == __slmain.log)
			CERR_EXIT("__slmain.log fopen %s error!", _STR_SCLOG_LOG);
	}
	//������ wf �ļ�
	if (NULL == __slmain.wf) {
		__slmain.wf = fopen(_STR_SCLOG_PATH "/" _STR_SCLOG_WFLOG, "a+");
		if (NULL == __slmain.wf) {
			fclose(__slmain.log); //��ʵ�ⶼû�б�Ҫ,ͼ���İ�
			CERR_EXIT("__slmain.log fopen %s error!", _STR_SCLOG_WFLOG);
		}
	}

	//��ȡ�ļ�����
	if ((lid = fopen(_STR_LOGID, "r")) != NULL) { //��ȡ�ļ�����,�־û�
		fscanf(lid, "%u", &__logid);
	}

	//������Ե�������һ���̻߳����,������־������ ���ģ���������ά��,���չ����
	sl_pecific_init("main thread","0.0.0.0");

	//ע���˳�����
	atexit(__sl_end);

	return _RT_OK;
}

int 
sl_printf(const char* format, ...)
{
	char tstr[_INT_LITTLE];// [%s] => [2016-01-08 23:59:59]
	int len;
	va_list ap;
	char logs[_INT_LOG]; //�������һ���õ����,����c ��֧�� int a[n];

	if (!__slmain.isdir) {
		CERR("%s fopen %s | %s error!",_STR_SCLOG_PATH, _STR_SCLOG_LOG, _STR_SCLOG_WFLOG);
		return _RT_EF;
	}

	//��ʼ������

	sh_times(tstr, _INT_LITTLE - 1);
	len = snprintf(logs, LEN(logs), "[%s ", tstr);
	va_start(ap, format);
	vsnprintf(logs + len, LEN(logs) - len, format, ap);
	va_end(ap);

	// д��ͨ�ļ� log
	fputs(logs, __slmain.log); //��������ȥ����,fputs�����̰߳�ȫ��

	// д�����ļ� wf
	if (format[4] == 'F' || format[4] == 'W') { //��ΪFATAL��WARNING��ҪЩд�뵽�����ļ���
		fputs(logs, __slmain.wf);
	}

	return _RT_OK;
}