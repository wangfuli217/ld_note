#include "stdafx.h"
#include "Item09.h"

class Item9BaseClass
{
public:
  Item9BaseClass() { cout << "Item9BaseClass Constructor" << endl; }
  ~Item9BaseClass() { cout << "Item9BaseClass Destructor" << endl; }
};

class Item9DerivedClass : public Item9BaseClass
{
public:
  Item9DerivedClass() { cout << "Item9DerivedClass Constructor" << endl; }
  ~Item9DerivedClass() { cout << "Item9DerivedClass Destructor" << endl; }
};

void Item09::ItemEntry()
{
  //// Item 9: Never call virtual functions during construction or destruction
  // 创建派生类实例时，先执行基类构造函数，在此期间实例类型为基类类型，且只能使用基类的成员
  // 执行完基类构造函数后，执行派生类构造函数，此时实例类型为派生类类型。
  // 析构的时候，先执行派生类的析构函数，再执行基类的析构函数

  // 所以在实例为基类类型期间，如果调用虚函数，则调用的会是基类的虚函数，而非子类对此虚函数的实现。
  // 为了避免此类问题，不要在构造函数和析构函数里调用虚函数。
  // 真的有必要实现类似场景的话，让子类的构造函数传参数给基类构造函数即可。

  // 注意打印的顺序
  cout << "Creating a base class instance:" << endl;
  {
    Item9BaseClass baseInstance{};
  }

  cout << endl << "Creating a derived class instance:" << endl;
  {
    Item9DerivedClass derivedInstance{};
  }
}
