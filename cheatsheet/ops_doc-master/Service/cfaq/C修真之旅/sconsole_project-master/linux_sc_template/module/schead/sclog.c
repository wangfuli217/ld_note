#include <sclog.h>
#include <schead.h>
#include <scatom.h>
#include <pthread.h>
#include <stdarg.h>

//-------------------------------------------------------------------------------------------|
// 第二部分 对日志信息体操作的get和set,这里隐藏了信息体的实现
//-------------------------------------------------------------------------------------------|

//线程私有数据 __lkey, __lonce为了__lkey能够正常初始化
static pthread_key_t __lkey;
static pthread_once_t __lonce = PTHREAD_ONCE_INIT;
static unsigned __logid = 0; //默认的全局logid,唯一标识

//内部简单的释放函数,服务于pthread_key_create 防止线程资源泄露
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
	unsigned		logid;					//请求的logid,唯一id
	char			reqip[_INT_LITTLE];		//请求方ip
	char			times[_INT_LITTLE];		//当前时间串
	struct timeval	timev;					//处理时间,保存值,统一用毫秒
	char			mod[_INT_LITTLE];		//当前线程的模块名称,不能超过_INT_LITTLE - 1
};

/**
*	线程的私有数据初始化
**
** mod   : 当前线程名称
** reqip : 请求的ip
** return :	_RT_OK 表示正常,_RF_EM内存分配错误
**/
int
sl_pecific_init(const char* mod, const char* reqip)
{
	struct slinfo* pl;

	//保证 __gkey只被执行一次
	pthread_once(&__lonce, __gkey);

	if((pl = pthread_getspecific(__lkey)) == NULL){
		//重新构建
		if ((pl = malloc(sizeof(struct slinfo))) == NULL)
			return _RT_EM;

		//printf("pthread 0x%p:0x%p create!\n", pthread_self().p,pl);
	}

	gettimeofday(&pl->timev, NULL);
	pl->logid = ATOM_ADD_FETCH(__logid, 1); //原子自增
	strcpy(pl->mod, mod); //复制一些数据
	strcpy(pl->reqip, reqip);
	
	//设置私有变量
	pthread_setspecific(__lkey, pl);

	return _RT_OK;
}

/**
*	重新设置线程计时时间
**	正常返回 _RT_OK, _RT_EM表示内存没有分配
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
*	获取日志信息体的唯一的logid
**/
unsigned 
sl_get_logid(void)
{
	struct slinfo* pl = pthread_getspecific(__lkey);
	if (NULL == pl) //返回0表示没有找见
		return 0u;
	return pl->logid;
}

/**
*	获取日志信息体的请求ip串,返回NULL表示没有初始化
**/
const char* 
sl_get_reqip(void)
{
	struct slinfo* pl = pthread_getspecific(__lkey);
	if (NULL == pl) //返回NULL表示没有找见
		return NULL;
	return pl->reqip;
}

/**
*	获取日志信息体的时间串,返回NULL表示没有初始化
**/
const char* 
sl_get_times(void)
{
	struct timeval et; //记录时间
	unsigned td;

	struct slinfo* pl = pthread_getspecific(__lkey);
	if (NULL == pl) //返回NULL表示没有找见
		return NULL;

	gettimeofday(&et, NULL);
	//同一用微秒记
	td = 1000000 * (et.tv_sec - pl->timev.tv_sec) + et.tv_usec - pl->timev.tv_usec;
	snprintf(pl->times, LEN(pl->times), "%u", td);

	return pl->times;
}

/**
*	获取日志信息体的名称,返回NULL表示没有初始化
**/
const char* 
sl_get_mod(void)
{
	struct slinfo* pl = pthread_getspecific(__lkey);
	if (NULL == pl) //返回NULL表示没有找见
		return NULL;
	return pl->mod;
}


//-------------------------------------------------------------------------------------------|
// 第三部分 对日志系统具体的输出输入接口部分
//-------------------------------------------------------------------------------------------|

//错误重定向宏 具体应用 于 "mkdir -p \"" _STR_SCLOG_PATH "\" >" _STR_TOOUT " 2>" _STR_TOERR
#define _STR_TOOUT "__out__"
#define _STR_TOERR "__err__"
#define _STR_LOGID "__lid__" //保存logid,持久化

static struct { //内部用的私有变量
	FILE* log;
	FILE* wf;
	bool isdir;	//标志是否创建了目录
} __slmain;

/**
*	日志关闭时候执行,这个接口,关闭打开的文件句柄
**/
static void __sl_end(void)
{
	FILE* lid;
	void* pl;

	// 在简单地方多做安全操作值得,在核心地方用算法优化的才能稳固
	if (!__slmain.isdir)
		return;

	//重置当前系统打开文件结构体
	fclose(__slmain.log);
	fclose(__slmain.wf);
	BZERO(__slmain);

	//写入文件
	lid = fopen(_STR_LOGID, "w");
	if (NULL != lid) {
		fprintf(lid, "%u", __logid);
		fclose(lid);
	}

	//主动释放私有变量,其实主进程 相当于一个线程是不合理的!还是不同的生存周期的
	pl = pthread_getspecific(__lkey);
	__slinfo_destroy(pl);
	pthread_setspecific(__lkey, NULL);
}

/**
*	日志系统首次使用初始化,找对对映日志文件路径,创建指定路径
**返回值具体见 schead.h 中定义的错误类型
**/
int 
sl_start(void)
{
	FILE *lid;

	//单例只执行一次
	if (!__slmain.isdir) {
		__slmain.isdir = true;
		//先多级创建目录,简易不借助宏实现跨平台,system返回值是很复杂,默认成功!
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
	//继续打开 wf 文件
	if (NULL == __slmain.wf) {
		__slmain.wf = fopen(_STR_SCLOG_PATH "/" _STR_SCLOG_WFLOG, "a+");
		if (NULL == __slmain.wf) {
			fclose(__slmain.log); //其实这都没有必要,图个心安
			CERR_EXIT("__slmain.log fopen %s error!", _STR_SCLOG_WFLOG);
		}
	}

	//读取文件内容
	if ((lid = fopen(_STR_LOGID, "r")) != NULL) { //读取文件内容,持久化
		fscanf(lid, "%u", &__logid);
	}

	//这里可以单独开启一个线程或进程,处理日志整理但是 这个模块可以让运维做,按照规则搞
	sl_pecific_init("main thread","0.0.0.0");

	//注册退出操作
	atexit(__sl_end);

	return _RT_OK;
}

int 
sl_printf(const char* format, ...)
{
	char tstr[_INT_LITTLE];// [%s] => [2016-01-08 23:59:59]
	int len;
	va_list ap;
	char logs[_INT_LOG]; //这个不是一个好的设计,最新c 中支持 int a[n];

	if (!__slmain.isdir) {
		CERR("%s fopen %s | %s error!",_STR_SCLOG_PATH, _STR_SCLOG_LOG, _STR_SCLOG_WFLOG);
		return _RT_EF;
	}

	//初始化参数

	sh_times(tstr, _INT_LITTLE - 1);
	len = snprintf(logs, LEN(logs), "[%s ", tstr);
	va_start(ap, format);
	vsnprintf(logs + len, LEN(logs) - len, format, ap);
	va_end(ap);

	// 写普通文件 log
	fputs(logs, __slmain.log); //把锁机制去掉了,fputs就是线程安全的

	// 写警告文件 wf
	if (format[4] == 'F' || format[4] == 'W') { //当为FATAL或WARNING需要些写入到警告文件中
		fputs(logs, __slmain.wf);
	}

	return _RT_OK;
}