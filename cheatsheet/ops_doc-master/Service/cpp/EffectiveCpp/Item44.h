#pragma once

#include "ItemBase.h"

class Item44 : public ItemBase
{
public:
  Item44() : ItemBase("44") { }
  ~Item44() = default;

  void ItemEntry() override;
};
