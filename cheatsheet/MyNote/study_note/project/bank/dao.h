#ifndef DAO_H
#define DAO_H
#include<stdio.h>
#include"bank.h"
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<sys/mman.h>
#include<fcntl.h>
int generator_id(void);			//生成账号ID
int write_to_acc(Account *pm);	//将账户信息写入账户文件中
int find(Account *pa);					//寻找特定的账号
int re_write_to_acc(Account *pm,int flag);	//将账户信息重新写入账户文件中
#endif
