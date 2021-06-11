#include "stdafx.h"
#include "Item03.h"

Item03::Item03() :
  ItemBase("03")
{
}


Item03::~Item03()
{
}


void Item03::ItemEntry()
{
  // decltype: 给一个名字或者表达式，返回对应的类型

  // 常见的情况：
  //const int i = 0;              // decltype(i)为const int
  //bool f(const Widget& w);      // decltype(w)为const Widget&
  //                                 decltype(f)为bool(const Widget&)
  // struct Point { int x,y; };   // decltype(Point::x)为int
  // Widget w;                    // decltype(w)为Widget
  // if(f(w))...                  // decltype(f(w))为bool
  // vector<int> v;               // decltype(v)为vector<int>
  // if (v[0] == 0)...            // decltype(v[0])为int&

  // C++11里decltype很有用的功能是使用函数的参数类型类声明函数的返回类型
  // auto表明返回类型从尾置返回类型trailing return type得到
  // template<typename Container, typename Index>
  // auto authAndAccess(Container& c, Index i)
  // -> decltype(c[i]) {}
  // 返回类型使用了参数c和i，所以用尾置返回类型

}
