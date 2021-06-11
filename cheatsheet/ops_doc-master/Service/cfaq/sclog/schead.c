#include "schead.h"

//简单通用的等待函数
void 
sh_pause(void) {
	rewind(stdin);
	printf(_STR_PAUSEMSG);
	getchar();
}

//12.0 判断是大端序还是小端序,大端序返回true
bool 
sh_isbig(void) {
	static union {
		unsigned short _s;
		unsigned char _c;
	} __u = { 1 };
	return __u._c == 0;
}

/**
*	sh_free - 简单的释放内存函数,对free再封装了一下
**可以避免野指针
**@pobj:指向待释放内存的指针(void*)
**/
void 
sh_free(void ** pobj) {
	if (pobj == NULL || *pobj == NULL)
		return;
	free(*pobj);
	*pobj = NULL;
}

#if defined(_MSC_VER)
/**
*	Linux sys/time.h 中获取时间函数在Windows上一种移植实现
**tv	:	返回结果包含秒数和微秒数
**tz	:	包含的时区,在window上这个变量没有用不返回
**		:   默认返回0
**/
int 
gettimeofday(struct timeval * tv, void * tz) {
	time_t clock;
	struct tm tm;
	SYSTEMTIME wtm;

	GetLocalTime(&wtm);
	tm.tm_year = wtm.wYear - 1900;
	tm.tm_mon = wtm.wMonth - 1; //window的计数更好写
	tm.tm_mday = wtm.wDay;
	tm.tm_hour = wtm.wHour;
	tm.tm_min = wtm.wMinute;
	tm.tm_sec = wtm.wSecond;
	tm.tm_isdst = -1; //不考虑夏令时
	clock = mktime(&tm);
	tv->tv_sec = (long)clock; //32位使用,接口已经老了
	tv->tv_usec = wtm.wMilliseconds * 1000;

	return _RT_OK;
}
#endif

/**
*	获取 当前时间串,并塞入tstr中C长度并返回
**	使用举例
char tstr[64];
puts(gettimes(tstr, LEN(tstr)));
**tstr	: 保存最后生成的最后串
**len	: tstr数组的长度
**		: 返回tstr首地址
**/
int 
sh_times(char tstr[], int len) {
	struct tm st;
	time_t	t = time(NULL);
	localtime_r(&t, &st);
	return (int)strftime(tstr, len, "%F %X", &st);
}