/*
    本例主要使用了8个函数：

    expect_in_range();
    expect_not_in_range();
    expect_in_range_count();
    expect_in_range_count();

    expect_in_set();
    expect_not_in_set();
    expect_in_set_count();
    expect_not_in_set_count();		
 
*/

#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>  //malloc
#include <errno.h>
#include <stdio.h>


static int waiter_process(int order)
{    
   check_expected(order); /*检查参数*/
   
   return 0;   
}  

static int cook(int order)
{	
	waiter_process(order);
	
	return 0;
	
}	

	static void int_test_success(void **state)      
	{  	   
	   expect_in_range(waiter_process,order,10,100);  //function是waiter_process,也是检查值的入口；
	   
	  /* 
	   const long unsigned int array[5]={1,2,3,4,5};  //const long unsigned int类型
	   
	   expect_in_set(waiter_process,order,array);     //order是要比较的值
     */  
       int k=8;
	  
	   cook(k);	               //调用函数 
	         	   
    }  
	
	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }