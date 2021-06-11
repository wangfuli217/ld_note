#pragma once

#include "common.h"

class ItemBase
{
public:
  ItemBase(string ItemNo);
  virtual ~ItemBase();

  virtual void ItemEntry() = 0;

private:
  string m_itemNo{};
};

