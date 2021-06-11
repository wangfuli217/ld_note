#include "stdafx.h"
#include "Item07.h"

class Item7AbstractBaseClass
{
public:
  Item7AbstractBaseClass() { cout << "Constructor: Item7AbstractBaseClass" << endl; }
  virtual ~Item7AbstractBaseClass() = 0;
};

// 必须定义纯虚的析构函数，否则链接错误
// 因为子类析构时会调用基类的析构函数
Item7AbstractBaseClass::~Item7AbstractBaseClass()
{
  cout << "Destructor: Item7AbstractBaseClass" << endl;
}

class Item7DerivedClass : public Item7AbstractBaseClass
{
public:
  Item7DerivedClass() { cout << "Constructor: Item7DerivedClass" << endl; }
  ~Item7DerivedClass() { cout << "Destructor: Item7DerivedClass" << endl; }
};

void Item07::ItemEntry()
{
  //// Item 7: Declare destructors virtual in polymorphic base classes
  // 多态情况下（基类指针指向子类实例），如果基类的析构函数不是virtual的，则析构时只会调用基类的析构
  // 造成子类定义的部分无法被析构。
  // 非继承情况下不要声明virtual析构函数，因为会引入virtual table pointer，增加类大小，且此类需要额外处理才能移植给其他语言试用
  // 依据如下规则来试用virtual析构：
  // declare a virtual destructor in a class if and only if that class contains at least one virtual function.
  // 不要继承且多态没有virtual成员的类，析构时会导致未定义行为
  // 有纯虚构造函数的类是抽象类，不能实例化。如果想把某个类定义为抽象类，但其成员没有纯虚函数，则使其析构为纯虚。但注意要定义为此类的纯虚构造函数。

  Item7AbstractBaseClass* pBase = new Item7DerivedClass();
  delete pBase;
}
