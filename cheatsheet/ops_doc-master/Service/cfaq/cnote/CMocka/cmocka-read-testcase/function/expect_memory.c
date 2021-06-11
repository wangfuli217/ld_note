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
   
   return 0;   
}  

static int cook(char *str)
{	
	waiter_process(str);
	
	return 0;
	
}	

	static void int_test_success(void **state)      
	{  
		 
		 char *p = (void *)malloc(8); 
         p="abcdefg";		 
		 expect_memory(waiter_process,str,p,8);  //比较两块区域的内容是否匹配 		 
		 	
		 char *s=(void *)malloc(8);
		 s="abcdefg";
		 
      	 if(s==NULL)
		 printf("false\n");
	 
		 cook(s);
		  
    }  
	
	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }