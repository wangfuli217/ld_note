#include "stdafx.h"
#include "Item30.h"

void Item30::ItemEntry()
{
  //// Item 30: Understand the ins and outs of inlining.
  // 对于编译器来说，inline是request而不是command
  // 隐式的inline为定义在类内部的成员函数或友元函数
  // 显式的inline为给函数添加inline关键字
  // 当定义inline的template时，其所有的实例都会inline
  // 静态连接库里有函数为inline，当改变这些函数时，库用户必须重新编译所有用到这些函数的文件。
  // 如果不是inline的，改变这些函数后，库用户只要重新link即可。
  // 如果是动态连接库，库用户无法察觉到非inline的函数改变。
}
