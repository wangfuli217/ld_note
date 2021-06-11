#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdbool.h>

void chef_sing(void);

void code_under_test()
{    
    chef_sing();
}

static void test_case(void **state)
{    
    expect_function_call(chef_sing);
    
	code_under_test();
}

 void chef_sing()  
{
  function_called();
}


int main()
{
	//struct CMUnitTest结构体
	const struct CMUnitTest tests[]={cmocka_unit_test(test_case),};
	
	
	return cmocka_run_group_tests(tests, NULL, NULL);
	
}