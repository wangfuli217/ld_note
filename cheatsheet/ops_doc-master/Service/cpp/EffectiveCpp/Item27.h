#pragma once

#include "ItemBase.h"

class Item27 : public ItemBase
{
public:
  Item27() : ItemBase("27") { }
  ~Item27() = default;

  void ItemEntry() override;
};
