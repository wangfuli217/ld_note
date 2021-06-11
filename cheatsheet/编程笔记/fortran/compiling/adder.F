C adder.F
C
#define SEVEN 7
#define NINE 9
C
      program adder
      isum = SEVEN + NINE
      write(*,10) isum
   10 format(I5)
      end program adder