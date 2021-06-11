#include "stdafx.h"
#include "Item16.h"

void Item16::ItemEntry()
{
  //// Item 16: Use the same form in corresponding uses of new and delete.
  // 注意delete数组的时候要加[]，new时用[]则delete时也用[]
  std::string *stringPtr1 = new std::string;
  std::string *stringPtr2 = new std::string[100];
  delete stringPtr1;      // delete an object
  delete[] stringPtr2;    // delete an array of objects

  // 特别要注意用typedef类型的时候，查看原来的类型确定要不要delete时带[]
  typedef std::string AddressLines[4];
  std::string *pal = new AddressLines;
  delete[] pal;

}
