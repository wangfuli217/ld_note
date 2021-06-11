#ifndef _PSIGNAL_H
#define _PSIGNAL_H
#include <stdio.h>
#include <tools-util.h>
#include <semaphore.h>

#ifdef __cplusplus
extern "C"{
#endif

struct call_param_t
{
	char src_sid[128];
	int session_id;
};
typedef void (*sig_callback_func)(const struct call_param_t * pack, const void * data, int data_len);

/*
* 初始化信号模块
* sid [in]: 本进程的实例id，机器中唯一
* 输出:0/-1
*/
int sig_init(const char * sid);

/*
* 发送信号到另外一个进程。
* dst_sid [in]: 目标进程的id，机器中唯一
* sig_name [in]: 信号名称
* data [in]: 附加数据
* data_len [in]:附加数据长度
* 输出:0/-1
*/
int sig_send(const char * dst_sid, const char * sig_name, const void * data, int data_len);

/*
* 注册本进程处理信号的回调函数
* dst_sid [in]: 目标进程的id，机器中唯一
* sig_name [in]: 信号名称
* callback [in]: 信号的回调函数
* 输出:0/-1
*/
int sig_regist_callback(const char * sig_name, sig_callback_func callback);

/*
* 在callback中发送返回信息
* dst_sid [in]: 目标进程的id，机器中唯一
* session_id [in]: 会话id
* data [in]: 返回数据
* data_len [in]: 返回数据长度
* 输出:0/-1
*/
int sig_reply(const char * dst_sid, int session_id, const void * data,int data_len);

/*
* 发送信号到另外一个进程。同时等待另一个进程的返回数据
* dst_sid [in]: 目标进程的id，机器中唯一
* sig_name [in]: 信号名称
* data [in]: 附加数据
* data_len [in]:附加数据长度
* reply_data [in]: 返回数据
* reply_data_len [in]:返回数据长度
* 输出:0/-1，当出错或者1s内没有收到返回数据，返回-1
*/
int sig_send_wait_reply(const char * dst_sid, const char * sig_name, 
	const void * data, int data_len, void * reply_data, int * reply_data_len);

#ifdef __cplusplus
}
#endif

#endif

