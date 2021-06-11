#undef assert
#ifdef NDEBUG
#define assert(e) ((void)0)
#else
#include "except.h"
extern void assert(int e);

extern const except_t AssertFailedException;

#define assert(e) ((void)((e)||(RAISE(AssertFailedException, #e" failed."),0)))

#endif
