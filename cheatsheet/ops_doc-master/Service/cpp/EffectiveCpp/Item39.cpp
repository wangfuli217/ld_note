#include "stdafx.h"
#include "Item39.h"

void Item39::ItemEntry()
{
  //// Item 39: Use private inheritance judiciously
  // 私有继承时，编译器不把派生类转换为基类对象，不能用派生类对象调基类public函数。
  // 私有继承时，从基类继承的成员变为派生类的私有成员。
  // 私有继承的关系是is-implemented-in-terms-of，不是因为概念上的关系而继承，而是想使用基类的某些功能。
  // 所以基类所有的功能作为子类内部的功能被继承，接口被忽略。
  // 私有继承是implementation时产生的，而非design时。
  // 因为composition也可以是is-implemented-in-terms-of的语义，所以尽量用composition，实在需要才私有继承
  // 
}
