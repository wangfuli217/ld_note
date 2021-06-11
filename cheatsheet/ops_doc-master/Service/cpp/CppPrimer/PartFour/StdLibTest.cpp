#include "stdafx.h"
#include "StdLibTest.h"
#include <tuple>
#include <iostream>
#include <string>
#include <vector>
#include <bitset>
#include <regex>
#include <random>
#include <iomanip>

using std::tuple;
using std::tuple_size;
using std::cout;
using std::cin;
using std::endl;
using std::vector;
using std::string;
using std::get;
using std::bitset;
using std::regex;
using std::smatch;
using std::default_random_engine;
using std::uniform_int_distribution;
using std::boolalpha;
using std::noboolalpha;
using std::oct;
using std::hex;
using std::dec;
using std::showbase;
using std::noshowbase;
using std::uppercase;
using std::nouppercase;
using std::showpoint;
using std::noshowpoint;
using std::showpos;
using std::noshowpos;
using std::scientific;
using std::fixed;
using std::hexfloat;
using std::defaultfloat;
using std::setw;
using std::left;
using std::right;
using std::internal;
using std::setfill;
using std::noskipws;
using std::skipws;

void tupleTest(void)
{
    /*
        C++11: tuple类似pair，不同tuple类型可以有任意数量的成员。
        用途:希望将一些数据组合成单一对象,但又不想定义一个新数据结构。如从函数返回多个数据。

        tuple<T1, ..., Tn> t                定义一个tuple，成员数为n，类型为T1/T2/...，值初始化
        tuple<T1, ..., Tn> t(v1, ..., vn)   定义一个tuple，成员用对于的v值初始化，此构造函数explicit
        make_tuple(v1, ..., vn)             返回用v值初始化的tuple
        t1 == t2                            t1和t2数量相同且成员相等时返回true
        t1 != t2
        t1 relop t2                         用字典序比较
        get<i>(t)                           返回第i个数据成员的引用（可能为左值引用也可能为右值引用）
        tuple_size<typleType>::value        用typle类型初始化的类模板，其public constexpr static的value数据成员，
                                            类型为size_t，表示tuple中成员数量
        tuple_element<i, typleType>::type   用整型常量和tuple类型初始化的类模板，其public的type成员表示tuple中指定成员的类型
    */
    tuple<int, char, string, vector<int>> tupleLoft{ 123, 'a', "ABC", vector<int>{1, 2, 3, 4} };

    cout << "## tuple test." << endl;
    cout << "tuple size: " << tuple_size<decltype(tupleLoft)>::value << endl;
    // 无法通过普通的方法遍历tuple容器, 因为"get<>()"方法, 无法使用变量获取值
    cout << "tuple get<0>: " << get<0>(tupleLoft) << endl;
    cout << "tuple get<1>: " << get<1>(tupleLoft) << endl;
    cout << "tuple get<2>: " << get<2>(tupleLoft) << endl;
    cout << "tuple get<3>: " << get<3>(tupleLoft)[3] << endl;
    cout << endl;
}

void bitsetTest(void)
{
    /*
        bitset类似array类，位置编号从0（低位low-order)开始，结束的编号为高位high-order

        bitset<n> b;                b有n位，每位均为0，此构造函数是constexpr
        bitset<n> b(u);             b是unsigned long long值u的低n位拷贝，如果n大于u的大小，b的高位置0
        bitset<n> b(s,pos,m,zero,one);
                                    s是string，只能包含字符zero或one，否则构造函数抛出invalid_argument异常
                                    从s的pos位置开始，拷贝m个字符到b
                                    pos默认为0
                                    m默认为string::npos
                                    zero默认为'0'
                                    one默认为'1'
        bitset<n> b(cp,pos,m,zero,one);
                                    cp不是string而是c风格的字符串

        b.any()                     b中是否有置位的二进制位
        b.all()                     b中是否所有位都置位
        b.none()                    b中是否所有位都未置位
        b.count()                   b中置位的位数
        b.size()                    b的位数
        b.test(pos)                 pos位置是否置位
        b.set(pos,v)                pos位置上置bool值v
        b.set()                     所有位置位
        b.reset(pos)                pos位置复位
        b.reset()                   复位所有位
        b.flip(pos)                 pos位反转
        b.flip()                    反转所有位
        b[pos]                      方位pos位置的位
        b.to_ulong()                返回unsigned long
        b.to_ullong()               返回unsigned long long
        b.to_string(zero,one)       返回一个string表示b的位模式，zero默认为‘0’，one默认为‘1’，表示b中的位值
        os << b                     将b中二进制位打印为字符1或0
        is >> b                     读取字符存入b，如输入字符不为1或0，或已经读到b.size()字符时，终止
    */
    cout << "## bitset test." << endl;


    // 0xBEEF二进制为 1011 1110 1110 1111
    cout.width(32);
    cout << "1011111011101111";
    cout << " : 0xBEEF" << endl;

    bitset<13> bsSmall(0xBEEF); // bitset位数少，截取
    cout.width(32);
    cout << bsSmall;
    cout << " : small bitset" << endl;

    bitset<20> bsBig(0xBEEF); // bitset位数多，高位补0
    cout.width(32);
    cout << bsBig;
    cout << " : big bitset" << endl;

    bitset<8> bsByte(0x00);
    cout << "bsByte: " << bsByte << endl;
    cout << "bsByte.size(): " << bsByte.size() << endl;
    cout << "bsByte.any(): " << bsByte.any() << endl;
    cout << "bsByte.all(): " << bsByte.all() << endl;
    cout << "bsByte.none(): " << bsByte.none() << endl;
    cout << "bsByte.count(): " << bsByte.count() << endl;
    cout << "bsByte.test(0): " << bsByte.test(0) << endl;
    cout << "bsByte.set(0,1): " << bsByte.set(0, 1) << endl;
    cout << "bsByte.any(): " << bsByte.any() << endl;
    cout << "bsByte.count(): " << bsByte.count() << endl;
    cout << "bsByte.test(0): " << bsByte.test(0) << endl;
    cout << "bsByte.reset(0): " << bsByte.reset(0) << endl;
    cout << "bsByte.test(0): " << bsByte.test(0) << endl;
    cout << "bsByte.flip(): " << bsByte.flip() << endl;
    cout << "bsByte.all(): " << bsByte.all() << endl;
    cout << "bsByte.count(): " << bsByte.count() << endl;

}

void regularExpressionTest(void)
{
    /*
        regex                           有一个正则表达式的类
        regex_match（seq, m, r, mft)    将一个字符序列与一个正则表达式匹配
                                        在字符序列seq中查找regex对象r中的正则表达式
                                        seq可以是string、表示范围的一对迭代器、指向空字符结尾的字符数组指针
                                        m是一个match对象，用来保存匹配结果，m和seq必须是兼容类型
                                        mft是可选的regex_constants::match_flag_type值
        regex_search                    寻找第一个与正则表达式匹配的子序列
        regex_replace                   用给定格式替换一个正则表达式
        sregex_iterator                 迭代器适配器，用regex_search遍历一个string中所有匹配的子串
        smatch                          容器类，保存在string中搜索的结果
        ssub_match                      string中匹配的子表达式结果
    */

    cout << "## regular expression test." << endl;

    string pattern("^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$"); // 正则表达式
    regex reg(pattern); // 用正则表达式初始化用于查找模式的regex
    smatch results; // 保存搜索结果
    string shallNotMatch("notmatch#mail.com");
    string shallMatch("match@mail.com");
    
    if (regex_search(shallNotMatch, results, reg))
    { cout << "Match!: " << results.str() << endl; }
    else
    { cout << "Not match: " << shallNotMatch << endl; }

    if (regex_search(shallMatch, results, reg))
    { cout << "Match!: " << results.str() << endl; }
    else
    { cout << "Not match: " << shallMatch << endl; }

    cout << endl;

}

void randomTest(void)
{
    /*
        C++用一组协作类实现随机数：
        - 随机数引擎类random-number engines：生成随机unsigned整数序列
        - 随机数分布类random-number distribution：使用引擎返回服从特定概率分布的随机数
        “随机数发生器”是指引擎对象和分布对象的组合。

        Engine e;               默认构造函数，使用该引擎默认的种子
        Engine e(s);            使用整型值s作为种子
        e.seed(s);              使用s重置引擎
        e.min();                引擎可生成的最小值
        e.max();                引擎可生成的最大值
        Engine::result_type     此引擎生成的unsigned整型类型
        e.discard(u)            用unsigned long long将引擎推进u步
    */

    cout << "## random test." << endl;

    cout << "default_random_engine:" << endl;
    default_random_engine randEngine;
    for (int i = 0; i != 5; i++)
    { cout << randEngine() << " "; }
    cout << endl;

    cout << "uniform_int_distribution:" << endl;
    uniform_int_distribution<unsigned> uniformEngine(0, 9);
    for (int i = 0; i != 5; i++)
    { cout << uniformEngine(randEngine) << " "; } // 将randEngine作为随机数源
    cout << endl << endl;
}

void moreIO(void)
{
    /*
        标准库定义操纵符manipulator来修改流的格式状态。
        操纵符是一个函数或对象，可以作为输入/输出运算符的运算对象，返回所处理的流对象
    */

    cout << "## More IO." << endl;

    //// 控制布尔值的输出格式 boolalpha/noboolalpha
    // 默认布尔值打印0和1，使用后输出true和false
    cout << "Default bool values: " << true << "/" << false << endl;
    cout << "boolapha bool values: " << boolalpha << true << "/" << false << endl;
    cout << "noboolalpha bool values: " << noboolalpha << true << "/" << false << endl;
    cout << endl;

    //// 控制整型值的进制
    // 默认输出十进制，使用hex/oct/dec切换进制
    cout << "Default int values: " << 255 << endl;
    cout << "Octal int value: " << oct << 255 << endl;
    cout << "Hex int value: " << hex << 255 << endl;
    cout << "Decimal int value: " << dec << 255 << endl;
    cout << showbase;
    // 开启和关闭进制值前导：showbase/noshowbase
    cout << "Octal int value: " << oct << 255 << endl; // 八进制前导0
    cout << "Hex int value: " << hex << 255 << endl; // 十六进制前导0x
    cout << "Decimal int value: " << dec << 255 << endl; // 十进制无前导
    cout << noshowbase;
    // 配合uppercase/nouppercase控制打印十六进制时大写/小写，科学计数法的E大写/小写
    cout << uppercase << showbase;
    cout << "Hex int value: " << hex << 255 << endl; // 十六进制大写
    cout << dec;
    cout << nouppercase << noshowbase;
    cout << endl;

    // showpos/noshowpos控制打印/不打印正号
    cout << "Default show positive: " << 123 << " " << -123 << endl;
    cout << showpos;
    cout << "Show positive: " << 123 << " " << -123 << endl;
    cout << noshowpos;
    cout << "Clear show positive: " << 123 << " " << -123 << endl;
    cout << endl;

    //// 控制浮点格式
    // 以多高精度(总数字位数，包括小数点之前）打印浮点值（默认6位数字）
    cout << "Default precision: " << cout.precision() << endl; // 返回当前精度
    cout << "Default result: " << sqrt(2.0) << endl;
    cout.precision(8); // 设置精度
    cout << "Precision(8) result: " << sqrt(2.0) << endl;
    cout.precision(3); // 设置精度
    cout << "Precision(3) result: " << sqrt(2.0) << endl;
    // 数值打印为十六进制/定点十进制/科学计数法
    cout << "Default: " << sqrt(2.0) * 100 << endl;
    cout << "Scientific: " << scientific << sqrt(2.0) * 100 << endl;
    cout << "Fixed decimal: " << fixed << sqrt(2.0) * 100 << endl;
    cout << "Hexadecimal: " << hexfloat << sqrt(2.0) * 100 << endl;
    cout << "Defaultfloat: " << defaultfloat << sqrt(2.0) * 100 << endl;
    // 对于没有小数部分的浮点值是否打印小数点（默认不打印小数点）
    cout << "Default show point: " << 123.0 << endl;
    cout << showpoint; // 打印小数点
    cout << "Set show point: " << 123.0 << endl;
    cout << noshowpoint; // 打印小数点
    cout << "Clear show point: " << 123.0 << endl;

    // 输出补白
    cout << "Align default: "
        << "|" << setw(10) << -10 << "|" << setw(10) << 123.456 << "|" << endl;// setw指定下一数字或字符串输出的最小空间
    cout << left << "Align left:    " // left输出左对齐
        << "|" << setw(10) << -10 << "|" << setw(10) << 123.456 << "|" << endl;
    cout << right << "Align right:   " // left输出左对齐
        << "|" << setw(10) << -10 << "|" << setw(10) << 123.456 << "|" << endl;
    cout << internal << left << "Symbol left:   " // 负数符号的位置，如左对齐则对齐符号，右对齐则对齐值，用空格填满中间空间
        << "|" << setw(10) << -10 << "|" << setw(10) << 123.456 << "|" << endl;
    cout << internal << right << "Symbol right:  "
        << "|" << setw(10) << -10 << "|" << setw(10) << 123.456 << "|" << endl;
    cout << setfill('#') << "Fill with #:   " // 用#补白
        << "|" << setw(10) << -10 << "|" << setw(10) << 123.456 << "|" << endl;

    // 输入控制
    char inputCh;
    cout << "Default cin. Enter with white space. 'q' to stop." << endl;
    while (cin >> inputCh)
    {
        cout << inputCh;
        if ('q' == inputCh)
        { break; }
    }
    cout << endl;
    cout << "Keep white space cin. Enter with white space. 'q' to stop." << endl;
    cin >> noskipws; // 不跳过空白字符
    while (cin >> inputCh)
    {
        cout << inputCh;
        if ('q' == inputCh)
        { break; }
    }
    cout << endl;
    cin >> skipws; // 跳过空白字符

    /*
        未格式化IO (unformatted IO)：允许把流当作无解释的字节序列来处理
        is.get(ch)          从is读取一个字节存入ch，返回is
        os.put(ch)          将ch输出到os，返回os
        is.get()            将is的一个字节作为int返回
        is.putback(ch)      将ch放回is，返回is
        is.unget()          将is向后移动一个字节，返回is
        is.peek()           将一个字节作为int返回，但不从流中删除
        is.get(sink, size, delim)
        is.getline(sink,size,delim)
        is.read(sink,size)
        is.gcount()
        os.write(source,size)
        is.ignore(size,delim)
    */
    
}

void stdLibTest(void)
{
    tupleTest();
    bitsetTest();
    regularExpressionTest();
    randomTest();
    moreIO();
}
