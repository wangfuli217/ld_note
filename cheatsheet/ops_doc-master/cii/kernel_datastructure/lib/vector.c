#include "vector.h"
#include <stdlib.h>
#include <string.h>
#include <search.h>
#define INIT_ALLOC_SIZE  128

int vector_new(struct vector *vector, int elem_size,  vector_destroy_func destroy_func, int init_size)
{
	if(elem_size <= 0 || !vector) return -1;
	vector->cur_len = 0;
	vector->elem_size = elem_size;
	vector->init_len = init_size > 0 ? init_size:INIT_ALLOC_SIZE;
	vector->destroy_func = destroy_func;
	vector->base = (void *)malloc(elem_size * vector->init_len);
	if(!vector->base) return -1;
	vector->alloc_len = vector->init_len;
	return 0;
}
static void *vector_Nth_raw(const struct vector *vector, int pos)
{
	return (void *)((char *)(vector->base) + pos * vector->elem_size);
}
void *vector_Nth(const struct vector *vector, int pos)
{
	if(pos < 0 || pos > vector->cur_len) return NULL;
	return vector_Nth_raw(vector, pos);
}
static int vector_growth(struct vector *vector)
{
	void *tmp;
	tmp = (void *)realloc(vector->base, (vector->alloc_len + vector->init_len)*vector->elem_size);
	if(!tmp) return -1;
	vector->alloc_len += vector->init_len;
	vector->base = tmp;
	return 0;
}
int vector_append(struct vector *vector, const void *data)
{
	void *tmp;
	if(vector->cur_len >= vector->alloc_len)
		if(vector_growth(vector) < 0)
			return -1;
	tmp = vector_Nth_raw(vector, vector->cur_len);
	memcpy(tmp, data, vector->elem_size);
	vector->cur_len++;
	return 0;
}
static void vector_shift(struct vector *vector, int pos, int delta)
{
	void *start = vector_Nth_raw(vector, pos);
	void *new_start = vector_Nth_raw(vector, pos + delta);
	int size = vector->elem_size * (vector->cur_len - pos);
	memmove(new_start, start, size);
}
int vector_insert(struct vector *vector, const void *data, int pos)
{
	if(pos < 0 || pos > vector->cur_len) return -1;
	if(vector->cur_len >= vector->alloc_len)
		if(vector_growth(vector) < 0)
			return -1;
	vector_shift(vector, pos, 1);
	memcpy(vector_Nth_raw(vector, pos), data, vector->elem_size);
	vector->cur_len++;
	return 0;
}
int vector_replace(struct vector *vector, const void *data, int pos)
{
	void *old_data;
	if(pos < 0 || pos > vector->cur_len) return -1;
	old_data = vector_Nth_raw(vector, pos);
	if(vector->destroy_func)
		vector->destroy_func(old_data);
	memcpy(old_data, data, vector->elem_size);
	return 0;
}
void vector_delete(struct vector *vector, int pos)
{
	if(pos < 0 || pos > vector->cur_len)return ;
	if(vector->destroy_func)
		vector->destroy_func(vector_Nth_raw(vector, pos));
	vector_shift(vector, pos + 1, -1);
	vector->cur_len--;
}


void vector_sort(struct vector *vector, vector_cmp_func cmp_func)
{
	qsort(vector->base, vector->cur_len, vector->elem_size, cmp_func);
}

static int vector_index(const struct vector *vector, void *pos)
{
	return ((int )((char*)pos - (char*)vector->base))/vector->elem_size;
}
int vector_search(const struct vector *vector, const void *key, vector_cmp_func cmp_func, int start_index, int is_sorted)
{
	void *start_pos;
	void *found;
	size_t  num = vector->cur_len - start_index;
	if(start_index < 0 || start_index > vector->cur_len) return -1;
	start_pos = vector_Nth_raw(vector, start_index);
	if(is_sorted){
		found = bsearch(key, start_pos, num, vector->elem_size, cmp_func);
	}else{
		found = lfind(key, start_pos, &num, vector->elem_size, cmp_func);
	
	}
	return found ? vector_index(vector, found) : -1;
}

int vector_map(struct vector *vector, vector_map_func map_func, void *aux_data)
{
	int i;
	for(i = 0; i < vector->cur_len; i++){
		map_func(vector_Nth_raw(vector, i), aux_data);
	}
	return 0;
}
void vector_dispose(struct vector *vector)
{
	int i;
	if(vector->destroy_func)
		for(i = 0; i < vector->cur_len; i++)
			vector->destroy_func(vector_Nth_raw(vector, i));
	free(vector->base);
}
int vector_length(struct vector *vector)
{
	return vector->cur_len;
}
