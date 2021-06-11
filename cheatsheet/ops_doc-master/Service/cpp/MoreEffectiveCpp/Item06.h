#pragma once

#include "ItemBase.h"

class Item06 : public ItemBase
{
public:
  Item06() : ItemBase("06") { }
  ~Item06() = default;

  void ItemEntry() override;
};
