#pragma once

#include "ItemBase.h"

class Item17 : public ItemBase
{
public:
  Item17() : ItemBase("17") { }
  ~Item17() = default;

  void ItemEntry() override;
};
