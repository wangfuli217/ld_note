#include "hdict.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/queue.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <pthread.h>
#include "crc64.h"
#include "util.h"
#include "terminal_define.h"

#define LOCK(hdb)   pthread_mutex_lock(&(hdb)->mutex)
#define UNLK(hdb)   pthread_mutex_unlock(&(hdb)->mutex)

/***
 * open the idx and db
 */
hdict_t* hdict_open(const char *path, int *hdict_errnop)
{
    FILE *fp = NULL;
    char pathname[256];

    hdict_t *hdict = (hdict_t *)calloc(1, sizeof(hdict[0]));
    hdict->path = strdup(path);

    snprintf(pathname, sizeof(pathname), "%s/idx", hdict->path);
    if ((fp = fopen(pathname, "r")) == NULL) {
        *hdict_errnop = EHDICT_BAD_FILE;
        goto error;
    }
    /* get the meta in idx file */
    meta_t *hdict_meta = (meta_t*)calloc(1, sizeof(meta_t));
    if (hdict_meta == NULL) {
        *hdict_errnop = EHDICT_OUT_OF_MEMERY;
        fprintf(stderr, "open idx %s fail get meta error\n", pathname);
        goto error;
    }
    if (fread(hdict_meta, sizeof(meta_t), 1, fp) != 1) {
        *hdict_errnop = EHDICT_BAD_FILE;
        goto error;
    }
    uint64_t crc64_num;
    if (fread(&crc64_num, sizeof(uint64_t), 1, fp) != 1){
        *hdict_errnop = EHDICT_BAD_FILE;
        fprintf(stderr, "open idx %s fail get crc error\n", pathname);
        goto error;
    }
    uint64_t meta_crc64 = crc64(0, hdict_meta, sizeof(meta_t));
    if (meta_crc64 != crc64_num){
        *hdict_errnop = EHDICT_BAD_FILE;
        fprintf(stderr, "open idx %s fail crc error crc is:%lu-%lu\n", pathname, meta_crc64, crc64_num);
        goto error;
    }
    hdict->hdict_meta = hdict_meta;

    struct stat st;
    if (stat(pathname, &st) == -1 ||
        ((st.st_size - sizeof(meta_t) - sizeof(uint64_t)) % sizeof(hdict->idx[0])) != 0) {
        *hdict_errnop = EHDICT_BAD_FILE;
        goto error;
    }
    /*malloc the idx space*/
    hdict->idx_num = (st.st_size - sizeof(meta_t) - sizeof(uint64_t)) / sizeof(hdict->idx[0]);
    hdict->idx = (idx_t *)malloc(hdict->idx_num * sizeof(hdict->idx[0]));
    if (hdict->idx == NULL) {
        *hdict_errnop = EHDICT_OUT_OF_MEMERY;
        goto error;
    }

    /* load the idx data to memory*/
    if (fread(hdict->idx, sizeof(hdict->idx[0]), hdict->idx_num, fp) != hdict->idx_num) {
        fprintf(stderr, "open idx %s fail idx_num:%d\n", pathname, hdict->idx_num);
        *hdict_errnop = EHDICT_BAD_FILE;
        goto error;
    }

    fclose(fp);
    fp = NULL;

    snprintf(pathname, sizeof(pathname), "%s/dat", hdict->path);
    hdict->fd = open(pathname, O_RDWR);
    if (hdict->fd <= 0) {
        //*hdict_errnop = EHDICT_BAD_FILE;
        *hdict_errnop = EHDICT_OUT_OF_MEMERY;
        goto error;
    }
    fprintf(stderr, "open idx %s success num:%d\n", pathname, hdict->idx_num);
    hdict->open_time = time(NULL);
    return hdict;

error:
    if (fp) fclose(fp);
    if (hdict) hdict_close(hdict);
    fprintf(stderr, "open idx %s fail\n", pathname);
    return NULL;
}

/***
 * find the key in the idx by binary search then return the offset and length of the value
 */
int hdict_seek(hdict_t *hdict, const char* str_key, off_t *off, uint32_t *length)
{
    uint32_t low = 0;
    uint32_t high = hdict->idx_num;
    uint32_t mid;
    int hit = 0;
    int count = 0;
    uint64_t key = strtoull(str_key, NULL, 10);
    while (low < high) {
        ++count;
        mid = (low + high) / 2;
        if (hdict->idx[mid].key > key) {
            high = mid;
        } else if (hdict->idx[mid].key < key) {
            low = mid + 1;
        } else {
            *off = (hdict->idx[mid].pos & 0xFFFFFFFFFF);
            *length = (hdict->idx[mid].pos >> 40);
            hit = 1;
            break;
        }
    }
    return hit;
}

int hdict_seek_v2(hdict_t *hdict, const char* str_key, off_t *off, uint32_t *length){
    uint32_t low = -1;
    uint32_t high = hdict->idx_num;
    uint32_t mid;
    int hit = 0;
    int count = 0;
    char buf[DATA_BUFFER_SIZE];
    uint64_t key = bkdr_hash(str_key);
    while (low + 1 != high) {
        ++count;
        mid = (low + high) / 2;
        if (key > hdict->idx[mid].key) {
            low = mid;
        } else {
            high = mid;
        } 
    }
     
    if(high >= hdict->idx_num || hdict->idx[high].key != key){
        return hit;
    }
    size_t len = strlen(str_key);
    while(high < hdict->idx_num){
        *off = (hdict->idx[high].pos & 0xFFFFFFFFFF);
        *length = (hdict->idx[high].pos >> 40);
        //compare the string key
        int res = hdict_read(hdict, buf, *length, *off);
        if (res != *length){
            return hit;
        }
        if (res > len && strncmp(buf, str_key, len) == 0 && buf[len] == ':'){
            *off = *off + len + 1;
            *length = *length - len - 1;
            hit = 1;
            return hit;
        }
        high++;
        if(hdict->idx[high].key != key){
            return hit;
        }
    }
    return hit;
}

int hdict_search(hdb_t *hdb, const char* label, const char* key, off_t *off, uint32_t *length, hdict_t **hdict){
    int hit = 0;
    if (NULL == label || NULL == key){
        return hit;
    }
    hdict_t *hd;
    uint64_t hdid = bkdr_hash(label);
    uint32_t hash = HASH(hdid);
    LOCK(hdb);
    hd = LIST_FIRST(&hdb->htab[hash]);

    while(hd){
        if (hd->hdid == hdid) {
            hd->ref++;
            *hdict = hd;
            if (hd->hdict_meta->idx_type == 2){
                hit = hdict_seek_v2(*hdict, key, off, length);
            }else{
                hit = hdict_seek(*hdict, key, off, length);
            }
            (*hdict)->num_qry++;
            if (hit){
                hd->ref--;
                UNLK(hdb);
                return hit;
            }
            hd->ref--;
            hd = LIST_NEXT(hd, h_link);
        }else{
            hd = LIST_NEXT(hd, h_link);
        }
    }
    UNLK(hdb);
    return hit;
}

int hdict_randomkey(hdict_t *hdict, uint64_t *key)
{
    if (hdict->idx_num == 0)
        return -1;
    int i = rand() % hdict->idx_num;
    *key = hdict->idx[i].key;
    return 0;
}

int hdict_read(hdict_t *hdict, char *buf, uint32_t length, off_t off)
{
    return pread(hdict->fd, buf, length, off);
}

void hdict_close(hdict_t *hdict)
{
    if (hdict->fd > 0) close(hdict->fd);
    if (hdict->idx) free(hdict->idx);
    if (hdict->hdict_meta) free(hdict->hdict_meta);
    free(hdict->path);
    free(hdict);
}

void *hdb_mgr(void *arg)
{
    hdb_t *hdb = (hdb_t *)arg;

    for (;;) {
        if (TAILQ_FIRST(&hdb->close_list)) {
            hdict_t *hdict, *next;
            hdict_t *hdicts[100];
            int i, k = 0;

            LOCK(hdb);
            for (hdict = TAILQ_FIRST(&hdb->close_list); hdict; hdict = next) {
                next = TAILQ_NEXT(hdict, link);
                if (hdict->ref == 0) {
                    hdicts[k++] = hdict;
                    TAILQ_REMOVE(&hdb->close_list, hdict, link);
                    hdb->num_close--;
                    if (k == 100)
                        break;
                }
            }
            UNLK(hdb);

            for (i = 0; i < k; ++i) {
                hdict = hdicts[i];
                hdict_close(hdict);
            }
        }
        sleep(1);
    }
    return NULL;
}

int hdb_init(hdb_t *hdb)
{
    if (pthread_mutex_init(&hdb->mutex, NULL)) return -1;
    TAILQ_INIT(&hdb->open_list);
    TAILQ_INIT(&hdb->close_list);
    hdb->num_open = 0;
    hdb->num_close = 0;

    int i;
    for (i = 0; i < HTAB_SIZE; i++) {
        LIST_INIT((hdb->htab + i));
    }
    return 0;
}
/***
 * you can append the db to the same tag
 * if the new db has the same key in the old one
 * then you will get the value with large version
 */
int hdb_append(hdb_t *hdb, const char *hdict_path){
    hdict_t *hd, *ihd = NULL;
    char rpath[1024];
    realpath(hdict_path, rpath);

    int hdict_errno = 0;
    hdict_t *hdict = hdict_open(rpath, &hdict_errno);
    if(NULL == hdict) return hdict_errno;
    LOCK(hdb);
    //use the label to generate hash id
    uint64_t key_hash = bkdr_hash(hdict->hdict_meta->label);
    uint32_t hash = HASH(key_hash);
    for (hd = LIST_FIRST(&hdb->htab[hash]); hd; hd = LIST_NEXT(hd, h_link)) {
        if (hd->hdict_meta->version <= hdict->hdict_meta->version) {
            ihd = hd;
            break;
        }
    }
    hdict->hdid = key_hash;
    TAILQ_INSERT_TAIL(&hdb->open_list, hdict, link);
    if(NULL == ihd){
        LIST_INSERT_HEAD(&hdb->htab[hash], hdict, h_link);
    }else{
        LIST_INSERT_BEFORE(ihd, hdict, h_link);
    }
    hdb->num_open++;
    UNLK(hdb);
    return 0;
}

/***
 * close all the hdb with label and open a new hdb
 */
int hdb_reopen(hdb_t *hdb, const char *hdict_path)
{
    hdict_t *hd, *next;
    uint32_t hash;
    char rpath[1024];
    realpath(hdict_path, rpath);

    int hdict_errno = 0;
    hdict_t *hdict = hdict_open(rpath, &hdict_errno);
    if (hdict == NULL) return hdict_errno;
    uint64_t hdid = bkdr_hash(hdict->hdict_meta->label);

    LOCK(hdb);
    for (hd = TAILQ_FIRST(&hdb->open_list); hd; hd = next) {
        next = TAILQ_NEXT(hd, link);
        if (hd->hdid == hdid && strcmp(hd->hdict_meta->label, hdict->hdict_meta->label) == 0) {
            LIST_REMOVE(hd, h_link);
            TAILQ_REMOVE(&hdb->open_list, hd, link);
            hdb->num_open--;
            TAILQ_INSERT_TAIL(&hdb->close_list, hd, link);
            hdb->num_close++;
            break;
        }
    }
    hdict->hdid = hdid;
    TAILQ_INSERT_TAIL(&hdb->open_list, hdict, link);
    /* put the hdb ptr to simple hash table */
    hash = HASH(hdict->hdid);
    LIST_INSERT_HEAD(&hdb->htab[hash], hdict, h_link);
    hdb->num_open++;
    UNLK(hdb);

    return 0;
}

int hdb_close(hdb_t *hdb, const char* label, uint32_t version_id)
{
    if(NULL == label){
        return 0;
    }
    uint64_t hdid = bkdr_hash(label);
    int found = 0;
    hdict_t *hd, *next;
    LOCK(hdb);
    for (hd = TAILQ_FIRST(&hdb->open_list); hd; hd = next) {
        next = TAILQ_NEXT(hd, link);
        if (hd->hdid == hdid && strcmp(hd->hdict_meta->label, label) == 0) {
            if (version_id != 0 && hd->hdict_meta->version != version_id){
                continue;
            }
            LIST_REMOVE(hd, h_link);
            TAILQ_REMOVE(&hdb->open_list, hd, link);
            hdb->num_open--;
            TAILQ_INSERT_TAIL(&hdb->close_list, hd, link);
            hdb->num_close++;
            found += 1;
            if (version_id != 0){
                break;
            }
        }
    }
    UNLK(hdb);

    return found;
}

int hdb_info(hdb_t *hdb, char *buf, int size)
{
    int len = 0;
    len += snprintf(buf+len, size-len, "%2s %20s %10s %5s %3s %9s %8s %13s %s\n", 
            "id", "label", "version", "state", "ref", "num_qry", "idx_num", "open_time", "path");
    if (len < size) 
        len += snprintf(buf+len, size-len, "---------------------------------------------------------------------------------------\n");
    int pass, k;
    hdict_t *hdict;
    LOCK(hdb);
    for (pass = 0; pass < 2; ++pass) {
        const char *state;
        struct hdict_list_t *hlist;
        switch (pass) {
        case 0:
            state = "OPEN";
            hlist = &hdb->open_list;
            break;
        case 1:
            state = "CLOSE";
            hlist = &hdb->close_list;
            break;
        default:
            state = NULL;
            hlist = NULL;
        }

        k = 0;
        for (hdict = TAILQ_FIRST(hlist); hdict; hdict = TAILQ_NEXT(hdict, link)) {
            ++k;
            if (len < size) {
                struct tm tm;
                localtime_r(&hdict->open_time, &tm);
                len += snprintf(buf+len, size-len, "%2lu %20s %u %5s %2d %10d %8d %02d%02d%02d-%02d%02d%02d %s\n",
                    hdict->hdid,
                    hdict->hdict_meta->label,
                    hdict->hdict_meta->version,
                    state,
                    hdict->ref,
                    hdict->num_qry,
                    hdict->idx_num,
                    tm.tm_year - 100, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec,
                    hdict->path);
            }
        }
    }
    UNLK(hdb);
    return len;
}

/***
 * give the label and find the hdb
 */
hdict_t *hdb_ref(hdb_t *hdb, const char* label)
{
    hdict_t *hdict = NULL;
    if (NULL == label){
        return hdict;
    }
    hdict_t *hd;
    LOCK(hdb);
    uint64_t hdid = bkdr_hash(label);
    uint32_t hash = HASH(hdid);
    for (hd = LIST_FIRST(&hdb->htab[hash]); hd; hd = LIST_NEXT(hd, h_link)) {
        if (hd->hdid == hdid) {
            hd->ref++;
            hdict = hd;
            break;
        }
    }
    UNLK(hdb);
    return hdict;
}

int hdb_deref(hdb_t *hdb, hdict_t *hdict)
{
    LOCK(hdb);
    hdict->ref--;
    UNLK(hdb);
    return 0;
}
