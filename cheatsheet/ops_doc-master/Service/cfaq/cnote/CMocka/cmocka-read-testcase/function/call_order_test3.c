#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

void chef_sing(void);

void code_under_test()
{    
    chef_sing();
}

static void test_case(void **state)
{    
    expect_function_call_any(chef_sing);    //至少调用1次
    
	code_under_test();
}

 void chef_sing()  
{
  /* expect_function_call_any至少调用1次，所以这里至少检查1次，检查count次也没关系*/
 
  function_called();         
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();         
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();
  function_called();

}


int main()
{
	//struct CMUnitTest结构体
	const struct CMUnitTest tests[]={cmocka_unit_test(test_case),};
		
	return cmocka_run_group_tests(tests, NULL, NULL);
	
}


/*
[==========] Running 1 test(s).
[ RUN      ] test_case
[       OK ] test_case
[==========] 1 test(s) run.
[  PASSED  ] 1 test(s).
*/