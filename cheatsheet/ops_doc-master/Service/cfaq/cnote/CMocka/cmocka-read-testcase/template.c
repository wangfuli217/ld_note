#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

static int setup(void **state) 
{  
     
    return 0;
}

static int teardown(void **state)  
{  
  free(*state);      
  return 0;
}
  
static void test_case(void **state)
{
	 
	 
} 

int main() { 

    const struct CMUnitTest tests[] = {cmocka_unit_test(test_case),};
         
    return cmocka_run_group_tests(tests, NULL, NULL);
}

