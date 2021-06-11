// list.h
// Structures and functions for working with linked lists.
//
// MAINTAINER
//     Justin J. Meza <justin dot meza at gmail dot com>
//
// STYLE
// - `#define's are not used to keep the code clear.
// - Argument names are in CAPS.
// - Control structures without braces will appear on a single line (if space
//   permits).
// - NULL is used instead of 0 for indicating a null-pointer.
//
// EXAMPLE
/*
// This function is required so the list knows how to delete its
// elements when required. It is passed to `list_create'.
void
data_delete_int(void *DATA)
{
	free(DATA);
}

int
main(void)
	// Creates an integer list and prints its contents
	// Prints: "123456789"
{
	int *my_data_1 = malloc(sizeof(int));
	int *my_data_2 = malloc(sizeof(int));
	int *my_data_3 = malloc(sizeof(int));
	struct list *my_list = list_create(data_delete_int);
	*my_data_1 = 123, *my_data_2 = 456, *my_data_3 = 789;
	list_push_back(my_list, my_data_1);
	list_push_back(my_list, my_data_2);
	list_push_back(my_list, my_data_3);
	while (!list_empty(my_list)) {
		printf("%d", *(int *)list_head(my_list));
		list_pop_front(my_list);
	}
	list_delete(my_list);
	// my_data_* have also been released
}
*/

////////// >>> Copy the following function into the client code and implement
        //     any special freeing of data structures being stored as list
        //     items (DATA). Replace the `T' in `data_delete_T' with a unique
        //     name (perhaps the datatype name) and pass this function name to
        //     the call to `list_create' for this particular type of list to
        //     ensure all of its data items' memories are freed properly.

/*
void
data_delete_T(void *DATA)
	// This function is meant to be used if the data structures this list
	// points to contain other allocated memory which must be separately
	// freed. Do so here.
{
	// EXAMPLE
	// free(DATA->my_pointer);
	free(DATA);
}
*/

////////// Structures and functions required for internal implementation. These
        // need not be dealt with directly.

struct item {
	void *data;
	struct item *next;
	struct item *prev;
};

struct list {
	void (*delete)(void *);
	struct item *head;
	struct item *tail;
	unsigned int size;
};

struct item *
item_create(void *DATA)
{
	struct item *item = malloc(sizeof(struct item));
	item->data = DATA;
	item->next = NULL;
	item->prev = NULL;
	return item;
}

void
item_delete(struct list *LIST, struct item *ITEM)
{
	if (!ITEM) return;
	if (ITEM->data) LIST->delete(ITEM->data);
	free(ITEM);
}

////////// Functions for use with lists

struct list *
list_create(void (*DELETE)(void *))
{
	struct list *list = malloc(sizeof(struct list));
	list->delete = DELETE;
	list->head = NULL;
	list->tail = NULL;
	list->size = 0;
	return list;
}

void
list_delete(struct list *LIST)
{
	struct item *current, *next;
	if (!LIST) return;
	// Iterate through list and delete all items
	current = LIST->head;
	while (current) {
		next = current->next;
		item_delete(LIST, current);
		current = next;
	}
	free(LIST);
}

int
list_empty(struct list *LIST)
	// Returns a value greater than 0 if the list is non-empty, 0 if the
	// list is empty and -1 if an error occurs.
{
	if (!LIST) return -1;
	return !LIST->size;
}

int
list_size(struct list *LIST)
	// Returns the number of elements in a list or -1 on error
{
	if (!LIST) return -1;
	return LIST->size;
}

int
list_push_back(struct list *LIST, void *DATA)
	// Pushes an item onto the back of a list and returns the new size of
	// the list or -1 on error.
{
	struct item *item;
	if (!LIST) return -1;
	item = item_create(DATA);
	if (list_empty(LIST)) {
		item->next = NULL;
		item->prev = NULL;
		LIST->head = item;
		LIST->tail = item;
	}
	else {
		item->prev = LIST->tail;
		item->next = NULL;
		LIST->tail->next = item;
		LIST->tail = item;
	}
	return ++LIST->size;
}

int
list_push_front(struct list *LIST, void *DATA)
{
	struct item *item;
	if (!LIST) return -1;
	item = item_create(DATA);
	if (item) {
		if (list_empty(LIST)) {
			item->next = NULL;
			item->prev = NULL;
			LIST->head = item;
			LIST->tail = item;
		}
		else {
			item->prev = NULL;
			item->next = LIST->head;
			LIST->head->prev = item;
			LIST->head = item;
		}
		return ++LIST->size;
	}
	return -1;
}

int
list_pop_front(struct list *LIST)
	// Removes and deletes an item from the front of a list and returns the
	// new size of the list or -1 on error.
{
	struct item *item;
	if (!LIST) return -1;
	item = LIST->head;
	if (LIST->head == LIST->tail) {
		LIST->head = NULL;
		LIST->tail = NULL;
	}
	else {
		LIST->head->next->prev = NULL;
		LIST->head = LIST->head->next;
	}
	if (item) {
		item_delete(LIST, item);
		LIST->size--;
	}
	return LIST->size;
}

int
list_pop_back(struct list *LIST)
{
	struct item *item;
	if (!LIST) return -1;
	item = LIST->tail;
	if (LIST->head == LIST->tail) {
		LIST->head = NULL;
		LIST->tail = NULL;
	}
	else {
		LIST->tail->prev->next = NULL;
		LIST->tail = LIST->tail->prev;
	}
	if (item) {
		item_delete(LIST, item);
		LIST->size--;
	}
	return LIST->size;
}

void *
list_head(struct list *LIST)
{
	if (!LIST || !LIST->head) return NULL;
	return LIST->head->data;
}

void *
list_tail(struct list *LIST)
{
	if (!LIST || !LIST->tail) return NULL;
	return LIST->tail->data;
}
