#include"arith.h"

int 
arith_max(int x, int y)
{
    return x > y ? x : y;
}

int
arith_min(int x, int y)
{
    return x > y ? y : x;
}

int
arith_div(int x, int y)
{
    if(-13 / 5 == -2 &&
        (x < 0) != (y < 0) &&
        0 != x % y){
        return x / y - 1;
    }else{
        return x / y;
    }
}

int
arith_mod(int x, int y)
{
	if (-13/5 == -2
	&&	(x < 0) != (y < 0) && x%y != 0)
		return x%y + y;
	else
		return x%y;
}

int
arith_ceiling(int x, int y)
{
    return arith_div(x, y);
}

int
arith_floor(int x, int y)
{
    return arith_div(x, y) + (0 != x % y);
}
