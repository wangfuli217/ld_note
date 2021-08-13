/*
 
1. mock(void);
   mock_type(type);
   will_return(function,value);  
  
2. ① 现象：先使用will_return_count(-1)，后使用will_return_count(1)会出错；
            will_return_count(__wrap_chef_cook, "abcd",-1);
	        will_return_count(__wrap_chef_cook, 0,1);

     猜想：当count=-1时，第一个will_return_count总是处于返回状态，导致后面的will_return_count不能执行；
     验证：
	      a.测试通过，也验证了上面的猜想；
	        will_return_count(__wrap_chef_cook, "abcd",1);
		    will_return_count(__wrap_chef_cook, 0,-1);
		
		  b.测试不通过，也验证了上面的猜想；
	        will_return_count(__wrap_chef_cook, "abcd",1);
		    will_return_count(__wrap_chef_cook, 0,-1);
		    will_return_count(__wrap_chef_cook, false,1);
		
   ② 现象：will_return_always和will_return_maybe同时使用会出错	  
      
	  推论：由上面的猜想可知，两者无论谁在前，总是处于返回状态，导致另一个无法返回。
	  验证：	  
	        a.测试不通过，也验证了推论正确；	  
	          will_return_always(__wrap_chef_cook, "abcd");  //相当于will_return_count(-1)
	          will_return_maybe(__wrap_chef_cook,0);         //相当于will_return_count(-2)
            
			b.测试不通过，也验证了推论正确；
	          will_return_maybe(__wrap_chef_cook,0);  
              will_return_always(__wrap_chef_cook, "abcd");

   ③ 现象：同时使用两个will_return_count(-1)、will_return_count(-2)也出错；
    
	  推论：由上面两个推论得出的结果和现象相同。

*/

#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>  //malloc
#include <errno.h>
#include <stdio.h>
#include <stdbool.h>


int __wrap_chef_cook()
{	
  //变量1
	bool has_ingredients;
	
    has_ingredients = mock_type(bool);
	
    if (has_ingredients == false) 
	{
        printf("false\n");
    }
	
	else
		printf("successful\n");
	
  //变量2	
	int eat;
	
	eat =mock();
    //eat=mock_type(int);
	
	if(eat==0)
	   {    printf("there is no rice\n");}
	else
	   {	printf("I am eating\n");     }
	
  //变量3
      char *str;
	  str = mock_ptr_type(char *);          //类型要写‘char *’
	//str=mock_type(char *);                //这种方法也可以
	//str =mock();                          //使用时会有警告
	
	if(str==NULL)
	   {printf("There is no string\n");}
	else
	   {printf("%s\n",str);}

    return 0;
}

static int waiter_process()
{
    __wrap_chef_cook();

    return 0;
}

	static void int_test_success(void **state)      
	{ 
	   //will_return(__wrap_chef_cook, false);	//这里是告诉__wrap_chef_cook函数，has_ingredients的值是FALSE；
       //will_return(__wrap_chef_cook, 0);		//这里是告诉__wrap_chef_cook函数，eat值0; 
	   //will_return(__wrap_chef_cook, "abcd");
	    
          
	      will_return_maybe(__wrap_chef_cook,0);         //相当于will_return_count(-2)
          will_return_always(__wrap_chef_cook, "abcd");  //相当于will_return_count(-1) 

        

       waiter_process();  		   
    }  
	
	   int main(void) 
	   {	  
	       const struct CMUnitTest tests[] = {	     	  
	           
			cmocka_unit_test(int_test_success), 	  	  
				  			   
			};       								

		return cmocka_run_group_tests(tests, NULL, NULL); 	   
	  }