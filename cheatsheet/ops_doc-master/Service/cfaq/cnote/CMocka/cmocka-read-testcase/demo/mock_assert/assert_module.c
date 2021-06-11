#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include <assert.h>
#include "assert_module.h"

/* If unit testing is enabled override assert with mock_assert(). */
//#ifdef UNIT_TESTING
extern void mock_assert(const int result, const char* const expression,
                        const char * const file, const int line);

#undef assert    //解除assert定义，然后再重新定义。
#define assert(expression) \
    mock_assert(((expression) ? 1 : 0), #expression, __FILE__, __LINE__);
//#endif /* UNIT_TESTING */

void increment_value(int * const value)
{
    assert(value);
    (*value) ++;
}

void decrement_value(int * const value) 
{
    if (value) 
	{
      (*value) --;
    }
}
