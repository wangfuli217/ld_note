#include <stddef.h>
#include "assert.h"
#include "mem.h"
#include "stack.h"

#define T Stack_T
#define LEGAL 0x66
#define STACK_T_IS_LEGAL (((stk) != NULL)&&((stk->check) == LEGAL))

struct T
{
	int count;
	int max_size;
	struct elem
	{
		void *x;
		struct elem *link;
	} *head;
	unsigned char check;
};

T Stack_new(int max)
{
	T stk;

	NEW(stk);
	stk->count = 0;
	stk->max_size = max;
	stk->check = LEGAL;
	stk->head = NULL;
	return stk;
}

int Stack_empty(T stk)
{
	assert(STACK_T_IS_LEGAL);

	return stk->count == 0;
}

void Stack_push(T stk, void *x)
{
	struct elem *t;

	assert(STACK_T_IS_LEGAL);
    assert(stk->count < stk->max_size);

	NEW(t);
	t->x = x;
	t->link = stk->head;
	stk->head = t;
	stk->count++;
}

void *Stack_pop(T stk)
{
	void *x;
	struct elem *t;

	assert(STACK_T_IS_LEGAL);
	assert(stk->count > 0);

	t = stk->head;
	stk->head = t->link;
	stk->count--;
	x = t->x;
	FREE(t);

	return x;
}
void Stack_free(T *stk)
{
	struct elem *t, *u;

	assert(stk && *stk);

	for (t = (*stk)->head; t; t = u)
    {
		u = t->link;
		FREE(t);
	}
	FREE(*stk);
}
