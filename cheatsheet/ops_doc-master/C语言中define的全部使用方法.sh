1. 简单的打印功能实现接口常常比较简单(接口的数量和接口的参数数量)。
   复杂的打印功能实现接口往往比较复杂(接口的数量和接口的参数数量)。
   mfs_syslog、mfs_arg_syslog、mfs_errlog、mfs_arg_errlog、mfs_errlog_silent、mfs_arg_errlog_silent：接口个数多(理解也复杂)，接口实现简单
   1.1 调用显式参数确定打印级别，函数名称确定输出对象；             依赖系统message文件rotate
   sd_emerg、sd_alert、sd_crit、sd_err、sd_warn、sd_notice、sd_info、sd_debug：接口个数多(理解却简单)，接口实现复杂
   提供了显性level，隐形输出格式和输出对象两个配置。
   1.2 调用显式函数名称确定打印级别，隐式确定输出格式和输出对象。   提供rotate
   redisLog: 接口个数少，接口实现简单。提供了隐形level和输出对象两个配置。
   1.3 调用显式参数确定打印级别，隐形确定输出对象。                 未提供rotate
   
2. 对操作过程的抽象常常导致操作流程描述认知的难度；使得降低灵活度的同时，降低了可维护性。
   对操作过程的抽象度不高往往导致操作流程描述认知的难度；使得降低灵活度的同时，降低了可维护性。
   2.1 业务不相关模块抽象度高些；业务相关模块抽象度低些。
       数据结构、算法、进程、线程间通信管理模块抽象度高些；缓存数据库或配置文件的管理模块，或模块之间交互流程抽象度低点。
   
3. 非业务性公共接口的增加常常是为了业务性公共接口的简单化；
   如果在增加了非业务性公共接口的同时未能降低业务性接口的复杂度，则得不偿失。
   moosefs：massert直接逻辑不正确(值等于0，则崩溃)、sassert间接逻辑不正确(值等于0，则崩溃)、passert针对指针(值等于0或-1，则崩溃)、
            eassertPOSIX接口errno值(值等于0，则崩溃)、zassert针对线程接口(值不等于0，则崩溃)
   sheepdog：panic(fmt, args...) 用于程序执行，未提供宏隔离。根据if判断进行panic。    判断在外，只管输出和崩溃
             assert(expr)        用于程序执行，提供宏隔离。  值等于0，则崩溃。        判断在内，管输出和崩溃
   
   moosefs非业务性接口较多，sheepdog业务性接口较少。

   redisAssertWithInfo(_c,_o,_e) (值等于0，则退出) 专用于RedisClient
   redisAssert(_e)               (值等于0，则退出) 判断在内，管输出和崩溃
   redisPanic(_e)                                  判断在外，只管输出和崩溃

4. 折中： 抽象促使代码量减少，往往会使代码短期修改难度增加，促使维护难度增加。
          具体促使代码量增加，常常会使代码长期受冗余，晦涩困扰，促使维护难度增加。
程序设计的艺术其实就是折中的艺术。每个人知识面不同，遇到的问题不同，折中出来的效果千差万别，所以称为艺术。
对外则是协议设计，接口设计和模块化设计的艺术。对内则是功能和接口的统一，使得模块化。
4.1 多路IO处理机制的折中        
dnsmasq和moosefs中poll机制：网络连接并发有限，整体数据处理性能低些，可是模块化性很强。
libevent,redis和tcpcopy中poll机制：网络并发量较大，整体数据处理性能高些，可是模块化较低。
4.2 内存和磁盘速度、容量的折中  
moosefs的mfsmaster单线程处理mfsmount,mfschunkserver,mfsmetalogger的请求，因为元数据信息都存放在内存中。
mfsmount的数据发送和接收都是多线程的请求，元数据的请求为单线程的，因为数据存放在磁盘上，而元数据存放在内存中。
内存和磁盘速度、容量的不同，设计程序要以IO接口为对象进行设计。本质需要折中内存和磁盘的不同。
4.3 程序设计的外部依赖性的折中
redis程序自己实现多路IO处理，封装了poll,epoll,evport等机制。
memacehed程序依赖libevent的多路IO处理，调用libevent的接口功能。
redis程序的Makefile文件完全手写；
moosefs程序的Makefile文件由configure命令依赖Makefile.in生成。

5. 宏定义函数定义和声明，过程定义。 do {} while

6. 检查单： 




////////////////////////////////////////////////////////////////////////////////////////////////////////
3.define的单行定义
#include <stdio.h>
#define paster( n ) printf( "token " #n" = %d\n ", token##n )
int main()
{
int token9=10;
paster(9);
return 0;
}
#define语句中的#是把参数字符串化，##是连接两个参数成为一个整体。
                           字符串化 字符串连接
#define FACTORY_REF(name) { #name, Make##name }
中#name就是将传入的name进行字符串化，Make##name就是将Make跟name进行连接，使它们成为一个整体。

__VA_ARGS__(自定义调试信息的输出)
{

qDebug( "[模块名称] 调试信息  File:%s, Line:%d", __FILE__, __LINE__ );
#define qWiFiDebug(format, ...) qDebug("[WiFi] "format" File:%s, Line:%d, Function:%s", ##__VA_ARGS__, __FILE__, __LINE__ , __FUNCTION__);

上面的宏是使用qDebug输出调试信息，在非Qt的程序中也可以改为printf，守护进程则可以改为syslog等等...  其中，
决窍其实就是这几个宏 ##__VA_ARGS__, __FILE__, __LINE__ 和__FUNCTION__,下面介绍一下这几个宏:
　　1)  __VA_ARGS__ 是一个可变参数的宏，很少人知道这个宏，这个可变参数的宏是新的C99规范中新增的，目前似乎只有gcc支持
       （VC6.0的编译器不支持）。宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用,
       否则会编译出错, 你可以试试。
　　2) __FILE__ 宏在预编译时会替换成当前的源文件名
　　3) __LINE__宏在预编译时会替换成当前的行号
　　4) __FUNCTION__宏在预编译时会替换成当前的函数名称
　　有了以上这几个宏，特别是有了__VA_ARGS__ ，调试信息的输出就变得灵活多了。

redis和moosefs使用宏__VA_ARGS__的时候，没有使用##这种方式，使得moosefs和redis打印的时候，要区分格式化输出和字符串直接输出。
sheepdog使用__VA_ARGS__的时候，使用了##这种方式，主要两个地方：
1. zookeeper.c
sd_err("failed, " fmt ", %s", ##__VA_ARGS__, zerror(__rc));
2. logger.h
#define sd_err(fmt, args...) \
	log_write(SDOG_ERR, __func__, __LINE__, fmt, ##args)
void log_write(int prio, const char *func, int line, const char *fmt, ...)


}


network()
{



#define FACTORY_CREATE(name) \
static sp<MediaSource> Make##name(const sp<MediaSource> &source) { \ 
     return new name(source); \
}\
#define FACTORY_CREATE_ENCODER(name) \
static sp<MediaSource> Make##name(const sp<MediaSource> &source, const sp<MetaData> &meta) { \ 
    return new name(source, meta); \
}\
#define FACTORY_REF(name) 
{#name,Make##name},
FACTORY_CREATE(MP3Decoder)
FACTORY_CREATE(AMRNBDecoder)
FACTORY_CREATE(AMRWBDecoder)
FACTORY_CREATE(AACDecoder)
FACTORY_CREATE(AVCDecoder)
FACTORY_CREATE(G711Decoder)
FACTORY_CREATE(M4vH263Decoder)
FACTORY_CREATE(VorbisDecoder)
FACTORY_CREATE(VPXDecoder)
FACTORY_CREATE_ENCODER(AMRNBEncoder)
FACTORY_CREATE_ENCODER(AMRWBEncoder)
FACTORY_CREATE_ENCODER(AACEncoder)
FACTORY_CREATE_ENCODER(AVCEncoder)
FACTORY_CREATE_ENCODER(M4vH263Encoder)
}


moosefs(总结)
{

1. 配置文件解析cfg。(对C语言处理过程中接口调用的抽象，其中数据处理流程部分由C语言实现)
1.1 宏实现字符串类型到整数、double、无符号整数类型的转换。
1.2 宏实现当前配置和默认配置之间的选择。
1.3 宏实现函数声明和函数定义对应关系。
关注点：参数类型，参数名称，函数名称，返回值类型几方面。 "##"

2. 打印输出函数slogger。(宏处理中，从"..." 到__VA_ARGS__的转换)
2.1 宏实现参数是否有、前后台打印、优先级设置、错误码输出否的定义。

3. 断言输出函数massert。(宏处理中，__FILE__,__LINE__以及__func__和字符串化输入参数)
3.2 宏实现输出文件名、行名和错误变量名情况下，提供了断言类型、errno值、异常打印、提示方式的输出定义。 "#"

4. 函数重定义bgjob, filesystem。(宏处理中，函数参数特殊化后，函数功能面向特定对象或者功能满足调用接口)
4.1 重定义函数。
关注点：参数个数变化。

5. 哈希表数据结构 bucket，(宏处理中，对C语言处理过程中接口调用的抽象，其中数据处理流程部分由C语言实现)
5.1 哈希表实现。
关注点：参数类型，参数名称，函数名称，返回值类型几方面。"##"

6. 测试mfstest，(对C语言处理过程中接口调用的抽象，其中数据处理流程部分由宏实现)
6.1 宏实现整数类型(uint8,uint16,uint32,int8,int16,int32,double)之间的比较(==,!=,<,<=,>,>=)抽象，
关注点：参数类型，参数名称，函数名称，返回值类型几方面。 "#"

7. MFSCommunication，
7.1 宏实现数据报文类型字段的定义。
7.2 宏实现对象属性字段的枚举。可以为数值、字符或者字符串。
注意点：宏名称。
        协议错误值宏定义。

8. offsetof 
关注点：动态数组和联合体, "节省内存"，"将两个数据结构合并成一个数据结构"。

9. ERRNO_ERROR，errno值比对；
   SO_ACCEPTFILTER 编译功能选择

}
moosefs(cfg)
{
1. isspace包括：空格(' ')、form-feed('\f')、新行('\n')、回车('\r')和水平制表符('\t')、垂直制表符('\v')。
2. 行内空格字符为' '和'\t'，行内非空格字符为>32和<127的所有字符。

    先将字符串(文件的一行数据fgets)解释成 name 和 value 两个字符串；然后根据 name 名称，将 value 解释成定义的类型。
name 和 value 字符串的开始位置使用' '和'\t'进行判定、结束位置使用>32和<127的字符进行判定。其中又通过 '=' 对两个
字符串进行分割。将解释出来的name和value存放到paramstr结构体中。
    value字符串以'\0'，'\r'，'\n'，'#'表示行解释中value的结束。

关键字：'\0','\r','\n','#','\t',' ',以及32 127 fgets while.
原则：  如果name不存在，添加到链表中；如果name已经存在，从链表中释放name和value，将新添加到覆盖原先添加的。


函数声明部分：
#define _CONFIG_MAKE_PROTOTYPE(fname,type) type cfg_get##fname(const char *name,type def)
                    名字部分 返回值类型       返回值类型实例
_CONFIG_MAKE_PROTOTYPE(str,char*);            char*字符串
_CONFIG_MAKE_PROTOTYPE(num,int);              int类型
_CONFIG_MAKE_PROTOTYPE(uint8,uint8_t);        uint8_t类型
_CONFIG_MAKE_PROTOTYPE(int8,int8_t);          int8_t类型
_CONFIG_MAKE_PROTOTYPE(uint16,uint16_t);      uint16_t
_CONFIG_MAKE_PROTOTYPE(int16,int16_t);        int16_t类型
_CONFIG_MAKE_PROTOTYPE(uint32,uint32_t);      uint32_t类型
_CONFIG_MAKE_PROTOTYPE(int32,int32_t);        int32_t类型
_CONFIG_MAKE_PROTOTYPE(uint64,uint64_t);      uint64_t类型
_CONFIG_MAKE_PROTOTYPE(int64,int64_t);        int64_t类型
_CONFIG_MAKE_PROTOTYPE(double,double);        double类型

函数实现部分：
#define _CONFIG_GEN_FUNCTION(fname,type,convname,format) 
                  名字部分 返回值类型 转换函数名字 格式化方式
_CONFIG_GEN_FUNCTION(str,char*,charptr,"%s")
_CONFIG_GEN_FUNCTION(num,int,int,"%d")
_CONFIG_GEN_FUNCTION(int8,int8_t,int32,"%"PRId8)
_CONFIG_GEN_FUNCTION(uint8,uint8_t,uint32,"%"PRIu8)
_CONFIG_GEN_FUNCTION(int16,int16_t,int32,"%"PRId16)
_CONFIG_GEN_FUNCTION(uint16,uint16_t,uint32,"%"PRIu16)
_CONFIG_GEN_FUNCTION(int32,int32_t,int32,"%"PRId32)
_CONFIG_GEN_FUNCTION(uint32,uint32_t,uint32,"%"PRIu32)
_CONFIG_GEN_FUNCTION(int64,int64_t,int64,"%"PRId64)
_CONFIG_GEN_FUNCTION(uint64,uint64_t,uint64,"%"PRIu64)
_CONFIG_GEN_FUNCTION(double,double,double,"%lf")

转换                          
#define STR_TO_int(x) return strtol(x,NULL,0)        有符号整形
#define STR_TO_int32(x) return strtol(x,NULL,0)      有符号整形
#define STR_TO_uint32(x) return strtoul(x,NULL,0)    无符号整形
#define STR_TO_int64(x) return strtoll(x,NULL,0)     有符号长整形
#define STR_TO_uint64(x) return strtoull(x,NULL,0)   无符号长整形
#define STR_TO_double(x) return strtod(x,NULL)       浮点类型
#define STR_TO_charptr(x)                            字符串类型

复制
#define COPY_int(x) return x                        有符号整形
#define COPY_int32(x) return x                      有符号整形
#define COPY_uint32(x) return x                     无符号整形
#define COPY_int64(x) return x                      有符号长整形
#define COPY_uint64(x) return x                     无符号长整形
#define COPY_double(x) return x                     浮点类型
#define COPY_charptr(x) {                           字符串类型

}

moosefs(slogger)
{
                        [参数]   [前后台打印]   [优先级]   [错误码]
mfs_syslog              必须无    前后台打印      支持       没有
mfs_arg_syslog          必须有    前后台打印      支持       没有
mfs_errlog              必须无    前后台打印      支持         有
mfs_arg_errlog          必须有    前后台打印      支持         有
mfs_errlog_silent       必须无     后台打印       支持         有
mfs_arg_errlog_silent   必须无     后台打印       支持         有
}

moosefs(massert)
{
文件名，行名和错误变量名
           [类型]     [errno]     [异常打印]        [提示方式]      
massert    整数         没有       等0                参传递        
sassert    整数         没有       等0                无参数        
passert    指针         没有       等于NULL或-1       无参数        内存申请
eassert  整数和指针     有         等0                无参数        系统调用read和write
zassert    整数         有         不等0              无参数        线程接口专用，关注返回值和异常错误
}

moosefs(bgjob, filesystem)
{
函数重定义
#define job_delete(_cb,_ex,_chunkid,_version) job_chunkop(_cb,_ex,_chunkid,_version,0,0,0,0)
#define job_create(_cb,_ex,_chunkid,_version) job_chunkop(_cb,_ex,_chunkid,_version,0,0,0,1)
#define job_test(_cb,_ex,_chunkid,_version) job_chunkop(_cb,_ex,_chunkid,_version,0,0,0,2)
#define job_version(_cb,_ex,_chunkid,_version,_newversion) (((_newversion)>0)?job_chunkop(_cb,_ex,_chunkid,_version,_newversion,0,0,0xFFFFFFFF):job_inval(_cb,_ex))
#define job_truncate(_cb,_ex,_chunkid,_version,_newversion,_length) (((_newversion)>0&&(_length)!=0xFFFFFFFF)?job_chunkop(_cb,_ex,_chunkid,_version,_newversion,0,0,_length):job_inval(_cb,_ex))
#define job_duplicate(_cb,_ex,_chunkid,_version,_newversion,_copychunkid,_copyversion) (((_newversion>0)&&(_copychunkid)>0)?job_chunkop(_cb,_ex,_chunkid,_version,_newversion,_copychunkid,_copyversion,0xFFFFFFFF):job_inval(_cb,_ex))
#define job_duptrunc(_cb,_ex,_chunkid,_version,_newversion,_copychunkid,_copyversion,_length) (((_newversion>0)&&(_copychunkid)>0&&(_length)!=0xFFFFFFFF)?job_chunkop(_cb,_ex,_chunkid,_version,_newversion,_copychunkid,_copyversion,_length):job_inval(_cb,_ex))

函数重定义
#define fsnode_dir_malloc() fsnode_malloc(0)
#define fsnode_file_malloc() fsnode_malloc(1)
#define fsnode_symlink_malloc() fsnode_malloc(2)
#define fsnode_dev_malloc() fsnode_malloc(3)
#define fsnode_other_malloc() fsnode_malloc(4)

#define fsnode_dir_free(n) fsnode_free(n,0)
#define fsnode_file_free(n) fsnode_free(n,1)
#define fsnode_symlink_free(n) fsnode_free(n,2)
#define fsnode_dev_free(n) fsnode_free(n,3)
#define fsnode_other_free(n) fsnode_free(n,4)
}

moosefs(bucket)
{
哈希函数 
                                  函数集名字     存储对象    哈希表大小
#define CREATE_BUCKET_ALLOCATOR(allocator_name,element_type,bucket_size)
CREATE_BUCKET_ALLOCATOR(slist,slist,5000)
slist_malloc();
slist_free();
slist_free_all();
slist_getusage();

}

moosefs(mfstest)
{
                       类型 打印 参数1 比较方式 参数2
#define mfstest_assert(type,pri,arg1,op,arg2) { \
	type _arg1,_arg2; \
	_arg1 = (arg1); \
	_arg2 = (arg2); \
	if (_arg1 op _arg2) { \
		mfstest_passed++; \
	} else { \
		mfstest_failed++; \
		mfstest_result = 1; \
		printf("%s","Assertion '" STR(arg1) "" STR(op) "" STR(arg2) "' failed: \n"); \
		printf("'%s' == %" pri ", '%s' == %" pri "\n",STR(arg1),_arg1,STR(arg2),_arg2); \
	} \
}

#define mfstest_start(name) { \
	printf("%s","Starting test: " STR(name) "\n"); \
	mfstest_passed = mfstest_failed = 0; \
}

#define mfstest_end() printf("%u%%: Checks: %" PRIu32 ", Failures: %" PRIu32 "\n",100*mfstest_passed/(mfstest_passed+mfstest_failed),(mfstest_passed+mfstest_failed),mfstest_failed)

比较方式：大于，小于，等于，不等于，大于等于，小于等于。
}

moosefs(MFSCommunication)
{
协议，

ERROR_STRINGS：动态数组。

}

moosefs(offsetof)
{
offsetof： 字段在结构体中的内存偏移值。

malloc(offsetof(in_packetstruct,data)+leng);
offsetof(fsnode,data)+offsetof(struct _ddata,end);
关注点：动态数组和联合体

}

moosefs(sockets)
{


#ifdef EWOULDBLOCK
#  define ERRNO_ERROR (errno!=EAGAIN && errno!=EWOULDBLOCK)
#else
#  define ERRNO_ERROR (errno!=EAGAIN)
#endif

SO_ACCEPTFILTER
}


sheepdog(总结)
{
utils输出字符串颜色，数值比较和数据查找
1.1 枚举字符串显示颜色。
1.2. min,max,intcmp定义比较函数。
关注点：typeof，能在编译时：根据输入参数，确定输入类型。
1.3. xqsort、xbsearch、xlfind、xlremove是对qsort,bsearch,lfind和lremove的重新封装
关注点：typeof，能在编译时：根据输入参数，确定输入类型。
        __ret、__removed为宏定义处理过程的返回值，在处理最后一行声明。

2. compile编译器选项重新定义
   likely(x)\unlikely(x) 和__attribute属性
关注点：__attribute，syscall，__builtin_expect

3. sheepdog_proto internel_proto
    sheepdog的外部通信协议和内部通信协议,数据报文类型定义。
    位处理功能：
关注点："<<" 左移， MASK掩码位，
    协议处理返回值定义；

4. list.h 定义了部分hlist_head、hlist_node
   list_node操作；
关注点：大写函数名处理单节点数据结构初始化和赋值。
        小写函数名处理节点之间关联关系。

5. rbtree.h 定义了部分rb_node,rb_root操作；
关注点：大写函数名处理单节点数据结构初始化、赋值、比较。
        小写函数名处理节点之间关联关系。        
        
6. logger.h 与moosefs相比而言，更在意输出级别。

}

sheepdog(utils)
{
颜色
#define TEXT_NORMAL         "\033[0m"
#define TEXT_BOLD           "\033[1m"
#define TEXT_RED            "\033[0;31m"
#define TEXT_BOLD_RED       "\033[1;31m"
#define TEXT_GREEN          "\033[0;32m"
#define TEXT_BOLD_GREEN     "\033[1;32m"
#define TEXT_YELLOW         "\033[0;33m"
#define TEXT_BOLD_YELLOW    "\033[1;33m"
#define TEXT_BLUE           "\033[0;34m"
#define TEXT_BOLD_BLUE      "\033[1;34m"
#define TEXT_MAGENTA        "\033[0;35m"
#define TEXT_BOLD_MAGENTA   "\033[1;35m"
#define TEXT_CYAN           "\033[0;36m"
#define TEXT_BOLD_CYAN      "\033[1;36m"

#define CLEAR_SCREEN        "\033[2J"
#define RESET_CURSOR        "\033[1;1H"


#define min(x, y) 
#define max(x, y)
#define intcmp(x, y)

#define xqsort(base, nmemb, compar)	
#define xbsearch(key, base, nmemb, compar)
#define xlfind(key, base, nmemb, compar)
#define xlremove(key, base, nmemb, compar)
#define assert(expr)

}

sheepdog(compile)
{
数组大小
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
一个特殊的变量名
#define __LOCAL(var, line) __ ## var ## line
#define _LOCAL(var, line) __LOCAL(var, line)
#define LOCAL(var) _LOCAL(var, __LINE__)
container_of
#define container_of(ptr, type, member) ({			\
	const typeof(((type *)0)->member) *__mptr = (ptr);	\
	(type *)((char *)__mptr - offsetof(type, member)); })
likely和unlikely
#define likely(x)       __builtin_expect(!!(x), 1)
#define unlikely(x)     __builtin_expect(!!(x), 0)
gcc内存对齐
#define __packed __attribute((packed))
gcc调用方式
#define asmlinkage  __attribute__((regparm(0)))
打印方式
#define __printf(a, b) __attribute__((format(printf, a, b)))

/* Force a compilation error if the condition is true */
#define BUILD_BUG_ON(condition) ((void)sizeof(struct { int: -!!(condition); }))

#define __must_check            __attribute__((warn_unused_result))

syscall(__NR_eventfd2, initval, flags);
}


sheepdog(sheepdog_proto internel_proto)
{
协议

字段功能
/*
 * Object ID rules
 *
 *  0 - 19 (20 bits): data object space
 * 20 - 31 (12 bits): reserved data object space
 * 32 - 55 (24 bits): VDI object space
 * 56 - 59 ( 4 bits): reserved VDI object space
 * 60 - 63 ( 4 bits): object type indentifier space
 */
#define VDI_SPACE_SHIFT   32
#define SD_VDI_MASK 0x00FFFFFF00000000
#define VDI_BIT (UINT64_C(1) << 63)
#define VMSTATE_BIT (UINT64_C(1) << 62)
#define VDI_ATTR_BIT (UINT64_C(1) << 61)
#define MAX_DATA_OBJS (1ULL << 20)
#define MAX_CHILDREN 1024U
#define SD_MAX_VDI_LEN 256U
#define SD_MAX_VDI_TAG_LEN 256U
#define SD_MAX_VDI_ATTR_KEY_LEN 256U
#define SD_MAX_VDI_ATTR_VALUE_LEN 65536U
#define SD_MAX_SNAPSHOT_TAG_LEN 256U
#define SD_NR_VDIS   (1U << 24)
#define SD_DATA_OBJ_SIZE (UINT64_C(1) << 22)
#define SD_MAX_VDI_SIZE (SD_DATA_OBJ_SIZE * MAX_DATA_OBJS)
}


sheepdog(list)
{
大写函数名处理单节点数据结构初始化和赋值。
小写函数名处理节点之间关联关系。
1. hlist_head、hlist_node
HLIST_HEAD_INIT
HLIST_HEAD
INIT_HLIST_HEAD
hlist_entry
hlist_for_each
hlist_for_each_entry

2. list_node
LIST_HEAD_INIT
LIST_NODE_INIT
LIST_HEAD
LIST_NODE
list_first_entry
list_entry
list_for_each
list_for_each_entry

}

sheepdog(rbtree)
{
RB_ROOT
INIT_RB_ROOT
RB_EMPTY_ROOT
RB_EMPTY_NODE
RB_CLEAR_NODE

rb_search
rb_insert
rb_nsearch
rb_for_each
rb_for_each_entry
rb_destroy
}

sheepdog(logger)
{


#define	SDOG_EMERG	LOG_EMERG
#define	SDOG_ALERT	LOG_ALERT
#define	SDOG_CRIT	LOG_CRIT
#define	SDOG_ERR	LOG_ERR
#define	SDOG_WARNING	LOG_WARNING
#define	SDOG_NOTICE	LOG_NOTICE
#define	SDOG_INFO	LOG_INFO
#define	SDOG_DEBUG	LOG_DEBUG

#define sd_emerg(fmt, args...) 
#define sd_alert(fmt, args...) 
#define sd_crit(fmt, args...) 
#define sd_err(fmt, args...)
#define sd_warn(fmt, args...)
#define sd_notice(fmt, args...)
#define sd_info(fmt, args...) 
#define sd_debug(fmt, args...)
#define panic(fmt, args...)	

log_write(SDOG_DEBUG, __func__, __LINE__, fmt, ##args);
log_write(int prio, const char *func, int line, const char *fmt, ...)
    dolog(int prio, const char *func, int line, const char *fmt, va_list ap)
    
在log_write根据打印级别进行打印输出；在dolog根据输出IO选择进行输出。(打印附加时间信息和线程PID值)。
   打印级别可以在进程启动时刻和运行时刻进行修改(通过config set loglevel <[warning|notice|verbose|debug]>)。
}

redis(总结)
{
1. rb (对C语言处理过程中接口调用的抽象，其中数据处理流程部分由C语言实现)
2. redisLog(int level, const char *fmt, ...)  返回值定义、
   redisLogRaw(int level, const char *msg)
   在redisLogRaw根据打印级别进行打印输出；根据输出IO选择进行输出。(打印附加时间信息和进程PID值)。
   打印级别可以在进程启动时刻和运行时刻进行修改(通过config set loglevel <[warning|notice|verbose|debug]>)。
3. adlist.h 对象字段的设置、获取、判断。
4. ac.h     返回值定义、枚举参数定义和特定功能选择
5. anet.h   返回值定义、枚举参数定义和特定功能选择
6. dict.h   返回值定义.

}

redis(rb.h)
{


#define	rb_gen(a_attr, a_prefix, a_rbt_type, a_type, a_field, a_cmp)
rb_gen(static UNUSED, arena_run_tree_, arena_run_tree_t, arena_chunk_map_t,
    u.rb_link, arena_run_comp)
rb_gen(static UNUSED, arena_avail_tree_, arena_avail_tree_t, arena_chunk_map_t,
    u.rb_link, arena_avail_comp)
rb_gen(static UNUSED, arena_chunk_dirty_, arena_chunk_tree_t, arena_chunk_t,
    dirty_link, arena_chunk_dirty_comp)
rb_gen(, extent_tree_szad_, extent_tree_t, extent_node_t, link_szad,
    extent_szad_comp)
rb_gen(, extent_tree_ad_, extent_tree_t, extent_node_t, link_ad,
    extent_ad_comp)


}

redis(redis.h)
{

#define REDIS_OK                0
#define REDIS_ERR               -1

#define redisAssertWithInfo(_c,_o,_e) ((_e)?(void)0 : (_redisAssertWithInfo(_c,_o,#_e,__FILE__,__LINE__),_exit(1)))
#define redisAssert(_e) ((_e)?(void)0 : (_redisAssert(#_e,__FILE__,__LINE__),_exit(1)))
#define redisPanic(_e) _redisPanic(#_e,__FILE__,__LINE__),_exit(1)

void redisLog(int level, const char *fmt, ...);

}

redis(adlist.h)
{


#define listLength(l) ((l)->len)
#define listFirst(l) ((l)->head)
#define listLast(l) ((l)->tail)
#define listPrevNode(n) ((n)->prev)
#define listNextNode(n) ((n)->next)
#define listNodeValue(n) ((n)->value)
#define listSetDupMethod(l,m) ((l)->dup = (m))
#define listSetFreeMethod(l,m) ((l)->free = (m))
#define listSetMatchMethod(l,m) ((l)->match = (m))
#define listGetDupMethod(l) ((l)->dup)
#define listGetFree(l) ((l)->free)
#define listGetMatchMethod(l) ((l)->match)
}

redis(ac.h)
{


#define AE_OK 0
#define AE_ERR -1

#define AE_NONE 0
#define AE_READABLE 1
#define AE_WRITABLE 2


#define AE_FILE_EVENTS 1
#define AE_TIME_EVENTS 2
#define AE_ALL_EVENTS (AE_FILE_EVENTS|AE_TIME_EVENTS)

#define AE_DONT_WAIT 4
#define AE_NOMORE -1
#define AE_NOTUSED(V) ((void) V)

}

redis(anet.h)
{

#define ANET_OK 0
#define ANET_ERR -1
#define ANET_ERR_LEN 256

#define ANET_NONE 0
#define ANET_IP_ONLY (1<<0)

#define ANET_CONNECT_NONE 0
#define ANET_CONNECT_NONBLOCK 1

}

redis(dict.h)
{
#define DICT_OK 0
#define DICT_ERR 1

#define DICT_NOTUSED(V) ((void) V)

}