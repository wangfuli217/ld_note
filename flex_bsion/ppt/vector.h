#ifndef CC_VECTOR_HEADER
#define CC_VECTOR_HEADER

typedef struct {
	int size;
	int capacity;
	void **data;
} Vector;

void vector_initialize(Vector *vector);
void vector_set(Vector *vector, int index, void *value);
// void vector_resize(Vector *vector, int size);
// void vector_reserve(Vector *vector, int size);
void vector_push_back(Vector *vector, void *value);
// void vector_pop_back(Vector *vector);
// void vector_insert(Vector *vector, int position, void *value);
// void vector_clear(Vector *vector);
int vector_size(Vector *vector);
void *vector_get(Vector *vector, int index);

#endif