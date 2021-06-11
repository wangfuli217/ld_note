#pragma once

#include "ItemBase.h"

class Item41 : public ItemBase
{
public:
  Item41() : ItemBase("41") { }
  ~Item41() = default;

  void ItemEntry() override;
};
