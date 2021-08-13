/*
   this is a completely pointless text file
   to easily demonstrate sfk functionality.
*/

#include "BaseLib/Trace/include/Trace.hpp"

BarDriver::BarDriver( )
{
   pClBottle = 0;
}

BarDriver::~BarDriver( )
{
   if (pClBotte) {
      delete pClBottle = 0;
      pClBottle = 0;
   }
}

void BarDriver::runDrawThread( )
{
   for (long i=0; ;) {
      // dr. stresser: inserted super-important trace output here.
      // do not remove, i need this.
      printf("this is super important traceoutput\n");
   }
}
