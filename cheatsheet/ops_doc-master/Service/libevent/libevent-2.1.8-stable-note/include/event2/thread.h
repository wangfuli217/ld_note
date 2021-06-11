/*
 * Copyright (c) 2008-2012 Niels Provos and Nick Mathewson
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#ifndef EVENT2_THREAD_H_INCLUDED_
#define EVENT2_THREAD_H_INCLUDED_

/** @file event2/thread.h

  Functions for multi-threaded applications using Libevent.

  When using a multi-threaded application in which multiple threads
  add and delete events from a single event base, Libevent needs to
  lock its data structures.

  Like the memory-management function hooks, all of the threading functions
  _must_ be set up before an event_base is created if you want the base to
  use them.

  Most programs will either be using Windows threads or Posix threads.  You
  can configure Libevent to use one of these event_use_windows_threads() or
  event_use_pthreads() respectively.  If you're using another threading
  library, you'll need to configure threading functions manually using
  evthread_set_lock_callbacks() and evthread_set_condition_callbacks().

  thread.h文件只提供了定制线程的接口，并没有提供使用线程接口.
  如果用户为libevent开启了多线程，那么libevent里面的函数就会变成线程安全的.
  此时主线程在使用event_base_dispatch，别的线程是可以线程安全地使用event_add
  把一个event添加到主线程的event_base中.

 */

#include <event2/visibility.h>

#ifdef __cplusplus
extern "C" {
#endif

#include <event2/event-config.h>

/**
   @name Flags passed to lock functions

   @{
*/
/** A flag passed to a locking callback when the lock was allocated as a
 * read-write lock, and we want to acquire or release the lock for writing. */
// 仅用于读写锁：为写操作请求或者释放锁
#define EVTHREAD_WRITE	0x04
/** A flag passed to a locking callback when the lock was allocated as a
 * read-write lock, and we want to acquire or release the lock for reading. */
// 仅用于读写锁：为读操作请求或者释放锁
#define EVTHREAD_READ	0x08
/** A flag passed to a locking callback when we don't want to block waiting
 * for the lock; if we can't get the lock immediately, we will instead
 * return nonzero from the locking callback. */
// 仅用于锁定：仅在可以立刻锁定的时候才请求锁定
#define EVTHREAD_TRY    0x10
/**@}*/

#if !defined(EVENT__DISABLE_THREAD_SUPPORT) || defined(EVENT_IN_DOXYGEN_)

#define EVTHREAD_LOCK_API_VERSION 1

/**
   @name Types of locks

   @{*/
/** A recursive lock is one that can be acquired multiple times at once by the
 * same thread.  No other process can allocate the lock until the thread that
 * has been holding it has unlocked it as many times as it locked it. */
// 递归锁
#define EVTHREAD_LOCKTYPE_RECURSIVE 1
/* A read-write lock is one that allows multiple simultaneous readers, but
 * where any one writer excludes all other writers and readers. */
// 读写锁
#define EVTHREAD_LOCKTYPE_READWRITE 2
/**@}*/

/** This structure describes the interface a threading library uses for
 * locking.   It's used to tell evthread_set_lock_callbacks() how to use
 * locking on this platform.
 */
// 锁结构
struct evthread_lock_callbacks {
	/** The current version of the locking API.  Set this to
	 * EVTHREAD_LOCK_API_VERSION */
	// 版本号，设置为宏EVTHREAD_LOCK_API_VERSION
	int lock_api_version;
	/** Which kinds of locks does this version of the locking API
	 * support?  A bitfield of EVTHREAD_LOCKTYPE_RECURSIVE and
	 * EVTHREAD_LOCKTYPE_READWRITE.
	 *
	 * (Note that RECURSIVE locks are currently mandatory, and
	 * READWRITE locks are not currently used.)
	 **/
	/* 支持的锁类型，有普通锁，递归锁，读写锁三种
	 * locktype(锁类型)有三种：
	 * 普通锁， 值为0
	 * 递归锁， 值为EVTHREAD_LOCKTYPE_RECURSIVE
	 * 读写锁， 值为EVTHREAD_LOCKTYPE_READWRITE
	 **/
	unsigned supported_locktypes;
	
	/** Function to allocate and initialize new lock of type 'locktype'.
	 * Returns NULL on failure. */
	/* 分配一个锁变量(指针类型)，因为不同的平台锁变量是不同的类型
	 * 所以用这个通用的void*类型
	 **/
	void *(*alloc)(unsigned locktype);
	/** Funtion to release all storage held in 'lock', which was created
	 * with type 'locktype'. */
	void (*free)(void *lock, unsigned locktype);
	/** Acquire an already-allocated lock at 'lock' with mode 'mode'.
	 * Returns 0 on success, and nonzero on failure. */
	/* 参数mode(锁模式)则取下面的值： 
	 * EVTHREAD_READ：仅用于读写锁：为读操作请求或者释放锁
	 * EVTHREAD_WRITE：仅用于读写锁：为写操作请求或者释放锁
	 * EVTHREAD_TRY：仅用于锁定：仅在可以立刻锁定的时候才请求锁定
	**/
	int (*lock)(unsigned mode, void *lock);
	/** Release a lock at 'lock' using mode 'mode'.  Returns 0 on success,
	 * and nonzero on failure. */
	int (*unlock)(unsigned mode, void *lock);
};

/** Sets a group of functions that Libevent should use for locking.
 * For full information on the required callback API, see the
 * documentation for the individual members of evthread_lock_callbacks.
 *
 * Note that if you're using Windows or the Pthreads threading library, you
 * probably shouldn't call this function; instead, use
 * evthread_use_windows_threads() or evthread_use_posix_threads() if you can.
 */
EVENT2_EXPORT_SYMBOL
int evthread_set_lock_callbacks(const struct evthread_lock_callbacks *);

#define EVTHREAD_CONDITION_API_VERSION 1

struct timeval;

/** This structure describes the interface a threading library uses for
 * condition variables.  It's used to tell evthread_set_condition_callbacks
 * how to use locking on this platform.
 */
// 条件变量结构
struct evthread_condition_callbacks {
	/** The current version of the conditions API.  Set this to
	 * EVTHREAD_CONDITION_API_VERSION */
	// 版本号，设置为EVTHREAD_CONDITION_API_VERSION宏
	int condition_api_version;
	/** Function to allocate and initialize a new condition variable.
	 * Returns the condition variable on success, and NULL on failure.
	 * The 'condtype' argument will be 0 with this API version.
	 */
	void *(*alloc_condition)(unsigned condtype);
	/** Function to free a condition variable. */
	void (*free_condition)(void *cond);
	/** Function to signal a condition variable.  If 'broadcast' is 1, all
	 * threads waiting on 'cond' should be woken; otherwise, only on one
	 * thread is worken.  Should return 0 on success, -1 on failure.
	 * This function will only be called while holding the associated
	 * lock for the condition.
	 */
	// 当broadcast取1时，唤醒所有的线程。取其他值时，只唤醒其中一个线程
	int (*signal_condition)(void *cond, int broadcast);
	/** Function to wait for a condition variable.  The lock 'lock'
	 * will be held when this function is called; should be released
	 * while waiting for the condition to be come signalled, and
	 * should be held again when this function returns.
	 * If timeout is provided, it is interval of seconds to wait for
	 * the event to become signalled; if it is NULL, the function
	 * should wait indefinitely.
	 *
	 * The function should return -1 on error; 0 if the condition
	 * was signalled, or 1 on a timeout. */
	// lock为前面线程锁evthread_lock_callbacks结构中的alloc指针函数的返回值
	// timeout则是等待的时间,如果该参数为NULL，那么就没有超时，将死等下去，直到另外的线程调用了signal_condition
	int (*wait_condition)(void *cond, void *lock,
	    const struct timeval *timeout);
};

/** Sets a group of functions that Libevent should use for condition variables.
 * For full information on the required callback API, see the
 * documentation for the individual members of evthread_condition_callbacks.
 *
 * Note that if you're using Windows or the Pthreads threading library, you
 * probably shouldn't call this function; instead, use
 * evthread_use_windows_threads() or evthread_use_pthreads() if you can.
 */
EVENT2_EXPORT_SYMBOL
int evthread_set_condition_callbacks(
	const struct evthread_condition_callbacks *);

/**
   Sets the function for determining the thread id.

   @param base the event base for which to set the id function
   @param id_fn the identify function Libevent should invoke to
     determine the identity of a thread.
*/
EVENT2_EXPORT_SYMBOL
void evthread_set_id_callback(
    unsigned long (*id_fn)(void));

#if (defined(_WIN32) && !defined(EVENT__DISABLE_THREAD_SUPPORT)) || defined(EVENT_IN_DOXYGEN_)
/** Sets up Libevent for use with Windows builtin locking and thread ID
    functions.  Unavailable if Libevent is not built for Windows.

    @return 0 on success, -1 on failure. */
EVENT2_EXPORT_SYMBOL
int evthread_use_windows_threads(void);
/**
   Defined if Libevent was built with support for evthread_use_windows_threads()
*/
#define EVTHREAD_USE_WINDOWS_THREADS_IMPLEMENTED 1
#endif

#if defined(EVENT__HAVE_PTHREADS) || defined(EVENT_IN_DOXYGEN_)
/** Sets up Libevent for use with Pthreads locking and thread ID functions.
    Unavailable if Libevent is not build for use with pthreads.  Requires
    libraries to link against Libevent_pthreads as well as Libevent.

    @return 0 on success, -1 on failure. */
EVENT2_EXPORT_SYMBOL
int evthread_use_pthreads(void);
/** Defined if Libevent was built with support for evthread_use_pthreads() */
#define EVTHREAD_USE_PTHREADS_IMPLEMENTED 1

#endif

/** Enable debugging wrappers around the current lock callbacks.  If Libevent
 * makes one of several common locking errors, exit with an assertion failure.
 *
 * If you're going to call this function, you must do so before any locks are
 * allocated.
 **/
EVENT2_EXPORT_SYMBOL
void evthread_enable_lock_debugging(void);

/* Old (misspelled) version: This is deprecated; use
 * evthread_enable_log_debugging instead. */
EVENT2_EXPORT_SYMBOL
void evthread_enable_lock_debuging(void);

#endif /* EVENT__DISABLE_THREAD_SUPPORT */

struct event_base;
/** Make sure it's safe to tell an event base to wake up from another thread
    or a signal handler.

    You shouldn't need to call this by hand; configuring the base with thread
    support should be necessary and sufficient.

    @return 0 on success, -1 on failure.
 */
EVENT2_EXPORT_SYMBOL
int evthread_make_base_notifiable(struct event_base *base);

#ifdef __cplusplus
}
#endif

#endif /* EVENT2_THREAD_H_INCLUDED_ */
