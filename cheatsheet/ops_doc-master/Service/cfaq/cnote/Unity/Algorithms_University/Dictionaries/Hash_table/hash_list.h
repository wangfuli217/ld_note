#ifndef __HASH_LIST_H_KEIXJ4PDU3__
#define __HASH_LIST_H_KEIXJ4PDU3__

typedef int (*CompFunction)(void*, void*);

typedef struct _HashNode {
    void* key;
    void* record;
    struct _HashNode* next;
    struct _HashNode* prev;
} HashNode_t, *HashNode_p;

typedef struct _HashList {
    HashNode_p first;
} HashList_t, *HashList_p;


HashList_p hash_list_create();
HashNode_p hash_node_create(void* key, unsigned int key_size, void* record);
void hash_list_insert(HashList_p list, HashNode_p node);
HashNode_p hash_list_search(HashList_p list, void* key, CompFunction compare);
void hash_list_remove_node(HashList_p list, HashNode_p node);
void hash_list_destroy(HashList_p list);

#endif
