/*
   cmocka_unit_test_prestate_setup_teardown()函数的使用；
   
   “state”设置为一个字符串
   
*/

#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>
#include <stdio.h>

static int setup(void **state2) 
 {  
    char *answer = *state2;
	
	printf("%s\n",answer);        
	
    return 0;
  }
  
 static int teardown(void **state) 
 {    	  
      return 0;
 }
  
  static void int_test_success(void **state)
 {     
     char *answer = *state;
       
	 assert_string_equal(answer, "abcde");
 }
  
  int main(void) 
 {
	  char *str="abcde";
	  	 
      const struct CMUnitTest tests[] = {
         		  
	 cmocka_unit_test_prestate_setup_teardown(int_test_success,setup, teardown,str),  //state是一个指针
	    	
 };
        return cmocka_run_group_tests(tests, NULL, NULL);
       		         
 }
