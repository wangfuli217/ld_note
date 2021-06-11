#ifndef __ZUNKFS_MUTEX_H__
#define __ZUNKFS_MUTEX_H__

#define _GNU_SOURCE
#include <pthread.h>

/*
 * Mutex wrappers.
 */
struct mutex {
    pthread_mutex_t mutex;
    pthread_t owner;
};

#if !defined(NDEBUG) && defined(PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP)
#define INIT_MUTEX { PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP, (pthread_t)-1 }
#else
#define INIT_MUTEX { PTHREAD_MUTEX_INITIALIZER, (pthread_t)-1 }
#endif

#define DECLARE_MUTEX(name) \
	struct mutex name = INIT_MUTEX

void init_mutex (struct mutex *m);
void lock (struct mutex *m);
void unlock (struct mutex *m);
int trylock (struct mutex *m);

static inline int have_mutex (const struct mutex *m) {
    return m->owner == pthread_self ();
}

#define locked_inc(value, mutex) do { \
	lock(mutex); \
	++ *(value); \
	assert(*(value) != 0); \
	unlock(mutex); \
} while(0)

#define locked_dec(value, mutex) do { \
	lock(mutex); \
	assert(*(value) != 0); \
	-- *(value); \
	unlock(mutex); \
} while(0)

#endif
