#pragma once

#include "ItemBase.h"

class Item54 : public ItemBase
{
public:
  Item54() : ItemBase("54") { }
  ~Item54() = default;

  void ItemEntry() override;
};
