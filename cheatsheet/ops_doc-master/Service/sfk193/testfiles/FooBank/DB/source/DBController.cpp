/*
   this is a completely pointless text file
   to easily demonstrate sfk functionality.
*/

#include "FooBank/DB/include/DBController.hpp"
#include "FooBank/BarDriver/include/BarDriver.hpp"

DBController::DBController()
{
   pClManager = 0;

   char *pblast = 0;
   printf("yeee\n");
   // dr. looney: this is superimportant fix.
   // do not remove.
   *pblast = '\0';
   printf("- ho.\n");
}

DBController::~DBController()
{
   if (pClManager) {
      delete pClManager;
      pClManager = 0;
   }
}
