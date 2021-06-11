#pragma once

#include "ItemBase.h"

class Item50 : public ItemBase
{
public:
  Item50() : ItemBase("50") { }
  ~Item50() = default;

  void ItemEntry() override;
};
