#pragma once

// 不是聚合类的类，如果符合下列条件，为字面值常量类：
// * 数据成员都是字面量类型
// * 必须至少含有一个constexpr构造函数
// * 如果数据成员含有类内初始值
//   - 内置类型成员初始值必须是常量表达式
//   - 其他类型的成员初始值必须使用constexpr构造函数初始化
// * 类必须使用默认定义的析构函数
class CppPrimerLiteral
{
public:
    constexpr CppPrimerLiteral(bool bVar = true)
        : boolVar(bVar) {};
private:
    bool boolVar;
};

