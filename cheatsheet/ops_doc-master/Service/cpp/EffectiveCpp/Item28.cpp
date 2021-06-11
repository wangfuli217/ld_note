#include "stdafx.h"
#include "Item28.h"

void Item28::ItemEntry()
{
  //// Item 28: Avoid returning "handles" to object internals.
  // handle指可用于获得另一个对象的方法，如reference，pointer，iterator。
  // 如果类成员函数（即使是const）返回handle，则调用者可使用handle修改类内部的私有成员，这些成员变得不再私有。
  // 返回const的handle相当于给用户只读的handle，可解决此问题。
  // 但即使返回const的handle，用户仍然可能自己定义指针指向handle所指向的数据，之后如果提供此handle的对象被销毁，用户持有的指针即悬空。
  // 仅可能避免用成员函数返回handle，但不是绝对的规则
}
