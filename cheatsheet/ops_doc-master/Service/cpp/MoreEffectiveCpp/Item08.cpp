#include "stdafx.h"
#include "Item08.h"

void Item08::ItemEntry()
{
  // Item08: Understand the different meanings of new and delete.
  // new operator: 是语言内建的操作符，类似于sizeof。使用语言的人不可改变其意义。
  //    此操作符做两件事：分配足够存储该类型对象的内存；调用内存中此对象的构造函数。
  //    例： string *ps = new string("Memory Management");
  // operator new: 是new operator调用的用于分配内存的函数。可以重载以实现自定义的内存分配方式。
  //    重载函数为：void * operator new(size_t size);
  //    返回值为void *，因为返回的是未初始化的内存。
  //    参数为分配内存的大小。重载时可添加参数，但第一个参数必须为size_t类型。
  //    调用此函数： void *rawMemory = operator new(sizeof(string));
  // 区别：operator new只管分配原始内存，new operator除了调用operator new之外，还负责调用构造函数把原始内存变为对象。
  // 对于语句 string *ps = new string("Memory Management"); 来说，编译器生成以下代码：
  // 1. void *memory = operator new(sizeof(string));
  // 2. 在*memory上调用string::string("Memory Management"); // 使用C++语言的人无法执行此步骤，只有编译器可以
  // 3. string *ps = static_cast<string*>(memory);

  // delete operator和operator delete类似。
  // operator delete函数：void operator delete(void *memoryToBeDeallocated);
  // 对语句delete ps;来说，编译器生成以下代码：
  // 1. ps->~string();
  // 2. operator delete(ps);
  // 如果只回收未初始化的内存，使用operator delete，此时不执行析构函数。即：
  // void *buffer = operator new(50 * sizeof(char));
  // ...
  // operator delete(buffer);
  // 可以理解为C++版本的malloc和free

  // Placement new用于在指定的内存位置调用指定类型的构造函数创建对象
  // 用于在共享内存或映射到内存的IO上创建对象。
  // 使用方法为： new (buffer) Widget(widgetSize); // buffer为内存地址的位置，Widget为指定对象，widgetSize为对象大小
  // 实际上是调用有额外buffer参数的重载operator new，称为placement new，其实现为：
  // void * operator new(size_t, void *location) { return location; }
  // 其效果为返回location，让new operator在其上调用构造函数
  // 使用placement new必须#include <new>
  // 清除placement new时不能直接调用delete operator，因为placement new的内存来源不明，可能是不能delete的。
  // 此时只要显式调用析构函数就足够了。

  // 对于语句 string *ps = new string[10];
  // 调用的依然是new operator，但分配内存的是operator new[]
}
