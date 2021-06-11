#ifndef _H_CHEAD
#define _H_CHEAD

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <errno.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stddef.h>

/*
 * 1.0 ������� �����жϷ���ֵ״̬��״̬�� _RF��ʾ���ر�־
 *	ʹ�þ��� : 
 		int flag = scconf_get("pursue");
 		if(flag != _RT_OK){
			sclog_error("get config %s error! flag = %d.", "pursue", flag);
			exit(EXIT_FAILURE);
		}
 * �������ڲ� ʹ�õ�ͨ�÷���ֵ ��־
 */
#define _RT_OK		(0)				//�����ȷ�ķ��غ�
#define _RT_EB		(-1)			//���������,���д��󶼿�����,�ڲ�����������
#define _RT_EP		(-2)			//��������
#define _RT_EM		(-3)			//�ڴ�������
#define _RT_EC		(-4)			//�ļ��Ѿ���ȡ��ϻ��ʾ���ӹر�
#define _RT_EF		(-5)			//�ļ���ʧ��

/*
 * 1.1 ����һЩ ͨ�õĺ���ָ�����,��Ҫ���ڻ���ķ�װ��
 * �й��캯��, �ͷź���, �ȽϺ�����
 */
typedef void* (*pnew_f)();
typedef void(*vdel_f)(void* node);
// icmp_f ��� �� int cmp(const void* ln,const void* rn); ��׼�ṹ
typedef int(*icmp_f)();

/*
 * c ����ǿհ��ַ����� true, ���򷵻�false
 * c : ������ int ֵ,����� char ��Χ
 */
#define sh_isspace(c) \
	((c==' ')||(c>='\t'&&c<='\r'))

/*
 *	2.0 ��������� __GNUC__ �ͼٶ��� ʹ��gcc ������,ΪLinuxƽ̨
 * ���� ��Ϊ�� Window ƽ̨,���ɷ��Ϻ��ǳ�ª��
 */
#if defined(__GNUC__)
//���������� Linux ʵ��,�ȴ�������
#include <unistd.h>
#include <sys/time.h>
#define SLEEPMS(m) \
		usleep(m * 1000)
#else 
// ���ﴴ���ȴ����� �Ժ���Ϊ��λ , ��Ҫ��������ϵͳʵ��
#include <Windows.h>
#include <direct.h> // ���ض����ͷ�ļ��� ����׶λ�ȥ��
#define rmdir  _rmdir

/**
*	Linux sys/time.h �л�ȡʱ�亯����Windows��һ����ֲʵ��
**tv	:	���ؽ������������΢����
**tz	:	������ʱ��,��window���������û���ò�����
**		:   Ĭ�Ϸ���0
**/
extern int gettimeofday(struct timeval* tv, void* tz);

//Ϊ�˽�� ��ͨ�ù���
#define localtime_r(t, tm) localtime_s(tm, t)

#define SLEEPMS(m) \
		Sleep(m)
#endif /*__GNUC__ ��ƽ̨�Ĵ��붼�ܳ�ª */

//3.0 ���������жϺ����, __��ͷ��ʾ��ϣ����ʹ�õĺ�
#define __DIFF(x, y)				((x)-(y))					//�������ʽ�����
#define __IF_X(x, z)				((x)<z&&(x)>-z)				//�жϺ�,z�����Ǻ곣��
#define EQ(x, y, c)					EQ_ZERO(__DIFF(x,y), c)		//�ж�x��y�Ƿ�����Χ�����

//3.1 float�ж϶���ĺ�
#define _FLOAT_ZERO				(0.000001f)						//float 0������ж�ֵ
#define EQ_FLOAT_ZERO(x)		__IF_X(x,_FLOAT_ZERO)			//float �ж�x�Ƿ�Ϊ���Ƿ���true
#define EQ_FLOAT(x, y)			EQ(x, y, _FLOAT_ZERO)			//�жϱ��ʽx��y�Ƿ����

//3.2 double�ж϶���ĺ�
#define _DOUBLE_ZERO			(0.000000000001)				//double 0����ж�ֵ
#define EQ_DOUBLE_ZERO(x)		__IF_X(x,_DOUBLE_ZERO)			//double �ж�x�Ƿ�Ϊ���Ƿ���true
#define EQ_DOUBLE(x,y)			EQ(x, y, _DOUBLE_ZERO)			//�жϱ��ʽx��y�Ƿ����

//4.0 ����̨��ӡ������Ϣ, fmt������˫�����������ĺ�
#ifndef CERR
#define CERR(fmt, ...) \
    fprintf(stderr,"[%s:%s:%d][error %d:%s]" fmt "\r\n",\
         __FILE__, __func__, __LINE__, errno, strerror(errno),##__VA_ARGS__)
#endif/* !CERR */

//4.1 ����̨��ӡ������Ϣ���˳�, tͬ��fmt������ ""���������ַ�������
#ifndef CERR_EXIT
#define CERR_EXIT(fmt,...) \
	CERR(fmt,##__VA_ARGS__),exit(EXIT_FAILURE)
#endif/* !ERR */

#ifndef IF_CERR
/*
 *4.2 if �� ������
 *
 * ����:
 *		IF_CERR(fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP), "socket create error!");
 * ���������ӡ��־ֱ���˳�,������Ϊ��һ�ּ�ģ��
 *	code : Ҫ���Ĵ��� 
 *  fmt	 : ������""���������ַ�����
 *	...	 : ����Ĳ���,����printf
 */
#define IF_CERR(code, fmt, ...)	\
	if((code) < 0) \
		CERR_EXIT(fmt, ##__VA_ARGS__)
#endif //!IF_CERR

//5.0 ��ȡ���鳤��,ֻ�����������ͻ�""�ַ�������,���߰���'\0'
#ifndef LEN
#define LEN(arr) \
	(sizeof(arr)/sizeof(*(arr)))
#endif/* !ARRLEN */

//6.0 ���������Ļ����
#ifndef CONSOLE_CLEAR
#ifndef _WIN32
#define CONSOLE_CLEAR() \
		system("printf '\ec'")
#else
#define CONSOLE_CLEAR() \
		system("cls")
#endif/* _WIN32 */
#endif /*!CONSOLE_CLEAR*/

//7.0 �ÿղ���
#ifndef BZERO
//v�����Ǹ�����
#define BZERO(v) \
	memset(&v,0,sizeof(v))
#endif/* !BZERO */	

//9.0 scanf ��׳��
#ifndef SAFETY_SCANF
#define SAFETY_SCANF(scanf_code,...) \
	while(printf(__VA_ARGS__),scanf_code){\
		while(getchar()!='\n');\
		puts("�������,�밴����ʾ���²���!");\
	}\
	while(getchar()!='\n')
#endif /*!SAFETY_SCANF*/

//10.0 �򵥵�time������
#ifndef TIME_PRINT
#define TIME_PRINT(code) {\
	clock_t __st,__et;\
	__st=clock();\
	code\
	__et=clock();\
	printf("��ǰ���������ʱ����:%lf��\n",(0.0+__et-__st)/CLOCKS_PER_SEC);\
}
#endif /*!TIME_PRINT*/

/*
 * 10.1 ������һ�� �� DEBUG ģʽ�µĲ��Ժ� 
 *	
 * �÷� :
 * DEBUG_CODE({
 *		puts("debug start...");	
 * });
 */
#ifndef DEBUG_CODE
# ifdef _DEBUG
#	define DEBUG_CODE(code) code
# else
#	define DEBUG_CODE(code) 
# endif // ! _DEBUG
#endif // !DEBUG_CODE



//11.0 �ȴ��ĺ� ���� �Ѿ��������
#define _STR_PAUSEMSG "�밴���������. . ."
extern void sh_pause(void);
#ifndef INIT_PAUSE

#	ifdef _DEBUG
#		define INIT_PAUSE() atexit(sh_pause)
#	else
#		define INIT_PAUSE()	(void)316 /* ��˵��,�����¿�ʼ�� */
#	endif

#endif/* !INIT_PAUSE */


//12.0 �ж��Ǵ������С����,����򷵻�true
extern bool sh_isbig(void);

/**
*	sh_free - �򵥵��ͷ��ڴ溯��,��free�ٷ�װ��һ��
**���Ա���Ұָ��
**pobj:ָ����ͷ��ڴ��ָ��(void*)
**/
extern void sh_free(void** pobj);

/**
*	��ȡ ��ǰʱ�䴮,������tstr�г��Ȳ�����
**	ʹ�þ���
	char tstr[64];
	puts(gettimes(tstr, LEN(tstr)));
**tstr	: ����������ɵ����
**len	: tstr����ĳ���
**		: ����tstr�׵�ַ
**/
extern int sh_times(char tstr[], int len);

#endif/* ! _H_CHEAD */