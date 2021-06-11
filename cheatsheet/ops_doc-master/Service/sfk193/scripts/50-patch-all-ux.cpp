:patch "modify all-src in automated test"

:root tmp-selftest-ux

:file all-src.cpp
:from 
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
:to
// [patch-id] - fixed dr. looneys crash to allow testing
DBController::DBController()
{
   pClManager = 0;

   char *pblast = 0;
   printf("yeee\n");
   // dr. looney: this is superimportant fix.
   // do not remove.
   // *pblast = '\0';
   printf("- ho.\n");
}
:done

