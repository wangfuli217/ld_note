#include "stdafx.h"
#include "Item19.h"

void Item19::ItemEntry()
{
  //// Item 19: Treat class design as type design
  // 定义一个新的类就是定义一种新类型，所以设计类的时候，
  // 要像设计编程语言的开发者设计内建类型一样小心。

  // 设计一个类时，考虑如下问题：
  // 1. How should objects of your new type be created and destoyed?
  //    影响到构造函数和析构函数，内存分配和释放(new, new[], delete, delete[])
  // 2. How should object initialization differ from object assignment?
  //    构造函数和赋值操作符的不同实现
  // 3. What does it mean for objects of your new type to be passed by value?
  //    拷贝构造函数定义了这种类型在pass-by-value时的行为
  // 4. What are the restrictions on legal values for your new type?
  //    类成员合法值的限制影响类内部的不同分支逻辑，构造函数，赋值操作符，setter函数，可能抛出的异常等
  // 5. Does your new type fit into an inheritance graph?
  //    如果类继承已有的类，则受基类的虚函数和非虚函数的限制，其自身函数虚和非虚定义，又影响到其派生类
  // 6. What kind of type conversions are allowed for your new type?
  //    是否允许隐式和显式类型转换
  // 7. What operators and functions make sense for the new type?
  //    包括定义在类内部和外部的
  // 8. What standard functions should be disallowed?
  //    涉及到应该定义在private里的函数
  // 9. Who should have access to the members of your new type?
  //    影响成员的public/protected/private，友元类和友元函数，内部嵌套类
  //10. What is the "undeclared interface" of your new type?
  //    类对性能的影响，是否异常安全，资源的消耗
  //11. How general is your new type?
  //    如果需要定义很多类，是不是能用模板
  //12. Is a new type really what you need?
  //    如果创建派生类只是为了给基类添加一些功能，是不是可以定义一些非成员函数或模板来实现

}
