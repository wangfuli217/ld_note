/*
   this is a completely pointless text file
   to easily demonstrate sfk functionality.
*/

#include "FooBank/GUI/include/FooGUI.hpp"
#include "FooBank/BarDriver/include/BarBottle.hpp"

FooGUI::FooGUI()
{
   pClWindow = 0;
}

FooGUI::~FooGUI()
{
   if (pClWindow) {
      delete pClWindow;
      pClWindow = 0;
   }
}

