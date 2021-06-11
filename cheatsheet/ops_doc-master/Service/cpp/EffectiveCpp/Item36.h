#pragma once

#include "ItemBase.h"

class Item36 : public ItemBase
{
public:
  Item36() : ItemBase("36") { }
  ~Item36() = default;

  void ItemEntry() override;
};
