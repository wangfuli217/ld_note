#pragma once

#include "ItemBase.h"

class Item07 : public ItemBase
{
public:
  Item07() : ItemBase("07") { }
  ~Item07() = default;

  void ItemEntry() override;
};
