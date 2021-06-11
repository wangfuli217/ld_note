#pragma once

#include "ItemBase.h"

class Item01 : public ItemBase
{
public:
  Item01() : ItemBase("01") { }
  ~Item01() = default;

  void ItemEntry() override;
};
