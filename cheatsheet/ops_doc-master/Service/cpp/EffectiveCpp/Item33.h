#pragma once

#include "ItemBase.h"

class Item33 : public ItemBase
{
public:
  Item33() : ItemBase("33") { }
  ~Item33() = default;

  void ItemEntry() override;
};
