1. 以T开头的类为模板类；以I开头的类为接口类，以C开头的类为实现类。


JetByteTools(ILogMessages)
{
ILogMessages:抽象类，抽象了初始化和日志打印的接口。

SetThreadIdentifier:设置线程名称
SetLogName：设置输出打印名称
LogMessage：格式化日志打印


JetByteTools(ILogMessages:CNullMessageLog)
{
ILogMessages:实现类，实现了ILogMessages的初始化和日志打印的接口。
CNullMessageLog实现了接口，接口不提供功能。
}

JetByteTools(ILogMessages:CSimpleMessageLog)
{
ILogMessages:实现类，实现了ILogMessages的初始化和日志打印的接口。
CSimpleMessageLog实现了接口，接口提供三种打印输出；
1. 日志文件输出
2. debugview输出
3. 内存输出
}

JetByteTools(ILogMessages:CMessageLog)
{
ILogMessages:封装类，回调了ILogMessages实现类的对应接口；
}

JetByteTools(ILogMessages:CMessageLog:CDebugTrace)
{
CDebugTrace：CMessageLog封装类，单实例，提供安装和卸载打印实现类。
同时提供了_DEBUG宏判断，输出CDebugTrace::Instance().LogMessage(s);
重新定义了OutputEx和Output两个通用输出函数。
}

}

JetByteTools(SYSTEMTIME:CSystemTime)
{
CSystemTime为SYSTEMTIME数据结构的继承类，封装了与SYSTEMTIME接口相关的WIN32 API函数。
包括获取时间，转换时间，格式化时间，修改时间，计算时间和时间之间差值的操作函数。

}

JetByteTools(CPINFOEX:CCodePage)
{
CCodePage为CPINFOEX数据结构的继承类，封装了与CPINFOEX接口相关的WIN32 API函数。
包括返回CPINFOEX内部字段的GetCodePage和isSingleByteCharacterSet。

}

JetByteTools(CException)
{
异常类基类，::MessageBox(hWnd, GetMessage().c_str(), GetWhere().c_str(), MB_ICONSTOP); 

触发异常的位置，触发异常的内容 
where, message
}

JetByteTools(CException:CWin32Exception)
{
异常类基类，派生类，关注WIN32 API调用错误。
CException(where, GetLastErrorMessage(error, true)),
where, message(指定message内容)
       message(指定error值，指定message内容)
       message(指定error值，不指定message内容)
}

JetByteTools(CSEHException)
{
跟踪执行异常的函数，并标注函数异常执行时的参数和位置信息。
ACCESS_VIOLATION
}

JetByteTools(TLockableObject<ILockableObject>:CLockableObject)
{
CLockableObject：根据宏选择SRWLock或CriticalSection两个之一。提供m_owningThreadId用于记录当前加锁线程。
#初始化
::InitializeSRWLock(&m_lock);
::InitializeCriticalSection(&m_lock);
#尝试加锁
::TryAcquireSRWLockExclusive(&m_lock);
::TryEnterCriticalSection(&m_lock);
#加锁
::AcquireSRWLockExclusive(&m_lock);
::EnterCriticalSection(&m_lock);
#解锁
::ReleaseSRWLockExclusive(&m_lock);
::LeaveCriticalSection(&m_lock);
#释放
::DeleteCriticalSection(&m_lock);

CLockableObject::Owner             接口类，构造函数加锁；析构函数解锁
CLockableObject::ConditionalOwner  接口类，默认构造函数加锁，提供Unlock函数和析构函数用于解锁
CLockableObject::PotentialOwner    接口类，默认构造函数不加锁，提供Lock函数进行加锁，析构函数根据状态进行解锁。

}

JetByteTools(TLockableObject<CEmptyBase> : CSlimLockableObject)
{
没有实例，意义未能明确。
}

JetByteTools(CStringConverter)
{
将StringA类型字符串转化为StringT类型字符串
static _tstring AtoT(const std::string &input);
static _tstring AtoT(const char *pInput);
static _tstring AtoT(const char *pInput,const size_t inputLength);

将StringA类型字符串转化为StringW类型字符串
static std::wstring AtoW(const std::string &input);
static std::wstring AtoW(const char *pInput);
static std::wstring AtoW(const char *pInput, const size_t inputLength);

将StringW类型字符串转化为StringT类型字符串
static _tstring WtoT(const std::wstring &input);
static _tstring WtoT(const wchar_t *pInput);
static _tstring WtoT(const wchar_t *pInput,const size_t inputLength);

将StringW类型字符串转化为StringA类型字符串
static std::string WtoA(const std::wstring &input);
static std::string WtoA(const wchar_t *pInput);
static std::string WtoA(const wchar_t *pInput,const size_t inputLength);

将StringT类型字符串转化为StringA类型字符串
static std::string TtoA(const _tstring &input);

将StringT类型字符串转化为StringW类型字符串
static std::wstring TtoW(const _tstring &input);

将StringUTF-8类型字符串转化为StringW类型字符串
static std::wstring UTF8toW(const std::string &input);


什么是BSTR
　　BSTR是“Basic STRing”的简称，微软在COM/OLE中定义的标准字符串数据类型。
　　对于C++，Windows头文件wtypes.h中定义如下：
　　typedef wchar_t WCHAR;
　　typedef WCHAR OLECHAR;
　　typedef OLECHAR __RPC_FAR *BSTR;;
　　使用以Null结尾的简单字符串在COM component间传递不太方便。因此，标准BSTR是一个有长度前缀和null结束符
的OLECHAR数组。BSTR的前4字节是一个表示字符串长度的前缀。BSTR长度域的值是字符串的字节数，并且不包括0
结束符。

将StringA，StringW，StringT类型字符串转化为BSTR类型字符串
static BSTR AtoBSTR(const std::string &input);
static BSTR AtoBSTR(const char *pInput,const size_t inputLength);
static BSTR WtoBSTR(const std::wstring &input);
static BSTR TtoBSTR(const _tstring &input);

将BSTR类型字符串转化为StringA，StringW，StringT类型字符串
static _tstring BSTRtoT(const BSTR bstr);
static std::string BSTRtoA(const BSTR bstr);
static std::wstring BSTRtoW(const BSTR bstr);
}

JetByteTools(Thread)
{
1. 增加Suspend选项，使得启动时刻的Start
Start()                             #直接启动，
StartSuspended()                    #开始待启动，需要Resume启动
Start(const bool startSuspended)    #根据startSuspended，执行直接启动；开始待启动，然后Resume启动
Resume()                            #调用Resume启动

StartWithPriority(const int priority) #按照指定优先级，直接启动
EnableThreadPriorityBoost()           #允许系统主动提升线程优先级
DisableThreadPriorityBoost()          #禁止系统主动提升线程优先级
ThreadPriorityBoostEnabled()          #查询是否允许系统主动提升线程优先级

SetThreadPriority(const int priority) #设置线程优先级
GetThreadPriority() const             #获取线程优先级

GetWaitHandle()                       #线程句柄
Wait() const                           #线程无限期等待
Wait(const Milliseconds timeout) const #线程超时等待

unsigned int __stdcall CThread::ThreadFunction(void *pV) #线程回调函数
Terminate(const DWORD exitCode)         #结束线程

SetThreadName(const _tstring &threadName) const   #设置线程名称
SetCurrentThreadName(const _tstring &threadName)  #设置线程名称

CThreadNameInfo类
const DWORD_PTR m_type;     #0x1000
const LPCSTR m_pName;       #线程名称
const DWORD_PTR m_threadID; #线程ID
const DWORD_PTR m_flags;    #0
}

JetByteTools(SetThreadAffinity，SelectSingleProcessor)
{
SetThreadAffinity:设置线程亲和性
SelectSingleProcessor: 获得系统亲和性
}