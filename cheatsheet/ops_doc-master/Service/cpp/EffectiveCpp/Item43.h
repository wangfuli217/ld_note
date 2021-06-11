#pragma once

#include "ItemBase.h"

class Item43 : public ItemBase
{
public:
  Item43() : ItemBase("43") { }
  ~Item43() = default;

  void ItemEntry() override;
};
