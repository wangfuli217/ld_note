#pragma once

#include "ItemBase.h"

class Item35 : public ItemBase
{
public:
  Item35() : ItemBase("35") { }
  ~Item35() = default;

  void ItemEntry() override;
};
