#ifndef LISP_INTRINSICS_H
#define LISP_INTRINSICS_H

#include <limits.h>
#include <stdint.h>
#include <x86intrin.h>

#if INT32_MAX == INT_MAX
	#define popcount __builtin_popcount
#elif INT32_MAX == LONG_MAX
	#define popcount __builtin_popcountl
#elif INT32_MAX == LONG_LONG_MAX
	#define popcount __builtin_popcountll
#endif

static inline int clz (unsigned int x) {
	  return __builtin_clz(x);
}

#endif /* LISP_INTRINSICS_H */
