#include "stdafx.h"
#include "Item02.h"

Item02::Item02() :
  ItemBase("02")
{
}


Item02::~Item02()
{
}


void Item02::ItemEntry()
{
  // 可以把auto当作template
  // auto x = 27;
  // const auto cx = x;
  // const auto& rx = x;
  // 相当于auto是T，auto和const auto和const auto&为T的ParamType：T和const T和const T&
  //
  // 所以auto的推导规则和模板一样（包括原始指针和函数指针），除了一种例外情况
  // auto x = 27;             // 对应"3."，x不是指针也不是引用
  // const auto cx = x;       // 对应"3."，x不是指针也不是引用
  // const auto& rx = x;      // 对应"1."，x是非universal reference
  // auto&& uref1 = x;        // 对应"2."，x是左值，推导为int&
  // auto&& uref2 = cx;       // 对应"2."，cx是const int，也是左值，推导为int&
  // auto&& uref3 = 27;       // 对应"2."，27是int右值，推导为int&&
  //
  // 例外情况
  // C++98初始化的两种方式：
  //    int x1 = 27;
  //    int x2(27);
  // C++11提供的额外方式：
  //    int x3 = { 27 };
  //    int x4{ 27 };
  // 当用auto替换int类型时
  //    auto x1 = 27;       // auto推导为int
  //    auto x2(27);        // 同上
  //    auto x3 = { 27 };   // auto推导为std::initializer_list<int>
  //    auto x4{ 27 };      // 同上
  // 例外情况在于auto假设大括号的initializer是initializer_list，而template需要手动指定TypeParam为initializer_list类型
  // C++14在auto当函数返回值或lambda表达式参数时，不能推导大括号为initializer_list


}
