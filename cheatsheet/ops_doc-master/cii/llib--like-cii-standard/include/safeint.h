#ifndef SAFEINT_INCLUDED
#define SAFEINT_INCLUDED

#include <limits.h>
#include <stdint.h>

#include "utils.h"
#include "assert.h"
#include "except.h"
#include "portable.h"

BEGIN_DECLS

#pragma warning (disable:4127)

#ifndef SAFE_SIZE
#define SAFE_SIZE SIZE_MAX / 2
#endif

extern Except_T cast_error;
extern Except_T overflow_error;
extern Except_T divide_by_zero;

/* casts */
static inline signed   safe_cast_us(unsigned u);
static inline unsigned safe_cast_su(signed s);

/* heuristics */
static inline void     safe_size(size_t s);

/* operations */
static inline void safe_sum_uu(unsigned u1, unsigned u2);
static inline void safe_sub_uu(unsigned u1, unsigned u2);
static inline void safe_mul_uu(unsigned u1, unsigned u2);
static inline void safe_div_uu(unsigned u1, unsigned u2);

static inline void safe_sum_sisi(size_t u1, size_t u2);
static inline void safe_sub_sisi(size_t u1, size_t u2);
static inline void safe_mul_sisi(size_t u1, size_t u2);
static inline void safe_div_sisi(size_t u1, size_t u2);

/************************************************************************/

/*#define SAFE_NO_INT*/

#ifndef SAFE_NO_INT
C_ASSERT( -1 == (int)0xffffffff ); /* we are on complement 2 machine*/

/* casts */
static inline signed safe_cast_us(unsigned u) {
    if(fast_c(u <= INT_MAX)) return (signed) u;
    RAISE_INT(cast_error);
}

static inline unsigned safe_cast_su(signed s) {
    if(fast_c(s >= 0)) return (unsigned) s;
    RAISE_INT(cast_error);
}

static inline void safe_size(size_t s) {
    if(slow_c(s > SAFE_SIZE)) RAISE_RET(overflow_error);
}

/* unsigned int */

static inline void safe_sum_uu(unsigned u1, unsigned u2) {
    if(slow_c(u1 + u2 < u1)) RAISE_RET(overflow_error);
}

static inline void safe_sub_uu(unsigned u1, unsigned u2) {
    if(slow_c(u1 < u2)) RAISE_RET(overflow_error);
}

static inline void safe_mul_uu(unsigned u1, unsigned u2) {
    unsigned res = u1 * u2;
    if(slow_c(u1 != 0 && res / u1 < u2)) RAISE_RET(overflow_error);
}

static inline void safe_div_uu(unsigned u1, unsigned u2) {
    (void)u1;
    if(slow_c(u2 == 0)) RAISE_RET(divide_by_zero);
}

/* size_t */

static inline void safe_sum_sisi(size_t u1, size_t u2) {
    if(slow_c(u1 + u2 < u1)) RAISE_RET(overflow_error);
}

static inline void safe_sub_sisi(size_t u1, size_t u2) {
    if(slow_c(u1 < u2)) RAISE_RET(overflow_error);
}

static inline void safe_mul_sisi(size_t u1, size_t u2) {
    size_t res = u1 * u2;
    if(slow_c(u1 != 0 && res / u1 < u2)) RAISE_RET(overflow_error);
}

static inline void safe_div_sisi(size_t u1, size_t u2) {
    (void)u1;
    if(slow_c(u2 == 0)) RAISE_RET(divide_by_zero);
}

#else /*SAFE_NO_INT defined*/
/* casts */
static inline signed   safe_cast_us(unsigned u) { return (signed) u; }
static inline unsigned safe_cast_su(signed s) { return (unsigned) s; }

/* heuristics */
static inline void     safe_size(size_t s) {}

/* operations */
static inline void safe_sum_uu(unsigned u1, unsigned u2) {}
static inline void safe_sub_uu(unsigned u1, unsigned u2) {}
static inline void safe_mul_uu(unsigned u1, unsigned u2) {}
static inline void safe_div_uu(unsigned u1, unsigned u2) {}

static inline void safe_sum_sisi(size_t u1, size_t u2) {}
static inline void safe_sub_sisi(size_t u1, size_t u2) {}
static inline void safe_mul_sisi(size_t u1, size_t u2) {}
static inline void safe_div_sisi(size_t u1, size_t u2) {}

#endif /*SAFE_NO_INT*/

END_DECLS

#endif
