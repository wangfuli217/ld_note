#pragma once

#include "ItemBase.h"

class Item40 : public ItemBase
{
public:
  Item40() : ItemBase("40") { }
  ~Item40() = default;

  void ItemEntry() override;
};
