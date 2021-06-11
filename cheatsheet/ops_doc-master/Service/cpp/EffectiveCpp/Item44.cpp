#include "stdafx.h"
#include "Item44.h"

void Item44::ItemEntry()
{
  //// Item 44: Factor parameter-independent code out of templates
  // 编译器产生模板实例的时候，只有被代码调用到的成员函数才会实例化
  // 但是不小心的话可能造成看起来少量代码，编译器生成很多重复的部分。Code bloat。
  // 为了避免这种情况出现，要做commonality and variability analysis.
  // 找到template里会因为模板类型不同而导致重复的代码，把这部分代码从模板剥离出去。
}
