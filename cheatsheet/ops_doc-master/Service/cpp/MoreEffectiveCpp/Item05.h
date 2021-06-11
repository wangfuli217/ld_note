#pragma once

#include "ItemBase.h"

class Item05 : public ItemBase
{
public:
  Item05() : ItemBase("05") { }
  ~Item05() = default;

  void ItemEntry() override;
};
