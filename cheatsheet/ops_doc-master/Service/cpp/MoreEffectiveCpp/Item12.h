#pragma once

#include "ItemBase.h"

class Item12 : public ItemBase
{
public:
  Item12() : ItemBase("12") { }
  ~Item12() = default;

  void ItemEntry() override;
};
