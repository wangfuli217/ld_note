#include "stdafx.h"
#include "Item22.h"
#include <vector>
#include <memory>
#include "ClassHierarchy.h"

using std::cout;
using std::endl;
using std::unique_ptr;
using std::make_unique;
using std::shared_ptr;
using std::make_shared;
using std::vector;

Item22::Item22() :
  ItemBase("22")
{
}


Item22::~Item22()
{
}


void Item22::ItemEntry()
{
  // Pimpl Idiom: Pointer to implementation idiom
  // 
  // 优点
  // 改变类私有成员变量不需要重新编译用到这个类的其他类 -> 缩短编译时间，解决FragileBinaryInterfaceProblem
  // 头文件不需要包含私有部分的实现类的头文件 -> 加速编译
  //
  // 可以用unique_ptr也可以用shared_ptr实现
  // unique_ptr实现有特别的注意事项。
  // 详见原文。
}
