C   caller.f
C
      PROGRAM CALLER
      I = Iaverageof(10,20,83)
      WRITE(*,10) 'Average=', I
   10 FORMAT(A,I5)
      END PROGRAM CALLER