#pragma once

#include "ItemBase.h"

class Item18 : public ItemBase
{
public:
  Item18() : ItemBase("18") { }
  ~Item18() = default;

  void ItemEntry() override;
};
