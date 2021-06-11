#include <stdlib.h>
#include <CUnit/Basic.h>
#include "test_atom.h"
#include "test_arena.h"

int setup(void) 
{
   return 0;
}

int teardown(void) 
{
   return 0;
}

CU_SuiteInfo suites[] = {
  { "Atom", setup, teardown, test_atom_info },
  { "Arena", setup, teardown, test_arena_info },
  CU_SUITE_INFO_NULL,
};

int main() 
{
   if (CU_initialize_registry() != CUE_SUCCESS)
      return CU_get_error();
   CU_register_suites(suites);
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();
   CU_cleanup_registry();
}
