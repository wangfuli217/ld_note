

/*struct Vector {
	void **content;
	int capacity;
	int size;
};

int vector_create() {
	struct Vector *vector = malloc(sizeof(struct vector));
	vector->content = malloc(sizeof(char));
	if (vector->content == NULL) {
		return -1;
	}
	vector->content[0] = '\0';
	vector->size = 1;
	vector->capacity = 1;
	return 0;
}

int vector_push_back(struct vector *vector, char c) {
	if (vector->size + 1 > vector->capacity) {
		vector->capacity = (vector->capacity == 0)? 1: vector->capacity*2;
		vector->content = realloc(vector->content, vector->capacity * sizeof(char));
		if (vector->content == NULL) {
			return -1;
		}
	}
	vector->content[vector->size - 1] = c;
	vector->content[vector->size] = '\0';
	vector->size++;
	return 0;
}

int vector_size(struct vector *vector) {
	return vector->size;
}

char vector_get(struct vector *vector, int index) {
	return vector->content[index];
}

char *vector_get_cvector(struct vector *vector) {
	return vector->content;
}

int vector_destroy(struct vector *vector) {
	free(vector->content);
	free(vector);
	return 0;
}*/




struct Vector {
	void **content;
	int capacity;
	int size;
};

Vector *vector_create(Vector *vector) {
	vector = malloc(sizeof(struct Vector));
	vector->size = 0;
	vector->capacity = 1;
	vector->content = malloc(sizeof(void *));
	return vector;
}

void vector_push_back(Vector *vector, void *value) {
	if (vector->size + 1 > vector->capacity) {
		vector->capacity = (vector->capacity == 0)? 1: vector->capacity*2;
		vector->content = realloc(vector->content, vector->capacity * sizeof(void*));
	}
	vector->content[vector->size] = value; 
	vector->size ++;
}

int vector_size(Vector *vector) {
	return vector->size;
}

void *vector_get(Vector *vector, int index) {
	return vector->content[index];
}