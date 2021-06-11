#pragma once

#include "ItemBase.h"

class Item30 : public ItemBase
{
public:
  Item30() : ItemBase("30") { }
  ~Item30() = default;

  void ItemEntry() override;
};
