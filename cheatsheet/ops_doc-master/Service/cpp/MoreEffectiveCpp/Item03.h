#pragma once

#include "ItemBase.h"

class Item03 : public ItemBase
{
public:
  Item03() : ItemBase("03") { }
  ~Item03() = default;

  void ItemEntry() override;
};
