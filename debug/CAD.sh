cad(CADServer.ini)
{
void ReadConfig(char* pFileName,char* pAppName,char* pKeyName,char* oValue)
    GetPrivateProfileString(pAppName, pKeyName, cDefault, oValue, MAX_CONFIG_TEXT_LEN, cFilePath);
WritePrivateProfileString(pAppName, pKeyName, pValue,cFilePath);
    WritePrivateProfileString(pAppName, pKeyName, pValue,cFilePath);
    
## 读写配置文件
CADServer.ini
[CADServer]
IP=192.168.3.205
Port=18080
TIMEOUT=500000
NMSIP=192.168.3.11
NMSPort=8099
TIMEADJUST=10
AUTORUN=0
USERNAME=cad
USERPWD=1

[DATABASE]
DBIP=192.168.3.11
DBPORT=3306
DBNAME=rd_ssi
DBUSERNAME=root
DBPASSWORD=root

[ATSServer]
ServerIP=192.168.3.205
SubPort=2000
RevPort=52152


[CLOCKServer]
ServerIP=202.120.2.101
Port=123    
}

cad(DoDataExchange)
{
DoDataExchange(CDataExchange* pDX) 是MFC CWnd的一个重要的函数。
在此函数中可以利用一系列的DDX_xxxx(..)函数实现UI与data的数据交互，以及用DDV_xxx(...)来实现数据验证。

    你要在对话框的构造函数里面初始化一个变量，再用DoDataExchange函数将它绑定到你的动态按扭中，比如：
DDX_Check(pDX, IDC_CHECK1, m_Lesson1);这就是将m_Lesson1(这是一个外部变量，其定义在对话框的构造函数里)
绑定到IDC_CHECK1中。
    看下DDX_Check函数原型：void AFXAPI DDX_Check(CDataExchange* pDX, int nIDC, int& value);可以看到
m_Lesson并不是真的添加到IDC_CHECK1控件里了，注意这是int& value，只是一个值引用而已。差不多的意思就是
这个变量被框架传递给控件了。控件只负责使用此变量 ，而不负责改写此变量。

UpdateData函数内部调用了DoDataExchange。该函数只有一个布尔型参数，它决定了数据传送的方向。调用UpdateData(TRUE)将数据从对话框的控件中传送到对应的数据成员中，调用UpdateData(FALSE)则将数据从数据成员中传送给对应的控件。
UpdateData(false)是将变量的值传到控件，表示对话框正在初始化.
UpdateData(TRUE)是从控件中取值到关联的变量, 表示数据正在获取
}

cad(WM_ICONERASEBKGND)
{
SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);
这个函数，是发送WM_ICONERASEBKGND到本窗口消息队列，(WPARAM) dc.GetSafeHdc(), 是响应这个消息的函数的参数。
WM_ICONERASEBKGND发送给某个最小化窗口，仅当它在画图标前它的背景必须被重画
后面获取图标信息，设置，然后重新画
(以下参考自MSDN)
    在计算机绘制窗口类的图标前，系统发送一个WM_ICONERASEBKGND消息给窗口消息处理函数(window procedure)，通过设置
最合适的背景色，使应用程序能够准备绘制图标的背景。这对于一些使用当前背景色组成图标的应用程序很有用。如果应用程序
处理这个消息，它将使用这个消息提供的设备上下文来绘制背景（wParam参数包含了显示DC的句柄）。如果应用程序没有处理
WM_ICONERASEBKGND消息的函数，那么它将被送到系统默认消息处理函数处(DefWindowProc)；这个函数使用当前桌面的颜色和
图案填充图标区域。当WM_ICONERASEBKGND消息发送完毕，系统发送WM_PAINTICON消息给窗口消息处理函数。应用程序会立刻
把这个消息传递至系统默认消息处理函数(DefWindowProc)。
}

postmessage()
{
1.全局变量
进程中的线程间内存共享，这是比较常用的通信方式和交互方式。

注：定义全局变量时最好使用volatile来定义，以防编译器对此变量进行优化。

 
2.Message消息机制

常用的Message通信的接口主要有两个：PostMessage和PostThreadMessage，

PostMessage为线程向主窗口发送消息。而PostThreadMessage是任意两个线程之间的通信接口。
2.1.PostMessage() 
函数原型：

    B00L PostMessage（HWND hWnd，UINT Msg，WPARAM wParam，LPARAM lParam）；
参数：
    hWnd：其窗口程序接收消息的窗口的句柄。可取有特定含义的两个值：
    HWND.BROADCAST：消息被寄送到系统的所有顶层窗口，包括无效或不可见的非自身拥有的窗口、被覆盖的窗口
和弹出式窗口。消息不被寄送到子窗口。
    NULL：此函数的操作和调用参数dwThread设置为当前线程的标识符PostThreadMessage函数一样。
    Msg：指定被寄送的消息。
    wParam：指定附加的消息特定的信息。
    IParam：指定附加的消息特定的信息。
    返回值：如果函数调用成功，返回非零值：如果函数调用失败，返回值是零。

MS还提供了SendMessage方法进行消息间通讯，SendMessage(),他和PostMessage的区别是：
SendMessage是同步的，而PostMessage是异步的。SendMessage必须等发送的消息执行之后，才返回。

2.2.PostThreadMessage()
PostThreadMessage方法可以将消息发送到指定线程。

函数原型：BOOL PostThreadMessage(DWORD idThread,UINT Msg,WPARAM wParam, LPARAM lParam);
参数除了ThreadId之外，基本和PostMessage相同。

目标线程通过GetMessage()方法来接受消息。
注：使用这个方法时，目标线程必须已经有自己的消息队列。否则会返回ERROR_INVALID_THREAD_ID错误。可以用
PeekMessage()给线程创建消息队列。
}