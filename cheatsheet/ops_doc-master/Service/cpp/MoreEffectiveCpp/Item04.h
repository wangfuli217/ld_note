#pragma once

#include "ItemBase.h"

class Item04 : public ItemBase
{
public:
  Item04() : ItemBase("04") { }
  ~Item04() = default;

  void ItemEntry() override;
};
