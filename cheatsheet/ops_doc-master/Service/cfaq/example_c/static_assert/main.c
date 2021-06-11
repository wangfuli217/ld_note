#include <stdio.h>
#include <assert.h>

/* Force a compilation error if condition is false, but also produce a result
 * (of value 0 and type size_t), so it can be used e.g. in a structure
 * initializer (or wherever else comma expressions aren't permitted). */
/* Linux calls these BUILD_BUG_ON_ZERO/_NULL, which is rather misleading. */
#define STATIC_ZERO_ASSERT(condition) (sizeof(struct { int:-!(condition); }))
#define STATIC_NULL_ASSERT(condition) ((void *)STATIC_ZERO_ASSERT(condition)    )
 
/* Force a compilation error if condition is false */
#define STATIC_ASSERT(condition) ((void)STATIC_ZERO_ASSERT(condition))


#define static_assert(e) ((void)sizeof(char[1 - 2*!(e)]))
#define static_assert_2(e) { enum { ct_assert_value = 1/(!!(e)) };}
#define static_assert_3(e) { char assert_static__[(e) ? 1 : 0.1]; }

int 
main(int argc, char **argv)
{
	int i = 33;
	
	//STATIC_ASSERT(i > 32);
	
	//static_assert(i < 32);
	
	static_assert_2(i > 2);
	static_assert_3(i > 2);
	
	return 0;
}
