//声明控制台日志发送器类
#ifndef _CONSOLESENDER_H
#define _CONSOLESENDER_H
#include "logsender.h"
//控制台日志发送器
class ConsoleSender:public LogSender
{
public:
	void sendLog(list<MLogRec>& logs) throw(); //发送日志
};
#endif
