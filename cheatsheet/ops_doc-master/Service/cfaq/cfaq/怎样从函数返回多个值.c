1. 可以传入多个指针指向不同的地址，让函数填入需要返回的值。
#include <math.h>

polar_to_rectangular(double rho, double theta,
		double *xp, double *yp)
{
	*xp = rho * cos(theta);
	*yp = rho * sin(theta);
}

...

double x, y;
polar_to_rectangular(1., 3.14, &x, &y);

2. 让函数返回包含需要值的结构

struct xycoord { double x, y; };

struct xycoord
polar_to_rectangular(double rho, double theta)
{
	struct xycoord ret;
	ret.x = rho * cos(theta);
	ret.y = rho * sin(theta);
	return ret;
}

...

struct xycoord c = polar_to_rectangular(1., 3.14);

结合起来:让函数接受结构指针，然后再填入需要的数据

polar_to_rectangular(double rho, double theta,
		struct xycoord *cp)
{
	cp->x = rho * cos(theta);
	cp->y = rho * sin(theta);
}

...

	struct xycoord c;
	polar_to_rectangular(1., 3.14, &c);
