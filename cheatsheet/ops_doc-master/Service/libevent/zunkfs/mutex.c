
#include "mutex.h"
#include "utils.h"

/*
 * Paranoid locking ops. 
 */
void init_mutex (struct mutex *m) {
    *m = (struct mutex) INIT_MUTEX;
}

void lock (struct mutex *m) {
    int err = pthread_mutex_lock (&m->mutex);
    if (err)
        panic ("pthread_mutex_lock: %s\n", strerror (err));
    m->owner = pthread_self ();
}

void unlock (struct mutex *m) {
    int err;
    m->owner = (pthread_t) - 1;
    err = pthread_mutex_unlock (&m->mutex);
    if (err)
        panic ("pthread_mutex_lock: %s\n", strerror (err));
}

int trylock (struct mutex *m) {
    int err = pthread_mutex_trylock (&m->mutex);
    if (err && err != EBUSY)
        panic ("pthread_mutex_lock: %s\n", strerror (err));
    if (!err)
        m->owner = pthread_self ();
    return !err;
}
