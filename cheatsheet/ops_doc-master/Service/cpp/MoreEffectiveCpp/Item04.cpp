#include "stdafx.h"
#include "Item04.h"

namespace ITEM04
{
  class NoDefaultCtor
  {
  public:
    NoDefaultCtor(int i) {};
  };
}

using ITEM04::NoDefaultCtor;

void Item04::ItemEntry()
{
  // Item04: Avoid gratuitous default constructors.

  // 如果默认构造函数不可用，就无法创建array，也无法在堆上new出array
  //NoDefaultCtor noDefaultCtor{};
  //NoDefaultCtor noDefaultCtorAry[3];
  //NoDefaultCtor *noDefaultCtorAryPtr = new NoDefaultCtor[3];

  // 解决方案: 显式调用非默认构造函数
  NoDefaultCtor noDefaultCtorAry[3] =
  {
    NoDefaultCtor(1),
    NoDefaultCtor(2),
    NoDefaultCtor(3)
  };

  // 对于堆上new的array，一个一个new，和指针数组元素一个一个绑定

  // 没有默认构造函数的另一个问题是无法使用基于模板的容器类
  // 模板容器类一般都会要求其类型提供默认构造函数，因为模板内部是用array实现的。

  // 没有默认构造函数的虚基类要求其派生类提供其构造需要的参数

  // 但如果默认构造函数构造出来的对象没有存在的实际意义，即使有以上的问题存在，也不要提供默认构造函数
}
