#include <stdio.h>
#include <stdlib.h>

typedef struct node_s node_t;
struct node_s {
	unsigned long	data;
	node_t 			*next;
};

typedef struct list_s list_t;
struct list_s {
	unsigned int 	sz;
	node_t			*head;
	node_t			*tail;
};

#define __LIST_NEW__(l) do {					\
	l = (list_t*)malloc(sizeof(list_t));		\
	if (l) {									\
		l->sz = 0;								\
		l->head = __LIST_END__;					\
		l->tail = __LIST_END__;					\
	}											\
} while (0)
	
#define __LIST_ADD__(l, n) do {					\
	if (l) {									\
		n = (node_t*)malloc(sizeof(node_t));	\	
		if (n) {								\
			n->next = __LIST_END__;				\
			n->data = (unsigned long)n;			\
			if (l->tail) {						\
				l->tail->next = n;				\
				l->tail = n;					\
			} else {							\
				l->tail = l->head = n;			\
			}									\
			l->sz++;							\
		}										\
	}											\
} while (0)

#define __LIST_PRT_NODE__(n) printf("node: %p node->next: %p node->data: %#x\n", n, n->next, n->data)
#define __LIST_PRT_HEAD__(l) do {				\
	for (node_t* n = l->head;n;n = n->next) {	\
		__LIST_PRT_NODE__(n);					\
	}											\
} while(0)


#define __LIST_END__ NULL

static void 
__LIST_INVERT__(list_t* l)
{
	node_t *p, *c, *n;									
	
	printf("******** %s begin ********\n", __FUNCTION__);
	if (l->head == l->tail) {
		printf("******** %s end 1 ********\n", __func__);
		return;						
	}
														
	c = l->head->next;									
	p = l->head;
	p->next = __LIST_END__;										
	n = c->next;										
	l->head = n->next;									
	printf("p: %p->%p c: %p->%p n: %p->%p l->head: %p\n", p, p->next, c ? c: NULL, c ? c->next : NULL, n, n->next, l->head);
														
	while (c) {									
		c->next = p;
		n->next = c;									
		printf("p: %p->%p c: %p->%p n: %p->%p l->head: %p\n", p, p->next, c ? c: NULL, c ? c->next : NULL, n, n->next, l->head);
													
		c = l->head->next;
		p = l->head;
		p->next = n;
		printf("p: %p->%p c: %p->%p n: %p->%p l->head: %p\n", p, p->next, c ? c: NULL, c ? c->next : NULL, n, n->next, l->head);
		if (c == NULL) {
			continue;
		}									
		n = c->next;									
		l->head = n->next;
		printf("p: %p->%p c: %p->%p n: %p->%p l->head: %p\n", p, p->next, c ? c: NULL, c ? c->next : NULL, n, n->next, l->head);
		
		printf("while end\n");							
	}													
	
	l->head = l->tail;

	printf("******** %s end ********\n", __func__);
}	
	



int main(int argc, char **argv)
{
	list_t *list;
	node_t *node;
	
	__LIST_NEW__(list);
	
	for (int idx = 0; idx < 10; idx++) {
		__LIST_ADD__(list, node);
		//__LIST_PRT_NODE__(node);
	}
	
	__LIST_PRT_HEAD__(list);
	
	__LIST_INVERT__(list);
	
	å__LIST_PRT_HEAD__(list);
	
	return 0;
}
