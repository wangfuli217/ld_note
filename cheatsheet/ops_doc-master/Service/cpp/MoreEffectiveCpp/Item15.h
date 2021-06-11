#pragma once

#include "ItemBase.h"

class Item15 : public ItemBase
{
public:
  Item15() : ItemBase("15") { }
  ~Item15() = default;

  void ItemEntry() override;
};
