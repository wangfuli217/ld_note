#include "stdafx.h"
#include "Item45.h"

namespace ITEM45
{
  // 模拟智能指针的实现
  template<typename T>
  class MySmartPointer
  {
  public:

    MySmartPointer(T t) { cout << "MySmartPointer<T>::CTOR(T)" << endl; }

    // 接受通用派生类类型的拷贝构造函数 generalized copy constructor：
    // 特定类型的模板实例对象 可以用同一个模板的不同类型实例对象 来创建
    // 表示MySmartPointer<T>可以由MySmartPointer<S>创建
    // 但此时S和T可以相互构造
    template<typename S>
    MySmartPointer(const MySmartPointer<S>& another)
    { cout << "MySmartPointer<T>::CTOR(MySmartPointer<S>)" << endl; }
  };

  // 只支持能够隐式类型转换的构造函数
  template<typename T>
  class MySmartPointerAdvanced
  {
  public:

    MySmartPointerAdvanced(T t) : m_typeT(t) { cout << "MySmartPointerAdvanced<T>::CTOR(T)" << endl; }

    // 
    template<typename S>
    MySmartPointerAdvanced(const MySmartPointerAdvanced<S>& another) :
      m_typeT(another.m_typeT) // 如果不能隐式类型转换则编译错误
    {
      cout << "MySmartPointerAdvanced<T>::CTOR(MySmartPointerAdvanced<S>)" << endl;
    }

    T m_typeT;
  };


}

void Item45::ItemEntry()
{
  //// Item 45: Use member function templates to accept "all compatible types."
  // Member function template或称member template，用于为类生成成员函数的函数模板
  using ITEM45::MySmartPointer;
  MySmartPointer<int> intIns{123};
  MySmartPointer<double> doubleIns{ intIns };
  MySmartPointer<int> intInsAnother{ doubleIns };

  using ITEM45::MySmartPointerAdvanced;
  MySmartPointerAdvanced<int> intAdvIns{ 123 };
  MySmartPointerAdvanced<double> doubleAdvIns{ intAdvIns }; // int 能转 double
  //MySmartPointerAdvanced<int> intAdvInsAnother{ doubleAdvIns }; // double 不能转 int，编译错误

}
