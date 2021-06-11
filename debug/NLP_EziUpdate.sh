NLP_EziUpdate(debug.h)
{
定义了VERIFY和TRACE两个函数；
VERIFY：_ASSERT这是由Win32 提供的断言函数。
TRACE：从OutputDebugStringA输出打印信息

}

NLP_EziUpdate(CMutex)
{
#初始化-构造函数
::CreateMutex( NULL, FALSE, szName );
::OpenMutex( MUTEX_MODIFY_STATE, FALSE, szName );
#析构函数
::CloseHandle( m_hMutex );

#加锁
::WaitForSingleObject( m_hMutex, dwTimeout );
0：加锁成功
1：加锁超时
-1：加锁失败，很不正常的情况。正常情况应该是阻塞。

#解锁
::ReleaseMutex(m_hMutex) 
}

NLP_EziUpdate(CCriticalSection)
{
#初始化--构造函数
InitializeCriticalSection( &m_CS );
#析构函数
DeleteCriticalSection( &m_CS );

#加锁
EnterCriticalSection( &m_CS );
#解锁
LeaveCriticalSection( &m_CS );

CCriticalSection::Owner   接口类，构造函数加锁；析构函数解锁
}

NLP_EziUpdate(SetLogFileName：Output)
{
SetLogFileName：设置输出文件名；s_logFileName
Output：        将日志输出到文件；s_logFileName, cout, 调试器
                                  s_debugOut     std::wcout  OutputDebugString
}

NLP_EziUpdate(ToString，ToStringA，ToStringW)
{
ToString:  根据宏配置，格式化字符串为A或W类型字符串；
ToStringA：格式化为A类型字符串
ToStringW：格式化为W类型字符串

_tstring: 当_UNICODE打开的时候，为StringW类型，当_UNICODE未打开的时候，为StringA类型。
_T      : 当_UNICODE打开的时候，格式化为StringW类型，当_UNICODE未打开的时候，格式化为StringA类型。

GetLastErrorMessage:返回系统调用出现的异常错误。返回值类型为_tstring

_tstring HexToString(const BYTE *pBuffer, size_t iBytes)            #从iBytes数组到HEX类型字符串
void StringToHex(const _tstring &ts, BYTE *pBuffer, size_t nBytes)  #从HEX类型字符串到iBytes数组
_tstring GetCurrentDirectory()                                      #Linux无对应函数
_tstring GetDateStamp()                                             #获取当前时刻-年月日
_tstring ToHex(BYTE c)                                              #BYTE格式化为字符串
_tstring DumpData(const BYTE * const pData, size_t dataLength, size_t lineLength /* = 0 */) #以HEX方式显示指定数据
_tstring GetComputerName()                                          #获取计算机名称
_tstring GetModuleFileName(HINSTANCE hModule /* = 0 */)             #获取模块名称
_tstring GetUserName()                                              #获得用户名
_tstring StripLeading(const _tstring &source, const char toStrip)   #截取头
_tstring StripTrailing(const _tstring &source, const char toStrip)  #截取尾


}

NLP_EziUpdate(TODO；很有意思，值得学习)
{
#define TODOSTRINGIZE(L) #L
#define TODOMAKESTRING(M,L) M(L)
#define TODOLINE TODOMAKESTRING( TODOSTRINGIZE, __LINE__) 
#define TODO(_msg) message(__FILE__ "(" TODOLINE ") : TODO : " _msg)

#define BUG(_msg) message(__FILE__ "(" TODOLINE ") : BUG : " _msg)
}

NLP_EziUpdate(Thread)
{

# 简简单单
m_hThread = (HANDLE)::_beginthreadex(0, 0, ThreadFunction, (void*)this, 0, &threadID);
unsigned int __stdcall CThread::ThreadFunction(void *pV);
TerminateThread(m_hThread, exitCode);
virtual int Run() = 0; #将来的实现函数

}

NLP_EziUpdate(CSemaphore)
{


#初始化--构造函数
m_hSemaphore = CreateSemaphore(NULL, nInitCount, MAXLONG, szName);
#销毁--析构函数
CloseHandle( m_hSemaphore );
#超时阻塞等待
DWORD dwRet = WaitForSingleObject(m_hSemaphore, dwTimeout);
#信号量释放
ReleaseSemaphore(m_hSemaphore, 1, NULL) 
}

NLP_EziUpdate(CMutex)
{

#初始化--构造函数
m_hMutex = ::CreateMutex( NULL, FALSE, szName );
m_hMutex = ::OpenMutex( MUTEX_MODIFY_STATE, FALSE, szName );
#销毁--析构函数
::CloseHandle( m_hMutex );
#超时阻塞等待
DWORD dwWaitResult = ::WaitForSingleObject( m_hMutex, dwTimeout );
#互斥量释放
::ReleaseMutex(m_hMutex) 
}

NLP_EziUpdate(CCriticalSection)
{

#初始化--构造函数
InitializeCriticalSection( &m_CS );
#销毁--析构函数
DeleteCriticalSection( &m_CS );
#阻塞等待
EnterCriticalSection( &m_CS );
#临界区释放
LeaveCriticalSection( &m_CS );
}

NLP_EziUpdate(CEvent)
{
::CreateEvent(lpEventAttributes, bManualReset, bInitialState, 0);
::CloseHandle(m_hEvent);
DWORD result = ::WaitForSingleObject(m_hEvent, timeoutMillis);

::ResetEvent(m_hEvent)
::SetEvent(m_hEvent)
::PulseEvent(m_hEvent)
}

NLP_EziUpdate(CQueue在CAD中有实现类)
{
int Pend( void *&msg, DWORD wTimeout = INFINITE );#阻塞等待消息
int Post( void *msg );                            #投递消息到消息队列
int PostFront( void *msg );                       #将消息投递到消息队列头部
int Accept( void *&msg );                         #获得一个消息
int Flush( void );                                #情况消息队列
}

NLP_EziUpdate(CMessageBase接口类)
{
int PostMessage( CMessageBase *pTarget, MSG *msg ); #外部创建一个消息，投递给pTarget消息队列
int PostMessage( CMessageBase *pTarget,             #内部创建一个消息，投递给pTarget消息队列
	 			 DWORD nCmd, 
				 DWORD wParam, 
				 DWORD lParam, 
				 void* act = NULL );#该函数最终会调用上面的函数，实现消息投递。
int OSMessageBase::Post( MSG *msg ) #将消息放进消息队列
  
int SendMessage( CMessageBase *pTarget, MSG *msg ); #外部创建一个消息，调用pTarget的OnHandleMessage予以处理
int SendMessage( CMessageBase *pTarget,             #内部创建一个消息，调用pTarget的OnHandleMessage予以处理
				 DWORD nCmd,
				 DWORD wParam,
				 DWORD lParam ); #该函数最终会调用上面的函数，实现OnHandleMessage调用。
                 
int  Pend( MSG *&msg, DWORD dwWaitTime = 0 );  #获得消息
}

NLP_EziUpdate(ThreadEx)
{
CThreadEx继承来自CThread和CMessageBase。
CThread提供线程功能；CMessageBase提供消息队列功能。

}