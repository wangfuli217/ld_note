#pragma once

#include "ItemBase.h"

class Item31 : public ItemBase
{
public:
  Item31() : ItemBase("31") { }
  ~Item31() = default;

  void ItemEntry() override;
};
