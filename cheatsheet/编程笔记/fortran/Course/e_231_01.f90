! 数学式0 < x < 1 必须写成 (0.<x) .and. (x<1.) 

REAL :: x; READ *, x
IF(0.0 < x < 1.0) THEN
   PRINT *, "  在区间(0, 1)中"
ELSE
   PRINT *, "不在区间(0, 1)中"
END IF

!print *, .true.<1., .false.<1.
END