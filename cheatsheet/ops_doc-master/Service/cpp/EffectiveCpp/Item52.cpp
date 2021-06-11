#include "stdafx.h"
#include "Item52.h"

void Item52::ItemEntry()
{
  //// Item 52: Write placement delete if you write placement new
  // 接收除了size_t之外参数的new，称为placement version of new
  // new一个类的时候，首先分配内存空间，接着调用类的构造函数。
  // Widget *pw = new Widget;
  // 但如果构造函数抛出异常，则需要C++运行时环境捕获并调用new对应的delete，以免内存泄漏。
  // 运行时环境在处理replacement of new的情况时，尝试寻找和replacement of new有相同参数的replacement of delete.
  // 如果找不到则不调用任何delete。此时发生内存泄漏。
  // 注意delete时
  // delete pw; 
  // 此语句调用普通的delete，而非replacement of delete。所以提供replacement of new时，要同时提供普通的delete和replacement of delete.

  // 在继承的情况下，注意相互覆盖的条件
  // C++默认在全局提供如下三种new
  // void* operator new(std::size_t) throw(std::bad_alloc);      // normal new
  // void* operator new(std::size_t, void*) throw();             // placement new
  // void* operator new(std::size_t, const std::nothrow_t&) throw();  // nothrow new
  // 在类内部定义任何形式的new都会隐藏以上三种。不想隐藏的话要在类中添加相同签名的函数，调用全局的版本。
  // delete同理






}
