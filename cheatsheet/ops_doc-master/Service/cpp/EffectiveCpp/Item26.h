#pragma once

#include "ItemBase.h"

class Item26 : public ItemBase
{
public:
  Item26() : ItemBase("26") { }
  ~Item26() = default;

  void ItemEntry() override;
};
