
typedef struct String {
	char *content;
	int capacity;
	int size;
};

int string_create(String *string);

int string_push_back(String *string, char c);

int string_size(String *string);

char string_get(String *string, int index);

char *string_raw(String *string);

int string_assign(String *string, char *c_string);

int string_destroy(String *string);

int string_clear(String *string);

char string_pop_back(String *string);

int string_concat(String *string, char *c_string);
