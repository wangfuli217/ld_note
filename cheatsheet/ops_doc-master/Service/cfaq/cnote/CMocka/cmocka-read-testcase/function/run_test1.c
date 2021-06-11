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
 {    free(*state);
      return 0;
  }

  
  static void null_test_success(void **state)
 {   (void) state;  }
 
  static void int_test_success(void **state)
 {     int *answer = *state;
       assert_int_equal(*answer, 42);
  }
  
  int main(void) 
 {
      const struct CMUnitTest tests[] = {
         
    		cmocka_unit_test(null_test_success),
         
	      /*① cmocka_unit_test_setup_teardown()*/
		  //cmocka_unit_test_setup_teardown(int_test_success,NULL,NULL),         //错误
		  //cmocka_unit_test_setup_teardown(int_test_success,NULL,teardown),     //错误
		  //cmocka_unit_test_setup_teardown(int_test_success,setup, NULL),       //正常
		  //cmocka_unit_test_setup_teardown(int_test_success,setup,teardown),    //正常
		  
		 /*② cmocka_unit_test_setup()*/
		 cmocka_unit_test_setup(int_test_success,setup),        //正常
		//cmocka_unit_test_setup(int_test_success,NULL),        //错误
		
 };
       
		  
    // return cmocka_run_group_tests(tests, NULL, NULL);
	   return cmocka_run_group_tests_name("zgb",tests, NULL, NULL);  //名字是自己任意起的，用引号引起来。
 }


