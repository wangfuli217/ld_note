/*
  mock_type();

  will_return();  
  
  cast_to_pointer_integral_type(value);         value是指针类型；
  
  cast_ptr_to_largest_integral_type(value);     value是指针类型； 
  
  cast_to_largest_integral_type(value);         value是整型

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
	
	char *str;	
    str = mock_ptr_type(char *);                 // mock_ptr_type	
	printf("%s\n",str);
	
	int a;
	a= mock_type(int);
	printf("%d\n",a);
	
	char *str2;	
    str2 = mock_ptr_type(char *);                 // mock_ptr_type	
	printf("%s\n",str2);

    return 0;
}

static int waiter_process(const char *order)
{
    __wrap_chef_cook(order);

    return 0;
}

	static void int_test_success(void **state)      
	{ 
	     expect_string(__wrap_chef_cook, order, "hotdog"); //希望__wrap_chef_cook函数能接到"hotdog"命令；
	   
         will_return(__wrap_chef_cook, cast_to_pointer_integral_type("fish"));		//指定 mock_ptr_type(char *) 的返回值是“fish” 
         
		 will_return(__wrap_chef_cook, cast_to_largest_integral_type(10));
		 
		 will_return(__wrap_chef_cook, cast_ptr_to_largest_integral_type("100"));
      
	  waiter_process("hotdog"); 	   
    }  
	
	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }