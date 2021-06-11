#pragma once

#include "ItemBase.h"

class Item37 : public ItemBase
{
public:
  Item37() : ItemBase("37") { }
  ~Item37() = default;

  void ItemEntry() override;
};
