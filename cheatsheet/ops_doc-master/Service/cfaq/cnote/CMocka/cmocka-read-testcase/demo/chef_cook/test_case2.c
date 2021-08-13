/*
  strdup()和free()的配对使用
*/
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int __wrap_chef_cook(const char *order, char **dish_out)
{
    char *dish;

    check_expected_ptr(order);

    dish = mock_ptr_type(char *);
	printf("%s\n",dish);
    
	*dish_out = strdup(dish);         //strdup()字符串拷贝库函数，一般和 free()函数成对出现
    if (*dish_out == NULL) 
		
	   return ENOMEM;

    return mock_type(int);
}

static void test_order_hotdog(void **state)
{
    int rv;
    char *dish="hotdog";                                        
    
	#if 0
      char *dish;
	  if (dish!=NULL)
	  {
	     printf("first:dish is not NULL\n");
         printf("second:%s\n",dish);	   
	  }
	#endif
	
    expect_string(__wrap_chef_cook, order, "hotdog");  //期待厨师可以接收到"hotdog"命令
			
    will_return(__wrap_chef_cook, cast_ptr_to_largest_integral_type("hotdog"));  //指定dish的返回值是字符串“hotdog”
    will_return(__wrap_chef_cook, 0);                  // return 0；

     __wrap_chef_cook("hotdog", &dish);   //调用strdup()
     free(dish);                          //free
  
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_order_hotdog),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
