#include "stdafx.h"
#include "Item12.h"

void Item12::ItemEntry()
{
  // Item12: Understand how throwing an exception differs from passing
  //         a parameter or calling a virtual function.
  // 函数参数的语法就像catch语句，可以传值或引用或指针，如：
  // void function1(Widget W);
  // catch (Widget W) ...

  // 区别1:
  // 实质上不论catch语句是接受值还是引用，throw语句抛出的对象都是拷贝给catch语句的。
  // 因为异常产生时会离开当前scope，如果传局部变量引用给catch，在catch里局部变量已经被析构。
  // 因为永远是拷贝，所以catch语句执行比同样的函数调用要慢。
  // catch使用的是对象静态类型的拷贝构造函数，而非动态类型的拷贝构造。
  // catch (Widget w) 两次拷贝操作，一次是创建临时的exception对象，另一次是把临时对象拷贝给w
  // catch (Widget & w) 和 catch (const Widget & w) 都只有创建临时exception对象的一次拷贝
  // throw指针的时候不要指向局部变量，因为局部变量会被析构。

  // 区别2:
  // 函数参数会做隐式类型转换，catch只做两种类型转换：
  // 1. catch基类类型异常的语句能catch到子类类型
  // 2. catch无类型的指针(void *)可以catch到任何类型的指针

  // 区别3:
  // 多个catch语句总是按照出现的先后顺序尝试匹配，而不是像虚函数一样会自动找最匹配动态类型的对象所拥有的实现。
  // 如先写catch基类的语句，再写catch派生类的语句，抛出子类异常时总是被catch基类的语句捕获
  // 建议先写catch派生类的语句。
}
