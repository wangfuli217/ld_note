/*
  本例中是 mock_assert()和expect_assert_failure()配合使用。
   
   #define assert()  mock_assert()
  
   assert(expression)的作用是判断expression的值为假。
   
   由于expect_assert_failure()期望assert(expression)的值为假。
   
   ①如果expression的值不为假（数值非0、指针非空）,则程序最终打印Expected assert in increment_value(&value)，
     并且expect_assert_failure()所在行会报错：failure。
   
   ②如果expression的值为假（数值为0、指针为空），则程序最终打印：Expected assertion value occurred.
   
*/

#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include <stdio.h>
#include <stdlib.h>

#if 1
#define assert(expression) \
   mock_assert(((expression) ? 1 : 0), #expression, __FILE__, __LINE__);    //expression为真，值是1；为假，值是0
#endif           
 
 
#if 0
  void increment_value(int * const value)
 {  
      assert(value);       //判断指针   
  	
	  printf("%d\n",*value);
	
 }
  
  static void test(void **state)
  {
	 int *value=NULL;      
	 expect_assert_failure(increment_value(value));     //Expected assertion value occurred
  
  }
#endif

#if 1
     void increment_value(int * const value)
 {  
    assert(*value);      //判断整型    
       	
	printf("%d\n",*value);
	
 }
  
  static void test(void **state)
  {
	    int value=1;        //Expected assert in increment_value(&value)
	  //int value=0;        //Expected assertion *value occurred
	   
	    expect_assert_failure(increment_value(&value));
	  
  }

#endif
  
 int main() 
 {  
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test),
    };
	
	return cmocka_run_group_tests(tests, NULL, NULL);
    return 0;
 }
 