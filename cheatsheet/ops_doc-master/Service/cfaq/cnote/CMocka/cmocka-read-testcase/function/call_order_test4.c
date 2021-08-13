/************************************************************/
/*
    ignore_function_calls可以调用1个或者count个function_called()，也可以不调用；
	 
	 @不调用示例
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
        ignore_function_calls(chef_sing);   
		code_under_test();
	 }
	
	int main()
	{
	  //struct CMUnitTest结构体
	   const struct CMUnitTest tests[]={cmocka_unit_test(test_case),};
	 	
	   return cmocka_run_group_tests(tests, NULL, NULL);
	
	}

	 
*/

/**********调用function_called()示例**************/

#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

/*
  方式1调用

 void chef_sing(void)
 { 
   function_called();     //可以在这里调用function_called()
 };
 
*/

/* 方式2调用 */ 
void chef_sing(void);    //这里只声明chef_sing()，调用在后面实现

void code_under_test()
{    
    chef_sing();
}

static void test_case(void **state)
{    
    ignore_function_calls(chef_sing);   //间接调用function_called()
	code_under_test();
}

 void chef_sing()  
{
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

