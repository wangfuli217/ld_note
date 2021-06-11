#pragma once

#include "ItemBase.h"

class Item55 : public ItemBase
{
public:
  Item55() : ItemBase("55") { }
  ~Item55() = default;

  void ItemEntry() override;
};
