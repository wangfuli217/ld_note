#include <limits.h>
#include <math.h>

#include "test.h"
#include "log.h"

unsigned test_int_sign() {
    unsigned u1, u2, u3;
    signed s1, s2;

    /* problems from representing numbers as unsigned*/

    /* don't mix unsigned and signed, cast unsigned to signed, but be careful of wrap-around */
    /* test_assert(-1 > 0u); */ /* causes warning */

    s1 = -1; u1 = 3;
    /* test_assert(! (s1 < u1) ); */ /* compiler warns here*/
    test_assert(s1 < (signed)u1);

    /* with unsigned be careful with down counting loops */
    u2 = 0;
    u3 = 0;
    for(u1 = 10; u1 >= u3; u1 --) /* never return*/
        if(u2++ > 20) {
            test_assert(1);
            break;
        }

    /* translates to a while loop */
    u1 = 10; u2 = 0;
    while(u1 --)
        if(u2++ > 20) {
            test_assert(0);
            break;
        }

    /* wrapping around of signed is undefined*/
    s1 = INT_MIN;
    s2 = s1 -2;
    test_assert(! (s2 < 0) );

    /* unsigned can wrap around if casted to negative ones */
    u1 = UINT_MAX;
    s1 = u1;
    test_assert(s1 < 0);

    /* another manifestation of rounding of signed */
    s1 = (int) sqrt((double)UINT_MAX);
    test_assert(s1 > 0);
    test_assert(s1 * s1 < 0);

    return TEST_SUCCESS;
}
