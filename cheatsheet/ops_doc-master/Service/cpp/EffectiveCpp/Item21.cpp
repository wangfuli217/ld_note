#include "stdafx.h"
#include "Item21.h"

void Item21::ItemEntry()
{
  //// Item 21: Don't try to return a reference when you must return an object
  // 函数把局部变量（栈内）作为引用返回，或将其地址作为指针返回，会因为局部变量在结束作用域后被清理而返回无效的引用和指针。
  // 用new在堆上分配空间，并返回对象是可行的，但要求函数的使用者来做delete操作不合理。
  // 所以该用拷贝返回的时候还是要用拷贝返回。

}
