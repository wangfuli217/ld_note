#include "stdafx.h"
#include "Item34.h"

namespace ITEM34
{
  // 有纯虚函数的类是abstract class，不能产生实例
  class BaseClass
  {
  public:
    virtual void PureVirtualFunc() = 0
    {
      cout << "BaseClass: PureVirtualFunc" << endl;
    }

    virtual void VirtualFuncNoOverride()
    {
      cout << "BaseClass: VirtualFuncNoOverride" << endl;
    }

    virtual void VirtualFuncOverride()
    {
      cout << "BaseClass: VirtualFuncOverride" << endl;
    }

    void Func()
    {
      cout << "BaseClass: Func" << endl;
    }
  };

  class DerivedClass : public BaseClass
  {
  public:
    void PureVirtualFunc() override
    {
      cout << "DerivedClass: PureVirtualFunc" << endl;
    }

    void VirtualFuncOverride() override
    {
      cout << "DerivedClass: VirtualFuncOverride" << endl;
    }

    // 不应该定义与基类相同的函数
#if 0
    void Func()
    {
      cout << "DerivedClass: Func" << endl;
    }
#endif
  };
}

void Item34::ItemEntry()
{
  //// Item 34: Differentiate between inheritance of interface and inheritance of implementation
  // 纯虚函数让派生类inherit interface，基类要求派生类提供实现，但基类一般不提供默认实现
  // 普通虚函数让派生类inherit interface和default implementation。
  // 普通函数让派生类inherit interface和mandatory implementation。不允许派生类有不同的行为。

  ITEM34::DerivedClass derived{};

  // 调用派生类实现的纯虚函数
  derived.PureVirtualFunc();
  // 调用基类实现的纯虚函数
  derived.BaseClass::PureVirtualFunc();

  // 调用没有override的虚函数
  derived.VirtualFuncNoOverride();
  // 调用override的虚函数
  derived.VirtualFuncOverride();

  // 调用普通函数
  derived.Func();
}
