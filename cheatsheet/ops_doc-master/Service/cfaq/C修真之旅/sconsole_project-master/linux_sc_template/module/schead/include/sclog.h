#ifndef _H_SCLOG
#define _H_SCLOG

//-------------------------------------------------------------------------------------------|
// 第一部分 共用的参数宏
//-------------------------------------------------------------------------------------------|

//
//关于日志切分,需要用第三方插件例如crontab , 或者下次我自己写一个监测程序.
#define _INT_LITTLE				(64)		//保存时间或IP长度
#define _INT_LOG				(1024<<3)	//最多8k日志

#define _STR_SCLOG_PATH			"log"		//日志相对路径目录,如果不需要需要配置成""
#define _STR_SCLOG_LOG			"sc.log"	//普通log日志 DEBUG,INFO,NOTICE,WARNING,FATAL都会输出
#define _STR_SCLOG_WFLOG		"sc.log.wf"	//级别比较高的日志输出 FATAL和WARNING

/**
*	fstr : 为标识串 例如 _STR_SCLOG_FATAL, 必须是双引号括起来的串
** 
** 拼接一个 printf 输出格式串
**/
#define SCLOG_PUTS(fstr)	\
	"%s][" fstr "][%s:%d:%s][logid:%u][reqip:%s][mod:%s]"

#define _STR_SCLOG_FATAL		"FATAL"	    //错误,后端使用
#define _STR_SCLOG_WARNING		"WARNING"	//警告,前端使用错误,用这个	
#define _STR_SCLOG_NOTICE		"NOTICE"	//系统使用,一般标记一条请求完成,使用这个日志
#define _STR_SCLOG_INFO			"INFO"		//普通的日志打印
#define _STR_SCLOG_TRACE		"TRACE"
#define _STR_SCLOG_DEBUG		"DEBUG"	    //测试用的日志打印,在发布版这些日志会被清除掉

/**
*	fstr : 只能是 _STR_SCLOG_* 开头的宏
**	fmt	 : 必须是""括起来的宏.单独输出的格式宏
**	...  : 对映fmt参数集
**	
**  拼接这里使用的宏,为sl_printf 打造一个模板,这里存在一个坑,在Window \n表示 CRLF, Unix就是LF
**/
#define SCLOG_PRINTF(fstr, fmt, ...) \
	sl_printf(SCLOG_PUTS(fstr) fmt "\n", sl_get_times(), __FILE__, __LINE__, __func__, \
		sl_get_logid(), sl_get_reqip(), sl_get_mod(), ##__VA_ARGS__)


/**
*	FATAL... 日志打印宏
**	fmt	: 输出的格式串,需要""包裹起来
**	...	: 后面的参数,服务于fmt
**/
#define SL_FATAL(fmt, ...)	  SCLOG_PRINTF(_STR_SCLOG_FATAL, fmt, ##__VA_ARGS__)
#define SL_WARNING(fmt, ...) SCLOG_PRINTF(_STR_SCLOG_WARNING, fmt, ##__VA_ARGS__)
#define SL_NOTICE(fmt, ...)   SCLOG_PRINTF(_STR_SCLOG_NOTICE, fmt, ##__VA_ARGS__)
#define SL_INFO(fmt, ...)     SCLOG_PRINTF(_STR_SCLOG_INFO, fmt, ##__VA_ARGS__)

// 发布状态下,关闭SL_DEBUG 宏,需要重新编译,没有改成运行时的判断,这个框架主要围绕单机部分多服务器
#if defined(_DEBUG)
#	define SL_TRACE(fmt, ...)    SCLOG_PRINTF(_STR_SCLOG_TRACE, fmt, ##__VA_ARGS__)
#	define SL_DEBUG(fmt, ...)    SCLOG_PRINTF(_STR_SCLOG_DEBUG, fmt, ##__VA_ARGS__)
#else
#	define SL_TRACE(fmt, ...)    (void)0x123	/* 人生难道就是123*/
#	define SL_DEBUG(fmt, ...)	 (void)0xa91	/* 爱过哎 */
#endif

//-------------------------------------------------------------------------------------------|
// 第二部分 对日志信息体操作的get和set,这里隐藏了信息体的实现
//-------------------------------------------------------------------------------------------|


/**
*	线程的私有数据初始化
**
** mod   : 当前线程名称
** reqip : 请求的ip 
** return :	_RT_OK 表示正常,_RF_EM内存分配错误
**/
extern int sl_pecific_init(const char* mod, const char* reqip);

/**
*	重新设置线程计时时间
**	正常返回 _RT_OK, _RT_EM表示内存没有分配
**/
int sl_set_timev(void);

/**
*	获取日志信息体的唯一的logid
**/
unsigned sl_get_logid(void);

/**
*	获取日志信息体的请求ip串,返回NULL表示没有初始化
**/
const char* sl_get_reqip(void);

/**
*	获取日志信息体的时间串,返回NULL表示没有初始化
**/
const char* sl_get_times(void);

/**
*	获取日志信息体的名称,返回NULL表示没有初始化
**/
const char* sl_get_mod(void);



//-------------------------------------------------------------------------------------------|
// 第三部分 对日志系统具体的输出输入接口部分
//-------------------------------------------------------------------------------------------|

/**
*	日志系统首次使用初始化,找对对映日志文件路径,创建指定路径
**返回值具体见 schead.h 中定义的错误类型
**/
extern int sl_start(void);

/**
*		这个函数不希望你使用,是一个内部限定死的日志输出内容.推荐使用相应的宏
**打印相应级别的日志到对映的文件中.
**	
**	format		: 必须是""号括起来的宏,开头必须是 [FALTAL:%s]后端错误
**				[WARNING:%s]前端错误, [NOTICE:%s]系统使用, [INFO:%s]普通信息,
**				[DEBUG:%s] 开发测试用
**
** return	: 返回输出内容长度
**/
int sl_printf(const char* format, ...);

#endif // !_H_SCLOG