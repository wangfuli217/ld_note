//声明网络日志发送器类
#ifndef _SOCKETSENDER_H
#define _SOCKETSENDER_H
#include "logsender.h"
//网络日志发送器
class SocketSender:public LogSender
{
public:
	void sendLog(list<MLogRec>& logs) throw(ClientException); //发送日志
	SocketSender(string const& failFile,short port,string const& ip="127.0.0.1");	//构造器
private:
	void readFailFile(list<MLogRec>& logs) throw(ReadException); //读取发送失败文件
	void connectServer(void) throw(SocketException);		//连接服务器
	void sendData(list<MLogRec>& logs) throw(SendException);	//发送数据
	void saveFailFile(list<MLogRec>& logs) throw(SaveException); //保存发送失败文件
	string m_failFile;		//发送失败文件
	short m_port;			//服务器端口号
	string m_ip;			//服务器IP地址
	int m_sockfd;			//套接字描述符
};
#endif
