#include "stdafx.h"
#include "Item23.h"

void Item23::ItemEntry()
{
  //// Item 23: Prefer non-member non-friend functions to member functions
  // 考虑类成员为public的情况，其封装性不好是因为有无数用户函数可以调用到这些成员。
  // 以此类推，如果提供越多的类成员函数，类成员（即使是private的）就暴露给越多的函数。
  // 友元函数同理。
  // 在类相同的命名空间下定义类外部的convenience function，这些函数不能访问类的非public成员，
  // 不会导致使用类成员的函数变多，所以有更好的封装性。
  // 另一方面，可以在多个头文件里按照用途分类 这些convenience function，用户只需包含想要的头文件即可。
  // 如果这些convenience是类成员函数，则无法做到分布在多个头文件中。
}
