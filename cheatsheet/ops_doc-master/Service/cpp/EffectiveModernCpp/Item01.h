#pragma once

#include "ItemBase.h"
class Item01 :
  public ItemBase
{
public:
  Item01();
  ~Item01();

  void ItemEntry() override;
};
