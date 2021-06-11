#include "stdafx.h"
#include "Item47.h"

namespace ITEM47
{
  template<typename Obj>
  struct MyTrait // 通常用struct实现，称为trait class
  {};
}

void Item47::ItemEntry()
{
  //// Item 47: Use traits classes for information about types
  // Iterator的五种类型：
  // - Input iterator：只能向前移动，每次移动一步，只能读取指向的内容，只能读一次。如读取输入的istream_iterator。
  // - Output iterator：类似input，但用于输出
  // - Forward iterator：除了input和output的功能，还可以读或写多次。如hash容器
  // - Bidirectional iterator：可以双向移动。如list，set，map
  // - Random access iterator：可以做常量时间而非线性时间的一次多步跳跃。用内建指针实现。如vector，deque，string

  // trait：在编译器获取对象类型信息的技术
  // 因为要处理内置类型，所以不能往对象注入信息，只能用模板实现
  // 用重载的函数来替换运行时的if else判断，进行编译时按参数类型的不同处理

}
