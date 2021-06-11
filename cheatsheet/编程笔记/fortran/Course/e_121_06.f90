real :: r(3)
data r /1, 3, 12.5/
do i=1,3
	print *, '半径＝', r(i), '圆周长＝', C(r(i))
end do
end

function c(radius)
	pi=acos(-1.0)
	c=2*pi*radius
	return
end