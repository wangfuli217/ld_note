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


int __wrap_chef_cook(const char *order,int len)
{
    check_expected_ptr(order);
    check_expected(len);	
	
    return 0;
}


static int waiter_process(const char *order,int len)
{
    __wrap_chef_cook(order,len);

    return 0;
}

static void int_test_success(void **state)      
{ 
	  expect_string(__wrap_chef_cook, order, "hotdog"); //希望__wrap_chef_cook函数能接到"hotdog"命令；
	  expect_value(__wrap_chef_cook, len, 10);
	   
      waiter_process("hotdog",10); 	        
}  
	
	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }