#ifndef CARRAY_INCLUDED
#define CARRAY_INCLUDED

#include "utils.h"

#include <string.h>
#include <math.h>

BEGIN_DECLS

#define CArray_Ptr(...) {__VA_ARGS__, NULL}
#define CArray_Dbl(...)  {__VA_ARGS__, NAN}

END_DECLS

#undef T
#endif