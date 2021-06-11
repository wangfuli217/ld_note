/*
本例主要使用了两个函数：

 1. expect_any();
  
 2. expect_any_count();
 
    这两个函数的位置可以放到 chef_cook()、waiter_process()、或者int_test_success()中；
 
 3.static void int_test_success(void **state)      
	{  
	   expect_any(chef_cook, order);

       .....	   
	}
	
   里面的‘order’参数究竟是哪里来的？可以尝试把‘order’换成‘or’等其他参数，会提示测试失败：
   
    Could not get value to check parameter order of function chef_cook
    There were no previously declared parameter values for this test.
   
   可以推测出这个参数就是chef_cook()的；
 
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
	//expect_any(chef_cook, order);
	
	check_expected_ptr(order);        //这里先检查参数order，触发 expect_*宏事件
		
	if (order == NULL ) 
		        return EINVAL;        //errno:#define EINVAL 22    /*Invalid argument 无效的参数*/
	else

       return -ENOSYS;                // #define ENOSYS 38         /* Function not implemented 函数功能没有实现*/
     
}

static int waiter_process(const char *order)
{
    int rtv;
	
	//expect_any(chef_cook, order);

    rtv = chef_cook(order);             //从chef_cook()的返回值可知，rv的值是22或者-38；
	   
	if (rtv != 0)			           //所以这个判断的返回值为-1；即waiter_process()的返回值是-1；
	{        
         fprintf(stderr, "Chef couldn't cook %s: %s\n", order, chef_strerror(rtv));       

         return -1;    
    }   
	
	return 0;
		 
}  
	
	static void int_test_success(void **state)      
	{  
	   expect_any(chef_cook, order);      //添加一个事件来检查order是否被传递了
	                                      //这个参数order就是chef_cook()的参数。
	    
	  // expect_any_count(chef_cook, order,-1);	
	                                                    															 
	   int rv;
 
       // 厨师接收到fish命令--> 调用chef_cook(order)---> check_expected_ptr(order)检查判断参数
	  
	   // --->将结果返回给chef_cook ---> 通过chef_cook的返回值rtv 判断不能做；
	   
       rv = waiter_process("fish");
	   
	   printf("%d\n",rv);                            //这里打印的waiter_process()的返回值就是-1，与上文一致。
	  
    }  

	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }