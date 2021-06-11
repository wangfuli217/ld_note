#include <stdlib.h>
#include <stdio.h>

#include <sys/queue.h>

/* struct stailq_head declaration */
STAILQ_HEAD(stailq_head, char_node);

struct char_node {
	STAILQ_ENTRY(char_node) node;
	char data;
};

#define CHAR_NODE_FMT "%c(%d)"

int main(void)
{
	struct char_node node_a = { .data = 'a' };
	struct char_node node_b = { .data = 'b' };
	struct char_node node_c = { .data = 'c' };
	struct char_node node_d = { .data = 'd' };
	struct char_node node_e = { .data = 'e' };
	struct char_node node_f = { .data = 'f' };
	struct char_node *cur;
	struct char_node *first;
	struct char_node *second;
	struct stailq_head head;

	puts("singly-linked tail queue API demo");

	/* initialization ... */
	head = (struct stailq_head) STAILQ_HEAD_INITIALIZER(head);
	/* ... equivalent to doing */
	STAILQ_INIT(&head);

	/* insert at the head */
	STAILQ_INSERT_HEAD(&head, &node_a, node);
	/* insert at the tail */
	STAILQ_INSERT_TAIL(&head, &node_c, node);
	/* insert after an element */
	STAILQ_INSERT_AFTER(&head, &node_a, &node_b, node);
	/* no insert before macro */

	/* walk through */
	puts("whole queue:");
	STAILQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* element removal */
	STAILQ_REMOVE(&head, &node_b, char_node, node);

	puts("After b's removal:");
	STAILQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* head element */
	first = STAILQ_FIRST(&head);
	printf("head element is "CHAR_NODE_FMT"\n", first->data, first->data);
	/* iterate by hand */
	second = STAILQ_NEXT(first, node);
	printf("second element is "CHAR_NODE_FMT"\n", second->data,
			second->data);

	/* STAILQ_EMPTY: test for emptiness (not the action of emptying) */
	STAILQ_REMOVE_HEAD(&head, node);
	printf("queue is%s empty\n", STAILQ_EMPTY(&head) ? "" : "n't");
	STAILQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);
	STAILQ_REMOVE_HEAD(&head, node);
	printf("queue is%s empty\n", STAILQ_EMPTY(&head) ? "" : "n't");

	/* iterating over an empty queue is safe */
	STAILQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* concat content of stailq 2 at the end of stailq 1 */
	struct stailq_head stailq_1 = STAILQ_HEAD_INITIALIZER(stailq_1);
	struct stailq_head stailq_2 = STAILQ_HEAD_INITIALIZER(stailq_2);

	STAILQ_INSERT_TAIL(&stailq_1, &node_a, node);
	STAILQ_INSERT_TAIL(&stailq_1, &node_b, node);
	STAILQ_INSERT_TAIL(&stailq_1, &node_c, node);

	STAILQ_INSERT_TAIL(&stailq_2, &node_d, node);
	STAILQ_INSERT_TAIL(&stailq_2, &node_e, node);
	STAILQ_INSERT_TAIL(&stailq_2, &node_f, node);

	puts("stailq 1:");
	STAILQ_FOREACH(cur, &stailq_1, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);
	puts("stailq 2:");
	STAILQ_FOREACH(cur, &stailq_2, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	STAILQ_CONCAT(&stailq_1, &stailq_2);

	puts("concat(stailq 1, stailq 2):");
	STAILQ_FOREACH(cur, &stailq_1, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	return EXIT_SUCCESS;
}
