#ifndef BST_INCLUDE
#define BST_INCLUDE

#define T bst_t

typedef struct T *T;

extern      T       bst_new         (void *key);
extern      void   *bst_get_key     (T bst);
extern      T       bst_minimum     (T bst);
extern      T       bst_maximum     (T bst);
extern      T       bst_successor   (T bst);
extern      T       bst_predecessor (T bst);
extern      T       bst_find        (T bst, void *key, 
                                    int(*cmp)(const void *x, const void *y));
extern      T       bst_insert      (T bst, void *key,
                                    int(*cmp)(const void *x, const void *y));
extern      T       bst_delete      (T bst);
extern      void    bst_traverse    (T bst, 
                                        void (*apply)(const void *key, void *cl),
                                        void *cl);
#undef T
#endif /*BST_INCLUDE*/
