#ifndef TOOLS_UTIL_H
#define TOOLS_UTIL_H

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

//#define print(format, ...) printf("[%s %s %d] "#format"\n", __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);fflush(stdout);
#define print(format, ...) do{	\
	struct timeval tv;	\
	gettimeofday(&tv, NULL);	\
	printf("[%ld:%ld][%s %s %d] "#format"\n", tv.tv_sec, tv.tv_usec, __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);fflush(stdout);	\
}while(0);

#define TIME_SPEND(func) do{struct timespec start_time, stop_time;\
	clock_gettime(CLOCK_MONOTONIC, &start_time);\
	func ; \
	clock_gettime(CLOCK_MONOTONIC, &stop_time);\
	print("TIME_SPEND >> %s expend time: %ld usec\n", #func, (stop_time.tv_sec - start_time.tv_sec)*1000000 + (stop_time.tv_nsec - start_time.tv_nsec)/1000); \
}while(0);

#ifndef MIN
#define MIN(a,b) (a<b?a:b)
#endif
#ifndef MAX
#define MAX(a,b) (a>b?a:b)
#endif

#define assert_perror(expression) do{	\
	int val;	\
	val = expression;	\
	if(val==0)	\
	{	\
		print("%s assert error, errno: %d", #expression, errno);	\
		perror("\033[0;31;40m error string \033[0m ");	\
	}	\
}while(0);

#define assert_return(ret_val, expression) do{	\
	int val;	\
	val = expression;	\
	if(val==0)	\
	{	\
		print("%s assert error", #expression);	\
		return ret_val;	/*按照unix编程惯例*/\
	}	\
}while(0);

#define assert_goto(flag, expression) do{	\
	int val;	\
	val = expression;	\
	if(val==0)	\
	{	\
		print("%s assert error", #expression);	\
		goto flag;	\
	}	\
}while(0);


#define assert_break(expression) if(expression==0){	\
	print("%s assert break", #expression);	\
	break;	\
}

#define assert_warning(expression) do{	\
	int val;	\
	val = expression;	\
	if(val==0)	\
	{	\
		print("%s assert warning", #expression);	\
	}	\
}while(0);

struct net_head_t
{
	int size; //不含头部数据
	int magic_num;
	char data[0];
};


/*
* 内存地址检查函数
* 输入:待检查的地址
* 输出:合法返回1，非法为0
*/
int mem_check(void * addr);

/*
* 打印16进制数据
* desc_str [in]: 说明信息
* data [in]: 数据
* data_len [in]: 数据长度
* 输出:void
*/
void print_hex(char * desc_str, unsigned char * data, int data_len);

/*
* 发送数据
* sock_fd [in]: 文件句柄
* buff [out]: 数据
* len [in]: 缓冲区长度
* 输出:接收长度, 0:超时 -1:出错
*/
int recvn(int sock_fd, char * buff, int len);

/*
* 接收数据
* sock_fd [in]: 文件句柄
* buff [in]: 数据
* len [in]: 数据长度
* 输出:发送长度, 0:超时 -1:出错
*/
int sendn(int sock_fd, char * buff, int len);


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


#ifdef __cplusplus
}
#endif


#endif


