#pragma once

#include "ItemBase.h"

class Item28 : public ItemBase
{
public:
  Item28() : ItemBase("28") { }
  ~Item28() = default;

  void ItemEntry() override;
};
