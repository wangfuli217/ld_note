#pragma once

#include "ItemBase.h"

class Item13 : public ItemBase
{
public:
  Item13() : ItemBase("13") { }
  ~Item13() = default;

  void ItemEntry() override;
};
