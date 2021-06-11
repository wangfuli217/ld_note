#ifndef _H_SIMPLEC_SCHEAD
#define _H_SIMPLEC_SCHEAD

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <errno.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stddef.h>

/*
 * 1.0 错误定义宏 用于判断返回值状态的状态码 _RF表示返回标志
 *	使用举例 : 
 		int flag = scconf_get("pursue");
 		if(flag != _RT_OK) {
			sclog_error("get config %s error! flag = %d.", "pursue", flag);
			exit(EXIT_FAILURE);
		}
 * 这里是内部 使用的通用返回值 标志
 */
#define _RT_OK		(0)				//结果正确的返回宏
#define _RT_EB		(-1)			//错误基类型,所有错误都可用它,在不清楚的情况下
#define _RT_EP		(-2)			//参数错误
#define _RT_EM		(-3)			//内存分配错误
#define _RT_EC		(-4)			//文件已经读取完毕或表示链接关闭
#define _RT_EF		(-5)			//文件打开失败

/*
 * 1.1 定义一些 通用的函数指针帮助,主要用于基库的封装中
 * 有构造函数, 释放函数, 比较函数等
 */
typedef void * (*pnew_f)();
typedef void (*vdel_f)(void* node);
// icmp_f 最好 是 int cmp(const void* ln,const void* rn); 标准结构
typedef int (*icmp_f)();

/*
 * c 如果是空白字符返回 true, 否则返回false
 * c : 必须是 int 值,最好是 char 范围
 */
#define sh_isspace(c) \
	((c==' ')||(c>='\t'&&c<='\r'))

/*
 *	2.0 如果定义了 __GNUC__ 就假定是 使用gcc 编译器,为Linux平台
 * 否则 认为是 Window 平台,不可否认宏是丑陋的
 */
#if defined(__GNUC__)

//下面是依赖 Linux 实现,等待毫秒数
#include <unistd.h>
#include <sys/time.h>

#define SLEEPMS(m) \
		usleep(m * 1000)

// 屏幕清除宏, 依赖系统脚本
#define CONSOLE_CLEAR() \
		system("printf '\ec'")

#else 

// 这里创建等待函数 以毫秒为单位 , 需要依赖操作系统实现
#include <Windows.h>
#include <direct.h> // 加载多余的头文件在 编译阶段会去掉
#define rmdir  _rmdir

#define CONSOLE_CLEAR() \
		system("cls")

/**
*	Linux sys/time.h 中获取时间函数在Windows上一种移植实现
**tv	:	返回结果包含秒数和微秒数
**tz	:	包含的时区,在window上这个变量没有用不返回
**		:   默认返回0
**/
extern int gettimeofday(struct timeval* tv, void* tz);

//为了解决 不通用功能
#define localtime_r(t, tm) localtime_s(tm, t)

#define SLEEPMS(m) \
		Sleep(m)

#endif // !__GNUC__ 跨平台的代码都很丑陋

//3.0 浮点数据判断宏帮助, __开头表示不希望你使用的宏
#define __DIFF(x, y)				((x)-(y))					//两个表达式做差宏
#define __IF_X(x, z)				((x)<z && (x)>-z)			//判断宏,z必须是宏常量
#define EQ(x, y, c)					EQ_ZERO(__DIFF(x,y), c)		//判断x和y是否在误差范围内相等

//3.1 float判断定义的宏
#define _FLOAT_ZERO				(0.000001f)						//float 0的误差判断值
#define EQ_FLOAT_ZERO(x)		__IF_X(x, _FLOAT_ZERO)			//float 判断x是否为零是返回true
#define EQ_FLOAT(x, y)			EQ(x, y, _FLOAT_ZERO)			//判断表达式x与y是否相等

//3.2 double判断定义的宏
#define _DOUBLE_ZERO			(0.000000000001)				//double 0误差判断值
#define EQ_DOUBLE_ZERO(x)		__IF_X(x, _DOUBLE_ZERO)			//double 判断x是否为零是返回true
#define EQ_DOUBLE(x,y)			EQ(x, y, _DOUBLE_ZERO)			//判断表达式x与y是否相等

//4.0 控制台打印错误信息, fmt必须是双引号括起来的宏
#ifndef CERR
#define CERR(fmt, ...) \
    fprintf(stderr,"[%s:%s:%d][error %d:%s]" fmt "\n",\
         __FILE__, __func__, __LINE__, errno, strerror(errno), ##__VA_ARGS__)
#endif // !CERR

//4.1 控制台打印错误信息并退出, t同样fmt必须是 ""括起来的字符串常量
#ifndef CERR_EXIT
#define CERR_EXIT(fmt,...) \
	CERR(fmt, ##__VA_ARGS__),exit(EXIT_FAILURE)
#endif // !CERR_EXIT

//4.2 执行后检测,如果有错误直接退出
#ifndef IF_CHECK
#define IF_CHECK(code) \
	if((code) < 0) \
		CERR_EXIT(#code)
#endif // !IF_CHECK

//5.0 获取数组长度,只能是数组类型或""字符串常量,后者包含'\0'
#ifndef LEN
#define LEN(arr) \
	(sizeof(arr)/sizeof(*(arr)))
#endif/* !ARRLEN */

//7.0 置空操作
#ifndef BZERO
//v必须是个变量
#define BZERO(v) \
	memset(&v,0,sizeof(v))
#endif/* !BZERO */	

//9.0 scanf 健壮的
#ifndef SAFETY_SCANF
#define _STR_SAFETY_SCANF "Input error, please according to the prompt!"
#define SAFETY_SCANF(scanf_code, ...) \
	while(printf(__VA_ARGS__), scanf_code){\
		while('\n' != getchar()) \
			;\
		puts(_STR_SAFETY_SCANF);\
	}\
	while('\n' != getchar())
#endif /*!SAFETY_SCANF*/

//10.0 简单的time帮助宏
#ifndef TIME_PRINT
#define _STR_TIME_PRINT "The current code block running time:%lf seconds\n"
#define TIME_PRINT(code) \
do{\
	clock_t __st, __et;\
	__st=clock();\
	code\
	__et=clock();\
	printf(_STR_TIME_PRINT, (0.0 + __et - __st) / CLOCKS_PER_SEC);\
} while(0)
#endif // !TIME_PRINT

/*
 * 10.1 这里是一个 在 DEBUG 模式下的测试宏 
 *	
 * 用法 :
 * DEBUG_CODE({
 *		puts("debug start...");	
 * });
 */
#ifndef DEBUG_CODE
# ifdef _DEBUG
#	define DEBUG_CODE(code) code
# else
#	define DEBUG_CODE(code) 
# endif	//	! _DEBUG
#endif	//	! DEBUG_CODE

//11.0 等待的宏 是个单线程没有加锁
#define _STR_PAUSEMSG "请按任意键继续. . ."
extern void sh_pause(void);
#ifndef INIT_PAUSE

#	ifdef _DEBUG
#		define INIT_PAUSE() atexit(sh_pause)
#	else
#		define INIT_PAUSE()	/* 别说了,都重新开始吧 */
#	endif

#endif // !INIT_PAUSE

//12.0 判断是大端序还是小端序,大端序返回true
extern bool sh_isbig(void);

/**
*	sh_free - 简单的释放内存函数,对free再封装了一下
**可以避免野指针
**pobj:指向待释放内存的指针(void*)
**/
extern void sh_free(void ** pobj);

/**
*	获取 当前时间串,并塞入tstr中长度并返回 need tstr >= 20, 否则返回NULL
**	使用举例
	char tstr[64];
	sh_times(tstr, LEN(tstr));
	puts(tstr);
**tstr	: 保存最后生成的最后串
**len	: tstr数组的长度
**		: 返回tstr首地址
**/
extern int sh_times(char tstr[], int len);

/*
 * 比较两个结构体栈上内容是否相等,相等返回true,不等返回false
 * a	: 第一个结构体值
 * b	: 第二个结构体值
 *		: 相等返回true, 否则false
 */
#define STRUCTCMP(a, b) \
	(!memcmp(&a, &b, sizeof(a)))

#endif// ! _H_SIMPLEC_SCHEAD