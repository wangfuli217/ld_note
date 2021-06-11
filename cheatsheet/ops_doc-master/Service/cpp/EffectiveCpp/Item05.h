#pragma once

#include "ItemBase.h"

class Item05 : public ItemBase
{
public:
  Item05() : ItemBase("05") { }
  ~Item05() = default;

  void ItemEntry() override;
};

// 定义一个空的类
#if 0
class Item05Example {};
#endif

// 相当于让编译器按照需要生成如下默认的成员函数：
class Item05Example
{
public:
  Item05Example() {} // 默认构造函数，由语句 Item05 item; 产生
  Item05Example(const Item05Example& rhs) {} // 默认拷贝构造函数，由语句 Item05 anoItem(item); 产生
  ~Item05Example() {} // 默认析构函数，由语句 Item05 item; 产生
  Item05Example& operator=(const Item05Example& rhs) {} // 拷贝赋值运算符，由语句 anoItem = item; 产生
};

// 默认的实现调用基类的构造函数和析构函数，构造和析构非静态数据成员
// 注意：默认的析构函数非virtual，除非其基类有virtual的析构函数
// 默认的拷贝构造函数和拷贝赋值操作符仅仅简单地拷贝非静态成员。

// 一旦声明了自定义构造函数，编译器就不再生成默认构造函数
// 即使声明了自定义构造函数，在不声明拷贝构造函数和拷贝赋值运算符时，编译器还是会尝试生成默认版本。
// 如果编译器无法生成默认版本（如无法拷贝const成员，无法拷贝引用成员），则产生编译错误。

