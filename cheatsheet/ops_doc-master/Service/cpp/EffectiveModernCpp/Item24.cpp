#include "stdafx.h"
#include "Item24.h"

Item24::Item24() :
  ItemBase("24")
{
}


Item24::~Item24()
{
}


void Item24::ItemEntry()
{
  // T&&不一定是右值引用，例如：
  // void f(Widget&& param)         // 右值引用
  // Widget&& var1 Widget();        // 右值引用
  // auto&& var2 = var1;            // auto声明，universal reference
  // template<typename T>
  // void f(std::vector<T>&& param);// 右值引用
  // template<typename T>
  // void f(T&& param);             // 作为函数的模板参数，universal reference

  // T&&可以绑定到右值（同右值引用），
  // 可以作为左值引用，
  // 可以绑定到const或non-const
  // 可以绑定到volatile或non-volatile
  // 几乎可以绑定所有对象。可以成为universal reference或forwarding reference
  //
  // 两种情况下T&&为universal reference：auto声明或作为函数的模板参数
  // 原因是type deduction
  // template<typename T>
  // void f(T&& param);           // Universal reference
  // auto&& var2 = var1;          // Universal reference
  // universal reference用左值初始化即为左值引用，用右值初始化即为右值引用，如：
  // Widget w;
  // f(w);                        // w为左值，param类型为Widget&左值引用
  // f(std::move(w));             // move之后类型转换为右值，param类型为Widget&&右值引用
  // 但要注意有限定符的情况下，T&&就不是universal reference了，如：
  // template<typename T>
  // void f(std::vector<T>&& param);  // param是右值引用
  // vector<int> v;
  // f(v);                            // 错误，v是左值，不能绑定到右值引用
  // template<typename T>
  // void f(const T&& param);         // 加上const之后，param也不是universal reference而是右值引用
  // 但并不是只有T&&出现就是universal reference



}
