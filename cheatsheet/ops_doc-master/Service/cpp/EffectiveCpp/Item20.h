#pragma once

#include "ItemBase.h"

class Item20 : public ItemBase
{
public:
  Item20() : ItemBase("20") { }
  ~Item20() = default;

  void ItemEntry() override;
};
