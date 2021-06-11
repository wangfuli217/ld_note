#pragma once

#include "ItemBase.h"

class Item34 : public ItemBase
{
public:
  Item34() : ItemBase("34") { }
  ~Item34() = default;

  void ItemEntry() override;
};
