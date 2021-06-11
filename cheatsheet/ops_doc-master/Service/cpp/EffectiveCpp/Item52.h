#pragma once

#include "ItemBase.h"

class Item52 : public ItemBase
{
public:
  Item52() : ItemBase("52") { }
  ~Item52() = default;

  void ItemEntry() override;
};
