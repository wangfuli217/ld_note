#include <stdio.h>
#include "stack.h"
#include "except.h"

int main()
{
    Stack_T s;
    int a = 0;

    s = Stack_new();

    // s = (Stack_T)&a;  // invalid pointer test

    TRY
        Stack_push(s, (void*)1);
        Stack_push(s, (void*)2);
        Stack_push(s, (void*)3);
    EXCEPT(Assert_Failed)  // exception handle
        fprintf(stderr, "%s:%d: invalid pointer use...", __FILE__, (int)__LINE__);
        exit(EXIT_FAILURE);
    END_TRY;

    printf("pop: %d\n", (int)Stack_pop(s));
    printf("pop: %d\n", (int)Stack_pop(s));
    printf("pop: %d\n", (int)Stack_pop(s));

	return 0;
}

