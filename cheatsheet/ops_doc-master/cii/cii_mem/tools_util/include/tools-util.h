/*****************************************************************************************
 *	@file	pic_trans.c
 *	@note	2012-2016 sipn.cn All Right Reserved.
 *	@brief	简要说明
 *			
 *	@author	蒋仕鹏 (jiangshipeng@hikvision.com.cn)
 *	@date	2015-05-20 11:29:39
 * 	@note	全局变量g_开头， 指针p_开头 , 布尔b_开头
 *	@note 	2015-05-20 11:29:39	V1.0.0	蒋仕鹏	创建文件
 *	@note	
******************************************************************************************/

#pragma once

#ifdef __cplusplus
extern "C"{
#endif

#include <string.h>
#include <unistd.h>
#include <regex.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>
#include <sys/time.h>
#include <sys/uio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <pthread.h>
#include <stdint.h>
#include <arpa/inet.h>
#include "list.h"

//#define print(format, ...) printf("[%s %s %d] "#format"\n", __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);fflush(stdout);
#define print(format, ...) do{	\
    struct timeval _tv = {0,0}; \
    gettimeofday(&_tv, NULL);    \
    struct tm *_tm = localtime(&_tv.tv_sec); \
    printf("[%02d:%02d:%02d %03ld][%s %s %d] "#format"\n", _tm->tm_hour, _tm->tm_min, _tm->tm_sec, _tv.tv_usec/1000, __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);fflush(stdout);	\
}while(0);

#define TIME_SPEND(func) do{struct timespec start_time, stop_time;\
	clock_gettime(CLOCK_MONOTONIC, &start_time);\
	func ; \
	clock_gettime(CLOCK_MONOTONIC, &stop_time);\
	print("TIME_SPEND >> %s expend time: %ld usec\n", #func, (stop_time.tv_sec - start_time.tv_sec)*1000000 + (stop_time.tv_nsec - start_time.tv_nsec)/1000); \
}while(0);

#ifndef MIN
#define MIN(a,b) ((a)<(b)?(a):(b))
#endif
#ifndef MAX
#define MAX(a,b) ((a)>(b)?(a):(b))
#endif

#ifndef int8
#define int8 int8_t
#endif
#ifndef uint8
#define uint8 uint8_t
#endif
#ifndef uchar
#define uchar uint8_t
#endif

#ifndef int16
#define int16 int16_t
#endif
#ifndef uint16
#define uint16 uint16_t
#endif

#ifndef int32
#define int32 int32_t
#endif
#ifndef uint32
#define uint32 uint32_t
#endif

#ifndef int64
#define int64 int64_t
#endif
#ifndef uint64
#define uint64 uint64_t
#endif

uint64 htonll(uint64 val);
uint64 ntohll(uint64 val);

#define assert_perror(expression) do{	\
	int val;	\
	val = (expression);	\
	if(val==0)	\
	{	\
		print("%s assert error, errno: %d", #expression, errno);	\
		perror("\033[0;31;40m error string \033[0m ");	\
	}	\
}while(0);

#define assert_return(ret_val, expression) do{	\
	int val;	\
	val = (expression);	\
	if(val==0)	\
	{	\
		print("%s assert error", #expression);	\
		return ret_val;	\
	}	\
}while(0);

#define assert_goto(flag, expression) do{	\
	int val;	\
	val = (expression);	\
	if(val==0)	\
	{	\
		print("%s assert error", #expression);	\
		goto flag;	\
	}	\
}while(0);


#define assert_break(expression) if((expression)==0){	\
	print("%s assert break", #expression);	\
	break;	\
}

#define assert_warning(expression) do{	\
	int val;	\
	val = (expression);	\
	if(val==0)	\
	{	\
        print(\033[0;31;40m assert warning %s \033[0m , #expression);	\
	}	\
}while(0);

//lambda表达式宏定义
//高阶函数使用
#define lambda( rt, fb) (<%rt lambda fb lambda;%>)

//alias
//导出函数符号
//eg. alias(my_func, my_func)
# define strong_alias(name) _strong_alias(__##name, name)
# define _strong_alias(name, aliasname) \
  extern __typeof (name) aliasname __attribute__ ((alias (#name)));

# define weak_alias(name) _weak_alias (__##name, name)
# define _weak_alias(name, aliasname) \
  extern __typeof (name) aliasname __attribute__ ((weak, alias (#name)));
  
//weak函数,如果外部存在就用外部函数	
# define weak_function __attribute__ ((weak))

//const，只调用一次
# define const_function __attribute__ ((__const__))

//constructor
# define constructor_function __attribute__ ((constructor))

//destructor
# define destructor_function __attribute__ ((destructor))

//指定代码段
#define SECTION(name) \
	__attribute__((section(name)))

/*
* 打印16进制数据
* desc_str [in]: 说明信息
* data [in]: 数据
* data_len [in]: 数据长度
* 输出:void
*/
void print_hex(char * desc_str, unsigned char * data, int data_len);

struct net_speed_t
{
	char net_dev_name[64]; //[in]网络设备名称
	int recv_speed; //[out]KiB/s
	int trans_speed; //[out]KiB/s
	struct timespec curr_time; //[out]//当前记录时间
	long long curr_recv_nums; //[out] 当前读取到的数值,KiB
	long long curr_trans_nums; //[out]当前读取到的数值,KiB
};

/*
* 网络速率
* net_speed [in/out]: 速率结构体
* 输出:0:成功 -1:出错
*/
int sys_net_speed(struct net_speed_t * net_speed);

//定时器
/*
* 定时器回调函数
* clock_fd [in]: 定时器句柄
* 输出:
*/
typedef void (* timer_callback_func)(int clock_fd);

/*
* 定时器初始化函数
* 输入:
* 输出:
*/
int timer_init();

/*
* 定时器初始化函数
* 输入:msec [in]: 休眠时间
* 	   call_back [in]: 超时回调
* 输出:成功安置返回0
*/
int timer_sleep(unsigned long msec, timer_callback_func call_back);



//循环缓冲区
struct circle_buff_t
{
	uint32 size;
	uchar * buff_addr;
	uint32 start_offset;
	uint32 end_offset;
	pthread_mutex_t buff_lock;
};

int str_startwith(const char * str, const char * flag);
int str_endwith(const char * str, const char * flag);

//内存
#define MEM_TYPE_MASK1 0x000000ff
#define MEM_TYPE_MASK2 0x0000ff00
#define MEM_TYPE_MASK3 0x00ff0000
#define MEM_TYPE_MASK4 0xff000000
//read,write,exec可以或
#define MEM_TYPE_READ	(0x01 & MEM_TYPE_MASK1)
#define MEM_TYPE_WRITE	(0x02 & MEM_TYPE_MASK1)
#define MEM_TYPE_EXEC	(0x04 & MEM_TYPE_MASK1)
//share,privite只能存在一个
#define MEM_TYPE_SHARE 	(0x0100 & MEM_TYPE_MASK2)
#define MEM_TYPE_PRIVITE (0x0200 & MEM_TYPE_MASK2)
//下面的只能存在一个
#define MEM_TYPE_STACK	(0x010000 & MEM_TYPE_MASK3) //栈
#define MEM_TYPE_HEAP	(0x020000 & MEM_TYPE_MASK3) //堆
#define MEM_TYPE_CODE	(0x040000 & MEM_TYPE_MASK3) //本地代码段
#define MEM_TYPE_SHARE_LIB (0x080000 & MEM_TYPE_MASK3) //共享库代码段

typedef struct mem_t
{
	uint8 * data;	
	int32 data_len;	//当前data长度
	int32 capacity; //整个内存长度
	uint32 mem_type; //see MEM_TYPE_XXXX
}mem_t;


/*
* 内存地址检查函数
* 输入:待检查的地址，长度，检查类型
* 输出:合法返回1，非法为0
*/
int check_mem(void * addr, uint64 len, uint32 check_type);
int mem_check(mem_t mem, uint32 check_type);
mem_t * mem_new_with_pointer(void * data, int32 data_size);
mem_t * mem_new(int32 size);
int mem_delete(mem_t ** mem);
//int mem_alloc(mem_t * mem, int32 size);内部使用
//int mem_free(mem_t * mem);内部使用
int mem_append(mem_t * mem, const char * data, int32 len);
int mem_put(mem_t * mem, const char * data, int32 len);
int mem_get(mem_t * mem, char ** data, int32 * len);

#ifdef __cplusplus
}
#endif


