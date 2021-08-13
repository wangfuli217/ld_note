#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>  //malloc
#include <errno.h>
#include <stdio.h>

static int waiter_process(char *str)
{    
   check_expected_ptr(str);
   
   //check_expected(str);
   
   return 0;   
}  

#if 0
static int cook(char *str)
{		
	waiter_process(str);
	
	return 0;
	
}	
#endif

	static void int_test_success(void **state)      
	{  
       char *p = (void *)malloc(27);

       p="abcdefghijklmnopqrstuvwxyz";	   
    	
       expect_not_memory(waiter_process,str,p,27);           //内容不匹配
	   	   	   
       char *s=malloc(20);
 
       s="123456";	 
	   
	   waiter_process(s);	                                 //调用函数 
	         	   
    }  
	
	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }