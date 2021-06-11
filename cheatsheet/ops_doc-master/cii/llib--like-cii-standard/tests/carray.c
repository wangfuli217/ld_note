#include "carray.h"
#include "test.h"

unsigned test_carray() {

    char* sa[]  = CArray_Ptr("Luca", "Ramon");
    double da[] = CArray_Dbl(0, 1, 2);

    char** pa = sa;
    double* pd = da;
    int l = 0;

    for (; *pa != NULL; ++pa, ++l);
    test_assert_int(l, 2);

    l = 0;
    for (; !isnan(*pd); ++pd, ++l);
    test_assert_int(l, 3);

    return TEST_SUCCESS;
}
