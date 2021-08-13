/*
本例主要使用了两个函数：

 1. expect_string();
  
 2. check_expected_ptr();
 
 可以根据这两个函数拓展：check_expected();
                         expect_string_count(); 
                         expect_not_string();
						 expect_not_string_count();等
*/

#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>  //malloc
#include <errno.h>
#include <stdio.h>

const char *chef_strerror(int error)
{
    switch (error) {
    case 0:
        return "Success";
    case -1:
        return "Unknown dish";
    case -2:
        return "Not enough ingredients for the dish";
    }

    return "Unknown error!";
}

int chef_cook(const char *order)
{
    check_expected_ptr(order);        //这里要先检查参数‘order’，然后再判断. check_expected_ptr()是触发事件.
	
	if (order == NULL ) 
		        return EINVAL;        //errno:#define EINVAL 22 /*Invalid argument*/表示无效的参数
	else

       return -ENOSYS;                // #define ENOSYS 38 /* Function not implemented */ 函数功能没有实现。
     
}

static int waiter_process(const char *order)
{
    int rv;

    rv = chef_cook(order);             //从chef_cook()的返回值可知，rv的值是22或者-38；
	   
	if (rv != 0)			           //所以本函数waiter_process()的返回值为-1；
	{        
         fprintf(stderr, "Chef couldn't cook %s: %s\n", order, chef_strerror(rv));       

         return -1;    
    }   
	
	return 0;
		 
}  
	
	static void int_test_success(void **state)      
	{  
       //第1步：设置命令	
	   expect_string(chef_cook, order, "hotdog");	 //假设设置的命令"hotdog"与厨师接到的命令相同；
	                                              													 
	  //expect_string_count(chef_cook, order, "hotdog",-1); 

		
	   int rv;
 
       rv = waiter_process("hotdog");
	   
	   printf("%d\n",rv);                            //这里打印的waiter_process()的返回值就是-1，与上文一致。
	  
	   assert_int_not_equal(rv, 0); 
    }  

	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }