/*
  cmocka_unit_test_setup();
  
  测试函数中的参数state来自于setup的state参数；没有setup会出错。
  
*/

#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>

static int setup(void **state) 
 {  
    int *answer = malloc(sizeof(int));
	if (answer == NULL) 
    {   return -1; }
    *answer = 42;
    *state = answer;
    return 0;
  }
  
 static int teardown(void **state) 
 {    
      free(*state);
	  
      return 0;
 }
  
  static void int_test_success(void **state)
 {     
     int *answer = *state;
       
	 assert_int_equal(*answer, 42);
 }
  
  int main(void) 
 {
      const struct CMUnitTest tests[] = {
         		  
		  cmocka_unit_test_setup(int_test_success,setup),     //运行结果通过，但是只有setup没有teardown会有内存泄漏;
	   
	      //cmocka_unit_test_setup(int_test_success,NULL),      //运行有段错误。则测试函数中的state来源于setup()，少了setup函数肯定出错。
	
 };
       		  
       return cmocka_run_group_tests(tests, NULL, NULL);
 }


