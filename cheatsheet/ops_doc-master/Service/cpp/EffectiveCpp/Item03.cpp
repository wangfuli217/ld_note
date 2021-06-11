#include "stdafx.h"
#include "Item03.h"
#include <vector>

void Item03::ItemEntry()
{
  // Item 3: Use const whenever possible 

  char greeting[] = "hello";

  ///// 对于指针，const在星号左边表示指向的为const，在星号右边表示指针自身是const
  // const char * 和 char const *意义相同
        char*       p  = greeting; // non-const data, non-const pointer
  const char*       p1 = greeting; //     const data, non-const pointer
        char* const p2 = greeting; // non-const data,     const pointer
  const char* const p3 = greeting; //     const data,     const pointer

  ///// Iterator的行为类似与T*指针，但是其const的形式略有不同
  std::vector<int> intVec = { 1,2,3,4,5,6 };
  const std::vector<int>::iterator iter = intVec.begin(); // 注意，这里const的位置和指针的const用法不一致
                                                          // 这里相当于T* const，表示iterator自身为常量
  *iter = 10;
  //++iter; // 不能修改iter自身
  std::vector<int>::const_iterator cIter = intVec.begin(); // const_iterator表示iterator指向的值为const
  //*cIter = 10; // 不能修改指向的值
  ++cIter;

  ///// const成员函数表示这些函数不改变该类对象的非static成员，这些函数可以在const对象上被调用
  // 有两个不同的理念：
  // bitwise constness（或称physical constness）：const成员函数不改变该对象的非static成员。
  //    但考虑特殊情况，如果成员变量是指针，有const成员函数返回和成员变量相关的指针，这符合此概念，但调用者可以利用指针修改成员变量
  // logical constness：在上述特殊情况存在的条件下，const成员函数应该也允许改变成员的值，但必须在不能被调用者察觉的情况下改变。
  //    使用mutable修饰成员，来让const成员函数也可以改变成员的值。

  ///// 如果const版本成员函数和non-const版本成员函数内容相同，为了避免代码冗余，可以在non-const版本里调用const版本
  // 先用static_cast<const T&>(*this)把non-const的this强转为const，然后再用const_cast<T&>把const版本返回值的const限定去掉
}
