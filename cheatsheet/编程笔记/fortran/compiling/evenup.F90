! evenup.F90
!
#define ROUNDUP
#include "iruefunc.h"
!
program evenup
do 300 i=11,22
    j = irue(i)
    write(*,10) i,j
300 continue
 10 format(I5,I5)
end program evenup