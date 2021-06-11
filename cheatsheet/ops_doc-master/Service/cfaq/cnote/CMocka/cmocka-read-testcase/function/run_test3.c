/*
   cmocka_unit_test_prestate_setup_teardown()函数的使用
   
*/

#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>
#include <stdio.h>

/* 1.*/

#if 1
static int setup(void **state) 
 {  
    int *answer = malloc(sizeof(int));
	if (answer == NULL) 
    {   return -1; }
    *answer = 42;                     //0x2a;
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
       
	 assert_int_equal(*answer, 42);  //0x2a;
 }
  
  int main(void) 
 {	 
      int a=43;        //0x2b
	  int *state =&a;
      const struct CMUnitTest tests[] = {
      
	  //cmocka_unit_test_prestate_setup_teardown(int_test_success,setup, teardown,state),    //setup()已经初始化了state，这里设置了参数也不会改变测试结果; 		  
	  //cmocka_unit_test_prestate_setup_teardown(int_test_success,setup, teardown, NULL),    //state为空，不预先设置state的值;
	  //cmocka_unit_test_prestate_setup_teardown(int_test_success, setup, NULL,NULL),        //测试可以通过，有内存泄漏;     
	  //cmocka_unit_test_prestate_setup_teardown(int_test_success, NULL,NULL,state),         //测试失败，0x2b!=0x2a;没有setup()时，state直接传送给测试函数；
        cmocka_unit_test_prestate_setup_teardown(int_test_success, NULL,NULL,NULL),	         //段错误.
	  //(setup/teardown/state都可以为空.具体到本例中，当三者都为空的时候，test_case中的state就是一个野指针了，只定义没有赋值，出现了段错误）
 };
       		  
       return cmocka_run_group_tests(tests, NULL, NULL);
 }
#endif

/*2.证明了state 的传递顺序
        .cmocka_unit_test_prestate_setup_teardown()将state传递给setup()函数；
		.setup()将state传递给测试函数；
		.测试函数将state传递给teardown()函数;
*/

#if 0 
static int setup(void **state2) 
 {  
    int *answer = *state;
	
	printf("%d\n",*answer);        //打印出来是43，证明state2是由state1传过来的;
	
    return 0;
  }
  
 static int teardown(void **state) 
 {    	  
      return 0;
 }
  
  static void int_test_success(void **state)
 {     
     int *answer = *state;
       
	 assert_int_equal(*answer, 43);
 }
  
  int main(void) 
 {
	  int a=43;
	  int *state1 =&a;
	 
      const struct CMUnitTest tests[] = {
         		  
	 cmocka_unit_test_prestate_setup_teardown(int_test_success,setup, teardown,state1),  //state是一个指针

	    	
 };
       		  
       return cmocka_run_group_tests(tests, NULL, NULL);
 }
#endif