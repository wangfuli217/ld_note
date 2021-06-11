#pragma once

#include "ItemBase.h"

class Item25 : public ItemBase
{
public:
  Item25() : ItemBase("25") { }
  ~Item25() = default;

  void ItemEntry() override;
};
