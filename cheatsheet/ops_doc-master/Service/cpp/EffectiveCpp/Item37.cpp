#include "stdafx.h"
#include "Item37.h"

namespace ITEM37
{
  class BaseClass
  {
  public:
    virtual void Virtual(string par = "BaseDefaultPar") { cout << "BASE Virtual: " << par << endl; }
  };

  class DerivedClass : public BaseClass
  {
  public:
    void Virtual(string par = "DerivedDefaultPar") override { cout << "DERIVED Virtual: " << par << endl; }
  };

  class AnotherDerivedClass : public BaseClass
  {
  public:
    void Virtual(string par) override { cout << "ANODERIVED Virtual: " << par << endl; }
  };
}

void Item37::ItemEntry()
{
  //// Item 37: Never redefine a function's inherited default parameter value
  // 虚函数动态绑定（dynamic binding或late binding），参数默认值静态绑定（static binding或early binding）
  // 静态类型是声明是在代码字面上的类型，和赋予的对象类型无关。

  using ITEM37::BaseClass;
  using ITEM37::DerivedClass;
  using ITEM37::AnotherDerivedClass;

  BaseClass* pB1;                           // 静态类型为BaseClass*；动态类型没有，因为还没赋值
  BaseClass* pB2 = new DerivedClass;        // 静态类型为BaseClass*；动态类型为DerivedClass*
  BaseClass* pB3 = new AnotherDerivedClass; // 静态类型为BaseClass*；动态类型为AnotherDerivedClass*
  // 通过赋值可以改变动态类型
  // 虚函数是动态绑定的，但参数默认值为了提高效率是静态绑定的，所以参数静态值都是基类的静态值
  pB2->Virtual();
  pB3->Virtual();
  delete pB2;
  delete pB3;

}
