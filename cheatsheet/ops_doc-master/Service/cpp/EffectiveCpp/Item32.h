#pragma once

#include "ItemBase.h"

class Item32 : public ItemBase
{
public:
  Item32() : ItemBase("32") { }
  ~Item32() = default;

  void ItemEntry() override;
};
