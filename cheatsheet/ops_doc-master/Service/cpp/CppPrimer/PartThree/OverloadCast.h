#pragma once

#include <iostream>

class OverloadTest
{

    friend std::ostream & operator<<(std::ostream &os, const OverloadTest &ins);
    friend std::istream & operator>>(std::istream &is, OverloadTest &ins);
    friend OverloadTest operator+(const OverloadTest &lhs, const OverloadTest &rhs);
    friend bool operator==(const OverloadTest &lhs, const OverloadTest &rhs);
    friend bool operator<(const OverloadTest &lhs, const OverloadTest &rhs);

public:
    OverloadTest(std::string initStr) : memStr(initStr) {};
    ~OverloadTest() {};

    /*
        重载的运算符是函数，其名字由关键字operator和其后要定义的运算符号组成，
        其参数与该运算符作用的运算对象数量一样多。

        对一个运算符函数来说，要么是类的成员，要么至少函授一个类类型的参数，
        为了防止内置类型的运算符被重载：int operator+(int, int);

        只能重载已有的运算符，不能创造运算符。

        可以重载的运算符：
            +       -       *       /       &       ^
            &       |       ~       !       ,       =
            <       >       <=      >=      ++      --
            <<      >>      ==      !=      &&      ||
            +=      -+      /=      %=      ^=      &=
            |=      *=      <<=     >>=     []      ()
            ->      ->*     new     new[]   delete  delete[]
        不可以重载的运算符：
            ::      .*      .       ?:
        不建议重载的运算符：
            逻辑与/或，逗号运算符重载后，运算对象求值顺序无法保留
            &&和||重载后无法保留短路求值属性，两个运算对象总是被求值
            逗号和取地址运算符对类类型对象有特殊含义，重载后导致用户无法适应
        必须是成员函数的重载：
            =       []      ()      ->
            复合赋值运算符（如+=）一般是成员，但非必须
            递增/递减/解引用运算符改变对象状态或与给定类型密切相关，通常是成员
            具有对称性的运算符可能转换任意一段的运算对象，如算术/相等性/关系/位运算符，通常是非成员函数

        调用的两种方式：
        data1 + data2
        operator+(data1, data2)

        如果是成员运算符函数，调用方式如下：
        data1 += data2
        data1.operator+=(data2)

        区别成员运算符函数和非成员运算符函数：
        string s = "world";
        string u - "hi" + s;    // 如果+被string重载为成员函数，则错误，相当于"hi".operator+(s)，而“hi“是const char *，内置类型没有成员
                                // 实际上，+被string重载为非成员函数，两个运算对象至少有一个是string类类型时，相当于operator+("hi",s)，两个实参都可转换为形参类型。
        string t = s + "!";     // 正确，同上
    */ 

    // 重载复合赋值运算符
    // 不一定要定义为类成员，但一般定义为类成员
    // 这样左侧运算符绑定到隐式的this
    // 返回左侧运算符对象的引用
    OverloadTest & operator+=(const OverloadTest &rhs);

    // 重载赋值运算符
    // 实现花括号的赋值
    OverloadTest & operator=(std::initializer_list<std::string> initVals);

    // 重载下标运算符
    // 必须是成员函数
    // 一般定义两个版本，一个返回普通引用，一个为常量成员并返回常量引用
    std::string & operator[](std::size_t idx);
    const std::string & operator[](std::size_t idx) const;

    // 重载递增递减运算符
    // 不要求是成员函数，但改变了操作对象的状态，建议设为成员函数
    // 前置版本
    OverloadTest & operator++(void);
    OverloadTest & operator--(void);
    // 后置版本
    // 编译器为了与前置版本区分，规定后置版本接收一个int型参数
    // 调用后置版本时，编译器为其提供值为0的实参
    // 从语法来说可以使用此实参，但一般不用
    OverloadTest & operator++(int); // 因为不用这个参数，不用为其命名
    OverloadTest & operator--(int);

    // 重载成员访问运算符
    // 一般用于迭代器类和智能指针类
    std::string & operator*(void);
    std::string* operator->(void);

    // 函数调用运算符
    // 必须是成员函数，可利用参数数量和类型差别多次重载函数调用运算符
    // 定义了函数调用运算符的类对象叫函数对象function object
    // lambda表达式会被编译器翻译为具有重载函数调用运算符的未命名类的未命名对象的调用
    // 函数对象常用作泛型算法实参
    // 可直接使用函数对象和()调用
    std::string operator() (std::string arg) const;
    
    // 标准库在functional头文件中定义了一组表示算术运算符/关系运算符/逻辑运算符的类
    // 算术：
    //      plus<Type>  minus<Type>  multiplies<Type>  divides<Type>  mudulus<Type>  nagate<Type>
    // 关系：
    //      equal_to<Type>  not_equal_to<Type>  greater<Type>  greater_equal<Type>
    //      less<Type>  less_equal<Type>
    // 逻辑：
    //      logical_and<Type>  logical_or<Type>  logical_not<Type>

    // 辅助函数
    void setMemStr(const std::string &newStr);
    std::string getMemStrAry(void);

private:
    std::string memStr;
    std::string memStrAry[3] = { "default", "default", "default" };
    std::string invalidIndex = std::string("Invalid Index");
};

// 重载输出运算符<<
// 第一个形参为非常量（写入流会改变其状态）ostream对象引用（无法复制ostream对象），
// 第二个形参为想要打印的类类型的常量（一般不会改变打印对象的内容）引用（避免复制实参）
// 与其他输出运算符保持一致，返回ostream形参
// 必须是非成员函数，否则第一个形参必须是对应类的对象
std::ostream & operator<<(std::ostream &os, const OverloadTest &ins);

// 重载输入运算符>>
// 第一个形参为要读取的流的引用
// 第二个形参为要读入到的非常量对象的引用
// 返回给定流的引用
std::istream & operator>>(std::istream &is, OverloadTest &ins);

// 重载算术运算符
// 参数为常量的引用，因为不需要改变运算对象的状态
// 运算后得到新值，操作完后返回该局部变量的副本
OverloadTest operator+(const OverloadTest &lhs, const OverloadTest &rhs);

// 重载相等运算符
bool operator==(const OverloadTest &lhs, const OverloadTest &rhs);

// 重载关系运算符
bool operator<(const OverloadTest &lhs, const OverloadTest &rhs);


class ConversionTest
{

public:
    ConversionTest() {};
    // 利用构造函数把int转为类对象
    ConversionTest(int initInt) : memInt(initInt) {
        std::cout << "Change int to class." << std::endl;
    };
    ~ConversionTest() {};

    // 类型转换运算符Conversion Operator
    // 负责将一个类类型的值转换为其他类型
    // 一般形式：operator type() const;
    // type为要转换的类型，不允许转换为数组或函数类型
    // 允许转换为指针（数组或函数指针皆可）或引用类型
    // 类型转换运算符没有显式的返回类型，也没有形参，必须定义为类成员函数
    // 一般不改变转换对象的内容，故定义为常量成员函数
    // 不能显式调用，只能隐式执行
    
    // 利用类型转换运算符把类对象转换为int
    // 以下定义使得编译器能隐式转换类类型为int
    operator int() const { std::cout << "Change class to int." << std::endl; return memInt; }
    // 以下定义只能显式转换类类型为int，如只有此定义，则编译器需要隐式类类型转换时会报错
    //explicit operator int() const { std::cout << "Explicit change class to int." << std::endl; return memInt; }

private:
    int memInt;
};

void testOverloadCast(void);

