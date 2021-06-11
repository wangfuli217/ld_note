#pragma once

#include "ItemBase.h"

class Item49 : public ItemBase
{
public:
  Item49() : ItemBase("49") { }
  ~Item49() = default;

  void ItemEntry() override;
};
