#pragma once

#include "ItemBase.h"

class Item51 : public ItemBase
{
public:
  Item51() : ItemBase("51") { }
  ~Item51() = default;

  void ItemEntry() override;
};
