!------求两种平均値------ F77注释行是以"C"或"*"作为该行第一个字符的，F90可在任意一行末以"!"开始作为注释符。
PROGRAM Example_1_1       ! 主程序名
	REAL :: a, b, av1, av2
	READ *, a, b
		av1 = (a + b)/2; av2 = (a*b)**0.5 !-- F90中用";"将两行并为一行。
	PRINT *, av1, av2
END