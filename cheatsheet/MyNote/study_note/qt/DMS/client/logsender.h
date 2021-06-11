//日志发送器接口类
#ifndef _LOGSENDER_H
#define _LOGSENDER_H
#include<list>
using namespace std;
#include"data.h"
#include"except.h"
//日志发送器
class LogSender
{
public:
	virtual void sendLog(list<MLogRec>& logs) throw(ClientException)=0; //发送日志
};
#endif
