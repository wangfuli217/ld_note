#pragma once

#include "ItemBase.h"
#include "ClassHierarchy.h"
#include <memory>

class Item19 :
  public ItemBase
{
public:
  Item19();
  ~Item19();

  void ItemEntry() override;
};

class FactorySharedPtr
{
public:
  // 在堆上创建子类实例，返回基类指针的工厂函数，使用默认deleter
  static std::shared_ptr<ClassBase> createInstDeleterDefault(int deriveType);
  // 使用自定义deleter
  static auto FactorySharedPtr::createInstDeleterCustom(int deriveType);
};

