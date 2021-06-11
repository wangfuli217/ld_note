#include "stdafx.h"
#include "Item18.h"

using std::cout;
using std::endl;
using std::unique_ptr;
using std::make_unique;

std::unique_ptr<ClassBase> FactoryUniquePtr::createInstDeleterDefault(int deriveType)
{
  if (deriveType == 1)
  {
    return make_unique<ClassDerived1>();
  }
  else
  {
    return make_unique<ClassDerived2>();
  }
}

void myDeleterFunc(ClassBase *pClassBase)
{
  cout << "myDeleterFunc()" << endl;
  delete pClassBase;
}

auto FactoryUniquePtr::createInstDeleterCustom(int deriveType)
{

  // 使用函数和使用lambda表达式效果相同，建议使用lambda表达式
#if 0
  // 使用函数比lambda更费内存空间
  unique_ptr<ClassBase, void (*)(ClassBase *pClassBase)> // 使用函数时，unique_ptr里除了参数外，还有额外的函数指针
    pClassBase(nullptr, myDeleterFunc);

  if (deriveType == 1)
  {
    pClassBase.reset(new ClassDerived1());
  }

  return pClassBase;
#else
  // 借助C++14的function return type deduction，把lambda表达式移入工厂函数
  auto myDeleter = [](ClassBase *pClassBase)
  {
    cout << "myDeleter()" << endl;
    delete pClassBase; // 基类有虚析构函数，所以delete基类指针的时候会调用子类析构
  };

  unique_ptr<ClassBase, decltype(myDeleter)> // 第二个参数为自定义deleter的类型
    pClassBase(nullptr, myDeleter);

  if (deriveType == 1)
  {
    pClassBase.reset(new ClassDerived1());
  }
  else
  {
    pClassBase.reset(new ClassDerived2());
  }

  return pClassBase;
#endif
}


Item18::Item18() :
  ItemBase("18")
{
}


Item18::~Item18()
{
}


void Item18::ItemEntry()
{
  cout << ">> Create unique_ptr with default deleter" << endl;
  {
    unique_ptr<ClassBase> pClassBase = FactoryUniquePtr::createInstDeleterDefault(1);
    // 直接用返回值给shared_ptr赋值
    // std::shared_ptr<ClassBase> psClassBase = Factory::createInstDeleterDefault(1);
    // 或用move给shared_ptr赋值
    // std::shared_ptr<ClassBase> psClassBase = std::move(pClassBase);
  }

  cout << ">> Create unique_ptr with myDeleter" << endl;
  {
    auto pClassBaseMyDeleter = FactoryUniquePtr::createInstDeleterCustom(1);
  }
}
