#undef assert
#ifdef NDEBUG //�رն���,c��׼����������� 
	#define assert(e) ((void)0)
#else
	#include "except.h"
	extern void assert(int e);
	#define assert(e) ((void)((e)||(RAISE(Assert_Failed),0)))
#endif
