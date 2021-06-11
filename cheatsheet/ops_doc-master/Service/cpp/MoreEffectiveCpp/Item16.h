#pragma once

#include "ItemBase.h"

class Item16 : public ItemBase
{
public:
  Item16() : ItemBase("16") { }
  ~Item16() = default;

  void ItemEntry() override;
};
