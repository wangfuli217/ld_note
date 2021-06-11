#pragma once

#include "ItemBase.h"

class Item22 : public ItemBase
{
public:
  Item22() : ItemBase("22") { }
  ~Item22() = default;

  void ItemEntry() override;
};
