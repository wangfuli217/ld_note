#include "list.h"

#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>

typedef struct _xxx_hash_bucket_head {
    struct hlist_head chain;           // hash 桶的头结点
} xxx_hash_bucket_head;

typedef struct _xxx_hashtable {
    xxx_hash_bucket_head *tbl;         // hash 表中的 hash 桶
    int8_t *name;                        // hash 表的名称，未使用
    uint32_t cnt;                         // 保存关键字 hash 后的最大值
    uint32_t element_cnt;                 // 记录当前 hash 表中的元素数量
    uint32_t offset;                      // hlist_node 成员与包含该成员结构体的地址偏移
    uint32_t (*hash)(void *);             // 关键字的 hash 算法函数
    int32_t (*compare)(void *, void *);  // 元素的比较函数
    void (*destroy)(void *);           // 反初始化时对每个元素的反初始化操作函数
} xxx_hashtable_t;

void *hashtable_init(int8_t *name,
        uint32_t cnt,
        uint32_t offset,
        uint32_t (*hash)(void *),
        uint32_t (*compare)(void *, void *),
        void (*destroy)(void *))
{
    xxx_hashtable_t *tbl;
    uint32_t i;
    uint32_t size;

    assert(!(cnt & (cnt - 1)));
    assert(NULL != hash);
    assert(NULL != compare);

    if (NULL == (tbl = (xxx_hashtable_t*)malloc(sizeof(xxx_hashtable_t)))) {
        return NULL;
    }

    size = sizeof(xxx_hash_bucket_head) * cnt;
    if (NULL == (tbl->tbl = malloc(size))) {
        free(tbl);
        return NULL;
    }

    tbl->name = name;
    tbl->cnt = cnt;
    tbl->element_cnt = 0;
    tbl->offset = offset;
    tbl->hash = hash;
    tbl->compare = compare;
    tbl->destroy = destroy;


    for (i = 0; i < cnt; i++) {
        INIT_HLIST_HEAD(&(tbl->tbl[i].chain));
    }

    return tbl;
}

void hashtable_fini(void *tbl)
{
    uint32_t i;
    struct hlist_node *pos, *n;
    xxx_hash_bucket_head *h;
    uint32_t size;
    uint32_t offset;

    if (NULL == tbl) {
        return;
    }

    offset = ((xxx_hashtable_t *)tbl)->offset;
    for (i = 0; i < ((xxx_hashtable_t *)tbl)->cnt; i++) {
        h = &((xxx_hashtable_t *)tbl)->tbl[i];
        hlist_for_each_safe(pos, n, &h->chain) {
            if (NULL != ((xxx_hashtable_t *)tbl)->destroy) {
                ((xxx_hashtable_t *)tbl)->destroy((void *)((uint8_t *)pos - offset));
            }
        }
    }

    size = sizeof(struct hlist_head) * ((xxx_hashtable_t *)tbl)->cnt;
    free(((xxx_hashtable_t *)tbl)->tbl);
    free(tbl);
}

static inline void *hashtable_find(void *tbl, void *elem)
{
    struct hlist_node *pos;
    xxx_hash_bucket_head *h;
    uint32_t hash;

    hash = ((xxx_hashtable_t *)tbl)->hash(elem);

    assert(hash < ((xxx_hashtable_t *)tbl)->cnt);

    h = &((xxx_hashtable_t *)tbl)->tbl[hash];
    hlist_for_each(pos, &h->chain) {
        if (!((xxx_hashtable_t *)tbl)->compare(elem, (uint8_t *)pos - ((xxx_hashtable_t *)tbl)->offset)) {
            return (void *)((uint8_t *)pos - ((xxx_hashtable_t *)tbl)->offset);
        }
    }

    return NULL;
}

static int hashtable_insert(void* hashtable, void* elem)
{
    struct hlist_node* pos;
    xxx_hash_bucket_head* bucket;
    uint32_t hash;

    hash = ((xxx_hashtable_t *)hashtable)->hash(elem);
    assert(hash < ((xxx_hashtable_t *)hashtable)->cnt);

    bucket = &((xxx_hashtable_t *)hashtable)->tbl[hash];
    hlist_for_each(pos, &bucket->chain) {
        if (!((xxx_hashtable_t *)hashtable)->compare(elem, (uint8_t *)pos - ((xxx_hashtable_t *)hashtable)->offset)) {
            return -1;
        }
    }

    hlist_add_head((struct hlist_node *)((uint8_t *)elem + ((xxx_hashtable_t *)hashtable)->offset), &bucket->chain);
    ((xxx_hashtable_t *)hashtable)->element_cnt++;

    return 0;
}

static inline void hashtable_delete(void *hashtable, void *elem)
{
    xxx_hash_bucket_head *bucket;
    uint32_t hash;

    hash = ((xxx_hashtable_t *)hashtable)->hash(elem);
    assert(hash < ((xxx_hashtable_t *)hashtable)->cnt);
    bucket = &((xxx_hashtable_t *)hashtable)->tbl[hash];
    hlist_del_init((struct hlist_node *)((uint8_t *)elem + ((xxx_hashtable_t *)hashtable)->offset));
    if (NULL != ((xxx_hashtable_t *)hashtable)->destroy) {
        ((xxx_hashtable_t *)hashtable)->destroy(elem);
    }
    ((xxx_hashtable_t *)hashtable)->element_cnt--;
}

#if 0
/* Hash map 实现 */
#define MAP_BUCKET_CNT (1 << 6)

typedef struct _str_map_t{
    int m_value;
    struct hlist_node hash_node;
} str_map_t;

/* 创建 str_map_t 对象 */
str_map_t* str_map_init();

/* 销毁 str_map_t 对象 */
void str_map_fini(str_map_t* p_str_map);

/* 插入元素 */
void str_map_insert(str_map_t* p_str_map);

/* 删除元素 */
void str_map_erase(str_map_t* p_str_map);

/* 查找元素 */
void str_map_erase(str_map_t* p_str_map);

/* 测试函数 */
typedef struct _hlist_demo_t{
    int m_value;
    struct hlist_node hash_node;
} hlist_demo_t;

static u32_t demo_hash(void *pkt)
{
    return (u32_t)(((hlist_demo_t*)pkt)->m_value) % BUCKET_CNT;
}

static s32_t demo_compare(void *pkt, void *pkt2)
{
    if (((hlist_demo_t*)pkt)->m_value == ((hlist_demo_t*)pkt2)->m_value) {
        return 0;
    }
    return -1;
}

static void demo_destroy(void *arg)
{
    xxx_free(arg);
}
#endif

int main(void)
{
    return 0;
}

