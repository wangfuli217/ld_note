#ifndef SPARSEARRAY_INCLUDE
#define SPARSEARRAY_INCLUDE

#define T sparsearray_t

#define INDEX_NO_KEY -1

typedef struct T *T;


extern T        sparsearray_new         (ssize_t hint);
extern void     sparsearray_free        (T *sarray);

extern ssize_t  sparsearray_length      (T sarray);

extern void    *sparsearray_get         (T sarray, ssize_t key);
extern void    *sparsearray_put         (T sarray, ssize_t key, void *value);

extern void    *sparsearray_get_at      (T sarray, ssize_t index);
extern void    *sparsearray_put_at      (T sarray, ssize_t index, void *value);

extern ssize_t  sparsearray_key_at      (T sarray, ssize_t index);

/* 
 * if use ring to record key, traverse for index of key is to slow
 */
extern ssize_t  sparsearray_index_of_key(T sarray, ssize_t key);

extern void    *sparsearray_remove      (T sarray, ssize_t key);
extern void    *sparsearray_remove_at   (T sarray, ssize_t index);


#undef T
#endif /*SPARSEARRAY_INCLUDE*/
