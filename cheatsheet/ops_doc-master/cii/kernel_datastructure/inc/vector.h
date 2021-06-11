#ifndef VECTOR_H_
#define VECTOR_H_
//#include <linux/types.h>
#ifndef NULL
#define NULL (void*)0
#endif

typedef void *(*vector_alloc_func)(unsigned int size);
typedef int (*vector_cmp_func)(const void *data1, const void *data2);
typedef void (*vector_destroy_func)(void *data);
typedef void (*vector_map_func)(void *data, void *aux_data);

struct vector {
	int cur_len;
	int alloc_len;
	int elem_size;
	int init_len;
	void *base;
	vector_alloc_func allo_func;
	vector_cmp_func   cmp_func;
	vector_destroy_func destroy_func;
};
extern int vector_length(struct vector *vector);
extern int vector_new(struct vector *vector, int elem_size, vector_destroy_func destroy_func, int init_size);
extern void *vector_Nth(const struct vector *vector, int nth);
extern int vector_insert(struct vector *vector, const void *data, int pos);
extern int vector_append(struct vector *vector, const void *data);
extern int vector_replace(struct vector *vector, const void *new_elem, int pos);
extern void vector_delete(struct vector *vector, int pos);
extern int vector_search(const struct vector *vector, const void *key, vector_cmp_func cmp_func, int start_index, int is_sorted);
extern void vector_sort(struct vector *vector, vector_cmp_func cmp_func);
extern int vector_map(struct vector *vector, vector_map_func map_func, void *aux_data);
extern void vector_dispose(struct vector *vector);
#endif
