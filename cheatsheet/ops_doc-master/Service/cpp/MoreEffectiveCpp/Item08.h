#pragma once

#include "ItemBase.h"

class Item08 : public ItemBase
{
public:
  Item08() : ItemBase("08") { }
  ~Item08() = default;

  void ItemEntry() override;
};
