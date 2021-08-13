/*
  mock_type();

  will_return();  

*/

#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>  //malloc
#include <errno.h>
#include <stdio.h>
#include <stdbool.h>


int __wrap_chef_cook(const char *order)
{
    check_expected_ptr(order);
	
	bool has_ingredients;

    has_ingredients = mock_type(bool);        //mock_type
	
    if (has_ingredients == false) 
	{
        printf("false\n");
    }
	
	else
		printf("successful\n");
	
    return 0;
}

#if 0
 static int waiter_process(const char *order)
 {
    __wrap_chef_cook(order);

    return 0;
 }
#endif

	static void int_test_success(void **state)      
	{ 
	     expect_string(__wrap_chef_cook, order, "hotdog"); //希望__wrap_chef_cook函数能接到"hotdog"命令；
	        		 
		 will_return(__wrap_chef_cook, false);	          //指定 mock_type(bool) 的返回值是FALSE；
 
        // waiter_process("hotdog"); 
        __wrap_chef_cook("hotdog");  	     //省略调用函数waiter_process(),直接调用__wrap_chef_cook(); 	
    }  
	
	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }