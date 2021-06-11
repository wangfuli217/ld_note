#include <stdlib.h>
#include <stdio.h>

#include <sys/queue.h>

/* struct circleq_head declaration */
CIRCLEQ_HEAD(circleq_head, char_node);

struct char_node {
	CIRCLEQ_ENTRY(char_node) node;
	char data;
};

#define CHAR_NODE_FMT "%c(%d)"

int main(void)
{
	struct char_node node_a = { .data = 'a' };
	struct char_node node_b = { .data = 'b' };
	struct char_node node_c = { .data = 'c' };
	struct char_node node_d = { .data = 'd' };
	struct char_node *cur;
	struct char_node *first;
	struct char_node *second;
	struct char_node *last;
	struct char_node *before_last;
	struct circleq_head head;

	puts("circular queue API demo");

	/* initialization ... */
	head = (struct circleq_head) CIRCLEQ_HEAD_INITIALIZER(head);
	/* ... equivalent to doing */
	CIRCLEQ_INIT(&head);

	/* insert at the head */
	CIRCLEQ_INSERT_HEAD(&head, &node_a, node);
	/* insert at the tail */
	CIRCLEQ_INSERT_TAIL(&head, &node_d, node);
	/* insert after an element */
	CIRCLEQ_INSERT_AFTER(&head, &node_a, &node_b, node);
	/* insert before */
	CIRCLEQ_INSERT_BEFORE(&head, &node_d, &node_c, node);

	/* walk through */
	puts("whole queue:");
	CIRCLEQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);
	puts("whole queue in reverse order:");
	CIRCLEQ_FOREACH_REVERSE(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* element removal */
	CIRCLEQ_REMOVE(&head, &node_b, node);

	puts("After b's removal:");
	CIRCLEQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	/* head element */
	first = CIRCLEQ_FIRST(&head);
	printf("head element is "CHAR_NODE_FMT"\n", first->data, first->data);
	/* iterate by hand */
	second = CIRCLEQ_NEXT(first, node);
	printf("second element is "CHAR_NODE_FMT"\n", second->data,
			second->data);
	/* iterate by hand, cycling */
	second = CIRCLEQ_LOOP_NEXT(&head, first, node);
	printf("second element is "CHAR_NODE_FMT"\n", second->data,
			second->data);
	/* last element of list */
	last = CIRCLEQ_LAST(&head);
	printf("last element is "CHAR_NODE_FMT"\n", last->data,
			last->data);
	/* element before another element */
	before_last = CIRCLEQ_PREV(last, node);
	printf("the element before the last one is "CHAR_NODE_FMT"\n",
			before_last->data, before_last->data);
	/* element before another element, cycling */
	before_last = CIRCLEQ_LOOP_PREV(&head, last, node);
	printf("the element before the last one is "CHAR_NODE_FMT"\n",
			before_last->data, before_last->data);

	/* CIRCLEQ_EMPTY: test for emptiness (not the action of emptying) */
	CIRCLEQ_REMOVE(&head, CIRCLEQ_FIRST(&head), node);
	printf("queue is%s empty\n", CIRCLEQ_EMPTY(&head) ? "" : "n't");
	CIRCLEQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);
	CIRCLEQ_REMOVE(&head, CIRCLEQ_FIRST(&head), node);
	printf("queue is%s empty\n", CIRCLEQ_EMPTY(&head) ? "" : "n't");

	/* iterating over an empty queue is safe */
	CIRCLEQ_FOREACH(cur, &head, node)
		printf("\tvalue is "CHAR_NODE_FMT"\n", cur->data, cur->data);

	return EXIT_SUCCESS;
}
