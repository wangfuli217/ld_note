#include  <sys/types.h>
#include  <sys/ipc.h>
#include  <syslog.h>
#include  <sys/shm.h>
#include  <string.h>
#include  <errno.h>
#include  "lja_shmhash.h"

shm_hash_t *shm_hash_addr(char *path, int id)
{
	key_t key = ftok(path, id);
	int shmid = shmget(key, 0, 0);
	void *addr = shmat(shmid, NULL, 0);
	if((void *)-1 == addr){
		syslog(LOG_ALERT, "shm_mat Failed %s %d\n", __FILE__, __LINE__);
		return NULL;
	}
	return (shm_hash_t *)addr;
}

int shm_hash_create(char *path, int id, int shmflg, int bucketnum,\
		int unitnum, int datasize)
{
	key_t key = ftok(path, id);
	if(-1 == key){
		syslog(LOG_ALERT, "ftok Failed %s %d %s\n", __FILE__, __LINE__, strerror(errno));
		return;
	}

	int bsize = sizeof(shm_hash_bucket_t) * bucketnum;
	int udsize = sizeof(shm_hash_uhead_t) + datasize;
	int usize = udsize * unitnum;

	int shmid = shmget(key, sizeof(shm_hash_t)+bsize+usize, shmflg);
	if(-1 == shmid){
		syslog(LOG_ALERT, "shmget Failed %s %d %s\n", __FILE__, __LINE__, strerror(errno));
		return;
	}

	void *addr = shmat(shmid, NULL, 0);
	if((void *)-1 == addr){
		syslog(LOG_ALERT, "shm_mat Failed %s %d\n", __FILE__, __LINE__);
		return;
	}

	shm_hash_t *shmhash = (shm_hash_t *)addr;

	pthread_rwlockattr_init(&shmhash->rwattr);
	pthread_rwlockattr_setpshared(&shmhash->rwattr, PTHREAD_PROCESS_SHARED);

	shmhash->bpos = sizeof(shm_hash_t);
	shmhash->upos = shmhash->bpos + bsize;
	shmhash->bnum = bucketnum;
	shmhash->unum = unitnum;
	shmhash->datalen = datasize;
	shmhash->free = 0;
	shmhash->used = -1;

	shm_hash_bucket_t *buckets = (shm_hash_bucket_t *)((char *)addr + shmhash->bpos);

	int i;
	for(i = 0; i < bucketnum ; i++){
		buckets[i].first = -1;
	}

	char *units = (char *)addr + shmhash->upos;
	shm_hash_unit_t *unit;

	for(i = 0; i < unitnum; i++){
		unit = (shm_hash_unit_t* )((char *)units + i * udsize);
		pthread_spin_init(&unit->head.spinlock, PTHREAD_PROCESS_SHARED);
		unit->head.h_next = -1;
		unit->head.h_prev = -1;
		unit->head.next = i+1;
		unit->head.prev = i-1;
		unit->head.used = 0;
	}
	unit->head.next = -1;
	shmdt(addr);
}

static void *shm_hash_find_index_lock(shm_hash_t *shmhash, void *key,\
		int index, int equal(void *key, void *data))
{
	shm_hash_bucket_t *buckets = (shm_hash_bucket_t *)((char *)shmhash + shmhash->bpos);

	char *units = (char *)shmhash + shmhash->upos;
	shm_hash_unit_t *unit;

	int udsize = shmhash->datalen + sizeof(shm_hash_uhead_t);

	pthread_rwlock_rdlock(&shmhash->rwlock);

	int i = buckets[index].first;
	while(-1!= i){
		unit = (shm_hash_unit_t*)(units + udsize * i);
		if(equal(key, unit->data)){
			break;
		}
		i = unit->head.h_next;
	}

	if(-1 == i){   //Not found
		pthread_rwlock_unlock(&shmhash->rwlock);
		return NULL;
	} 
	
	pthread_spin_lock(&unit->head.spinlock);
	return unit->data;
}

void *shm_hash_find_lock(shm_hash_t *shmhash, void *key, \
		int hash(void *key), int equal(void *key, void *data))
{
	int index = hash(key);
	if(index < 0 || index > shmhash->bnum){
		syslog(LOG_ALERT, "hash error! %s %d\n", __FILE__, __LINE__);
		return NULL;
	}
	return shm_hash_find_index_lock(shmhash, key,index, equal);
}

static void *shm_hash_alloc_index_lock(shm_hash_t *shmhash, int index)
{
	pthread_rwlock_wrlock(&shmhash->rwlock);

	if(-1 == shmhash->free){
		pthread_rwlock_unlock(&shmhash->rwlock);
		syslog(LOG_ALERT, "shmhash is full! %s %d\n", __FILE__, __LINE__);
		return NULL;
	}

	shm_hash_bucket_t *buckets = (shm_hash_bucket_t *)((char *)shmhash + shmhash->bpos);
	shm_hash_bucket_t *bucket = &buckets[index];
	char *units = (char *)shmhash + shmhash->upos;
	shm_hash_uhead_t *unit;

	int udsize = shmhash->datalen + sizeof(shm_hash_uhead_t);

	//从free上摘下一个
	int newid = shmhash->free;
	shm_hash_unit_t *new = (shm_hash_unit_t *)(units + newid * udsize);
	shmhash->free = new->head.next;
	if(-1 != shmhash->free){
		((shm_hash_uhead_t *)(units + shmhash->free * udsize))->prev = -1;
	}

	//挂在到used上
	new->head.next = shmhash->used;
	if(-1 == shmhash->used){
		((shm_hash_uhead_t *)(units + shmhash->used* udsize))->prev = newid;
	}
	shmhash->used = newid;
	new->head.prev = -1;

	//放入哈希桶
	new->head.h_next = bucket->first;
	if(-1 != bucket->first){
		((shm_hash_uhead_t *)(units + bucket->first* udsize))->prev = newid;
	}
	new->head.h_prev = -1;
	bucket->first = newid;

	pthread_rwlock_unlock(&shmhash->rwlock);
	pthread_rwlock_rdlock(&shmhash->rwlock);
	pthread_spin_lock(&new->head.spinlock);
	return new->data;
}

void *shm_hash_alloc_lock(shm_hash_t *shmhash, void *key, int hash(void*ey))
{
	int index = hash(key);
	if(index < 0 || index > shmhash->bnum){
		syslog(LOG_ALERT, "hash error! %s %d\n", __FILE__, __LINE__);
		return NULL;
	}

	return shm_hash_alloc_index_lock(shmhash, index);
}

void *shm_hash_find_and_get_lock(shm_hash_t *shmhash, void *key,\
		int hash(void *key), int equal(void *data1, void *data2))
{
	int index = hash(key);
	if(index < 0 || index > shmhash->bnum){
		syslog(LOG_ALERT, "hash error! %s %d\n", __FILE__, __LINE__);
		return NULL;
	}
	void *ret = shm_hash_find_index_lock(shmhash, key, index, equal);
	if(NULL == ret){
		ret = shm_hash_alloc_index_lock(shmhash, index);
	}
	return ret;
}

void shm_hash_unit_unlock(shm_hash_t *shmhash, void *data)
{
	shm_hash_uhead_t *uhead = (shm_hash_uhead_t *)((char *)data - sizeof(shm_hash_uhead_t));
	pthread_spin_unlock(&uhead->spinlock);
	pthread_rwlock_unlock(&shmhash->rwlock);
}

void shm_hash_for_each(shm_hash_t *shmhash, void (*dump)(void *data))
{
	char *units = (char *)shmhash + shmhash->upos;
	shm_hash_unit_t *unit;
	int udsize = shmhash->datalen + sizeof(shm_hash_uhead_t);
	
	pthread_rwlock_wrlock(&shmhash->rwlock);

	int i = shmhash->used;
	while(-1 != i){
		unit = (shm_hash_unit_t *)(units + i * udsize);
		pthread_spin_lock(&unit->head.spinlock);
		i = unit->head.next;
		dump(unit->data);
		pthread_spin_unlock(&unit->head.spinlock);
	}
	pthread_rwlock_unlock(&shmhash->rwlock);
}

void shm_hash_destroy(char *path, int id)
{
	int shmid = shmget(ftok(path, id), 0, 0);
	void *addr = shmat(shmid, NULL, 0);
	if((void *)-1 == addr){
		syslog(LOG_ALERT, "shm_mat %s %s %d\n", strerror(errno),__FILE__, __LINE__);
		return ;
	}

	shm_hash_t *shmhash = (shm_hash_t *)addr;
	
	char *units = (char *)addr + shmhash->upos;
	shm_hash_unit_t *unit;
	int udsize = shmhash->datalen + sizeof(shm_hash_uhead_t);

	int i;
	for(i = 0; i < shmhash->unum; i++){
		unit = (shm_hash_unit_t *)(units + i * udsize);
		pthread_spin_destroy(&unit->head.spinlock);
	}

	pthread_rwlockattr_destroy(&shmhash->rwattr);
	pthread_rwlock_destroy(&shmhash->rwlock);

	shmdt(addr);
	shmctl(shmid, IPC_RMID, NULL);
}
