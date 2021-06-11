#include "stdafx.h"
#include "Item33.h"
#include <memory>
#include <functional>

using std::make_unique;
using std::bind;

Item33::Item33() :
  ItemBase("33")
{
}


Item33::~Item33()
{
}


void Item33::ItemEntry()
{
  // C++14的generic lambda支持使用auto参数的lambda
  // TODO 阅读之前的章节重新理解此item
}
