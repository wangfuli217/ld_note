#include "stdafx.h"
#include "Item41.h"

void Item41::ItemEntry()
{
  //// Item 41: Understand implicit interfaces and compile-time polymorphism

  // 面向对象编程处理explicit interface和runtime polymorphism
  // explicit interface: 当声明一个类的对象时，此对象提供类定义的接口，可以显式地通过查看类定义的源代码来确认接口。
  // runtime polymorphism：如果类有虚函数，则实际调用的函数是在运行时由动态类型确定的。

  // 模板和泛型编程更关注implicit interface和compile-time polymorphism
  // implicit interface：由于模板类在使用一个类型为T的对象时，只是在语句中调用此对象的接口，并没有接口的签名，所以是隐式地知道那些实际类型会提供能适配语句的接口
  // compile-time polymorphism：实际调用的T对象接口，是在编译时期根据模板实例来确定T的真实类型。


}
