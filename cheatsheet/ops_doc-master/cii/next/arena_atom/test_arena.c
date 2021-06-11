#include <CUnit/Basic.h>
#include "arena.h"

#define ARENA_ALLOC(arena, nbytes) \
   Arena_alloc((arena), (nbytes), __FILE__, __LINE__)
#define DUMMY 0

void test_Arena_reuse_existing_chunk(void) 
{
   Arena_T arena = Arena_new();
   /* first chunk */
   char *p = ARENA_ALLOC(arena, 1);
   CU_ASSERT_EQUAL(Arena_count(arena), 1);
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE/2);
   CU_ASSERT_EQUAL(Arena_count(arena), 1);   
   /* second chunk */
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE);
   CU_ASSERT_EQUAL(Arena_count(arena), 2);
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE);
   CU_ASSERT_EQUAL(Arena_count(arena), 2);   
   /* should re-use the first chunk */
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE/2);
   CU_ASSERT_EQUAL(Arena_count(arena), 2);
   Arena_dispose(&arena);
}

void test_Arena_use_largest_free_chunk(void) 
{
   Arena_T arena = Arena_new();
   char *p = ARENA_ALLOC(arena, ARENA_MIN_SIZE);
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE*2);
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE*3);
   Arena_free(arena);
   /* these two allocations should use the third chunk */
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE);
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE * 3);
   CU_ASSERT_EQUAL(Arena_count(arena), 1);
   /* these two allocations should use the second chunk */
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE);
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE * 2);
   CU_ASSERT_EQUAL(Arena_count(arena), 2);
   /* this allocation should use the first chunk */
   p = ARENA_ALLOC(arena, ARENA_MIN_SIZE * 2);
   CU_ASSERT_EQUAL(Arena_count(arena), 3);
   /* this allocation should use a new chunk */
   p = ARENA_ALLOC(arena, 1);
   CU_ASSERT_EQUAL(Arena_count(arena), 4);
   Arena_dispose(&arena);
}