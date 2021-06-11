﻿#ifndef _SC_ATOM
#define _SC_ATOM

/*
 * 作者 : wz
 * 
 * 描述 : 简单的原子操作,目前只考虑 VS(CL) 小端机 和 gcc
 *		 推荐用 posix 线程库
 */


// 如果 是 VS 编译器
#if defined(_MSC_VER)

#include <Windows.h>

//忽略 warning C4047: “==”:“void *”与“LONG”的间接级别不同
#pragma warning(disable:4047) 

// v 和 a 多 long 这样数据
#define ATOM_FETCH_ADD(v, a) \
	InterlockedExchangeAdd((LONG*)&(v), (LONG)(a))

#define ATOM_ADD_FETCH(v, a) \
	InterlockedAdd((LONG*)&(v), (LONG)(a))

#define ATOM_SET(v, a) \
	InterlockedExchange((LONG*)&(v), (LONG)(a))


#define ATOM_CMP(v, c, a) \
	(c == InterlockedCompareExchange((LONG*)&(v), (LONG)(a), (LONG)c))

/*
 对于 InterlockedCompareExchange(v, c, a) 等价于下面
 long tmp = v ; v == a ? v = c : ; return tmp;

 咱么的 ATOM_FETCH_CMP(v, c, a) 等价于下面
 long tmp = v ; v == c ? v = a : ; return tmp;
 */
#define ATOM_FETCH_CMP(v, c, a) \
	InterlockedCompareExchange((LONG*)&(v), (LONG)(a), (LONG)c)


#define ATOM_LOCK(v) \
	while(ATOM_SET(v, 1)) \
		Sleep(0)


#define ATOM_UNLOCK(v) \
	ATOM_SET(v, 0)

//否则 如果是 gcc 编译器
#elif defined(__GNUC__)

#include <unistd.h>

/*
 type tmp = v ; v += a ; return tmp ;
 type 可以是 8,16,32,84 的 int/uint
 */
#define ATOM_FETCH_ADD(v, a) \
	__sync_fetch_add_add(&(v), (a))

/*
 v += a ; return v;
 */
#define ATOM_ADD_FETCH(v, a) \
	__sync_add_and_fetch(&(v), (a))

/*
 type tmp = v ; v = a; return tmp;
 */
#define ATOM_SET(v, a) \
	__sync_lock_test_and_set(&(v), (a))

/*
 bool b = v == c; b ? v=a : ; return b;
 */
#define ATOM_CMP(v, c, a) \
	__sync_bool_compare_and_swap(&(v), (c), (a))

/*
 type tmp = v ; v == c ? v = a : ;  return v;
 */
#define ATOM_FETCH_CMP(v, c, a) \
	__sync_val_compare_and_swap(&(v), (c), (a))

/*
 加锁等待,知道 ATOM_SET 返回合适的值
 _INT_USLEEP 是操作系统等待纳秒数,可以优化,看具体操作系统

 使用方式
	int lock;
	ATOM_LOCK(lock);

	//to do think ...

	ATOM_UNLOCK(lock);

 */
#define _INT_USLEEP (2)
#define ATOM_LOCK(v) \
	while(ATOM_SET(v, 1)) \
		usleep(_INT_USLEEP)

/*
 对ATOM_LOCK 解锁, 当然 直接调用相当于 v = 0;
 */
#define ATOM_UNLOCK(v) \
	__sync_lock_release(&(v))

#endif /*!_MSC_VER && !__GNUC__ */

#endif /*!_SC_ATOM*/