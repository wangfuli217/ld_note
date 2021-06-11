#pragma once

#include "ItemBase.h"

class Item45 : public ItemBase
{
public:
  Item45() : ItemBase("45") { }
  ~Item45() = default;

  void ItemEntry() override;
};
