extern void test_Arena_reuse_existing_chunk(void);
extern void test_Arena_use_largest_free_chunk(void);

CU_TestInfo test_arena_info[] = {
  { "Reusing existing chunk in Arena_alloc", test_Arena_reuse_existing_chunk },
  { "Using the largest free chunk in Arena_alloc", test_Arena_use_largest_free_chunk },
  CU_TEST_INFO_NULL,
};
