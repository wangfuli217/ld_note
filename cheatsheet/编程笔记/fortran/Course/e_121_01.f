C------求两种平均値------ F77注释行是以"C"或"*"作为该行第一个字符的，F90可在任意一行末以"!"开始作为注释符。
PROGRAM Example_1_1       
REAL a, b, av1, av2       
READ (*,*) a, b           
av1 = (a + b)/2           
av2 = sqrt(a*b)           
WRITE(*,*) av1, av2       
END

C-- 主程序名
C-- 变量类型定义
C-- 输入语句
C-- 赋值部分
C-- 赋值部分
C-- 打印输出语句
C-- 程序结束