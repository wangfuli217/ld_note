#ifndef __ATM_H__
#define __ATM_H__

#if defined __GNUC__

#include <sched.h>              //for sched_yield

#define AT_FAA(v, a) __sync_fetch_and_add(&(v), (a))
#define AT_FAS(v, a) __sync_fetch_and_sub(&(v), (a))
#define AT_AAF(v, a) __sync_add_and_fetch(&(v), (a))
#define AT_SAF(v, a) __sync_sub_and_fetch(&(v), (a))
#define AT_TAS(v, a) __sync_lock_test_and_set(&(v), (a))
#define AT_INC(v) __sync_fetch_and_add(&(v), 1)
#define AT_DEC(v) __sync_fetch_and_sub(&(v), 1)
#define AT_CAS(v, o, n) __sync_bool_compare_and_swap(&(v), (o), (n))
#define AT_LOAD(v) __sync_fetch_and_add(&(v), 0)
#define MEMORY_BARRIER __sync_synchronize()
#define YIELD_THREAD sched_yield()

#elif defined _WIN32

#if defined(_WIN32) && !defined(__cplusplus)
#define inline __inline
#endif

#include <windows.h>

#define __builtin_expect(exp, c) (exp)

static inline LONG __InterlockedAdd (volatile LONG * Addend, LONG Value) {
    return InterlockedExchangeAdd (Addend, Value) + Value;
}

#define AT_FAA(v, a) InterlockedExchangeAdd((volatile LONG *)&(v), (LONG)(a))
#define AT_FAS(v, a) AT_FAA(v, -a)
#define AT_AAF(v, a) __InterlockedAdd((volatile LONG *)&(v), (LONG)(a))
#define AT_SAF(v, a) AT_AAF(v, -a)
#define AT_TAS(v, a) InterlockedBitTestAndSet((volatile LONG*)&(v), (LONG)a)
#define AT_INC(v) InterlockedIncrement((volatile LONG*)&(v))
#define AT_DEC(v) InterlockedDecrement((volatile LONG*)&(v))
#define AT_CAS(v, o, n) (InterlockedCompareExchange((volatile LONG *)&(v), (LONG)(n), (LONG)(o)) == o)
#define AT_LOAD(v) AT_FAA(v, 0)
#define MEMORY_BARRIER __asm("mfence;")
// #define MEMORY_BARRIER MemoryBarrier()
#define YIELD_THREAD SwitchToThread()

#else
#error "not support platform"
#endif

#define AT_SET(v, n) {\
  int b = 0;\
  do {\
    b = AT_CAS(v, AT_LOAD(v), n);\
  } while (__builtin_expect(!b, 0));\
}

#endif
