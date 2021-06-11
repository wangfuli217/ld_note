#include "stdafx.h"
#include "StdLibIO.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

using std::cin;
using std::endl;
using std::cout;
using std::cerr;
using std::istream;
using std::string;
using std::flush;
using std::ends;
using std::unitbuf;
using std::nounitbuf;
using std::ostream;
using std::ifstream;
using std::ofstream;
using std::fstream;
using std::istringstream;
using std::ostringstream;
using std::stringstream;

StdLibIO::StdLibIO()
{
}


StdLibIO::~StdLibIO()
{
}

void getCinStateBits(void)
{
    // 查看constexpr标志位的值，可用于位操作置或清标志位
    cout << "istream bit: badbit[" << istream::badbit   // 系统级错误，流已崩溃
        << "] failbit[" << istream::failbit             // IO操作失败，可修正继续使用
        << "] eofbit[" << istream::eofbit               // 流到达文件结束，会同时置fail
        << "] gootbit[" << istream::goodbit             // 流未处于错误状态
        << "]" << endl;
}

void getCinStateFunc(void)
{
    cout << "istream bitfun: bad()[" << cin.bad()       // badbit置位时返回true
        << "] fail()[" << cin.fail()                    // failbit或bad置位时返回true
        << "] eof()[" << cin.eof()                      // eofbit置位时返回true
        << "] good()[" << cin.good()                    // 流处于有效状态时返回true
        << "]" << endl;
}

void StdLibIO::conditionState(void)
{
    // iostate是机器相关的类型，提供了表达条件状态的完整功能
    istream::iostate curCondStat = cin.rdstate(); // rdstate()返回当前条件状态
    getCinStateBits();
    cout << "---Initial---" << endl;
    getCinStateFunc();

    // 输入的类型和期望类型不匹配，产生fail
    int intInput = 0;
    cout << "---Test fail. Expect int, but enter string.---" << endl;
    cin >> intInput;
    getCinStateFunc();

    // 需要清除错误状态，才能继续使用
    cout << "---Clear cin.---" << endl;
    cin.clear(); // 所有条件状态位复位，流状态置为有效
    getCinStateFunc();

    // 输入EOF，产生eof和fail
    char charAryInput[50];
    cout << "---Test EOF. Enter Ctrl+D (Unix) or Ctrl+Z (Win)---" << endl;
    cin >> charAryInput; // 把之前输入的字符串读取掉
    cin >> charAryInput;
    getCinStateFunc();

    // 用位操作清除错误状态
    cout << "---Bit clear cin.---" << endl;
    cin.clear(cin.rdstate() & ~cin.failbit & ~cin.eofbit); // 清除fail和eof位
    getCinStateFunc();
}

void StdLibIO::outputBuffer(void)
{
    // 导致缓冲刷新的原因：
    // - 程序正常结束，缓冲刷新作为main函数return操作的一部分
    // - 缓冲区满
    // - endl显式刷新
    // - 输出操作之后用操纵符unitbuf设置流内部状态来清空缓冲区。cerr默认设置unitbuf，写到ceer的内容立即刷新
    // - 当输出流被关联到其他流时，读写被关联的流导致刷新。默认cin和cerr关联到cout，故读cin或写cerr会刷新cout缓冲区
    // * 程序崩溃时不会刷新缓冲区
    
    cout << "flush" << flush; // 输出后刷新缓冲区，不附加额外字符
    cout << "ends" << ends; // 输出内容和一个空字符，刷新缓冲区
    cout << "endl" << endl; // 输出内容和一个换行，刷新缓冲区

    cout << unitbuf; // 此后的输出操作都立即刷新缓冲区
    cout << "unitbufed";
    cout << nounitbuf; // 此后的输出操作恢复正常缓冲方式
    cout << endl;

    // 交互式系统一般关联输入流和输出流，这样在读操作之前保证要输出的用户提示信息都已经被打印出来
    // 可以将istream对象关联到ostream，也可以将ostream对象关联到ostream
    if (&cout == cin.tie()) // 如果已经关联则返回关联的流指针，否则返回空指针
    { cout << "cin already tied to cout." << endl; }

    ostream *oldTieOstream = cin.tie(nullptr); // cin不关联其他流
    cin.tie(oldTieOstream); // cin关联cout
    cout << "End of tie testing" << endl;
}

void StdLibIO::fileStream(void)
{
    // 文件模式
    // in       以读方式打开              只能针对陈stream或fstream
    // out      以写方式打开              只能针对ofstream或fstream；默认trunc，要追加必须指定app或者in
    // app      写操作追加到文件末尾      没指定trunc时才可app；设定为app后默认out
    // ate      打开文件后定位到文件末尾  可用于任何类型的文件流对象，可与任何模式组合使用
    // trunc    截断文件，即覆盖文件      只有out才能指定trunc
    // binary   以二进制方式进行IO        可用于任何类型的文件流对象，可与任何模式组合使用
    //
    // ifstream 从给定文件读取数据 默认in模式
    // ofstream 向给定文件写入数据 默认out模式
    // fstream  读写给定文件       默认in和out模式

    // 用ifstream对象读取文件内容
    ifstream iFileStream; // 创建文件流但不绑定文件
    cout << "Is iFileStream open: " << iFileStream.is_open() << endl; // 测试文件流是否打开了文件
    iFileStream.open(".\\Resources\\file.txt"); // 以默认模式绑定文件
    cout << "Is iFileStream open: " << iFileStream.is_open() << endl;
    // 读取一行
    char fileContent[1024];
    iFileStream.getline(fileContent, sizeof fileContent);
    cout << "Original file.txt: " << fileContent << endl;
    // 关闭绑定的文件
    iFileStream.close();

    // 用ofstream对象写入文件内容
    ofstream oFileStream(string(".\\Resources\\file.txt")); // 隐式out+隐式trunc
    //ofstream oFileStream(string(".\\Resources\\file.txt"), ofstream::out); // 显式out+默认trunc
    //ofstream oFileStream(string(".\\Resources\\file.txt"), ofstream::out | ofstream::trunc); // 显式out+显式trunc
    //ofstream oFileStream(string(".\\Resources\\file.txt"), ofstream::app); // 隐式out+显示app
    //ofstream oFileStream(string(".\\Resources\\file.txt"), ofstream::out | ofstream::app); // 显式out+显式app
    oFileStream << "This is a new line from oFileStream. " << __DATE__ << " " << __TIME__; // TODO 使用日期时间函数
    oFileStream.close();

    // 用fstream写入和读取文件内容
    fstream fileStream(string{ ".\\Resources\\file.txt" }, fstream::out | fstream::app);
    fileStream << " With fileStream content." ;
    fileStream.close();
    fileStream.open(string{ ".\\Resources\\file.txt" }, fstream::in);
    fileStream.getline(fileContent, sizeof fileContent);
    cout << "Final    file.txt: " << fileContent << endl;

    fileStream.close();
}

void StdLibIO::stringStream(void)
{
    // istringstream 从string读取数据
    // ostringstream 向string写入数据
    // stringstream  string读写数据

    string strSentence("Hello string stream.");
    string word;
    istringstream istrStreamInsNoInit; // 未绑定string的istringstream对象
    istringstream istrStreamInsInit(strSentence); // 保存了strSentence拷贝的istringstream对象
    ostringstream ostrStreamInsNoInit; // 未绑定string的ostringstream对象

    cout << "istrSteamInsInit: " << istrStreamInsInit.str() << endl; // 获取保存的string的拷贝

    istrStreamInsNoInit.str(string("This is a new sentence.")); // 将string拷贝到对象中
    while (istrStreamInsNoInit >> word) // 获取内部string
    {
        cout << "istrStreamInsNoInit word: " << word << endl;

        // 转大写后输出到ostringStream对象
        for (char &c : word)
        { c = toupper(c); }
        ostrStreamInsNoInit << word << " ";
    }
    cout << "ostrStreamInsNoInit: " << ostrStreamInsNoInit.str() << endl;
    
}
