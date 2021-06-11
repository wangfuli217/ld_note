#include <stdlib.h>
#include <stdio.h>

#include <sys/queue.h>

/* struct list_head declaration */
LIST_HEAD(list_head, char_node);

struct char_node {
	LIST_ENTRY(char_node) node;
	char data;
};

#define CHAR_NODE_FMT "%c(%d)"

int main(void)
{
	struct char_node node_a = { .data = 'a' };
	struct char_node node_b = { .data = 'b' };
	struct char_node node_c = { .data = 'c' };
	struct char_node *cur;
	struct char_node *first;
	struct char_node *second;
	struct list_head head;

	puts("doubly-linked list API demo");

	/* initialization ... */
	head = (struct list_head) LIST_HEAD_INITIALIZER(head);
	/* ... equivalent to doing */
	LIST_INIT(&head);

	/* insert at the head */
	LIST_INSERT_HEAD(&head, &node_a, node);
	/* insert after an element */
	LIST_INSERT_AFTER(&node_a, &node_c, node);
	/* insert before an element */
	LIST_INSERT_BEFORE(&node_c, &node_b, node);

	/* walk through */
	puts("whole list:");
	LIST_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* element removal, can occur anywhere */
	LIST_REMOVE(&node_b, node);

	puts("After b's removal:");
	LIST_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* head element */
	first = LIST_FIRST(&head);
	printf("head element is "CHAR_NODE_FMT"\n", first->data, first->data);
	/* iterate by hand */
	second = LIST_NEXT(first, node);
	printf("second element is "CHAR_NODE_FMT"\n", second->data,
			second->data);

	/* LIST_EMPTY: test for emptiness (not the action of emptying) */
	LIST_REMOVE(LIST_FIRST(&head), node);
	printf("list is%s empty\n", LIST_EMPTY(&head) ? "" : "n't");
	LIST_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);
	LIST_REMOVE(LIST_FIRST(&head), node);
	printf("list is%s empty\n", LIST_EMPTY(&head) ? "" : "n't");

	/* iterating over an empty list is safe */
	LIST_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	return EXIT_SUCCESS;
}
