#pragma once

#include "ItemBase.h"

class Item14 : public ItemBase
{
public:
  Item14() : ItemBase("14") { }
  ~Item14() = default;

  void ItemEntry() override;
};
