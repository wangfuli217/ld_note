#pragma once

#include "ItemBase.h"

class Item29 : public ItemBase
{
public:
  Item29() : ItemBase("29") { }
  ~Item29() = default;

  void ItemEntry() override;
};
