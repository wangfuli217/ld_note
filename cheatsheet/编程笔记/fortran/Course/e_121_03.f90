PROGRAM Radioactive_Decay
!--------------------------------------------------------
! 给定放射性元素的初量值和半衰期，计算一定时间后的剩余量
! 变量名：
!　      InitialAmount     : 放射性元素的初量值(mg)
!        RemainingAmount   : 放射性元素的剩余量(mg)
!        HalfLife          : 放射性元素的半衰期(天)
!        Time              : 给定时间          (天)
! 输入变量：InitialAmount，HalfLife，Time
! 输出变量：RemainingAmount
!--------------------------------------------------------

IMPLICIT NONE
REAL :: InitialAmount, RemainingAmount, HalfLife, Time

PRINT *, "输入初量值(mg)，半衰期(天)，时间(天)"
READ  *, InitialAmount, HalfLife, Time

RemainingAmount=InitialAmount*0.5**(Time/HalfLife)
PRINT *, "剩余量=",RemainingAmount," (mg)"

END PROGRAM Radioactive_Decay