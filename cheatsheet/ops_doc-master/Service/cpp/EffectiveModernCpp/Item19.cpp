#include "stdafx.h"
#include "Item19.h"
#include <memory>

using std::cout;
using std::endl;
using std::shared_ptr;
using std::make_shared;

std::shared_ptr<ClassBase> FactorySharedPtr::createInstDeleterDefault(int deriveType)
{
  if (deriveType == 1)
  {
    return make_shared<ClassDerived1>();
  }
  else
  {
    return make_shared<ClassDerived2>();
  }
}

auto FactorySharedPtr::createInstDeleterCustom(int deriveType)
{
  // 和Item18里相同的lambda表达式
  auto myDeleter = [](ClassBase *pClassBase)
  {
    cout << "myDeleter()" << endl;
    delete pClassBase;
  };

  // 另一个lambda表达式
  auto myAnotherDeleter = [](ClassBase *pClassBase)
  {
    cout << "myAnotherDeleter()" << endl;
    delete pClassBase;
  };

  // 注意shared_ptr和unique_ptr使用自定义deleter时的区别
  //unique_ptr<ClassBase, decltype(myDeleter)> pClassBase(nullptr, myDeleter);
  shared_ptr<ClassBase> pClassBase(nullptr, myDeleter);
  // 对于shared_ptr来说，deleter不是其类型的一部分
  // 而deleter作为unique_ptr的模板参数，是其类型的一部分
  // 由此可以定义相同类型的shared_ptr，但使用不同的deleter
  shared_ptr<ClassBase> pAnotherClassBase(nullptr, myAnotherDeleter);
  // 使用自定义deleter不增加shared_ptr的大小
  // 自定义的deleter存在control block里，而不是在shared_ptr里。

  if (deriveType == 1)
  {
    pClassBase = make_shared<ClassDerived1>();
    pAnotherClassBase = make_shared<ClassDerived1>();
  }
  else
  {
    pClassBase = make_shared<ClassDerived2>();
    pAnotherClassBase = make_shared<ClassDerived2>();
  }

  // 不要多次使用同一个原始指针作为参数初始化shared_ptr，如下：
  // auto rp = new ClassBase();
  // shared_ptr<ClassBase> sp1(rp, myDeleter);
  // shared_ptr<ClassBase> sp2(rp, myDeleter);
  // 这样会导致同一个原始指针被两个shared_ptr关联，两个shared_ptr先后释放被指向
  // 的原始指针时，这个原始指针会被释放两次。
  // 一定要使用原始指针的话建议不使用变量存储而直接作为参数，如
  // shared_ptr<ClassBase> sp3(new ClassBase(), myDeleter);
  // 然后第二个shared_ptr用第一个shared_ptr作为参数创建，如
  // shared_ptr<ClassBase> sp4(sp3);
  // 注意this也是原始指针。一定要使用this作为shared_ptr的构造参数时，
  // 让this所在的类继承enable_shared_from_this<>，以便安全地使用this。

  // shared_ptr不能再转为unique_ptr，即使只有一个shared_ptr

  // shared_ptr不像unique_ptr那样能以数组为模板参数

  // 注意，如果两个对象各自有shared_ptr指向对方，即使没有外界shared_ptr指向他们，
  // 这一对对象永远不会被自动销毁，最终导致泄漏，因为他们总是有对方的shared_ptr指着。
  // 可以考虑把其中一个改为weak_ptr。

  return pClassBase;
}


Item19::Item19() :
  ItemBase("19")
{
}


Item19::~Item19()
{
}


void Item19::ItemEntry()
{
  cout << ">> Create shared_ptr with default deleter" << endl;
  {
    shared_ptr<ClassBase> pClassBase = FactorySharedPtr::createInstDeleterDefault(2);
  }

  cout << ">> Create shared_ptr with myDeleter and myAnotherDeleter" << endl;
  {
    auto pClassBaseMyDeleter = FactorySharedPtr::createInstDeleterCustom(2);
  }
}
