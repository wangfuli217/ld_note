#include "stdafx.h"
#include "Item01.h"

Item01::Item01() :
  ItemBase("01")
{
}


Item01::~Item01()
{
}


void Item01::ItemEntry()
{
  // 对于函数模板来说（Paramtype是和T相关但可能添加了限定符的部分，如const T&）：
  // template<typename T>
  // void f(ParamType param);

  // 在调用这个模板时：
  // f(expr);
  // 编译器从expr推导出T和ParamType
  
  // 但有三种情况下，推导不光依赖于expr，还依赖于ParamType的形式。

  // 1. ParamType是指针或引用，但不是universal reference
  // 规则：如果expr是引用，则忽略引用部分，接着用expr的类型去套ParamType的模式来决定T
  //
  // 引用的情况例如：
  // template<typename T>
  // void f(T& param);        // ParamType是引用
  //
  // int x = 27;
  // f(x);                    // T是int，param类型为int&
  //
  // const int cx = x;
  // f(cx);                   // T是const int, param类型为const int&
  //
  // const int& rx = x;
  // f(rx);                   // T是const int，param类型为const int&
  //                          // expr是引用，按规则忽略其引用部分后，相当于情况b
  //
  // 指针的情况例如：
  // template<typename T>
  // void f(T* param);
  //
  // 情况a：
  // int x = 27;
  // f(&x);                   // T是int，param类型为int*
  //
  // 情况b：
  // const int *px = &x;
  // f(px);                   // T是const int，param类型为const int*

  // 2. ParamType是universal reference
  // 规则：如果expr是左值，T和ParamType都被推导为左值引用
  // 规则：如果expr是右值，按照"1."的规则推导
  //
  // 例如：
  // template<typename T>
  // void f(T&& param);       // param是universal reference
  // 
  // int x = 27;
  // f(x);                    // x为左值，T是int&，param类型为int&
  //
  // const int cx = x;
  // f(cx);                   // cx为左值，T是const int&, param类型为const int&
  //
  // const int& rx = x;
  // f(rx);                   // rx为左值，T是const int&, param类型为const int&
  //
  // f(27);                   // 27为右值，T是int，param类型为T&&

  // 3. ParamType既不是指针也不是引用
  // 相当于传值（拷贝），所以可以忽略各种限定符
  // 规则：如果expr是引用，忽略引用部分；忽略引用后如果expr是const，忽略const，如果expr是volatile，忽略volatile
  //
  // 例如：
  // template<typename T>
  // void f(T param);
  //
  // int x = 27;
  // f(x);                    // T和param类型都为int
  //
  // const int cx = x;
  // f(cx);                   // T和param类型都为int
  //
  // const int& rx = x;
  // f(rx);                   // T和param类型都为int
  //
  // const char* const ptr = "test";  // 左边的const表示指针指向的字符串不可修改
  //                                  // 右边的const表示指针自身的值（指向的地址）不可修改
  // f(ptr);                  // T和param类型都为const char*，右边的const被忽略，左边的const保留

  // 注意小心处理原始array和函数指针
}
