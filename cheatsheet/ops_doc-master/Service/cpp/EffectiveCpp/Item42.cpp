#include "stdafx.h"
#include "Item42.h"

namespace ITEM42
{
  template<typename C>
  void f(const C& container, typename C::iterator iter) // C::iterator为nested dependent name
  {

  }
}

void Item42::ItemEntry()
{
  //// Item 42: Understand the two meanings of typename
  // 以下两种方式声明template是相同的：
  // template<class T> class Widget;
  // template<typename T> class Widget;
  // 在模板内部依赖于模板参数才能确定类型的名字叫dependent name，如typename C的C在模板内部用到的地方
  // 如果dependent name是属于某个类的，则称为nested dependent name，如C::iterator
  // 不依赖模板参数即可确定类型的名字叫non-dependent name，如int类型的变量名字

  // 因为nested dependent name在不知道C细节的时候无法确定其为类型还是C的成员，当其应为类型时，在其前面添加typename关键字



}
