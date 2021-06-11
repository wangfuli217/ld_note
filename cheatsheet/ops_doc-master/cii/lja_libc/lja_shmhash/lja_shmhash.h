#ifndef SHMHASH_H
#define SHMHASH_H
#include  <pthread.h>
#include  "lja_type.h"

/*
 |--------------------------------+
 | shmhash_t                      |
 +--------------------------------+
 | HASH  BUCKETS                  |
 +--------------------------------+
 | UNITS                          |
 +--------------------------------+
*/

typedef struct shm_hash{
	pthread_rwlock_t rwlock;
	pthread_rwlockattr_t rwattr; 
	int bpos;
	int upos;
	int bnum;       //! buckets number
	int unum;       //! units number
	int datalen;
	int free;
	int used;
}shm_hash_t;

typedef struct shm_hash_bucket{
	int first;
}shm_hash_bucket_t;

typedef struct shm_hash_unit_head{
	pthread_spinlock_t spinlock;
	int h_next;
	int h_prev;
	int next;
	int prev;
	char used;
}shm_hash_uhead_t;

typedef struct shm_hash_unit{
	shm_hash_uhead_t head;
	char data[0];
}shm_hash_unit_t;

shm_hash_t *shm_hash_addr(char *path, int id);

int shm_hash_create(char *path, int id, int shmflg,int bucketnum,\
		int unitnum, int datasize);

void *shm_hash_find_lock(shm_hash_t *shmhash, void *key,\
		int hash(void *key), int equal(void *key, void *data2));

void *shm_hash_find_and_get_lock(shm_hash_t *shmhash, void *key,\
		int hash(void *key), int equal(void *key, void *data2));

void *shm_hash_alloc_lock(shm_hash_t *shmhash, void *key, \
		int hash(void*ey));

void shm_hash_unit_unlock(shm_hash_t *shmhash, void *data);

void shm_hash_for_each(shm_hash_t *shmhash, void (*dump)(void *data));

void shm_hash_destroy(char *path, int id);

#endif //SHMHASH_H

