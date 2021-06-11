#include "stdafx.h"
#include "OverloadCast.h"
#include <string>
#include <functional>
#include <map>

using std::ostream;
using std::istream;
using std::cout;
using std::cin;
using std::endl;
using std::string;
using std::function;
using std::map;

ostream & operator<<(ostream &os, const OverloadTest &ins)
{
    // 不应打印换行符，让调用者自行换行
    os << "[memStr] " << ins.memStr;
    return os;
}

istream & operator>>(istream & is, OverloadTest & ins)
{
    is >> ins.memStr;

    if (!is) // 输入失败
    { ins.memStr = "istream fail"; }

    return is;
}

OverloadTest & OverloadTest::operator+=(const OverloadTest & rhs)
{
    this->memStr += " + ";
    this->memStr += rhs.memStr;
    return *this;
}

OverloadTest & OverloadTest::operator=(std::initializer_list<std::string> initVals)
{
    int eleNum = 0;

    for (auto itr = initVals.begin(); itr != initVals.end(); itr++, eleNum++)
    {
        this->memStrAry[eleNum] = *itr;
        if (2 == eleNum)
        {
            break;
        }
    }

    return *this;
}

std::string & OverloadTest::operator[](std::size_t idx)
{
    if (idx < 3)
    { return this->memStrAry[idx]; }
    else
    { return this->invalidIndex; }
}

const std::string & OverloadTest::operator[](std::size_t idx) const
{
    if (idx < 3)
    { return this->memStrAry[idx]; }
    else
    { return this->invalidIndex; }
}

OverloadTest & OverloadTest::operator++(void)
{
    // 无实际操作，仅打印输出表示执行
    cout << "++OverloadTest called!" << endl;
    return *this;
}

OverloadTest & OverloadTest::operator--(void)
{
    // 无实际操作，仅打印输出表示执行
    cout << "--OverloadTest called!" << endl;
    return *this;
}

OverloadTest & OverloadTest::operator++(int)
{
    // 一般先拷贝当前值，然后再调用前置版本
    cout << "OverloadTest++ called by calling ";
    ++*this;
    return *this;
}

OverloadTest & OverloadTest::operator--(int)
{
    // 一般先拷贝当前值，然后再调用前置版本
    cout << "OverloadTest-- called by calling ";
    --*this;
    return *this;
}

std::string & OverloadTest::operator*(void)
{
    return this->memStr;
}

std::string * OverloadTest::operator->(void)
{
    // 将实际工作委托给解引用
    // 因为ptr->member相当于(*ptr).member
    return & this->operator*();
}

std::string OverloadTest::operator()(std::string arg) const
{
    return "[Overload ()]: " + arg;
}

void OverloadTest::setMemStr(const string & newStr)
{
    this->memStr = newStr;
}

string OverloadTest::getMemStrAry(void)
{
    return this->memStrAry[0] + " " + this->memStrAry[1] + " " + this->memStrAry[2];
}

OverloadTest operator+(const OverloadTest & lhs, const OverloadTest & rhs)
{
    // 如果同时重载了符合赋值运算符+=，一般用复合赋值运算符来实现算术运算符
    OverloadTest result = lhs;
    result += rhs;
    return result;
}


bool operator==(const OverloadTest & lhs, const OverloadTest & rhs)
{
    return lhs.memStr == rhs.memStr;
}

bool operator<(const OverloadTest & lhs, const OverloadTest & rhs)
{
    return lhs.memStr < rhs.memStr;
}

void testOverload(void)
{
    OverloadTest ocIns = OverloadTest("Initialized.");
    cout << "Test << and >>" << endl;
    cout << "Original value:";
    cout << ocIns << endl; // 测试输出重载 
    cout << "Enter new value: ";
    cin >> ocIns; // 测试输入重载
    cout << "New value: ";
    cout << ocIns << endl << endl;

    cout << "Test overload +" << endl;
    OverloadTest ocLhs = OverloadTest("Left");
    OverloadTest ocRhs = OverloadTest("Right");
    OverloadTest ocRst = ocLhs + ocRhs; // 测试算术运算符重载
    cout << ocRst << endl << endl;

    cout << "Test overload ==" << endl;
    ocLhs.setMemStr("Left");
    ocRhs.setMemStr("Right");
    cout << ocLhs << " == " << ocRhs << " is: " << (ocLhs == ocRhs) << endl;
    ocLhs.setMemStr("Same");
    ocRhs.setMemStr("Same");
    cout << ocLhs << " == " << ocRhs << " is: " << (ocLhs == ocRhs) << endl;

    cout << "Test overload <" << endl;
    ocLhs.setMemStr("Same");
    ocRhs.setMemStr("Same");
    cout << ocLhs << " < " << ocRhs << " is: " << (ocLhs < ocRhs) << endl;
    ocLhs.setMemStr("Samf");
    ocRhs.setMemStr("Same");
    cout << ocLhs << " < " << ocRhs << " is: " << (ocLhs < ocRhs) << endl;
    ocLhs.setMemStr("Same");
    ocRhs.setMemStr("Samf");
    cout << ocLhs << " < " << ocRhs << " is: " << (ocLhs < ocRhs) << endl;
    cout << endl;

    cout << "Test overload ={}" << endl;
    cout << "Current value: ";
    cout << ocIns.getMemStrAry() << endl;
    ocIns = { "val1", "val2", "val3" };
    cout << "Current value: ";
    cout << ocIns.getMemStrAry() << endl << endl;

    cout << "Test overload []" << endl;
    cout << "memStrAry[0]: ";
    cout << ocIns[0] << endl;
    cout << "memStrAry[1]: ";
    cout << ocIns[1] << endl;
    cout << "memStrAry[2]: ";
    cout << ocIns[2] << endl;
    cout << "memStrAry[3]: ";
    cout << ocIns[3] << endl;
    cout << endl;

    cout << "Test overload ++ and --" << endl;
    ++ocIns;
    --ocIns;
    ocIns++;
    ocIns--;
    // 显式调用时，用参数区分前置与后置
    ocIns.operator++();
    ocIns.operator++(0);
    cout << endl;

    cout << "Test overload ()" << endl;
    cout << ocIns("TestArgument") << endl;
    cout << endl;
}

// 普通函数
void sigMethod(string strPar) { cout << "In sigMethod(" << strPar << "\")" << endl; }
// lambda
auto sigLambda = [](string strPar) { cout << "In sigLambda(" << strPar << "\")" << endl; }; 
// 函数对象类
struct SigClass //必须为struct，不能为class
{
    void operator()(string strPar) { cout << "In sigClass(" << strPar << "\")" << endl; };
};
// 重载函数
void sigOverload(string strPar) { cout << "In sigOverload(" << strPar << "\")" << endl; }
void sigOverload(int intPar) { cout << "/!\\Shall NOT in sigOverload(int)" << endl; }

void testCallSignature(void)
{
    /*
    可调用对象（callable object）：可以对其使用调用运算符()的对象或表达式
    - 函数
    - 函数指针
    - 重载了函数调用运算符的类
    - lambda表达式
    - bind创建的对象

    不同的可调用对象类型不同，但可以用相同的调用形式call signature（类似函数签名）
    比如接受两给int，返回一个int的调用形式为：
    int(int, int)
    
    
    定义函数表function table（类似中断向量表）
       可以使用map<string, void(*)(string)>实现，但无法将lambda和重载了函数调用运算符的类添加进map
       C++11标准库的function模板类型可以解决此问题

       function的操作：
       function<T> f;           f用来存储函数类型为T的可调用对象
       function<T> f(nullptr);  显式构造一个空function
       function<T> f(obj);      在f中存储可调用对象obj的副本
       f                        直接用f作为条件，f含义可调用对象时为真
       f(args)                  调用f中的对象，args为参数

       f的成员的类型：
       result_type              可调用对象返回的类型
       argument_type            只有一个实参时，表示此实参的类型
       first_argument_type      有两个实参时，第一个参数的类型
       second_argument_type     有两个实参时，第二个参数的类型
    */
    function<void(string)> funMethod = sigMethod;
    function<void(string)> funLambda = sigLambda;
    function<void(string)> funClass = SigClass();
    void(*fp)(string) = sigOverload;
    function<void(string)> funOverload = fp; // 由于重载函数的二义性，不能直接写重载的函数名，用函数指针消除二义性

    map<string, function<void(string)>> isrVector = {
        { "method", funMethod },
        { "lambda", funLambda },
        { "class", funClass },
        { "overload", funOverload }
    };

    isrVector["method"]("1");
    isrVector["lambda"]("2");
    isrVector["class"]("3");
    isrVector["overload"]("4");
}

void testConversion(void)
{
    ConversionTest ctIns;
    ctIns = 123; // 123被转成ConversionTest对象
    // ConversionTest被转成int，之后内置类型转double运算
    cout << ctIns + 321.123 << endl; // 隐式类型转换，只可调用普通类类型转换
    cout << static_cast<int>(ctIns) + 321.123 << endl; // 显式类型转换，可调用普通类类型转换或explicit类类型转换
}

void testOverloadCast(void)
{
    //testOverload();
    //testCallSignature();
    testConversion();
}

