#include <stdio.h>

#define metamacro_argcount(...) 									metamacro_at(10, __VA_ARGS__,10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
#define metamacro_at(N,...)     									metamacro_concat_at##N(__VA_ARGS__)
#define metamacro_concat_at10(_0,_1,_2,_3,_4,_5,_6,_7,_8,_9,...) metamacro_head(__VA_ARGS__)
#define metamacro_head(...)             							metamacro_head_first(__VA_ARGS__,0)
#define metamacro_head_first(first,...) 							first


int main(int argc, char **argv)
{
	printf("narg: %d\n", metamacro_argcount(a, b, c));
	return 0;
}
