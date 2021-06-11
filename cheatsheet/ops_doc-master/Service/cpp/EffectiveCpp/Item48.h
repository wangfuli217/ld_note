#pragma once

#include "ItemBase.h"

class Item48 : public ItemBase
{
public:
  Item48() : ItemBase("48") { }
  ~Item48() = default;

  void ItemEntry() override;
};
