//异常类
#ifndef _EXCEPT_H
#define _EXCEPT_H
#include<string>
using namespace std;
//客户机异常
class ClientException:public exception
{
public:
	ClientException(void):m_msg("客户机异常!"){}
	ClientException(string const& msg):m_msg("客户机异常:")
	{
		m_msg+=msg;
		m_msg+="!";
	}
	char const* what(void) const throw()	//覆盖虚函数what
	{
		return m_msg.c_str();
	}
	~ClientException(void) throw(){}		//基类中不抛出任何异常,如果不写,默认析构可以抛出任何异常
private:
	string m_msg;
};
//备份异常
class BackupException:public ClientException
{
public:
	BackupException(void):ClientException("备份错误"){}
	BackupException(string const& msg):ClientException(msg){}
};
//读取异常
class ReadException:public ClientException
{
public:
	ReadException(void):ClientException("读取错误"){}
	ReadException(string const& msg):ClientException(msg){}
};
//存储异常
class SaveException:public ClientException
{
public:
	SaveException(void):ClientException("存储错误"){}
	SaveException(string const& msg):ClientException(msg){}
};
//网络异常
class SocketException:public ClientException
{
public:
	SocketException(void):ClientException("网络错误"){}
	SocketException(string const& msg):ClientException(msg){}
};
//发送异常
class SendException:public ClientException
{
public:
	SendException(void):ClientException("发送错误"){}
	SendException(string const& msg):ClientException(msg){}
};
#endif
