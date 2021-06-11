#include "stdafx.h"
#include "Item06.h"

void Item06::ItemEntry()
{
  ///// Item 6: Explicitly disallow the use of compiler-generated functions you do not want
  // 不想提供拷贝构造函数和拷贝操作符时，声明他们为private（普通类不能调用private成员函数），且不定义（其他的成员函数和友元因未定义而调用失败）
}

