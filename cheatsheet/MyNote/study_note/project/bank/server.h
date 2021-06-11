#ifndef SERVER_H
#define SERVER_H
#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<sys/mman.h>
#include<fcntl.h>
#include<sys/ipc.h>
#include<sys/msg.h>
void init(void);				//初始化服务器
void delet(void);				//删除消息队列1和2 
void fa(int signa);			//自定义函数处理信号2
void recv(void);			//定义接收函数
void del(void);				//处理客户端发来的信息
void send(void);			//将处理完成后的消息发送给消息队列2
#endif
