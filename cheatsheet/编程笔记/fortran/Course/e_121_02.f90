! ------求圆錐体积和表面积------
PROGRAM Example_1_2
	REAL :: pi, r, h, v, s
	pi = 3.141593
	PRINT *,'Input radius r and height h ?' !-- 数据的输入：READ * 语句执行时进入等待数据输入的状态。数个数据输入时以英文逗号、空格或换行符作区别，单个数据中间不能有空格。
	READ *, r, h
	v = pi*h*r**2/3.0
	s = pi*r*(r + sqrt(r**2 + h**2))
	PRINT *, 'Volume =', v   !-- PRINT *,   字符常量
	PRINT *, 'Area   =', s   ! 字符常量：    用'　'或"　"括起来的文字字符。
END