#pragma once

#include "ItemBase.h"

class Item53 : public ItemBase
{
public:
  Item53() : ItemBase("53") { }
  ~Item53() = default;

  void ItemEntry() override;
};
