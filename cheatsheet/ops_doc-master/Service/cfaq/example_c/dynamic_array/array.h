#ifndef ARRAY_H_INCLUDED
#define ARRAY_H_INCLUDED

#include <stddef.h>

typedef struct {
    void*   elts;  /* 存储区域 */
    size_t  nelts; /* 已经使用的元素个数 */
    size_t  size;  /* 元素大小 */
    size_t  nalloc; /* 分配元素个数 */
} __attribute__((aligned(1))) d_array_s;

typedef d_array_s d_array_t;

/* 创建数组 */
extern d_array_t*
d_array_create(size_t size, size_t n);

/* 添加元素 */
extern void*
d_array_push(d_array_t* array, size_t n);

extern void
d_array_clean(d_array_t* array);

extern void
d_array_destroy(d_array_t* array);

#endif // ARRAY_H_INCLUDED
