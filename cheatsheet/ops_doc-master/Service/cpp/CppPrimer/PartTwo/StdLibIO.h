#pragma once

// 类型：
// istream, wistream 从流读取数据
// ostream, wostream 向流写入数据
// iostream, wiostream 读写流
#include <iostream>
// 类型：
// ifstream, wifstream 从文件读取数据
// ofstream, wofstream 向文件写入数据
// fstream, wfstream 读写文件
#include <fstream>
// 类型：
// istringstream, wistringstream 从string读取数据
// ostringstream, wostringstream 向string写入数据
// stringstream, wstringstream 读写string
#include <sstream>
// ifstream和istringstream都继承自istream
// ostream类似

// IO库设施：
// - istream    输入流
// - ostream    输出流
// - cin        istream对象，从标准输入读取数据
// - cout       ostream对象，向标准输出写入数据
// - cerr       ostream对象，向标准错误写入数据
// - >>         用来从istream对象读取输入数据
// - <<         用来向ostream对象写入输出数据
// - getline()  从istream对象读取一行数据，存入string对象
//
// IO对象不能拷贝或赋值，所以不能将形参或返回类型设为流类型，
// 要用引用方式传递和返回流。读写IO对象会改变其状态，所以IO的引用不能是const。

class StdLibIO
{
public:
    StdLibIO();
    ~StdLibIO();

    // 流的条件状态 condition state
    void conditionState(void);
    // 输出缓冲
    void outputBuffer(void);
    // 文件输入输出
    void fileStream(void);
    // string流
    void stringStream(void);
};

