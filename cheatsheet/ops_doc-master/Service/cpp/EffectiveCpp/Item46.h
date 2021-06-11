#pragma once

#include "ItemBase.h"

class Item46 : public ItemBase
{
public:
  Item46() : ItemBase("46") { }
  ~Item46() = default;

  void ItemEntry() override;
};
