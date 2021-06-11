/*
   把两个文件一起编译
*/

#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include <stdio.h>
#include <stdlib.h> 

 static void test(void **state)
  {	
	//expect_assert_failure(divide(100,0));  //Expected assertion b occurred
	  
	  expect_assert_failure(divide(100,5));   // Expected assert in divide()...failure
  }
  
 int main() 
 {  
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test),
    };
	
	return cmocka_run_group_tests(tests, NULL, NULL);
 }