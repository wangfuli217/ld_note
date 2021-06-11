#include <stdio.h>
#include <assert.h>

#include "table.h"

TABLE_DEF(table, int);

int cmp(int left, int right)
{
	if (left > right)
		return 1;
	if (left < right)
		return -1;
	return 0;
}

TABLE_GEN(static inline, table_, struct table, int, int,
				TABLE_DEREF_KEY, TABLE_ID_HASH, cmp)

void show_table(struct table *table)
{
	printf("size %ld\n", table->size);
	printf("load %ld\n", table->load);
	printf("load_incl_del %ld\n", table->load_incl_del);
	for (size_t i = 0; i < table->size; i++) {
		printf("  [%ld] = ", i);
		if (!table->items[i]) {
			printf("(null)\n");
		} else if (table->items[i] == TABLE_DELETED) {
			printf("(deleted)\n");
		} else {
			printf("%d\n", *table->items[i]);
		}
	}
}

int main(int argc, char **argv)
{
	struct table table;
	int size = 100;
	int *ent;

	if (argc >= 2)
		size = atoi(argv[1]);

	/* Initalize the table */
	table_init(&table);

	/* Insert some items */
	for (int i = 0; i < size; i++) {
		ent = malloc(sizeof(*ent));
		*ent = i;
		if (table_insert(&table, ent))
			return 1;
		printf("====\ninsert %d\n", i);
		show_table(&table);
	}

	/* Ensure they were inserted */
	for (int i = 0; i < size; i++) {
		ent = table_find(&table, i);
		assert(ent && *ent == i);
		if (!ent || *ent != i)
			return 1;
	}

	/* Remove some items */
	for (int i = 0; i < size; i++) {
		ent = table_remove(&table, i);
		assert(ent && *ent == i);
		if (!ent || *ent != i)
			return 1;
		free(ent);
		printf("====\nremove %d\n", i);
		show_table(&table);
	}

	/* Ensure they were deleted */
	for (int i = 0; i < size; i++) {
		ent = table_find(&table, i);
		assert(!ent);
		if (ent)
			return 1;
	}

	/* Free the table */
	table_clear(&table);

	return 0;
}

