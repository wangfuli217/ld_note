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
    check_expected_ptr(order);                //检查传递进来的命令“order”
	
	bool has_ingredients;

    has_ingredients = mock_type(bool);        //mock_type()
	
    if (has_ingredients == false) 
	{
        printf("false\n");
    }
	
	else
		printf("successful\n");
	
	
	int eat;
	
	eat=mock_type(int);                      //mock_type()
	
	if(eat==0)
	{
		printf("there is no rice\n");
	}
	else
	{
		printf("I am eating\n");
	}

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
	   
    //will_return(__wrap_chef_cook, true);	        		 
	  will_return(__wrap_chef_cook, false);	//指定 mock_type(bool) 的返回值是FALSE；
      will_return(__wrap_chef_cook, 0);		//指定 mock_type(int)  的返回值是0； 

      waiter_process("hotdog"); 	        //传递给waiter_process()的参数是"hotdog"
    }  
	
	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }