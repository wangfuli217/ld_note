#include<stdio.h>
#include"arena.h"

struct test_gt{
    int n;
    char *str;
    union{
        long uid;
        long aid;
    }person;
};


int
main(int argc, char *argv[])
{
    char *p;
    struct test_gt *p_test;
    struct test_gt *t_array;
    arena_t arena;


    arena = arena_new();

    p = ARENA_ALLOC(arena, 1024);
    p_test = ARENA_ALLOC(arena, sizeof(*p_test));
    t_array = ARENA_CALLOC(arena, 1024, sizeof(*t_array));

    arena_free(arena);
}
