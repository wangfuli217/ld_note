#include "stdafx.h"
#include "Item27.h"

namespace ITEM27
{
  class BaseClass
  {
  public:
    BaseClass() = default;
    virtual ~BaseClass() = default;

    virtual void changeName(string newName) { m_name = "BASE-" + newName; }
    virtual void printName() { cout << "BASE NAME: " + m_name << endl;; }
  private:
    string m_name{ "BASE-Default" };
  };

  class DerivedClass : public BaseClass
  {
  public:
    DerivedClass() = default;

    void changeName(string newName) override
    {
      // 错误的调用基类方法，会产生一封基类对象的拷贝，调用的changeName是拷贝得到的对象的成员。
      // 导致调用后此函数后原对象基类的部分没有变化，派生类的部分被修改
      //static_cast<BaseClass>(*this).changeName(newName);

      // 正确的调用基类成员函数方法
      BaseClass::changeName(newName);

      m_name = "DERIVED-" + newName;
    }

    void printName() override
    {
      BaseClass::printName();
      cout << "DERIVED NAME: " + m_name << endl;;
    }

  private:
    string m_name{ "DERIVED-Default" };
  };
}

void Item27::ItemEntry()
{
  //// Item 27: Minimize casting.
  // 老式C风格类型转换，只是写法不同功能没有差别：
  // 1. (T)expression
  // 2. T(expression)
  // C++风格类型转换：
  // 1. const_cast<T>(expression)
  //    唯一的能去掉const的C++类型转换
  // 2. dynamic_cast<T>(expression)
  //    用于在继承结构里safe downcasting。用C风格的类型转换无法实现。但运行时对想能影响比较大，因为有很多实现需要比较类名的字符串。
  // 3. reinterpret_cast<T>(expression)
  //    底层类型转换，比如指针转int。不是底层代码尽量少用。
  // 4. static_cast<T>(expression)
  //    可以强行隐式转换，如非const转const，int转double，void*转类型指针，指向基类的指针转派生类指针。

  ITEM27::DerivedClass derivedIns{};
  cout << endl << "-----Print default values" << endl;
  derivedIns.printName();
  cout << endl << "-----Print changed values" << endl;
  derivedIns.changeName("Changed");
  derivedIns.printName();
  
}
