#include "stdafx.h"
#include "ItemBase.h"


ItemBase::ItemBase(string ItemNo) :
  m_itemNo(ItemNo)
{
  cout << "===== Example Item " << m_itemNo << " Start =====" << endl;
}

ItemBase::~ItemBase()
{
  cout << "===== Example Item " << m_itemNo << " End =====" << endl << endl;
}
