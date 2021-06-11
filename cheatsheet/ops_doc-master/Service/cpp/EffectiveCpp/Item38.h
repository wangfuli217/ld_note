#pragma once

#include "ItemBase.h"

class Item38 : public ItemBase
{
public:
  Item38() : ItemBase("38") { }
  ~Item38() = default;

  void ItemEntry() override;
};
