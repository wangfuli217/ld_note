#include <stdlib.h>
#include <stdio.h>

#include <sys/queue.h>

/* struct slist_head declaration */
SLIST_HEAD(slist_head, char_node);

struct char_node {
	SLIST_ENTRY(char_node) node;
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
	SLIST_HEAD(slist_head, char_node) head;

	puts("singly-linked list API demo");

	/* initialization ... */
	head = (struct slist_head) SLIST_HEAD_INITIALIZER(head);
	/* ... equivalent to doing */
	SLIST_INIT(&head);

	/* insert at the head */
	SLIST_INSERT_HEAD(&head, &node_a, node);
	/* insert after an element */
	SLIST_INSERT_AFTER(&node_a, &node_c, node);
	SLIST_INSERT_AFTER(&node_a, &node_b, node);
	/* no insert before macro */

	/* walk through */
	puts("whole list:");
	SLIST_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* element removal */
	SLIST_REMOVE(&head, &node_b, char_node, node);

	puts("After b's removal:");
	SLIST_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* head element */
	first = SLIST_FIRST(&head);
	printf("head element is "CHAR_NODE_FMT"\n", first->data, first->data);
	/* iterate by hand */
	second = SLIST_NEXT(first, node);
	printf("second element is "CHAR_NODE_FMT"\n", second->data,
			second->data);

	/* SLIST_EMPTY: test for emptiness (not the action of emptying) */
	SLIST_REMOVE_HEAD(&head, node);
	printf("list is%s empty\n", SLIST_EMPTY(&head) ? "" : "n't");
	SLIST_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);
	SLIST_REMOVE_HEAD(&head, node);
	printf("list is%s empty\n", SLIST_EMPTY(&head) ? "" : "n't");

	/* iterating over an empty list is safe */
	SLIST_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	return EXIT_SUCCESS;
}
