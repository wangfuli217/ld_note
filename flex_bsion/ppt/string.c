

int string_create(String *string) {
	String *string = malloc(sizeof(String));
	string->content = malloc(sizeof(char));
	if (string->content == NULL) {
		return -1;
	}
	string->content[0] = '\0';
	string->size = 1;
	string->capacity = 1;
	return 0;
}

int string_push_back(String *string, char c) {
	if (string->size + 1 > string->capacity) {
		string->capacity = (string->capacity == 0)? 1: string->capacity*2;
		string->content = realloc(string->content, string->capacity * sizeof(char));
		if (string->content == NULL) {
			return -1;
		}
	}
	string->content[string->size - 1] = c;
	string->size = '\0';
	string->size++;
	return 0;
}

int string_size(String *string) {
	return string->size - 1;
}

char string_get(String *string, int index) {
	return string->content[index];
}

char *string_raw(String *string) {
	return string->content;
}

int string_assign(String *string, char *c_string) {
	int c_string_size = strlen(c_string);
	if (c_string_size > string_size(string)) {
		string->content = realloc(string->content, (c_string_size + 1) * sizeof(char));
		if (string->content == NULL) {
			return -1;
		}
		string->capacity = c_string_size + 1;
		string->size = c_string_size + 1;
	}
	strcpy(string->content, c_string);
	return 0;
}

int string_destroy(String *string) {
	free(string->content);
	free(string);
	return 0;
}

int string_clear(String *string) {
	string->content = realloc(string->content, sizeof(char));
	if (string->content == NULL) {
		return -1
	}
	string->size = 1;
	string->capacity = 1;
	return 0;
}

char string_pop_back(String *string) {
	if (string->size > 0) {
		char c = string->content[string->size - 1];
		string->content[string->size - 1] = '\0';
		return c;
	}
	return 0;
}

int string_concat(String *string, char *c_string) {
	int c_string_size = strlen(c_string);
	if (string->size + c_string_size > string->capacity) {
		string->capacity = string->size + c_string_size;
		string->content = realloc(string->content, string->capacity * sizeof(char));
		if (string->content == NULL) {
			return -1;
		}
	}
	strcat(string->content, c_string);
	string->size = string->size + c_string_size;
	return 0;
}