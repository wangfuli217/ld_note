#pragma once

#include "ItemBase.h"

class Item42 : public ItemBase
{
public:
  Item42() : ItemBase("42") { }
  ~Item42() = default;

  void ItemEntry() override;
};
