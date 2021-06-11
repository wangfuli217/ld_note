#pragma once
#include <iostream>
#include <string>

// 聚合类aggregrate class必须满足如下条件：
// - 所有成员都是public
// - 没有定义任何构造函数
// - 没有类内初始值
// - 没有基类，没有virtual函数
// 如果聚合类的成员都是字面值，则类为字面值常量类
class CppPrimerAggregate
{
public:
    std::string stringVar;
    int intVar;

    void printStr(void) { std::cout << stringVar << std::endl; }
};

