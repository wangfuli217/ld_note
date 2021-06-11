#ifndef LJA_MEM_H
#define LJA_MEM_H
#include  "lja_type.h"

#define LJA_MEM_ALLOC(bytes) mem_alloc((bytes), __func__)
#define LJA_MEM_CALLOC(count, bytes) mem_calloc((count),(bytes), __func__)
#define LJA_MEM_FREE(ptr) mem_free((ptr), __func__)

void lja_mem_init(u_int64 max, void (*no_mem)(const char *));
void *lja_mem_alloc(u_int64 bytes, const char *func);
void *lja_mem_calloc(u_int64 count, u_int64 bytes, const char *func);
void *lja_mem_free(void *ptr, const char *func);
#endif //__MEM_H__

