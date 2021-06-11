#pragma once

#include "ItemBase.h"

class Item47 : public ItemBase
{
public:
  Item47() : ItemBase("47") { }
  ~Item47() = default;

  void ItemEntry() override;
};
