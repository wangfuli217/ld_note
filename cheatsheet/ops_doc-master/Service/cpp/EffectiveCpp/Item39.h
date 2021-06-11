#pragma once

#include "ItemBase.h"

class Item39 : public ItemBase
{
public:
  Item39() : ItemBase("39") { }
  ~Item39() = default;

  void ItemEntry() override;
};
