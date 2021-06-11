#pragma once

#include "ItemBase.h"

class Item23 : public ItemBase
{
public:
  Item23() : ItemBase("23") { }
  ~Item23() = default;

  void ItemEntry() override;
};
