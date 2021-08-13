#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>  //malloc
#include <errno.h>
#include <stdio.h>


	static void int_test_success(void **state)      
	{ 
	  /* 
	     int num=10, size=4;
		 
         void *p=test_calloc(num, size);      //test_calloc()
	  */
	  
	  int size=200;                  //200字节
	  
	  void *p=test_malloc (size);    //test_malloc ()
	  
	  p= test_realloc(p,2*size);     //test_realloc()
	  
	  
	  if(p==NULL)
	  {
		printf("false\n");  
		  
	  }
	  else
		printf("success\n");
      
	   test_free(p);	             // 不释放会出现内存泄漏
	          
    }  
	
	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }