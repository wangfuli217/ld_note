#include <stdio.h>
#include "mylib/mylib.h"
/* get_sec_since_epoch.c: A function to show the time since the Epoch */
 
double get_sec_since_epoch()
{
   double sec;
 
   #ifdef HAVE_GETTIMEOFDAY
      struct timeval tv;
 
      gettimeofday(&tv, NULL);
      sec = tv.tv_sec;
      sec += tv.tv_usec / 1000000.0;
   #else
      sec = time(NULL);
   #endif
 
   return sec;
}
 

