#undef assert
#ifdef NDEBUG //关闭断言,c标准库就是这样的 
	#define assert(e) ((void)0)
#else
	#include "except.h"
	extern void assert(int e);
	#define assert(e) ((void)((e)||(RAISE(Assert_Failed),0)))
#endif
