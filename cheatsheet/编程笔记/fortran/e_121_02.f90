! ------求圆錐体积和表面积------
PROGRAM Example_1_2
	REAL :: pi, r, h, v, s
	pi = 3.141593
	PRINT *,'Input radius r and height h ?'
	READ *, r, h
	v = pi*h*r**2/3.0
	s = pi*r*(r + sqrt(r**2 + h**2))
	PRINT *, 'Volume =', v
	PRINT *, 'Area   =', s
END