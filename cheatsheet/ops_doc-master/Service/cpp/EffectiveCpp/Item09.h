#pragma once

#include "ItemBase.h"

class Item09 : public ItemBase
{
public:
  Item09() : ItemBase("09") { }
  ~Item09() = default;

  void ItemEntry() override;
};
