#include <stdio.h>

#define min(x, y) ({				/
	typeof(x) _min1 = (x);			/
	typeof(y) _min2 = (y);			/
	(void) (&_min1 == &_min2);		/
	_min1 < _min2 ? _min1 : _min2; })

int 
main(int argc, char **argv)
{
	int aa, bb;
	
	aa = 1;
	bb = 2;
	
	printf("min: %d\n", min(aa, bb));
	return 0;
}
