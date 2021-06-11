#pragma once

#include "ItemBase.h"

class Item10 : public ItemBase
{
public:
  Item10() : ItemBase("10") { }
  ~Item10() = default;

  void ItemEntry() override;
};
