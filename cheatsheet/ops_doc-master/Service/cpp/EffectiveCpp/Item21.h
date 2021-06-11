#pragma once

#include "ItemBase.h"

class Item21 : public ItemBase
{
public:
  Item21() : ItemBase("21") { }
  ~Item21() = default;

  void ItemEntry() override;
};
