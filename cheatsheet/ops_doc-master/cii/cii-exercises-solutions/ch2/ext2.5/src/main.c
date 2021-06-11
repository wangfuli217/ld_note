#include <stdio.h>
#include "stack.h"
#include "except.h"

int main()
{
    Stack_T s;

    s = Stack_new(3);

    TRY
        Stack_push(s, (void*)1);
        Stack_push(s, (void*)2);
        Stack_push(s, (void*)3);
        // Stack_push(s, (void*)4); // over max size test
    EXCEPT(Assert_Failed)  // exception handle
        fprintf(stderr, "%s:%d :stack over max size...", __FILE__, (int)__LINE__);
        exit(EXIT_FAILURE);
    END_TRY;

    printf("pop: %d\n", (int)Stack_pop(s));
    printf("pop: %d\n", (int)Stack_pop(s));
    printf("pop: %d\n", (int)Stack_pop(s));

	return 0;
}

