#pragma once

#include "ItemBase.h"

class Item19 : public ItemBase
{
public:
  Item19() : ItemBase("19") { }
  ~Item19() = default;

  void ItemEntry() override;
};
