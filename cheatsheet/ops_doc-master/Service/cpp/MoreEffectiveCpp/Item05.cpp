#include "stdafx.h"
#include "Item05.h"

namespace ITEM05
{
  class MyInteger
  {
  public:
    // 通过构造函数支持隐式类型转换
    MyInteger(int intVal) : m_val(intVal) {};
    explicit MyInteger(string strVal) : m_val(65535) {};
    MyInteger(std::wstring wstrVal, int addition = 1) : m_val(32767 + addition) {};

    void Display() { cout << "MyInteger: " << m_val << endl; }

    int m_val{ 0 };
  };

  class MyNotInteger
  {
  public:
    MyNotInteger(int intVal) : m_val(intVal) {};

    // 隐式类型转换操作符： operator 要转换的类型() {}
    operator MyInteger()
    {
      MyInteger myInteger{0};
      myInteger.m_val = this->m_val;
      return myInteger;
    }

    int m_val{ 0 };
  };
}

using namespace ITEM05;

void Item05::ItemEntry()
{
  // Item05: Be wary of user-defined conversion functions.
  // 自定义的类如果要让编译器支持隐式类型转换有两种方式：
  // 1. 创建可以只提供单个参数来调用的构造函数
  // 2. 重载隐式类型转换操作符

  MyInteger myIntegerCtorInt = 123 ;
  myIntegerCtorInt.Display();

  MyInteger myIntegerCtorDouble = 654.321;
  myIntegerCtorDouble.Display();

  // Explicit阻止隐式类型转换
  //MyInteger myIntegerCtorStringFail = string("anything");
  //MyInteger myIntegerCtorStringFail = "anything";
  // 但显示调用构造函数时，参数可隐式转换
  MyInteger myIntegerCtorStringOk{ "anything" };
  myIntegerCtorStringOk.Display();

  MyInteger myIntegerCtorWstring = std::wstring(L"ANYTHING");
  myIntegerCtorWstring.Display();

  MyNotInteger myNotInteger{ 135 };
  MyInteger myInteger = myNotInteger;
  myInteger.Display();

  // 由于编译器在无匹配操作时会尝试各种可能的隐式类型转换，
  // 如果自定义隐式类型转换后，没有重载必要的操作，编译器可能先做最合适的隐式类型转换，然后执行操作，而不是直接报错。
  // 尽量不要实现隐式类型转换操作符，而提供显式类型转换函数。如标准库的string转C类型的char*，需要显式地调用c_str函数。
  // 避免构造函数成为隐式类型转换用explicit关键字。
}
