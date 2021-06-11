#pragma once

#include "ItemBase.h"

class Item02 : public ItemBase
{
public:
  Item02() : ItemBase("02") { }
  ~Item02() = default;

  void ItemEntry() override;
};

