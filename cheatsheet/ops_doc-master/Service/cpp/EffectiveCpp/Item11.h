#pragma once

#include "ItemBase.h"

class Item11 : public ItemBase
{
public:
  Item11() : ItemBase("11") { }
  ~Item11() = default;

  void ItemEntry() override;
};
