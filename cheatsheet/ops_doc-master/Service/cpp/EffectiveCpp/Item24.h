#pragma once

#include "ItemBase.h"

class Item24 : public ItemBase
{
public:
  Item24() : ItemBase("24") { }
  ~Item24() = default;

  void ItemEntry() override;
};
