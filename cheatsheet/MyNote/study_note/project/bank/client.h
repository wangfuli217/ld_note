#ifndef  CLIENT_H
#define  CLIENT_H
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/msg.h>
void show();			//显示功能界面
void flush();		//清空缓冲区
void print(void);		//打印账户信息
void init(void);		//初始化客户端
int getchoice();		//得到用户的选择
void del_back(void);	//处理返回的信息
void del(int choice);		//处理用户选择
void send_to_msg1(void);	//发送消息到消息队列1
void open_acc(void);		//开户功能函数
void recv(void);		//从消息队列2接收消息
void stop(void);		//暂停屏幕以便看到输出结果
void destory_acc(void);		//注销一个账户
int login(void);		//登录
void save_acc(void);		//存款
void take_acc(void);	//取款
void find_acc(void);		//查询
void tran_acc(void);		//转账
#endif
