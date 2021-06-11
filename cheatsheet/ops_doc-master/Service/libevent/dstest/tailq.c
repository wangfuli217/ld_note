#include <stdlib.h>
#include <stdio.h>

#include <sys/queue.h>

/* struct tailq_head declaration */
TAILQ_HEAD(tailq_head, char_node);

struct char_node {
	TAILQ_ENTRY(char_node) node;
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
	struct char_node *last;
	struct char_node *before_last;
	struct tailq_head head;

	puts("doubly-linked tail queue API demo");

	/* initialization ... */
	head = (struct tailq_head) TAILQ_HEAD_INITIALIZER(head);
	/* ... equivalent to doing */
	TAILQ_INIT(&head);

	/* insert at the head */
	TAILQ_INSERT_HEAD(&head, &node_a, node);
	/* insert at the tail */
	TAILQ_INSERT_TAIL(&head, &node_c, node);
	/* insert after an element */
	TAILQ_INSERT_AFTER(&head, &node_a, &node_b, node);
	/* no insert before macro */

	/* walk through */
	puts("whole queue:");
	TAILQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* element removal */
	TAILQ_REMOVE(&head, &node_b, node);

	puts("After b's removal:");
	TAILQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* head element */
	first = TAILQ_FIRST(&head);
	printf("head element is "CHAR_NODE_FMT"\n", first->data, first->data);
	/* iterate by hand */
	second = TAILQ_NEXT(first, node);
	printf("second element is "CHAR_NODE_FMT"\n", second->data,
			second->data);
	/* last element of list */
	last = TAILQ_LAST(&head, tailq_head);
	printf("last element is "CHAR_NODE_FMT"\n", last->data,
			last->data);
	/* element before another element */
	before_last = TAILQ_PREV(last, tailq_head, node);
	printf("the element before the last one is "CHAR_NODE_FMT"\n",
			before_last->data, before_last->data);

	/* TAILQ_EMPTY: test for emptiness (not the action of emptying) */
	TAILQ_REMOVE(&head, TAILQ_FIRST(&head), node);
	printf("queue is%s empty\n", TAILQ_EMPTY(&head) ? "" : "n't");
	TAILQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);
	TAILQ_REMOVE(&head, TAILQ_FIRST(&head), node);
	printf("queue is%s empty\n", TAILQ_EMPTY(&head) ? "" : "n't");

	/* iterating over an empty queue is safe */
	TAILQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* concat content of tailq 2 at the end of tailq 1 */
	struct tailq_head tailq_1 = TAILQ_HEAD_INITIALIZER(tailq_1);
	struct tailq_head tailq_2 = TAILQ_HEAD_INITIALIZER(tailq_2);

	TAILQ_INSERT_TAIL(&tailq_1, &node_a, node);
	TAILQ_INSERT_TAIL(&tailq_1, &node_b, node);
	TAILQ_INSERT_TAIL(&tailq_1, &node_c, node);

	TAILQ_INSERT_TAIL(&tailq_2, &node_d, node);
	TAILQ_INSERT_TAIL(&tailq_2, &node_e, node);
	TAILQ_INSERT_TAIL(&tailq_2, &node_f, node);

	puts("tailq 1:");
	TAILQ_FOREACH(cur, &tailq_1, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);
	puts("tailq 2:");
	TAILQ_FOREACH(cur, &tailq_2, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	TAILQ_CONCAT(&tailq_1, &tailq_2, node);

	puts("concat(tailq 1, tailq 2):");
	TAILQ_FOREACH(cur, &tailq_1, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);
	puts("concat(tailq 1, tailq 2) reversed:");
	TAILQ_FOREACH_REVERSE(cur, &tailq_1, tailq_head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	return EXIT_SUCCESS;
}
